<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Http\HttpError;
use Hls\Http\Input;

final class EquipmentTimesheetRepository
{
    public function __construct(public readonly EquipmentRepository $data,public readonly bool $own=false) {}
    public function permission(string $operation):string{return 'equipment.timesheet.'.$operation.($this->own?'_own':'_scoped');}
    public function context(int $unit,?int $assignment,string $operation='view',bool $lock=false,bool $review=false):array
    {
        $g=$this->data->guard;$permission=$review?'equipment.verification.view':$this->permission($operation);$actor=$g->actor($permission,$lock);$r=$this->data->repo;
        $u=$r->one('SELECT * FROM eq_contract_units WHERE id=?'.($lock?' FOR UPDATE':''),[$unit]);if(!$u)throw new HttpError(404,'Penugasan tidak ditemukan.');$c=$this->data->header((int)$u['contract_id'],$lock);
        $o=$assignment?$r->one('SELECT * FROM eq_operator_assignments WHERE id=? AND contract_unit_id=?'.($lock?' FOR UPDATE':''),[$assignment,$unit]):null;
        if(($u['operator_mode']==='WITH'&&!$o)||($u['operator_mode']==='WITHOUT'&&$assignment))throw new HttpError(404,'Penugasan tidak ditemukan.');
        $branch=(int)$c['branch_id'];
        if($this->own){
            if($review)throw new HttpError(403,'Akses hanya penugasan operator sendiri.');
            if(!$o)throw new HttpError(404,'Penugasan tidak ditemukan.');
            $p=$r->one('SELECT * FROM md_personnel WHERE id=?'.($lock?' FOR UPDATE':''),[$o['operator_id']]);
            if(!$p||(int)$o['effective_account_id']!==(int)$actor['id']||(int)$p['account_id']!==(int)$actor['id']||(int)$p['branch_id']!==(int)$o['operator_owner_branch_id'])throw new HttpError(404,'Penugasan tidak ditemukan.');
            $branch=(int)$o['operator_owner_branch_id'];
            if(!$r->one('SELECT id FROM branches WHERE id=? AND active=1'.($lock?' FOR UPDATE':''),[$c['branch_id']]))throw new HttpError(404,'Penugasan tidak ditemukan.');
        }
        try{$g->branch($branch,$permission,$lock);}catch(HttpError){throw new HttpError(404,'Penugasan tidak ditemukan.');}
        return ['unit'=>$u,'contract'=>$c,'assignment'=>$o,'access_branch'=>$branch];
    }
    public function find(int $id,bool $lock=false,bool $review=false):array
    {
        $t=$this->data->repo->one('SELECT * FROM eq_timesheets WHERE id=?'.($lock?' FOR UPDATE':''),[$id]);if(!$t)throw new HttpError(404,'Timesheet tidak ditemukan.');
        $t['context']=$this->context((int)$t['contract_unit_id'],$t['operator_assignment_id']?(int)$t['operator_assignment_id']:null,'view',$lock,$review);return $t;
    }
    public function revision(int $id,int $root,bool $lock=false):array
    {
        return $this->data->repo->one('SELECT * FROM eq_timesheet_revisions WHERE id=? AND timesheet_id=?'.($lock?' FOR UPDATE':''),[$id,$root])??throw new HttpError(404,'Revisi tidak ditemukan.');
    }
    public function entries(int $revision,bool $lock=false):array{return $this->data->repo->all('SELECT * FROM eq_timesheet_work_entries WHERE revision_id=? ORDER BY line_no'.($lock?' FOR UPDATE':''),[$revision]);}
    public function detail(int $id,bool $review=false):array
    {
        $t=$this->find($id,false,$review);$t['revisions']=$this->data->repo->all('SELECT * FROM eq_timesheet_revisions WHERE timesheet_id=? ORDER BY revision_no',[$id]);
        foreach($t['revisions'] as &$v){$v['entries']=$this->entries((int)$v['id']);$v['net_seconds']=0;foreach($v['entries'] as $entry)$v['net_seconds']+=strtotime($entry['ends_at_exclusive'])-strtotime($entry['starts_at'])-(int)$entry['break_minutes']*60;
            $v['verification']=$this->data->repo->one('SELECT v.*,u.name reviewer_name FROM eq_timesheet_verifications v JOIN users u ON u.id=v.reviewer_id WHERE v.revision_id=?',[$v['id']]);}
        unset($v);$t['events']=$this->data->repo->all('SELECT e.*,u.name actor_name FROM eq_events e JOIN users u ON u.id=e.actor_id WHERE timesheet_id=? ORDER BY e.id',[$id]);return $t;
    }
    private function scope(bool $review=false):array
    {
        $permission=$review?'equipment.verification.view':$this->permission('view');$u=$this->data->guard->actor($permission);$where=['b.active=1'];$args=[];
        if($this->own){$where[]='o.effective_account_id=? AND p.account_id=? AND ob.active=1';array_push($args,$u['id'],$u['id']);if(!$u['all_branches']){$where[]='EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=o.operator_owner_branch_id)';$args[]=$u['id'];}}
        elseif(!$u['all_branches']){$where[]='EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=c.branch_id)';$args[]=$u['id'];}
        return [$where,$args];
    }
    public function listing(array $input,bool $review=false):array
    {
        [$where,$args]=$this->scope($review);
        if($review)$where[]="v.status='SUBMITTED' AND t.pending_revision_id=v.id";
        $status=Input::text($input,'status',10,false);if($status!==''){if(!in_array($status,['DRAFT','SUBMITTED','APPROVED','RETURNED','REJECTED'],true))throw new HttpError(422,'Status tidak sah.');$where[]='v.status=?';$args[]=$status;}
        foreach(['from'=>'>=','until'=>'<='] as $field=>$compare){$date=Input::text($input,$field,10,false);if($date!==''){$where[]='t.work_date'.$compare.'?';$args[]=\Hls\Services\EquipmentContracts::date($date);}}
        $q=Input::text($input,'q',80,false);if($q!==''){$where[]="(c.official_number LIKE ? ESCAPE '!' OR a.code LIKE ? ESCAPE '!')";$term='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';array_push($args,$term,$term);}
        $sql=' FROM eq_timesheets t JOIN eq_contract_units u ON u.id=t.contract_unit_id JOIN eq_contracts c ON c.id=u.contract_id JOIN branches b ON b.id=c.branch_id JOIN md_assets a ON a.id=u.asset_id LEFT JOIN eq_operator_assignments o ON o.id=t.operator_assignment_id LEFT JOIN md_personnel p ON p.id=o.operator_id LEFT JOIN branches ob ON ob.id=o.operator_owner_branch_id JOIN eq_timesheet_revisions v ON v.id=(SELECT MAX(v2.id) FROM eq_timesheet_revisions v2 WHERE v2.timesheet_id=t.id) WHERE '.implode(' AND ',$where);
        $page=isset($input['page'])?Input::id($input,'page'):1;$offset=($page-1)*20;
        return ['rows'=>$this->data->repo->all('SELECT t.*,c.official_number,v.status,v.revision_no,v.snapshot,v.hm_start,v.hm_end,COALESCE((SELECT SUM(TIMESTAMPDIFF(SECOND,w.starts_at,w.ends_at_exclusive)-w.break_minutes*60) FROM eq_timesheet_work_entries w WHERE w.revision_id=v.id),0) net_seconds'.$sql.' ORDER BY t.id DESC LIMIT 20 OFFSET '.$offset,$args),'total'=>(int)$this->data->repo->one('SELECT COUNT(*) n'.$sql,$args)['n'],'page'=>$page];
    }
    public function choices():array
    {
        [$where,$args]=$this->scope();$where[]=$this->data->guard->access->can('equipment.timesheet.revise_terminal')?"u.actual_start IS NOT NULL AND u.status IN('ACTIVE','COMPLETED','TERMINATED')":"u.actual_start IS NOT NULL AND u.status='ACTIVE'";
        return $this->data->repo->all('SELECT u.id unit_id,o.id assignment_id,c.official_number,a.code,a.name,COALESCE(p.name,pa.name) operator_name,u.status FROM eq_contract_units u JOIN eq_contracts c ON c.id=u.contract_id JOIN branches b ON b.id=c.branch_id JOIN md_assets a ON a.id=u.asset_id LEFT JOIN eq_operator_assignments o ON o.contract_unit_id=u.id LEFT JOIN md_personnel p ON p.id=o.operator_id LEFT JOIN users pa ON pa.id=p.account_id LEFT JOIN branches ob ON ob.id=o.operator_owner_branch_id WHERE '.implode(' AND ',$where)." AND (u.operator_mode='WITHOUT' OR o.status IN('CONFIRMED','ACTIVE','COMPLETED','TERMINATED')) ORDER BY u.id DESC,o.id LIMIT 500",$args);
    }
}

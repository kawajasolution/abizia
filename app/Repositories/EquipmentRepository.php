<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Http\HttpError;
use Hls\Services\EquipmentAccess;
final class EquipmentRepository
{
    public function __construct(public readonly Repository $repo,public readonly EquipmentAccess $guard) {}
    public function header(int $id,bool $lock=false):array
    {
        return $this->repo->one('SELECT * FROM eq_contracts WHERE id=?'.($lock?' FOR UPDATE':''),[$id])??throw new HttpError(404,'Kontrak tidak ditemukan.');
    }
    public function find(int $id):array
    {
        $this->guard->actor('equipment.contract.view');$c=$this->header($id);
        try{$this->guard->branch((int)$c['branch_id'],'equipment.contract.view');}catch(HttpError){throw new HttpError(404,'Kontrak tidak ditemukan.');}
        return $c;
    }
    public function units(int $id,bool $lock=false):array
    {
        return $this->repo->all('SELECT u.*,p.starts_on,p.ends_on FROM eq_contract_units u LEFT JOIN eq_unit_periods p ON p.id=u.current_period_id WHERE u.contract_id=? ORDER BY u.id'.($lock?' FOR UPDATE':''),[$id]);
    }
    public function operators(int $unit,bool $lock=false):array
    {
        return $this->repo->all('SELECT * FROM eq_operator_assignments WHERE contract_unit_id=? ORDER BY id'.($lock?' FOR UPDATE':''),[$unit]);
    }
    public function detail(int $id):array
    {
        $c=$this->find($id);$c['units']=$this->units($id);
        foreach($c['units'] as &$u){$u['operators']=$this->operators((int)$u['id']);$u['periods']=$this->repo->all('SELECT * FROM eq_unit_periods WHERE contract_unit_id=? ORDER BY revision_no',[$u['id']]);$u['authorizations']=$this->repo->all('SELECT * FROM eq_branch_authorizations WHERE contract_unit_id=? ORDER BY id',[$u['id']]);}
        unset($u);$c['events']=$this->repo->all('SELECT e.*,u.name actor_name FROM eq_events e JOIN users u ON u.id=e.actor_id WHERE contract_id=? ORDER BY e.id',[$id]);return $c;
    }
    public function listing(array $input):array
    {
        $this->guard->actor('equipment.contract.view');$where=['b.active=1'];$args=[];
        if(!$this->guard->access->user['all_branches']){$where[]='EXISTS(SELECT 1 FROM user_branches ub WHERE ub.branch_id=c.branch_id AND ub.user_id=?)';$args[]=$this->guard->access->user['id'];}
        $q=\Hls\Http\Input::text($input,'q',80,false);if($q!==''){$where[]="(c.internal_ref LIKE ? OR c.official_number LIKE ?)";$args[]=$args[]='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';$where[count($where)-1]="(c.internal_ref LIKE ? ESCAPE '!' OR c.official_number LIKE ? ESCAPE '!')";}
        $status=\Hls\Http\Input::text($input,'status',12,false);if($status!==''){if(!in_array($status,['DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED'],true))throw new HttpError(422,'Status tidak sah.');$where[]='c.status=?';$args[]=$status;}
        $branch=\Hls\Http\Input::id($input,'branch_id',true);if($branch){$this->guard->branch($branch,'equipment.contract.view');$where[]='c.branch_id=?';$args[]=$branch;}
        $page=isset($input['page'])?\Hls\Http\Input::id($input,'page'):1;$offset=($page-1)*20;
        $sql=' FROM eq_contracts c JOIN branches b ON b.id=c.branch_id WHERE '.implode(' AND ',$where);
        return ['rows'=>$this->repo->all('SELECT c.*'.$sql.' ORDER BY c.id DESC LIMIT 20 OFFSET '.$offset,$args),'total'=>(int)$this->repo->one('SELECT COUNT(*) n'.$sql,$args)['n'],'page'=>$page];
    }
    public function choices():array
    {
        $this->guard->actor('equipment.contract.view');$scope=$this->guard->access->user['all_branches']?'1=1':'EXISTS(SELECT 1 FROM user_branches ub WHERE ub.branch_id=b.id AND ub.user_id=?)';$args=$this->guard->access->user['all_branches']?[]:[$this->guard->access->user['id']];
        $result=['branches'=>$this->repo->all('SELECT b.id,b.name FROM branches b WHERE b.active=1 AND '.$scope,$args)];
        foreach(['customers'=>'md_customers','assets'=>'md_assets','personnel'=>'md_personnel'] as $key=>$table){$kind=$key==='assets'?" AND m.kind='equipment'":($key==='personnel'?" AND m.kind='operator'":'');$result[$key]=$this->repo->all("SELECT m.id,m.code,m.name,m.branch_id FROM $table m JOIN branches b ON b.id=m.branch_id WHERE b.active=1 AND m.active=1 AND $scope $kind ORDER BY m.id LIMIT 500",$args);}return $result;
    }
    public function approvals():array
    {
        $this->guard->actor('equipment.cross_branch.approve');$u=$this->guard->access->user;
        return $this->repo->all("SELECT a.* FROM eq_branch_authorizations a WHERE a.status IN('REQUESTED','APPROVED') AND EXISTS(SELECT 1 FROM branches b WHERE b.active=1 AND b.id IN(a.owner_branch_id,a.contract_branch_id) AND (?=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.branch_id=b.id AND ub.user_id=?))) ORDER BY a.id DESC LIMIT 100",[$u['all_branches'],$u['id']]);
    }
}

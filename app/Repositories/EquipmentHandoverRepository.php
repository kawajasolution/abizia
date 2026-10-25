<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Http\HttpError;
use Hls\Http\Input;

/** Full-document access; an own-assignment grant never opens a multi-unit BA. */
final class EquipmentHandoverRepository
{
    public function __construct(public readonly EquipmentRepository $data) {}
    public function contract(int $id,string $permission='equipment.handover.view',bool $lock=false):array
    {
        $this->data->guard->actor($permission,$lock);
        $c=$this->data->header($id,$lock);
        try{$this->data->guard->branch((int)$c['branch_id'],$permission,$lock);}
        catch(HttpError){throw new HttpError(404,'Kontrak tidak ditemukan.');}
        return $c;
    }
    public function find(int $id,bool $lock=false):array
    {
        $this->data->guard->actor('equipment.handover.view',$lock);
        $b=$this->data->repo->one('SELECT * FROM eq_handover_documents WHERE id=?'.($lock?' FOR UPDATE':''),[$id]);
        if(!$b)throw new HttpError(404,'Berita Acara tidak ditemukan.');
        $this->contract((int)$b['contract_id'],'equipment.handover.view',$lock);
        return $b;
    }
    public function units(int $id,bool $lock=false):array
    {
        return $this->data->repo->all('SELECT * FROM eq_handover_units WHERE handover_id=? ORDER BY contract_unit_id'.($lock?' FOR UPDATE':''),[$id]);
    }
    public function detail(int $id):array
    {
        $b=$this->find($id);$b['contract']=$this->contract((int)$b['contract_id']);$b['units']=$this->units($id);
        foreach($b['units'] as &$u){
            $u['evidence']=$this->data->repo->all('SELECT id,filename,mime_type,size_bytes,sha256,recorded_at FROM eq_evidence WHERE handover_unit_id=? ORDER BY id',[$u['id']]);
            $u['current']=$this->data->repo->one('SELECT status,actual_start,actual_end FROM eq_contract_units WHERE id=?',[$u['contract_unit_id']]);
        }
        unset($u);
        $b['events']=$this->data->repo->all('SELECT e.*,a.name actor_name FROM eq_events e JOIN users a ON a.id=e.actor_id WHERE e.contract_id=? AND e.handover_id=? ORDER BY e.id',[$b['contract_id'],$id]);
        return $b;
    }
    public function listing(array $input):array
    {
        $actor=$this->data->guard->actor('equipment.handover.view');$where=['b.active=1'];$args=[];
        if(!$actor['all_branches']){$where[]='EXISTS(SELECT 1 FROM user_branches ub WHERE ub.branch_id=c.branch_id AND ub.user_id=?)';$args[]=$actor['id'];}
        $q=Input::text($input,'q',80,false);
        if($q!==''){$where[]="(d.internal_ref LIKE ? ESCAPE '!' OR d.official_number LIKE ? ESCAPE '!' OR c.official_number LIKE ? ESCAPE '!')";$term='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';array_push($args,$term,$term,$term);}
        foreach(['status'=>['DRAFT','CONFIRMED','CANCELLED'],'document_type'=>['HANDOVER','RETURN']] as $field=>$allowed){$value=Input::text($input,$field,10,false);if($value!==''){if(!in_array($value,$allowed,true))throw new HttpError(422,'Filter BA tidak sah.');$where[]='d.'.$field.'=?';$args[]=$value;}}
        $page=isset($input['page'])?Input::id($input,'page'):1;$offset=($page-1)*20;
        $sql=' FROM eq_handover_documents d JOIN eq_contracts c ON c.id=d.contract_id JOIN branches b ON b.id=c.branch_id WHERE '.implode(' AND ',$where);
        return ['rows'=>$this->data->repo->all('SELECT d.*,c.official_number contract_number,c.branch_id'.$sql.' ORDER BY d.id DESC LIMIT 20 OFFSET '.$offset,$args),'total'=>(int)$this->data->repo->one('SELECT COUNT(*) n'.$sql,$args)['n'],'page'=>$page];
    }
}

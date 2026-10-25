<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Services\ExpeditionAccess;
final class ExpeditionRepository
{
    public function __construct(public readonly Repository $repo, public readonly ExpeditionAccess $guard) {}
    public function table(string $kind): string { return match($kind){'dn'=>'exp_dns','manifest'=>'exp_manifests',default=>throw new HttpError(404,'Dokumen tidak tersedia.')}; }
    public function permission(string $kind): string { return $kind==='manifest'?'expedition.manifest.view':'expedition.view'; }
    public function canOperateAt(string $permission,int $branch): bool
    {
        return $this->guard->access->can($permission)&&$this->guard->access->branch($branch)&&(bool)$this->repo->one('SELECT id FROM branches WHERE id=? AND active=1',[$branch]);
    }
    private function linked(string $kind,string $alias,string $branch): string
    {
        if($kind==='manifest')return "($branch IN($alias.origin_branch_id,$alias.destination_branch_id) OR EXISTS(SELECT 1 FROM exp_trip_legs sl WHERE sl.manifest_id=$alias.id AND $branch IN(sl.origin_branch_id,sl.destination_branch_id)))";
        return "($branch IN($alias.origin_branch_id,$alias.destination_branch_id,$alias.current_branch_id) OR EXISTS(SELECT 1 FROM exp_manifest_items si JOIN exp_trip_legs sl ON sl.manifest_id=si.manifest_id WHERE si.dn_id=$alias.id AND $branch IN(sl.origin_branch_id,sl.destination_branch_id)))";
    }
    public function scope(string $alias='t',string $kind='dn'): array
    {
        $actor=$this->guard->access->user;
        $where="EXISTS(SELECT 1 FROM branches scope_branch WHERE scope_branch.active=1 AND ".$this->linked($kind,$alias,'scope_branch.id');
        if (!$actor['all_branches']) return [$where.' AND EXISTS(SELECT 1 FROM user_branches scope_member WHERE scope_member.branch_id=scope_branch.id AND scope_member.user_id=?))',[$actor['id']]];
        return [$where.')',[]];
    }
    public function find(string $kind,int $id,bool $lock=false): array
    {
        $this->guard->actor($this->permission($kind));[$scope,$args]=$this->scope('t',$kind);$args[]=$id;
        $row=$this->repo->one('SELECT t.* FROM '.$this->table($kind).' t WHERE '.$scope.' AND t.id=?'.($lock?' FOR UPDATE':''),$args);
        if (!$row) throw new HttpError(404,'Dokumen tidak ditemukan dalam akses Anda.');
        return $row;
    }
    public function listing(string $kind,array $query,string $workflow='all'): array
    {
        $this->guard->actor($this->permission($kind));[$where,$args]=$this->scope('t',$kind);
        $q=Input::text($query,'q',100,false);$status=Input::text($query,'status',20,false);$branch=Input::id($query,'branch',true);
        if ($q!=='') {$where.=" AND (t.number LIKE ? ESCAPE '!' OR t.official_number LIKE ? ESCAPE '!' OR JSON_UNQUOTE(JSON_EXTRACT(t.snapshot,'$.customer.name')) LIKE ? ESCAPE '!')";$like='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';array_push($args,$like,$like,$like);}
        $allowed=$kind==='dn'?['created','confirmed','departed','transit','arrived','received','completed']:['draft','confirmed','departed','transit','completed','cancelled'];
        if($workflow==='transit'){$where.=" AND t.status IN('confirmed','departed','transit')";$allowed=['confirmed','departed','transit'];}
        if($workflow==='receipts'){$where.=" AND t.status IN('arrived','received','completed') AND NOT EXISTS(SELECT 1 FROM exp_manifest_items ri WHERE ri.dn_id=t.id AND ri.removed_at IS NULL)";$allowed=['arrived','received','completed'];}
        if($status!==''){if(!in_array($status,$allowed,true))throw new HttpError(422,'Filter status tidak valid.');$where.=' AND t.status=?';$args[]=$status;}
        if($branch){$this->guard->branch($branch,$this->permission($kind));$where.=' AND '.$this->linked($kind,'t','?');array_push($args,$branch,$branch);}
        $dates=[];foreach(['from','until'] as $field){$date=Input::text($query,$field,10,false);if($date!==''&&(!preg_match('/^\d{4}-\d{2}-\d{2}$/D',$date)||!checkdate((int)substr($date,5,2),(int)substr($date,8,2),(int)substr($date,0,4))))throw new HttpError(422,'Tanggal filter tidak valid.');$dates[$field]=$date;}
        if($dates['from']!==''&&$dates['until']!==''&&$dates['from']>$dates['until'])throw new HttpError(422,'Rentang tanggal terbalik.');
        foreach(['from'=>'>=','until'=>'<='] as $field=>$op)if($dates[$field]!==''){$where.=" AND t.document_date $op ?";$args[]=$dates[$field];}
        $table=$this->table($kind);$total=(int)$this->repo->one("SELECT COUNT(*) n FROM $table t WHERE $where",$args)['n'];
        $raw=Input::text($query,'page',6,false)?:'1';if(!ctype_digit($raw)||(int)$raw<1)throw new HttpError(422,'Halaman tidak valid.');
        $perPage=10;$pages=max(1,(int)ceil($total/10));$page=min((int)$raw,$pages);$offset=($page-1)*10;
        $rows=$this->repo->all("SELECT t.* FROM $table t WHERE $where ORDER BY t.id DESC LIMIT 10 OFFSET $offset",$args);
        foreach($rows as &$row){$row['data']=json_decode($row['snapshot'],true,512,JSON_THROW_ON_ERROR);$row['membership']=$kind==='dn'?$this->active((int)$row['id']):null;$row['dn_count']=$kind==='manifest'?(int)$this->repo->one('SELECT COUNT(*) n FROM exp_manifest_items WHERE manifest_id=? AND removed_at IS NULL',[$row['id']])['n']:null;}unset($row);
        return compact('rows','q','status','branch','dates','allowed')+['pagination'=>compact('total','perPage','pages','page')];
    }
    public function active(int $id,bool $lock=false): ?array { return $this->repo->one('SELECT i.*,m.number FROM exp_manifest_items i JOIN exp_manifests m ON m.id=i.manifest_id WHERE i.dn_id=? AND i.removed_at IS NULL'.($lock?' FOR UPDATE':''),[$id]); }
    public function events(string $kind,int $id): array
    {
        $this->find($kind,$id);$field=$kind==='dn'?'dn_id':'manifest_id';
        return $this->repo->all("SELECT e.event_type,e.created_at,e.detail,b.name AS branch_name,u.name AS actor_name FROM exp_events e JOIN branches b ON b.id=e.branch_id JOIN users u ON u.id=e.actor_id WHERE e.$field=? ORDER BY e.id",[$id]);
    }
    public function members(int $id): array
    {
        $this->find('manifest',$id);
        return $this->repo->all('SELECT i.*,d.number,d.official_number,d.description,d.status dn_status,d.current_location_id FROM exp_manifest_items i JOIN exp_dns d ON d.id=i.dn_id WHERE i.manifest_id=? ORDER BY i.id',[$id]);
    }
    public function candidates(array $manifest): array
    {
        $this->guard->branch((int)$manifest['origin_branch_id'],'expedition.manifest');
        return $this->repo->all("SELECT d.id,d.number,d.official_number,d.description FROM exp_dns d JOIN md_routes dr ON dr.id=d.route_id WHERE d.current_location_id=(SELECT origin_location_id FROM exp_trip_legs WHERE manifest_id=? AND position=1) AND d.status IN('created','confirmed','transit') AND EXISTS(SELECT 1 FROM exp_trip_legs l WHERE l.manifest_id=? AND l.destination_location_id=dr.destination_location_id) AND NOT EXISTS(SELECT 1 FROM exp_manifest_items i WHERE i.dn_id=d.id AND i.removed_at IS NULL) ORDER BY d.id DESC LIMIT 100",[$manifest['id'],$manifest['id']]);
    }
    public function routes(string $permission): array
    {
        $actor=$this->guard->actor($permission);
        $where=$actor['all_branches']?'1=1':'EXISTS(SELECT 1 FROM user_branches ub WHERE ub.branch_id=r.branch_id AND ub.user_id=?)';
        return $this->repo->all("SELECT r.*,a.name AS origin_name,b.name AS destination_name FROM md_routes r JOIN branches a ON a.id=r.branch_id AND a.active=1 JOIN branches b ON b.id=r.destination_branch_id AND b.active=1 JOIN md_locations lo ON lo.id=r.origin_location_id AND lo.active=1 JOIN md_locations ld ON ld.id=r.destination_location_id AND ld.active=1 WHERE r.active=1 AND $where ORDER BY r.code",$actor['all_branches']?[]:[$actor['id']]);
    }
    public function choices(array $route,string $kind): array
    {
        $permission=$kind==='dn'?'expedition.ship':'expedition.manifest';$this->guard->branch((int)$route['branch_id'],$permission);
        $a=$route['branch_id'];$b=$route['destination_branch_id'];
        if($kind==='dn')return ['customer_id'=>$this->repo->all('SELECT id,code,name FROM md_customers WHERE branch_id=? AND active=1 ORDER BY name',[$a]),'sender_id'=>$this->repo->all("SELECT id,code,name FROM md_parties WHERE branch_id=? AND active=1 AND party_role IN('sender','both') ORDER BY name",[$a]),'receiver_id'=>$this->repo->all("SELECT id,code,name FROM md_parties WHERE branch_id=? AND active=1 AND party_role IN('receiver','both') ORDER BY name",[$b])];
        return ['vehicle_id'=>$this->repo->all("SELECT id,code,name FROM md_assets WHERE kind='truck' AND branch_id=? AND active=1 ORDER BY name",[$a]),'driver_id'=>$this->repo->all("SELECT p.id,p.code,COALESCE(u.name,p.name) name FROM md_personnel p LEFT JOIN users u ON u.id=p.account_id WHERE p.kind='driver' AND p.branch_id=? AND p.active=1 AND (p.account_id IS NULL OR (u.active=1 AND (u.all_branches=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=u.id AND ub.branch_id=p.branch_id)))) ORDER BY name",[$a])];
    }
}

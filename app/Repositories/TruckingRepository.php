<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Http\HttpError;
use Hls\Http\Input;
final class TruckingRepository
{
    public function __construct(public readonly ExpeditionRepository $data) {}
    public function legs(int $manifest,bool $lock=false): array
    {
        return $this->data->repo->all('SELECT * FROM exp_trip_legs WHERE manifest_id=? ORDER BY position'.($lock?' FOR UPDATE':''),[$manifest]);
    }
    public function stop(array $m,?int $position=null): array
    {
        $legs=$this->legs((int)$m['id']);$index=$position??(int)$m['current_stop'];
        if(!$legs||$index>count($legs))throw new HttpError(409,'Posisi trip tidak valid.');
        $leg=$index===0?$legs[0]:$legs[$index-1];$prefix=$index===0?'origin':'destination';
        return ['branch'=>(int)$leg[$prefix.'_branch_id'],'location'=>(int)$leg[$prefix.'_location_id'],'position'=>$index];
    }
    public function destinationIndex(array $m,int $location): ?int
    {
        foreach($this->legs((int)$m['id']) as $leg)if((int)$leg['destination_location_id']===$location)return (int)$leg['position'];
        return null;
    }
    public function destination(array $dn): int { return (int)json_decode($dn['snapshot'],true,512,JSON_THROW_ON_ERROR)['destination_location']['id']; }
    public function claim(int $id,bool $lock=false): array
    {
        $this->data->guard->actor('expedition.claim.view');
        $claim=$this->data->repo->one('SELECT * FROM exp_claims WHERE id=?'.($lock?' FOR UPDATE':''),[$id]);
        if(!$claim)throw new HttpError(404,'Klaim tidak ditemukan.');$this->data->find('dn',(int)$claim['dn_id']);return $claim;
    }
    public function claimHistory(int $id): array
    {
        $this->claim($id);return $this->data->repo->all('SELECT e.*,u.name actor_name FROM exp_claim_events e JOIN users u ON u.id=e.actor_id WHERE e.claim_id=? ORDER BY e.id',[$id]);
    }
    public function evidence(int $id): array
    {
        $this->claim($id);return $this->data->repo->all('SELECT id,file_name,mime_type,file_size,sha256,created_at FROM exp_evidence WHERE claim_id=? ORDER BY id',[$id]);
    }
    public function detail(string $kind,array $row): array
    {
        $activeBranches=array_map('intval',array_column($this->data->repo->all('SELECT id FROM branches WHERE active=1'),'id'));
        if($kind==='dn')return ['receipt'=>$this->data->repo->one('SELECT r.*,u.name actor_name FROM exp_receipts r JOIN users u ON u.id=r.actor_id WHERE r.dn_id=?',[$row['id']]),'activeBranches'=>$activeBranches];
        $legs=$this->legs((int)$row['id']);$stop=$this->stop($row);$nextRoutes=[];$targets=[];$assignments=[];
        if($this->data->guard->access->can('expedition.manifest')){
            if($row['status']==='draft'&&$this->data->guard->access->branch((int)$row['origin_branch_id'])&&in_array((int)$row['origin_branch_id'],$activeBranches,true)){
                $assignments=$this->data->choices(['branch_id'=>$row['origin_branch_id'],'destination_branch_id'=>$row['destination_branch_id']],'manifest');
                $nextRoutes=$this->data->repo->all('SELECT r.id,r.code,r.name FROM md_routes r JOIN md_locations lo ON lo.id=r.origin_location_id AND lo.active=1 JOIN md_locations ld ON ld.id=r.destination_location_id AND ld.active=1 JOIN branches b ON b.id=r.destination_branch_id AND b.active=1 WHERE r.active=1 AND r.origin_location_id=? ORDER BY r.code',[$legs[count($legs)-1]['destination_location_id']]);
            }
            [$scope,$args]=$this->data->scope('t','manifest');array_push($args,$row['id'],$stop['location']);
            $targets=$this->data->repo->all("SELECT t.id,t.number,t.version FROM exp_manifests t JOIN exp_trip_legs l ON l.manifest_id=t.id AND l.position=1 WHERE $scope AND t.status='draft' AND t.id<>? AND l.origin_location_id=? ORDER BY t.id DESC LIMIT 100",$args);
        }
        return compact('legs','stop','nextRoutes','targets','assignments','activeBranches');
    }
    public function claims(array $query): array
    {
        $this->data->guard->actor('expedition.claim.view');[$where,$args]=$this->data->scope('t','dn');
        $q=Input::text($query,'q',100,false);$status=Input::text($query,'status',20,false);$branch=Input::id($query,'branch',true);
        if($q!==''){$like='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';$where.=" AND (t.number LIKE ? ESCAPE '!' OR t.official_number LIKE ? ESCAPE '!' OR c.reporter_name LIKE ? ESCAPE '!' OR c.description LIKE ? ESCAPE '!')";array_push($args,$like,$like,$like,$like);}
        if($status!==''){if(!in_array($status,['REPORTED','REVIEWING','APPROVED','REJECTED','CLOSED'],true))throw new HttpError(422,'Status klaim tidak valid.');$where.=' AND c.status=?';$args[]=$status;}
        if($branch){$this->data->guard->branch($branch,'expedition.claim.view');$where.=' AND c.branch_id=?';$args[]=$branch;}
        $dates=[];foreach(['from'=>'>=','until'=>'<='] as $field=>$op){$date=Input::text($query,$field,10,false);$dates[$field]=$date;if($date!==''){$dt=\DateTimeImmutable::createFromFormat('!Y-m-d',$date);if(!$dt||$dt->format('Y-m-d')!==$date)throw new HttpError(422,'Tanggal filter tidak valid.');$where.=" AND DATE(c.created_at) $op ?";$args[]=$date;}}
        if($dates['from']!==''&&$dates['until']!==''&&$dates['from']>$dates['until'])throw new HttpError(422,'Rentang tanggal terbalik.');
        $raw=Input::text($query,'page',6,false)?:'1';if(!ctype_digit($raw)||(int)$raw<1)throw new HttpError(422,'Halaman tidak valid.');
        $total=(int)$this->data->repo->one("SELECT COUNT(*) n FROM exp_claims c JOIN exp_dns t ON t.id=c.dn_id WHERE $where",$args)['n'];$perPage=10;$pages=max(1,(int)ceil($total/10));$page=min((int)$raw,$pages);$offset=($page-1)*10;
        $rows=$this->data->repo->all("SELECT c.*,t.number,t.official_number FROM exp_claims c JOIN exp_dns t ON t.id=c.dn_id WHERE $where ORDER BY c.id DESC LIMIT 10 OFFSET $offset",$args);
        return compact('rows','q','status','branch','dates')+['pagination'=>compact('total','perPage','pages','page')];
    }
}

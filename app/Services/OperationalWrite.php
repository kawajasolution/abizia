<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\HttpError;
use Hls\Repositories\ExpeditionRepository;
final class OperationalWrite
{
    public function __construct(public readonly ExpeditionRepository $data,private Audit $audit) {}
    public function run(string $permission,string $action,string $key,array $payload,int $branch,callable $work): array
    {
        $this->data->guard->actor($permission);
        if(!preg_match('/^[a-f0-9]{64}$/D',$key))throw new HttpError(422,'Token permintaan tidak valid.');
        $hash=hash('sha256',json_encode($payload,JSON_THROW_ON_ERROR));
        try{return Database::transaction($this->data->repo->db,function()use($permission,$action,$key,$hash,$branch,$work):array{
            $actor=$this->data->guard->actor($permission,true);
            $prior=$this->data->repo->one('SELECT * FROM exp_requests WHERE request_key=? FOR UPDATE',[$key]);
            if($prior){
                if((int)$prior['actor_id']!==(int)$actor['id']||$prior['action']!==$action||!hash_equals($prior['payload_hash'],$hash))throw new HttpError(409,'Token sudah digunakan untuk permintaan lain.');
                $this->data->guard->branch((int)$prior['branch_id'],$permission,true);
                return json_decode($prior['result'],true,512,JSON_THROW_ON_ERROR);
            }
            $this->data->guard->branch($branch,$permission,true);$result=$work();
            $this->data->repo->run('INSERT INTO exp_requests(request_key,actor_id,branch_id,action,payload_hash,result) VALUES (?,?,?,?,?,?)',[$key,$actor['id'],$branch,$action,$hash,json_encode($result,JSON_THROW_ON_ERROR)]);
            return $result;
        });}catch(\PDOException $e){if(in_array((string)$e->getCode(),['23000','40001'],true))throw new HttpError(409,'Terjadi konflik. Muat ulang atau ulangi permintaan yang sama.');throw $e;}
    }
    public function event(?int $dn,?int $manifest,int $branch,string $type,array $detail): void
    {
        $actor=(int)$this->data->guard->access->user['id'];
        $this->data->repo->run('INSERT INTO exp_events(dn_id,manifest_id,actor_id,branch_id,event_type,detail) VALUES (?,?,?,?,?,?)',[$dn,$manifest,$actor,$branch,$type,json_encode($detail,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE)]);
        $this->audit->record($actor,$type,$dn?'exp_dns':'exp_manifests',$dn??$manifest,$detail);
    }
}

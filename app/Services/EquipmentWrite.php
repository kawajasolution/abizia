<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\HttpError;
use Hls\Repositories\EquipmentRepository;
final class EquipmentWrite
{
    public function __construct(public readonly EquipmentRepository $data,private Audit $audit) {}
    public function run(string $permission,string $action,string $key,array $payload,int $branch,int $contract,callable $work,string $resourceType='contract'):array
    {
        if(!in_array($resourceType,['contract','handover','timesheet'],true))throw new \LogicException('Jenis resource Equipment tidak sah.');
        if(!preg_match('/^[a-f0-9]{64}$/D',$key))throw new HttpError(422,'Token permintaan tidak sah.');
        $hash=hash('sha256',json_encode($payload,JSON_THROW_ON_ERROR));$r=$this->data->repo;
        // Serialize identical keys before starting the transaction, including first use (no gap-lock race).
        $lock='eq:'.substr(hash('sha256',$r->db->query('SELECT DATABASE()')->fetchColumn().$key),0,55);
        if((int)$r->one('SELECT GET_LOCK(?,5) acquired',[$lock])['acquired']!==1)throw new HttpError(409,'Permintaan sedang diproses. Ulangi token sama.');
        try{return Database::transaction($r->db,function()use($r,$permission,$action,$key,$hash,$payload,$branch,$contract,$work,$resourceType):array{
            $actor=$this->data->guard->actor($permission,true);$this->data->guard->branch($branch,$permission,true);
            $prior=$r->one('SELECT * FROM eq_requests WHERE request_key=? FOR UPDATE',[$key]);
            if($prior){if((int)$prior['actor_id']!==(int)$actor['id']||$prior['action']!==$action||!hash_equals($prior['payload_hash'],$hash)||(int)$prior['scope_branch_id']!==$branch)throw new HttpError(409,'Token telah digunakan untuk payload/aktor lain.');return json_decode($prior['committed_result'],true,512,JSON_THROW_ON_ERROR);}
            if($contract){$c=$this->data->header($contract,true);if((int)$c['branch_id']!==(int)($payload['contract_branch_id']??$branch))throw new HttpError(409,'Konteks kontrak berubah.');}
            $result=$work();$r->run('INSERT INTO eq_requests(request_key,actor_id,action,resource_type,resource_id,scope_branch_id,payload_hash,committed_result) VALUES (?,?,?,?,?,?,?,?)',[$key,$actor['id'],$action,$resourceType,$result['id']??$contract,$branch,$hash,json_encode($result,JSON_THROW_ON_ERROR)]);return $result;
        });}catch(\PDOException $e){if(in_array((string)$e->getCode(),['23000','40001'],true)||(int)($e->errorInfo[1]??0)===1205)throw new HttpError(409,'Konflik data/jadwal. Muat ulang atau ulangi token yang sama.');throw $e;}
        finally{$r->run('SELECT RELEASE_LOCK(?)',[$lock]);}
    }
    public function event(int $contract,string $type,string $key,array $detail,?int $unit=null,?int $period=null,?int $assignment=null):void
    {
        $r=$this->data->repo;$c=$this->data->header($contract);$actor=(int)$this->data->guard->access->user['id'];
        [$from,$to]=match($type){
            'eq_contract_confirmed','eq_unit_confirmed','eq_operator_confirmed'=>['DRAFT','CONFIRMED'],
            'eq_contract_cancelled','eq_unit_cancelled','eq_operator_cancelled'=>[$detail['from']??'DRAFT','CANCELLED'],
            'eq_draft_saved','eq_unit_draft_saved'=>[$detail['before']['status']??null,'DRAFT'],
            'eq_operator_proposed'=>[null,'DRAFT'], 'eq_cross_requested'=>[null,'REQUESTED'],
            'eq_contract_closed_after_cancel'=>['ACTIVE',$detail['to']],
            'eq_cross_revoked'=>['APPROVED','REVOKED'],default=>[null,null],
        };
        if($type==='eq_cross_approved'){$from='REQUESTED';$to=$r->one('SELECT status FROM eq_branch_authorizations WHERE id=?',[$detail['authorization']])['status'];}
        $detail+=['from'=>$from,'to'=>$to];
        $r->run('INSERT INTO eq_events(contract_id,contract_unit_id,period_id,operator_assignment_id,event_type,previous_state,next_state,actor_id,branch_id,request_key,detail,occurred_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,NOW())',[$contract,$unit,$period,$assignment,$type,$from,$to,$actor,$c['branch_id'],$key,json_encode($detail,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE)]);
        $this->audit->record($actor,$type,'eq_contracts',$contract,$detail);
    }
}

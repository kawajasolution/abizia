<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\EquipmentHandoverRepository;

/** BA commands share the contract lock and atomic audit/idempotency boundary. */
final class EquipmentHandovers
{
    public readonly EquipmentWrite $write;
    public function __construct(public readonly EquipmentHandoverRepository $records,private Audit $audit)
    {
        $this->write=new EquipmentWrite($records->data,$audit);
    }
    private function version(array $b,int $version):void
    {
        if((int)$b['version']!==$version)throw new HttpError(409,'Versi BA berubah. Muat ulang dokumen.');
    }
    private function draft(array $b):void
    {
        if($b['status']!=='DRAFT')throw new HttpError(409,'Hanya BA DRAFT dapat diubah.');
    }
    private function event(array $b,string $type,string $key,array $detail,?string $from,?string $to):void
    {
        $r=$this->records->data->repo;$c=$this->records->data->header((int)$b['contract_id']);$actor=(int)$this->records->data->guard->access->user['id'];
        $r->run('INSERT INTO eq_events(contract_id,handover_id,contract_unit_id,operator_assignment_id,event_type,previous_state,next_state,actor_id,branch_id,request_key,detail,occurred_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',[$c['id'],$b['id'],$detail['unit_id']??null,$detail['assignment_id']??null,$type,$from,$to,$actor,$c['branch_id'],$key,json_encode($detail,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE),$b['occurrence_at']]);
        $this->audit->record($actor,$type,'eq_handover_documents',(int)$b['id'],$detail);
    }
    public function save(array $input):array
    {
        $id=Input::id($input,'id',true);$contract=Input::id($input,'contract_id');$version=$id?Input::id($input,'version'):0;
        $type=Input::text($input,'document_type',8);$scope=Input::text($input,'scope_mode',8);$time=EquipmentContracts::time(Input::text($input,'occurrence_at',19));$key=Input::text($input,'request_key',64);
        if(!in_array($type,['HANDOVER','RETURN'],true)||!in_array($scope,['ALL','SELECTED'],true))throw new HttpError(422,'Jenis/cakupan BA tidak sah.');
        $values=$input['units']??[];if(!is_array($values)||count($values)>500)throw new HttpError(422,'Daftar unit tidak sah.');$units=[];
        $meta=['location'=>Input::text($input,'location',1000,false),'handover_party'=>Input::text($input,'handover_party',255,false),'handover_title'=>Input::text($input,'handover_title',255,false),'receiver_party'=>Input::text($input,'receiver_party',255,false),'receiver_title'=>Input::text($input,'receiver_title',255,false),'machine_condition'=>Input::text($input,'machine_condition',2000,false),'hydraulic_condition'=>Input::text($input,'hydraulic_condition',2000,false),'attachment_condition'=>Input::text($input,'attachment_condition',2000,false),'cabin_condition'=>Input::text($input,'cabin_condition',2000,false),'safety_condition'=>Input::text($input,'safety_condition',2000,false),'completeness_note'=>Input::text($input,'completeness_note',2000,false),'general_note'=>Input::text($input,'general_note',2000,false)];
        foreach($values as $unit=>$value){
            if(!is_array($value)||!ctype_digit((string)$unit)||(int)$unit<1)throw new HttpError(422,'Detail unit tidak sah.');
            if(($value['selected']??'')!=='1')continue;
            $condition=Input::text($value,'condition_note',2000);$hm=Input::text($value,'hm_reading',13,false);
            if($hm!==''&&!preg_match('/^(?:0|[1-9][0-9]{0,8})(?:\.[0-9]{1,3})?$/D',$hm))throw new HttpError(422,'HM harus nonnegatif, maksimal tiga desimal.');
            $units[(int)$unit]=['condition_note'=>$condition,'hm_reading'=>$hm===''?null:number_format((float)$hm,3,'.','')];
        }
        ksort($units);if(!$units)throw new HttpError(422,'Pilih minimal satu unit dan catat kondisinya.');
        $c=$this->records->contract($contract);if($id&&(int)$this->records->find($id)['contract_id']!==$contract)throw new HttpError(422,'Kontrak BA tidak boleh dipindahkan.');
        return $this->write->run('equipment.handover.'.($id?'update':'create'),'eq_ba_save',$key,compact('id','contract','version','type','scope','time','units','meta'),(int)$c['branch_id'],$contract,function()use($id,$contract,$version,$type,$scope,$time,$units,$meta,$key):array{
            $r=$this->records->data->repo;$c=$this->records->contract($contract,'equipment.handover.'.($id?'update':'create'),true);
            if(!in_array($c['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'BA memerlukan kontrak CONFIRMED/ACTIVE.');
            $before=$id?$this->records->find($id,true):null;$old=$id?$this->records->units($id,true):[];
            if($before){$this->version($before,$version);$this->draft($before);if($before['correction_of_id'])throw new HttpError(409,'Gunakan prosedur koreksi administratif.');}
            $available=$this->records->data->units($contract,true);$eligible=[];
            foreach($available as $u)if($u['status']===($type==='HANDOVER'?'CONFIRMED':'ACTIVE'))$eligible[(int)$u['id']]=$u;
            if(array_diff_key($units,$eligible))throw new HttpError(409,'Unit bukan milik kontrak atau statusnya tidak memenuhi syarat.');
            if($scope==='ALL'&&array_keys($units)!==array_keys($eligible))throw new HttpError(422,'ALL harus mencakup seluruh unit yang memenuhi syarat saat penyimpanan.');
            foreach($old as $previous)if(!isset($units[(int)$previous['contract_unit_id']])&&$r->one('SELECT id FROM eq_evidence WHERE handover_unit_id=? LIMIT 1',[$previous['id']]))throw new HttpError(409,'Unit dengan bukti tidak dapat dikeluarkan. Batalkan draft dan buat BA baru; bukti lama tetap tersimpan.');
            if($id)$r->run('UPDATE eq_handover_documents SET document_type=?,scope_mode=?,occurrence_at=?,version=version+1 WHERE id=?',[$type,$scope,$time,$id]);
            else{$r->run('INSERT INTO eq_handover_documents(contract_id,internal_ref,document_type,scope_mode,occurrence_at,created_by) VALUES (?,?,?,?,?,?)',[$contract,'INT-BA-'.strtoupper(bin2hex(random_bytes(16))),$type,$scope,$time,$this->records->data->guard->access->user['id']]);$id=(int)$r->db->lastInsertId();}
            foreach($old as $previous)if(!isset($units[(int)$previous['contract_unit_id']]))$r->run('DELETE FROM eq_handover_units WHERE id=?',[$previous['id']]);
            foreach($units as $unit=>$value){$u=$eligible[$unit];$snapshot=json_encode(['unit'=>json_decode($u['snapshot'],true,512,JSON_THROW_ON_ERROR),'contract'=>json_decode($c['snapshot'],true,512,JSON_THROW_ON_ERROR),'contract_number'=>$c['official_number'],'project_address'=>$c['project_address'],'bast_meta'=>$meta,'period'=>['id'=>$u['current_period_id'],'starts_on'=>$u['starts_on'],'ends_on'=>$u['ends_on']]],JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE);
                $r->run('INSERT INTO eq_handover_units(handover_id,contract_id,contract_unit_id,condition_note,hm_reading,occurrence_at,snapshot) VALUES (?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE condition_note=VALUES(condition_note),hm_reading=VALUES(hm_reading),occurrence_at=VALUES(occurrence_at),snapshot=VALUES(snapshot)',[$id,$contract,$unit,$value['condition_note'],$value['hm_reading'],$time,$snapshot]);
            }
            $b=$this->records->find($id,true);$this->event($b,'eq_ba_draft_saved',$key,['before'=>$before,'before_units'=>$old,'after'=>$b,'after_units'=>$this->records->units($id)],$before['status']??null,'DRAFT');return ['id'=>$id];
        },'handover');
    }
    public function cancel(int $id,int $version,string $key,string $reason):array
    {
        if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Alasan pembatalan wajib.');
        $b=$this->records->find($id);$c=$this->records->contract((int)$b['contract_id']);
        return $this->write->run('equipment.handover.cancel','eq_ba_cancel',$key,compact('id','version','reason'),(int)$c['branch_id'],(int)$c['id'],function()use($id,$version,$key,$reason):array{
            $r=$this->records->data->repo;$b=$this->records->find($id,true);$this->version($b,$version);$this->draft($b);
            $r->run("UPDATE eq_handover_documents SET status='CANCELLED',version=version+1 WHERE id=?",[$id]);
            $this->event($b,'eq_ba_cancelled',$key,['reason'=>$reason],'DRAFT','CANCELLED');return ['id'=>$id];
        },'handover');
    }
    public function confirm(int $id,int $version,string $key,string $closure='NORMAL',string $reason=''):array
    {
        $this->recoverySources=[];
        if(!in_array($closure,['NORMAL','EARLY'],true)||mb_strlen($reason)>2000||($closure==='EARLY'&&trim($reason)===''))throw new HttpError(422,'Jenis pengembalian/alasan tidak sah.');
        $b=$this->records->find($id);$c=$this->records->contract((int)$b['contract_id']);
        return $this->write->run('equipment.handover.confirm','eq_ba_confirm',$key,compact('id','version','closure','reason'),(int)$c['branch_id'],(int)$c['id'],function()use($id,$version,$key,$closure,$reason):array{
            $r=$this->records->data->repo;$b=$this->records->find($id,true);$this->version($b,$version);$this->draft($b);$c=$this->records->data->header((int)$b['contract_id'],true);
            $baUnits=$this->records->units($id,true);if(!$baUnits)throw new HttpError(409,'BA tidak mempunyai unit.');
            if($b['correction_of_id']){
                $this->records->data->guard->actor('equipment.handover.correct',true);
                $original=$this->records->find((int)$b['correction_of_id'],true);if($original['status']!=='CONFIRMED')throw new HttpError(409,'Sumber koreksi belum confirmed.');
            }else{
                if(!in_array($c['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Kontrak tidak dapat diproses.');
                $permission=$b['document_type']==='HANDOVER'?'equipment.contract.activate':($closure==='EARLY'?'equipment.contract.terminate':'equipment.contract.close');$this->records->data->guard->actor($permission,true);
                if($b['document_type']==='HANDOVER'&&($closure!=='NORMAL'||$reason!==''))throw new HttpError(422,'HANDOVER tidak mempunyai jenis penutupan.');
                $all=$this->records->data->units((int)$c['id'],true);$byId=array_column($all,null,'id');$selected=[];
                foreach($baUnits as $bu){$u=$byId[$bu['contract_unit_id']]??null;if(!$u||$u['status']!==($b['document_type']==='HANDOVER'?'CONFIRMED':'ACTIVE'))throw new HttpError(409,'Status unit berubah atau unit tidak memenuhi syarat.');$selected[]=$u;}
                if($b['document_type']==='HANDOVER'){
                    foreach($selected as $u) EquipmentOperationalGuard::assertAvailable($r,(int)$u['asset_id']);
                    (new EquipmentContracts($this->records->data,$this->audit))->validateHandover($c,$selected);
                    foreach($selected as $u)if(substr($b['occurrence_at'],0,10)<$u['starts_on']||substr($b['occurrence_at'],0,10)>$u['ends_on'])throw new HttpError(422,'Serah terima harus berada dalam periode reservasi efektif.');
                }else{$this->returnSources($c,$selected,$reason);if($this->recoverySources)$this->event($b,'eq_ba_recovery_used',$key,['sources'=>$this->recoverySources,'reason'=>$reason],null,null);}
                foreach($baUnits as $bu){$u=$byId[$bu['contract_unit_id']];$time=$b['occurrence_at'];
                    if($b['document_type']==='RETURN'){
                        if(!$u['actual_start']||$time<$u['actual_start'])throw new HttpError(422,'Pengembalian mendahului serah terima aktual.');
                        $start=$r->one("SELECT bu.hm_reading FROM eq_handover_units bu JOIN eq_handover_documents b ON b.id=bu.handover_id WHERE bu.contract_unit_id=? AND bu.lifecycle_effect='HANDOVER' AND b.status='CONFIRMED'",[$u['id']]);
                        if($bu['hm_reading']!==null&&$start&&$start['hm_reading']!==null&&(float)$bu['hm_reading']<(float)$start['hm_reading'])throw new HttpError(422,'HM pengembalian menurun; prosedur koreksi meter khusus belum tersedia di M4.');
                    }
                    $next=$b['document_type']==='HANDOVER'?'ACTIVE':($closure==='EARLY'?'TERMINATED':'COMPLETED');
                    if($next==='ACTIVE')$r->run("UPDATE eq_contract_units SET status='ACTIVE',actual_start=?,version=version+1 WHERE id=?",[$time,$u['id']]);
                    else $r->run('UPDATE eq_contract_units SET status=?,actual_end=?,version=version+1 WHERE id=?',[$next,$time,$u['id']]);
                    foreach($this->records->data->operators((int)$u['id'],true) as $o){$opNext=null;
                        if($next==='ACTIVE'&&$o['status']==='CONFIRMED'&&$o['starts_at']<=$time&&$o['ends_at_exclusive']>$time){$opNext='ACTIVE';$r->run("UPDATE eq_operator_assignments SET status='ACTIVE',actual_start=?,version=version+1 WHERE id=?",[$time,$o['id']]);}
                        elseif($next!=='ACTIVE'&&$o['status']==='ACTIVE'){if(!$o['actual_start']||$time<$o['actual_start'])throw new HttpError(422,'Return mendahului mulai aktual operator.');$opNext=$next;$r->run('UPDATE eq_operator_assignments SET status=?,actual_end=?,version=version+1 WHERE id=?',[$next,$time,$o['id']]);}
                        elseif($next!=='ACTIVE'&&in_array($o['status'],['DRAFT','CONFIRMED'],true)){$opNext='CANCELLED';$r->run("UPDATE eq_operator_assignments SET status='CANCELLED',version=version+1 WHERE id=?",[$o['id']]);}
                        if($opNext)$this->event($b,'eq_ba_operator_changed',$key,['unit_id'=>$u['id'],'assignment_id'=>$o['id'],'from'=>$o['status'],'to'=>$opNext,'reason'=>$reason?:($next==='ACTIVE'?'Serah terima aktual dalam interval penugasan.':'Pengembalian aktual unit; penugasan yang belum dimulai ditutup.')],$o['status'],$opNext);
                    }
                    $r->run('UPDATE eq_handover_units SET lifecycle_effect=? WHERE id=?',[$b['document_type'],$bu['id']]);
                    $this->event($b,'eq_ba_unit_changed',$key,['unit_id'=>$u['id'],'from'=>$u['status'],'to'=>$next,'actual_at'=>$time,'closure'=>$closure,'reason'=>$reason],$u['status'],$next);
                }
                $this->aggregate($b,$c,$key,$closure);
                $r->run('UPDATE eq_contracts SET version=version+1 WHERE id=?',[$c['id']]);
            }
            $number=$this->number((int)$c['branch_id']);$r->run("UPDATE eq_handover_documents SET status='CONFIRMED',official_number=?,confirmed_at=NOW(),version=version+1 WHERE id=?",[$number,$id]);
            $this->event($b,'eq_ba_confirmed',$key,['number'=>$number,'correction_of_id'=>$b['correction_of_id'],'closure'=>$closure,'reason'=>$reason],'DRAFT','CONFIRMED');return ['id'=>$id];
        },'handover');
    }
    private function returnSources(array $c,array $units,string $reason):void
    {
        $this->recoverySources=[];
        $r=$this->records->data->repo;$sources=['md_customers'=>[(int)$c['customer_id']],'md_assets'=>[],'md_personnel'=>[]];
        foreach($units as $u){$sources['md_assets'][]=(int)$u['asset_id'];foreach($this->records->data->operators((int)$u['id']) as $o)if(in_array($o['status'],['DRAFT','CONFIRMED','ACTIVE'],true))$sources['md_personnel'][]=(int)$o['operator_id'];}
        $inactive=[];foreach($sources as $table=>$ids){$ids=array_unique($ids);sort($ids);foreach($ids as $source){$m=$r->one('SELECT * FROM '.$table.' WHERE id=? FOR UPDATE',[$source]);$branch=$m?$r->one('SELECT active FROM branches WHERE id=? FOR UPDATE',[$m['branch_id']]):null;if(!$m||!$m['active']||!$branch||!$branch['active'])$inactive[]=$table.':'.$source;}}
        if($inactive){$this->records->data->guard->actor('equipment.recovery.close',true);if(trim($reason)==='')throw new HttpError(422,'Alasan recovery wajib.');}
        // Preserve the exception in the confirmation audit; no master is reactivated.
        if($inactive)$this->recoverySources=$inactive;
    }
    private array $recoverySources=[];
    private function aggregate(array $b,array $c,string $key,string $closure):void
    {
        $r=$this->records->data->repo;$units=$this->records->data->units((int)$c['id'],true);$open=array_filter($units,fn($u)=>in_array($u['status'],['DRAFT','CONFIRMED','ACTIVE'],true));
        $early=$closure==='EARLY'||$c['closure_kind']==='EARLY'||(bool)array_filter($units,fn($u)=>$u['status']==='TERMINATED');
        $next=$open?'ACTIVE':($early?'TERMINATED':'COMPLETED');
        $operatorOpen=$r->one("SELECT o.id FROM eq_operator_assignments o JOIN eq_contract_units u ON u.id=o.contract_unit_id WHERE u.contract_id=? AND o.status IN('DRAFT','CONFIRMED','ACTIVE') LIMIT 1 FOR UPDATE",[$c['id']]);
        if(!$open&&$operatorOpen)throw new HttpError(409,'Masih ada penugasan operator yang belum diselesaikan.');
        $r->run('UPDATE eq_contracts SET status=?,closure_kind=?,activated_at=COALESCE(activated_at,?),closed_at=? WHERE id=?',[$next,$early?'EARLY':($open?null:'NORMAL'),$b['document_type']==='HANDOVER'?$b['occurrence_at']:$c['activated_at'],$open?null:$b['occurrence_at'],$c['id']]);
        if($c['status']!==$next)$this->event($b,'eq_ba_contract_changed',$key,['from'=>$c['status'],'to'=>$next,'recovery_sources'=>$this->recoverySources],$c['status'],$next);
    }
    private function number(int $branch):string
    {
        $r=$this->records->data->repo;$b=$r->one('SELECT * FROM branches WHERE id=? FOR UPDATE',[$branch]);$year=(int)date('Y');
        $r->run("INSERT INTO eq_document_sequences VALUES ('BA',?,?,0) ON DUPLICATE KEY UPDATE last_value=last_value",[$branch,$year]);
        $next=(int)$r->one("SELECT last_value FROM eq_document_sequences WHERE document_type='BA' AND branch_id=? AND document_year=? FOR UPDATE",[$branch,$year])['last_value']+1;
        if($next>999999)throw new HttpError(409,'Urutan BA tahun ini habis.');
        $r->run("UPDATE eq_document_sequences SET last_value=? WHERE document_type='BA' AND branch_id=? AND document_year=?",[$next,$branch,$year]);
        return 'BA/'.$b['code'].'/'.$year.'/'.str_pad((string)$next,6,'0',STR_PAD_LEFT);
    }
    /** An administrative addendum copies all operational facts; only its reason is new. */
    public function correct(int $source,string $key,string $reason):array
    {
        if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Catatan koreksi administratif wajib.');
        $b=$this->records->find($source);$c=$this->records->contract((int)$b['contract_id']);
        return $this->write->run('equipment.handover.correct','eq_ba_correct',$key,compact('source','reason'),(int)$c['branch_id'],(int)$c['id'],function()use($source,$key,$reason):array{
            $r=$this->records->data->repo;$b=$this->records->find($source,true);if($b['status']!=='CONFIRMED')throw new HttpError(409,'Koreksi hanya untuk BA confirmed.');
            $r->run('INSERT INTO eq_handover_documents(contract_id,internal_ref,document_type,scope_mode,occurrence_at,correction_of_id,correction_reason,created_by) VALUES (?,?,?,?,?,?,?,?)',[$b['contract_id'],'INT-BA-'.strtoupper(bin2hex(random_bytes(16))),$b['document_type'],$b['scope_mode'],$b['occurrence_at'],$source,$reason,$this->records->data->guard->access->user['id']]);$id=(int)$r->db->lastInsertId();
            foreach($this->records->units($source,true) as $u)$r->run('INSERT INTO eq_handover_units(handover_id,contract_id,contract_unit_id,condition_note,hm_reading,occurrence_at,snapshot) VALUES (?,?,?,?,?,?,?)',[$id,$b['contract_id'],$u['contract_unit_id'],$u['condition_note'],$u['hm_reading'],$u['occurrence_at'],$u['snapshot']]);
            $new=$this->records->find($id,true);$this->event($new,'eq_ba_administrative_correction',$key,['source_id'=>$source,'reason'=>$reason],null,'DRAFT');return ['id'=>$id];
        },'handover');
    }
}

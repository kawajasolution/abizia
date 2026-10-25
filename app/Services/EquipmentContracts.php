<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\EquipmentRepository;
use Hls\Services\EquipmentOperationalGuard;
final class EquipmentContracts
{
    public readonly EquipmentWrite $write;
    public function __construct(public readonly EquipmentRepository $data,Audit $audit){$this->write=new EquipmentWrite($data,$audit);}
    private function version(array $row,int $version):void{if((int)$row['version']!==$version)throw new HttpError(409,'Versi berubah. Muat ulang kontrak.');}
    private function open(array $c):void{if(!in_array($c['status'],['DRAFT','CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Kontrak sudah terminal.');}
    private function row(string $table,int $id):array
    {
        if(!in_array($table,['md_customers','md_assets','md_personnel','branches'],true))throw new \LogicException('Master tidak sah.');
        $r=$this->data->repo->one("SELECT * FROM $table WHERE id=? FOR UPDATE",[$id]);if(!$r||!$r['active'])throw new HttpError(422,'Master terkini tidak aktif/tidak tersedia.');
        if(isset($r['branch_id'])){$b=$this->data->repo->one('SELECT active FROM branches WHERE id=? FOR UPDATE',[$r['branch_id']]);if(!$b||!$b['active'])throw new HttpError(422,'Cabang sumber tidak aktif.');}return $r;
    }
    private function source(string $table,int $id):array
    {
        $r=$this->row($table,$id);if($r['kind']!==($table==='md_assets'?'equipment':'operator'))throw new HttpError(422,'Jenis sumber tidak sesuai Equipment.');
        if($table==='md_personnel'&&$r['account_id']){$a=$this->data->repo->one('SELECT * FROM users WHERE id=? FOR UPDATE',[$r['account_id']]);if(!$a||!$a['active']||(!$a['all_branches']&&!$this->data->repo->one('SELECT user_id FROM user_branches WHERE user_id=? AND branch_id=? FOR UPDATE',[$a['id'],$r['branch_id']])))throw new HttpError(422,'Akun operator tidak aktif/tidak mempunyai cabang sumber.');}return $r;
    }
    public static function date(string $value):string
    {
        $d=\DateTimeImmutable::createFromFormat('!Y-m-d',$value);if(!$d||$d->format('Y-m-d')!==$value||$value<'1000-01-01'||$value>'9999-12-30')throw new HttpError(422,'Tanggal tidak sah.');return $value;
    }
    public static function time(string $value):string
    {
        $value=str_replace('T',' ',$value);if(strlen($value)===16)$value.=':00';$d=\DateTimeImmutable::createFromFormat('!Y-m-d H:i:s',$value);if(!$d||$d->format('Y-m-d H:i:s')!==$value)throw new HttpError(422,'Datetime tidak sah.');self::date(substr($value,0,10));return $value;
    }
    private function bounds(array $p):array{return [$p['starts_on'].' 00:00:00',(new \DateTimeImmutable($p['ends_on']))->modify('+1 day')->format('Y-m-d').' 00:00:00'];}
    private function unit(int $id,int $contract):array{return $this->data->repo->one('SELECT * FROM eq_contract_units WHERE id=? AND contract_id=? FOR UPDATE',[$id,$contract])??throw new HttpError(404,'Unit kontrak tidak ditemukan.');}
    private function period(int $id,int $unit):array{return $this->data->repo->one('SELECT * FROM eq_unit_periods WHERE id=? AND contract_unit_id=? FOR UPDATE',[$id,$unit])??throw new HttpError(404,'Periode tidak ditemukan.');}
    private function bump(int $id):void{$this->data->repo->run('UPDATE eq_contracts SET version=version+1 WHERE id=?',[$id]);}
    private function run(int $id,int $version,string $permission,string $action,string $key,array $payload,callable $work):array
    {
        $c=$this->data->find($id);return $this->write->run($permission,$action,$key,['id'=>$id,'version'=>$version]+$payload,(int)$c['branch_id'],$id,function()use($id,$version,$work):array{$c=$this->data->header($id,true);$this->version($c,$version);$work($c);$this->bump($id);return ['id'=>$id];});
    }
    private function permissionForeign(int $owner,int $branch):void{if($owner!==$branch)$this->data->guard->actor('equipment.cross_branch.request',true);}
    public function save(array $input):array
    {
        $id=Input::id($input,'id',true);$branch=Input::id($input,'branch_id');$customer=Input::id($input,'customer_id');$project=Input::text($input,'project_address',1000,false);$version=$id?Input::id($input,'version'):0;$key=Input::text($input,'request_key',64);
        if($id){$c=$this->data->find($id);if((int)$c['branch_id']!==$branch)throw new HttpError(422,'Cabang kontrak tidak boleh dipindahkan.');}
        return $this->write->run('equipment.contract.'.($id?'update':'create'),'eq_draft_save',$key,compact('id','branch','customer','project','version'),$branch,$id,function()use($id,$branch,$customer,$project,$version,$key):array{
            $before=$id?$this->data->header($id,true):null;if($before){$this->version($before,$version);if($before['status']!=='DRAFT')throw new HttpError(409,'Hanya header DRAFT dapat diedit.');}
            $m=$this->row('md_customers',$customer);if((int)$m['branch_id']!==$branch)throw new HttpError(422,'Customer bukan cabang kontrak.');$snapshot=json_encode(['customer'=>array_intersect_key($m,array_flip(['id','code','name','address']))],JSON_THROW_ON_ERROR);$r=$this->data->repo;
            if($id){$r->run('UPDATE eq_contracts SET customer_id=?,project_address=?,snapshot=?,version=version+1 WHERE id=?',[$customer,$project,$snapshot,$id]);}
            else{$r->run('INSERT INTO eq_contracts(internal_ref,branch_id,customer_id,project_address,snapshot,created_by) VALUES (?,?,?,?,?,?)',['INT-KS-'.strtoupper(bin2hex(random_bytes(16))),$branch,$customer,$project,$snapshot,$this->data->guard->access->user['id']]);$id=(int)$r->db->lastInsertId();}
            $this->write->event($id,'eq_draft_saved',$key,['before'=>$before,'customer_id'=>$customer,'project_address'=>$project]);return ['id'=>$id];
        });
    }
    public function saveUnit(int $id,int $version,string $key,array $input):array
    {
        $unit=Input::id($input,'unit_id',true);$asset=Input::id($input,'asset_id',true);$foreign=Input::id($input,'foreign_asset_id',true);if(($asset&&$foreign)||(!$asset&&!$foreign))throw new HttpError(422,'Pilih satu unit dari daftar atau referensi lintas cabang.');$asset=$asset?:$foreign;$mode=Input::text($input,'operator_mode',7);if(!in_array($mode,['WITH','WITHOUT'],true))throw new HttpError(422,'Mode operator tidak sah.');
        $start=self::date(Input::text($input,'starts_on',10));$end=self::date(Input::text($input,'ends_on',10));if($end<$start)throw new HttpError(422,'Akhir periode sebelum awal.');
        $reason=Input::text($input,'reason',2000,$unit>0);
        return $this->run($id,$version,'equipment.assignment.manage','eq_unit_save',$key,compact('unit','asset','mode','start','end','reason'),function(array $c)use($id,$key,$unit,$asset,$mode,$start,$end,$reason):void{
            $this->open($c);$r=$this->data->repo;$old=$unit?$this->unit($unit,$id):null;if($old&&$old['status']!=='DRAFT')throw new HttpError(409,'Detail confirmed tidak diedit langsung.');
            if($old&&array_filter($this->data->operators($unit,true),fn($o)=>in_array($o['status'],['DRAFT','CONFIRMED','ACTIVE'],true)))throw new HttpError(409,'Batalkan penugasan draf terlebih dahulu sebelum mengganti detail.');
            $a=$this->source('md_assets',$asset);$this->permissionForeign((int)$a['branch_id'],(int)$c['branch_id']);$snapshot=json_encode(['asset'=>array_intersect_key($a,array_flip(['id','code','name','identity','branch_id']))],JSON_THROW_ON_ERROR);
            if(!$unit){$line=(int)$r->one('SELECT COALESCE(MAX(line_no),0)+1 n FROM eq_contract_units WHERE contract_id=?',[$id])['n'];$r->run('INSERT INTO eq_contract_units(contract_id,contract_branch_id,line_no,asset_id,asset_owner_branch_id,operator_mode,snapshot) VALUES (?,?,?,?,?,?,?)',[$id,$c['branch_id'],$line,$asset,$a['branch_id'],$mode,$snapshot]);$unit=(int)$r->db->lastInsertId();}
            else{$r->run('UPDATE eq_contract_units SET asset_id=?,asset_owner_branch_id=?,operator_mode=?,snapshot=?,version=version+1 WHERE id=?',[$asset,$a['branch_id'],$mode,$snapshot,$unit]);}
            $previous=$old['current_period_id']??null;$revision=(int)$r->one('SELECT COALESCE(MAX(revision_no),0)+1 n FROM eq_unit_periods WHERE contract_unit_id=?',[$unit])['n'];
            $r->run("INSERT INTO eq_unit_periods(contract_unit_id,revision_no,starts_on,ends_on,previous_period_id,change_kind,reason,actor_id) VALUES (?,?,?,?,?,'INITIAL',?,?)",[$unit,$revision,$start,$end,$previous,$reason,$this->data->guard->access->user['id']]);$period=(int)$r->db->lastInsertId();$r->run('UPDATE eq_contract_units SET current_period_id=? WHERE id=?',[$period,$unit]);
            $this->write->event($id,'eq_unit_draft_saved',$key,['before'=>$old,'asset_id'=>$asset,'operator_mode'=>$mode,'starts_on'=>$start,'ends_on'=>$end],$unit,$period);
        });
    }
    public function operator(int $id,int $version,string $key,array $input):array
    {
        $unit=Input::id($input,'unit_id');$operator=Input::id($input,'operator_id',true);$foreign=Input::id($input,'foreign_operator_id',true);if(($operator&&$foreign)||(!$operator&&!$foreign))throw new HttpError(422,'Pilih satu operator dari daftar atau referensi lintas cabang.');$operator=$operator?:$foreign;$previous=Input::id($input,'previous_assignment_id',true);$start=self::time(Input::text($input,'starts_at',19));$end=self::time(Input::text($input,'ends_at_exclusive',19));$reason=Input::text($input,'reason',2000,$previous>0);if($end<=$start)throw new HttpError(422,'Interval operator kosong/terbalik.');
        return $this->run($id,$version,'equipment.assignment.manage','eq_operator_propose',$key,compact('unit','operator','previous','start','end','reason'),function(array $c)use($id,$unit,$operator,$previous,$start,$end,$reason,$key):void{
            $this->open($c);$u=$this->unit($unit,$id);if(!in_array($u['status'],['DRAFT','CONFIRMED'],true)||$u['operator_mode']!=='WITH')throw new HttpError(409,'Penugasan M3 memerlukan unit WITH yang belum ACTIVE.');
            $r=$this->data->repo;$p=$this->source('md_personnel',$operator);$this->permissionForeign((int)$p['branch_id'],(int)$c['branch_id']);
            if($previous){$old=$r->one('SELECT * FROM eq_operator_assignments WHERE id=? AND contract_unit_id=? FOR UPDATE',[$previous,$unit]);if(!$old||!in_array($old['status'],['DRAFT','CONFIRMED'],true))throw new HttpError(409,'Penugasan sebelumnya tidak dapat diganti pada M3.');if($old['status']==='DRAFT')$r->run("UPDATE eq_operator_assignments SET status='CANCELLED',version=version+1 WHERE id=?",[$previous]);}
            $r->run('INSERT INTO eq_operator_assignments(contract_unit_id,operator_id,operator_owner_branch_id,effective_account_id,starts_at,ends_at_exclusive,previous_assignment_id,reason) VALUES (?,?,?,?,?,?,?,?)',[$unit,$operator,$p['branch_id'],$p['account_id'],$start,$end,$previous?:null,$reason]);$assignment=(int)$r->db->lastInsertId();
            $this->write->event($id,'eq_operator_proposed',$key,['operator_id'=>$operator,'start'=>$start,'end'=>$end,'previous_assignment_id'=>$previous],$unit,null,$assignment);
        });
    }
    private function approval(array $c,array $u,array $p,?array $o=null):void
    {
        $owner=(int)($o['operator_owner_branch_id']??$u['asset_owner_branch_id']);if($owner===(int)$c['branch_id'])return;
        [$start,$end]=$o?[$o['starts_at'],$o['ends_at_exclusive']]:$this->bounds($p);
        $sql="SELECT * FROM eq_branch_authorizations WHERE contract_unit_id=? AND period_id=? AND resource_type=? AND status='APPROVED' AND owner_branch_id=? AND contract_branch_id=? AND valid_from<=? AND valid_until_exclusive>=?";
        $args=[$u['id'],$p['id'],$o?'OPERATOR':'UNIT',$owner,$c['branch_id'],$start,$end];$sql.=$o?' AND operator_assignment_id=?':' AND operator_assignment_id IS NULL';if($o)$args[]=$o['id'];$a=$this->data->repo->one($sql.' ORDER BY id DESC LIMIT 1 FOR UPDATE',$args);
        if(!$a||$a['owner_approved_by']===$a['contract_approved_by']||$a['requested_by']===$a['owner_approved_by']||$a['requested_by']===$a['contract_approved_by'])throw new HttpError(409,'Dua persetujuan lintas cabang sah belum lengkap untuk sumber/periode ini.');
        foreach([[$a['owner_approved_by'],$owner],[$a['contract_approved_by'],(int)$c['branch_id']]] as [$actor,$branch]){
            $valid=$this->data->repo->one("SELECT u.id FROM users u JOIN role_permissions rp ON rp.role_id=u.role_id JOIN permissions pe ON pe.id=rp.permission_id JOIN branches b ON b.id=? AND b.active=1 WHERE u.id=? AND u.active=1 AND pe.code='equipment.cross_branch.approve' AND (u.all_branches=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=u.id AND ub.branch_id=b.id)) FOR UPDATE",[$branch,$actor]);if(!$valid)throw new HttpError(409,'Otorisasi pemberi persetujuan telah dicabut.');
        }
    }
    private function resources(array $units,bool $active=true):void
    {
        $assets=[];$operators=[];foreach($units as $u){$assets[]=(int)$u['asset_id'];foreach($this->data->operators((int)$u['id']) as $o)if(in_array($o['status'],['DRAFT','CONFIRMED','ACTIVE'],true))$operators[]=(int)$o['operator_id'];}
        $assets=array_unique($assets);sort($assets);$operators=array_unique($operators);sort($operators);foreach($assets as $asset){if($active)$this->source('md_assets',$asset);else $this->data->repo->one('SELECT id FROM md_assets WHERE id=? FOR UPDATE',[$asset]);}foreach($operators as $operator){if($active)$this->source('md_personnel',$operator);else $this->data->repo->one('SELECT id FROM md_personnel WHERE id=? FOR UPDATE',[$operator]);}
    }
    private function checkUnit(array $c,array $u,array $p,bool $approval=true):void
    {
        $r=$this->data->repo;$a=$this->source('md_assets',(int)$u['asset_id']);if((int)$a['branch_id']!==(int)$u['asset_owner_branch_id'])throw new HttpError(409,'Pemilik sumber berubah.');if($approval)$this->approval($c,$u,$p);
        $conflict=$r->one("SELECT u.id FROM eq_contract_units u JOIN eq_unit_periods p ON p.id=u.current_period_id WHERE u.asset_id=? AND u.id<>? AND (u.status='ACTIVE' OR (u.status='CONFIRMED' AND p.starts_on<=? AND p.ends_on>=?)) LIMIT 1 FOR UPDATE",[$u['asset_id'],$u['id'],$p['ends_on'],$p['starts_on']]);if($conflict)throw new HttpError(409,'Unit sedang digunakan atau periode reservasi bertabrakan.');
    }
    private function checkOperator(array $c,array $u,array $p,array $o,array $pending=[]):void
    {
        $r=$this->data->repo;$source=$this->source('md_personnel',(int)$o['operator_id']);if((int)$source['branch_id']!==(int)$o['operator_owner_branch_id']||($source['account_id']??null)!==($o['effective_account_id']??null))throw new HttpError(409,'Identitas/akun operator berubah; buat penugasan pengganti eksplisit.');
        [$start,$end]=$this->bounds($p);if($o['starts_at']<$start||$o['ends_at_exclusive']>$end)throw new HttpError(422,'Jadwal operator di luar periode unit.');$this->approval($c,$u,$p,$o);
        $hits=$r->all("SELECT * FROM eq_operator_assignments WHERE id<>? AND (operator_id=? OR contract_unit_id=?) AND status IN('CONFIRMED','ACTIVE') AND starts_at<? AND ends_at_exclusive>? FOR UPDATE",[$o['id'],$o['operator_id'],$u['id'],$o['ends_at_exclusive'],$o['starts_at']]);
        foreach([...$hits,...$pending] as $other){if((int)$other['id']===(int)$o['id']||(int)$other['id']===(int)($o['previous_assignment_id']??0))continue;if(($other['operator_id']===$o['operator_id']||$other['contract_unit_id']===$o['contract_unit_id'])&&$other['starts_at']<$o['ends_at_exclusive']&&$other['ends_at_exclusive']>$o['starts_at'])throw new HttpError(409,'Jadwal operator/unit bertabrakan.');}
    }
    /** Reuse the M3 source/calendar/approval guards at actual handover time. */
    public function validateHandover(array $c,array $units):void
    {
        $customer=$this->row('md_customers',(int)$c['customer_id']);
        if((int)$customer['branch_id']!==(int)$c['branch_id'])throw new HttpError(422,'Cabang customer berubah.');
        $this->resources($units);
        foreach($units as $u){$p=$this->period((int)$u['current_period_id'],(int)$u['id']);$this->checkUnit($c,$u,$p);$ops=array_values(array_filter($this->data->operators((int)$u['id'],true),fn($o)=>$o['status']==='CONFIRMED'));
            if(($u['operator_mode']==='WITH'&&!$ops)||($u['operator_mode']==='WITHOUT'&&$ops))throw new HttpError(409,'Penugasan operator tidak sesuai mode unit.');
            foreach($ops as $o)$this->checkOperator($c,$u,$p,$o);
        }
    }
    private function confirmUnits(array $c,array $units,string $key):void
    {
        $this->resources($units);$r=$this->data->repo;$pending=[];
        foreach($units as $u){if($u['status']!=='DRAFT')throw new HttpError(409,'Unit tambahan bukan DRAFT.');EquipmentOperationalGuard::assertAvailable($r,(int)$u['asset_id']);$p=$this->period((int)$u['current_period_id'],(int)$u['id']);$this->checkUnit($c,$u,$p);$ops=array_values(array_filter($this->data->operators((int)$u['id'],true),fn($o)=>$o['status']==='DRAFT'));
            if(($u['operator_mode']==='WITH'&&!$ops)||($u['operator_mode']==='WITHOUT'&&$ops))throw new HttpError(422,'WITH memerlukan operator; WITHOUT tidak boleh mempunyai operator.');
            // Replacement proposals are activated separately after the parent is confirmed.
            foreach($ops as $o){if($o['previous_assignment_id']){$previous=$r->one('SELECT status FROM eq_operator_assignments WHERE id=? FOR UPDATE',[$o['previous_assignment_id']]);if(!$previous||$previous['status']!=='CANCELLED')throw new HttpError(409,'Penugasan sebelumnya belum digantikan secara sah.');}$this->checkOperator($c,$u,$p,$o,$pending);$pending[]=$o;}
            $r->run("UPDATE eq_contract_units SET status='CONFIRMED',version=version+1 WHERE id=?",[$u['id']]);$r->run('UPDATE eq_unit_periods SET effective_at=NOW() WHERE id=?',[$p['id']]);
            foreach($ops as $o)$r->run("UPDATE eq_operator_assignments SET status='CONFIRMED',version=version+1 WHERE id=?",[$o['id']]);$this->write->event((int)$c['id'],'eq_unit_confirmed',$key,['operator_ids'=>array_column($ops,'id')],(int)$u['id'],(int)$p['id']);
        }
    }
    public function confirm(int $id,int $version,string $key,?int $unit=null):array
    {
        return $this->run($id,$version,'equipment.contract.confirm',$unit?'eq_unit_confirm':'eq_contract_confirm',$key,compact('unit'),function(array $c)use($id,$key,$unit):void{
            $r=$this->data->repo;$customer=$this->row('md_customers',(int)$c['customer_id']);if((int)$customer['branch_id']!==(int)$c['branch_id'])throw new HttpError(422,'Cabang customer berubah.');
            if($unit){$this->data->guard->actor('equipment.assignment.manage',true);if(!in_array($c['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Tambahan memerlukan kontrak CONFIRMED/ACTIVE.');$units=[$this->unit($unit,$id)];}
            else{if($c['status']!=='DRAFT')throw new HttpError(409,'Kontrak bukan DRAFT.');$units=array_values(array_filter($this->data->units($id,true),fn($u)=>$u['status']!=='CANCELLED'));if(!$units)throw new HttpError(422,'Tambahkan minimal satu unit.');}
            $this->confirmUnits($c,$units,$key);
            if(!$unit){$branch=$this->row('branches',(int)$c['branch_id']);$year=(int)date('Y');$r->run("INSERT INTO eq_document_sequences VALUES ('KS',?,?,0) ON DUPLICATE KEY UPDATE last_value=last_value",[$branch['id'],$year]);$sequence=$r->one("SELECT last_value FROM eq_document_sequences WHERE document_type='KS' AND branch_id=? AND document_year=? FOR UPDATE",[$branch['id'],$year]);$next=(int)$sequence['last_value']+1;if($next>999999)throw new HttpError(409,'Urutan KS tahun ini habis.');$number='KS/'.$branch['code'].'/'.$year.'/'.str_pad((string)$next,6,'0',STR_PAD_LEFT);$r->run("UPDATE eq_document_sequences SET last_value=? WHERE document_type='KS' AND branch_id=? AND document_year=?",[$next,$branch['id'],$year]);$r->run("UPDATE eq_contracts SET status='CONFIRMED',official_number=?,confirmed_at=NOW() WHERE id=?",[$number,$id]);$this->write->event($id,'eq_contract_confirmed',$key,['number'=>$number]);}
        });
    }
    public function cancel(int $id,int $version,string $key,string $reason,?int $unit=null,?int $assignment=null):array
    {
        if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Alasan pembatalan wajib.');
        return $this->run($id,$version,$unit||$assignment?'equipment.assignment.manage':'equipment.contract.cancel','eq_cancel',$key,compact('reason','unit','assignment'),function(array $c)use($id,$key,$reason,$unit,$assignment):void{
            $this->open($c);$r=$this->data->repo;
            if($assignment){$o=$r->one('SELECT a.* FROM eq_operator_assignments a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=? AND u.contract_id=? FOR UPDATE',[$assignment,$id]);if(!$o||$o['status']!=='DRAFT')throw new HttpError(409,'Pembatalan langsung operator hanya DRAFT; gunakan penugasan pengganti.');$r->run("UPDATE eq_operator_assignments SET status='CANCELLED',version=version+1 WHERE id=?",[$assignment]);$this->write->event($id,'eq_operator_cancelled',$key,compact('reason'),(int)$o['contract_unit_id'],null,$assignment);return;}
            if(!$unit&&!in_array($c['status'],['DRAFT','CONFIRMED'],true))throw new HttpError(409,'Kontrak sudah pernah aktif.');$units=$unit?[$this->unit($unit,$id)]:$this->data->units($id,true);$this->resources(array_filter($units,fn($u)=>$u['status']!=='CANCELLED'),false);
            foreach($units as $u){if($u['status']==='CANCELLED')continue;if(!in_array($u['status'],['DRAFT','CONFIRMED'],true)||$u['actual_start'])throw new HttpError(409,'Unit telah berjalan; pengembalian sah diperlukan.');foreach($this->data->operators((int)$u['id'],true) as $o)if($o['status']==='ACTIVE'||$o['actual_start'])throw new HttpError(409,'Operator telah aktif.');$r->run("UPDATE eq_contract_units SET status='CANCELLED',version=version+1 WHERE id=?",[$u['id']]);$r->run("UPDATE eq_operator_assignments SET status='CANCELLED',version=version+1 WHERE contract_unit_id=? AND status IN('DRAFT','CONFIRMED')",[$u['id']]);$this->write->event($id,'eq_unit_cancelled',$key,['reason'=>$reason,'from'=>$u['status']],(int)$u['id']);}
            if(!$unit){$r->run("UPDATE eq_contracts SET status='CANCELLED',closed_at=NOW() WHERE id=?",[$id]);$this->write->event($id,'eq_contract_cancelled',$key,['reason'=>$reason,'from'=>$c['status']]);}
            elseif($c['status']==='ACTIVE'){
                // M4 integration: the last unstarted detail may be cancelled after all actual returns.
                $remaining=$this->data->units($id,true);
                if(!array_filter($remaining,fn($u)=>in_array($u['status'],['DRAFT','CONFIRMED','ACTIVE'],true))){
                    if($r->one("SELECT o.id FROM eq_operator_assignments o JOIN eq_contract_units u ON u.id=o.contract_unit_id WHERE u.contract_id=? AND o.status IN('DRAFT','CONFIRMED','ACTIVE') LIMIT 1 FOR UPDATE",[$id]))throw new HttpError(409,'Penugasan belum diselesaikan.');
                    $early=$c['closure_kind']==='EARLY'||(bool)array_filter($remaining,fn($u)=>$u['status']==='TERMINATED');$to=$early?'TERMINATED':'COMPLETED';
                    $this->data->guard->actor($early?'equipment.contract.terminate':'equipment.contract.close',true);
                    $r->run('UPDATE eq_contracts SET status=?,closure_kind=?,closed_at=NOW() WHERE id=?',[$to,$early?'EARLY':'NORMAL',$id]);$this->write->event($id,'eq_contract_closed_after_cancel',$key,['from'=>'ACTIVE','to'=>$to,'reason'=>$reason]);
                }
            }
        });
    }
    public function extension(int $id,int $version,string $key,int $unit,string $end,string $reason,?int $apply=null):array
    {
        if(!$apply)$end=self::date($end);if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Alasan perpanjangan wajib.');
        return $this->run($id,$version,'equipment.contract.extend',$apply?'eq_extension_apply':'eq_extension_propose',$key,compact('unit','end','reason','apply'),function(array $c)use($id,$unit,$end,$reason,$apply,$key):void{
            if(!in_array($c['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Kontrak belum dikonfirmasi.');$u=$this->unit($unit,$id);if(!in_array($u['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Unit tidak dapat diperpanjang.');$r=$this->data->repo;$old=$this->period((int)$u['current_period_id'],$unit);$this->resources([$u]);
            if(!$apply){if($end<=$old['ends_on'])throw new HttpError(422,'Perpanjangan harus menambah akhir periode.');$revision=(int)$r->one('SELECT MAX(revision_no)+1 n FROM eq_unit_periods WHERE contract_unit_id=?',[$unit])['n'];$r->run("INSERT INTO eq_unit_periods(contract_unit_id,revision_no,starts_on,ends_on,previous_period_id,change_kind,reason,actor_id) VALUES (?,?,?,?,?,'EXTENSION',?,?)",[$unit,$revision,$old['starts_on'],$end,$old['id'],$reason,$this->data->guard->access->user['id']]);$p=$this->period((int)$r->db->lastInsertId(),$unit);$this->checkUnit($c,$u,$p,false);
            }else{$p=$this->period($apply,$unit);if($p['effective_at']||$p['change_kind']!=='EXTENSION'||(int)$p['previous_period_id']!==(int)$old['id'])throw new HttpError(409,'Usulan periode stale/telah efektif.');$this->checkUnit($c,$u,$p);foreach($this->data->operators($unit,true) as $o)if(in_array($o['status'],['CONFIRMED','ACTIVE'],true))$this->checkOperator($c,$u,$p,$o);$r->run('UPDATE eq_unit_periods SET effective_at=NOW() WHERE id=?',[$p['id']]);$r->run('UPDATE eq_contract_units SET current_period_id=?,version=version+1 WHERE id=?',[$p['id'],$unit]);}
            $this->write->event($id,$apply?'eq_extension_applied':'eq_extension_proposed',$key,compact('reason'),$unit,(int)$p['id']);
        });
    }
    public function confirmOperator(int $id,int $version,string $key,int $assignment):array
    {
        return $this->run($id,$version,'equipment.assignment.manage','eq_operator_confirm',$key,compact('assignment'),function(array $c)use($id,$assignment,$key):void{
            if(!in_array($c['status'],['CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Kontrak belum confirmed.');$r=$this->data->repo;$o=$r->one('SELECT a.* FROM eq_operator_assignments a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=? AND u.contract_id=? FOR UPDATE',[$assignment,$id]);if(!$o||$o['status']!=='DRAFT')throw new HttpError(409,'Usulan operator tidak sah.');$u=$this->unit((int)$o['contract_unit_id'],$id);if($u['status']!=='CONFIRMED')throw new HttpError(409,'Perubahan operator M3 hanya sebelum unit ACTIVE.');EquipmentOperationalGuard::assertAvailable($r,(int)$u['asset_id']);$this->resources([$u]);$p=$this->period((int)$u['current_period_id'],(int)$u['id']);$this->checkOperator($c,$u,$p,$o);
            if($o['previous_assignment_id']){$old=$r->one('SELECT * FROM eq_operator_assignments WHERE id=? FOR UPDATE',[$o['previous_assignment_id']]);if(!$old||!in_array($old['status'],['CONFIRMED','CANCELLED'],true)||$old['actual_start'])throw new HttpError(409,'Penugasan lama tidak lagi eligible.');if($old['status']==='CONFIRMED')$r->run("UPDATE eq_operator_assignments SET status='CANCELLED',version=version+1 WHERE id=?",[$old['id']]);}
            $r->run("UPDATE eq_operator_assignments SET status='CONFIRMED',version=version+1 WHERE id=?",[$assignment]);$this->write->event($id,'eq_operator_confirmed',$key,['previous_assignment_id'=>$o['previous_assignment_id']],(int)$u['id'],null,$assignment);
        });
    }
    public function requestApproval(int $id,int $version,string $key,int $unit,int $period,?int $assignment,string $reason):array
    {
        if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Alasan permintaan wajib.');
        return $this->run($id,$version,'equipment.cross_branch.request','eq_cross_request',$key,compact('unit','period','assignment','reason'),function(array $c)use($id,$unit,$period,$assignment,$reason,$key):void{
            $this->open($c);$u=$this->unit($unit,$id);if(!in_array($u['status'],['DRAFT','CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Detail terminal.');$p=$this->period($period,$unit);if((int)$p['id']!==(int)$u['current_period_id']&&($p['change_kind']!=='EXTENSION'||$p['effective_at']||(int)$p['previous_period_id']!==(int)$u['current_period_id']))throw new HttpError(409,'Periode request bukan periode kini/usulan extension yang berlaku.');$o=null;$owner=(int)$u['asset_owner_branch_id'];[$start,$end]=$this->bounds($p);$r=$this->data->repo;
            if($assignment){$o=$r->one('SELECT * FROM eq_operator_assignments WHERE id=? AND contract_unit_id=? FOR UPDATE',[$assignment,$unit]);if(!$o||!in_array($o['status'],['DRAFT','CONFIRMED','ACTIVE'],true))throw new HttpError(409,'Penugasan tidak sah.');$owner=(int)$o['operator_owner_branch_id'];$start=$o['starts_at'];$end=$o['ends_at_exclusive'];}
            if($owner===(int)$c['branch_id'])throw new HttpError(422,'Sumber bukan lintas cabang.');$this->resources([$u]);
            if($r->one("SELECT id FROM eq_branch_authorizations WHERE contract_unit_id=? AND period_id=? AND COALESCE(operator_assignment_id,0)=? AND status IN('REQUESTED','APPROVED') FOR UPDATE",[$unit,$period,$assignment??0]))throw new HttpError(409,'Permintaan periode/sumber ini sudah ada.');
            $r->run('INSERT INTO eq_branch_authorizations(contract_unit_id,operator_assignment_id,period_id,resource_type,owner_branch_id,contract_branch_id,valid_from,valid_until_exclusive,requested_by,reason) VALUES (?,?,?,?,?,?,?,?,?,?)',[$unit,$assignment,$period,$assignment?'OPERATOR':'UNIT',$owner,$c['branch_id'],$start,$end,$this->data->guard->access->user['id'],$reason]);$this->write->event($id,'eq_cross_requested',$key,['authorization_id'=>(int)$r->db->lastInsertId(),'reason'=>$reason],$unit,$period,$assignment);
        });
    }
    public function approve(int $authorization,int $version,string $side,string $key):array
    {
        if(!in_array($side,['owner','contract'],true))throw new HttpError(422,'Pihak persetujuan tidak sah.');$r=$this->data->repo;$this->data->guard->actor('equipment.cross_branch.approve');$a=$r->one('SELECT a.*,u.contract_id FROM eq_branch_authorizations a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=?',[$authorization])??throw new HttpError(404,'Permintaan tidak ditemukan.');$branch=(int)$a[$side==='owner'?'owner_branch_id':'contract_branch_id'];
        return $this->write->run('equipment.cross_branch.approve','eq_cross_approve',$key,['authorization'=>$authorization,'version'=>$version,'side'=>$side,'contract_branch_id'=>(int)$a['contract_branch_id']],$branch,(int)$a['contract_id'],function()use($r,$authorization,$version,$side,$key):array{
            $a=$r->one('SELECT a.*,u.contract_id,u.status unit_status FROM eq_branch_authorizations a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=? FOR UPDATE',[$authorization]);$this->version($a,$version);$c=$this->data->header((int)$a['contract_id'],true);$this->open($c);if(!in_array($a['unit_status'],['DRAFT','CONFIRMED','ACTIVE'],true)||$a['status']!=='REQUESTED')throw new HttpError(409,'Permintaan tidak eligible.');$actor=(int)$this->data->guard->access->user['id'];$other=$a[$side==='owner'?'contract_approved_by':'owner_approved_by'];if($actor===(int)$a['requested_by']||$actor===(int)$other)throw new HttpError(403,'Tidak boleh menyetujui permintaan sendiri atau kedua pihak dengan akun sama.');$column=$side==='owner'?'owner_approved':'contract_approved';if($a[$column.'_by'])throw new HttpError(409,'Pihak ini sudah menyetujui.');
            $r->run("UPDATE eq_branch_authorizations SET {$column}_by=?,{$column}_at=NOW(),version=version+1 WHERE id=?",[$actor,$authorization]);$r->run("UPDATE eq_branch_authorizations SET status='APPROVED' WHERE id=? AND owner_approved_by IS NOT NULL AND contract_approved_by IS NOT NULL",[$authorization]);$this->bump((int)$c['id']);$this->write->event((int)$c['id'],'eq_cross_approved',$key,compact('authorization','side'),(int)$a['contract_unit_id'],(int)$a['period_id'],$a['operator_assignment_id']?(int)$a['operator_assignment_id']:null);return ['id'=>(int)$c['id']];
        });
    }
    public function revoke(int $authorization,int $version,string $side,string $reason,string $key):array
    {
        if(!in_array($side,['owner','contract'],true)||trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Pihak dan alasan pencabutan wajib.');
        $r=$this->data->repo;$this->data->guard->actor('equipment.cross_branch.approve');$a=$r->one('SELECT a.*,u.contract_id FROM eq_branch_authorizations a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=?',[$authorization])??throw new HttpError(404,'Permintaan tidak ditemukan.');$branch=(int)$a[$side==='owner'?'owner_branch_id':'contract_branch_id'];
        return $this->write->run('equipment.cross_branch.approve','eq_cross_revoke',$key,['authorization'=>$authorization,'version'=>$version,'side'=>$side,'reason'=>$reason,'contract_branch_id'=>(int)$a['contract_branch_id']],$branch,(int)$a['contract_id'],function()use($r,$authorization,$version,$reason,$key):array{
            $a=$r->one('SELECT a.*,u.contract_id FROM eq_branch_authorizations a JOIN eq_contract_units u ON u.id=a.contract_unit_id WHERE a.id=? FOR UPDATE',[$authorization]);$this->version($a,$version);if($a['status']!=='APPROVED')throw new HttpError(409,'Hanya persetujuan lengkap dapat dicabut.');
            $r->run("UPDATE eq_branch_authorizations SET status='REVOKED',revoked_by=?,revoked_at=NOW(),revocation_reason=?,version=version+1 WHERE id=?",[$this->data->guard->access->user['id'],$reason,$authorization]);$this->bump((int)$a['contract_id']);$this->write->event((int)$a['contract_id'],'eq_cross_revoked',$key,compact('authorization','reason'),(int)$a['contract_unit_id'],(int)$a['period_id'],$a['operator_assignment_id']?(int)$a['operator_assignment_id']:null);return ['id'=>(int)$a['contract_id']];
        });
    }
}

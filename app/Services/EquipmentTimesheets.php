<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\EquipmentTimesheetRepository;

final class EquipmentTimesheets
{
    public readonly EquipmentWrite $write;
    public function __construct(public readonly EquipmentTimesheetRepository $records,private Audit $audit){$this->write=new EquipmentWrite($records->data,$audit);}
    private function version(array $row,int $version):void{if((int)$row['version']!==$version)throw new HttpError(409,'Versi timesheet berubah. Muat ulang.');}
    private function terminal(array $context,string $reason):void
    {
        if(in_array($context['contract']['status'],['COMPLETED','TERMINATED','CANCELLED'],true)||in_array($context['unit']['status'],['COMPLETED','TERMINATED','CANCELLED'],true)){
            $this->records->data->guard->actor('equipment.timesheet.revise_terminal',true);if(trim($reason)==='')throw new HttpError(422,'Alasan pencatatan/koreksi pascaterminal wajib.');
        }
    }
    private function validate(array $ctx,string $date,array $body,?string $historicalSnapshot=null):void
    {
        foreach (['standby_hours','breakdown_hours','billable_hours'] as $field) {
            $value = $body[$field] ?? '0';
            if ($value === '' || !preg_match('/^(?:0|[1-9][0-9]{0,8})(?:\.[0-9]{1,3})?$/D', (string)$value)) {
                throw new HttpError(422, 'Jam '.$field.' harus berupa angka nonnegatif dengan maksimal tiga desimal.');
            }
        }
        if ((float)($body['breakdown_hours'] ?? 0) > 0 && trim((string)($body['breakdown_note'] ?? '')) === '') {
            throw new HttpError(422, 'Catatan breakdown wajib diisi jika jam breakdown lebih dari nol.');
        }
        if (mb_strlen((string)($body['shift'] ?? '')) > 40 || mb_strlen((string)($body['project_location'] ?? '')) > 255) {
            throw new HttpError(422, 'Shift atau lokasi proyek terlalu panjang.');
        }
        $u=$ctx['unit'];$o=$ctx['assignment'];$r=$this->records->data->repo;
        EquipmentOperationalGuard::assertAvailable($r,(int)$u['asset_id']);
        if(!$u['actual_start']||!in_array($u['status'],['ACTIVE','COMPLETED','TERMINATED'],true))throw new HttpError(409,'Unit belum diserahkan atau tidak memenuhi syarat.');
        if($o&&!in_array($o['status'],['CONFIRMED','ACTIVE','COMPLETED','TERMINATED'],true)){
            $snapshot=$historicalSnapshot?json_decode($historicalSnapshot,true,512,JSON_THROW_ON_ERROR):[];$prior=$snapshot['assignment']??[];
            if($o['status']!=='CANCELLED'||!$u['actual_end']||(int)($prior['id']??0)!==(int)$o['id']||!in_array($prior['status']??'', ['CONFIRMED','ACTIVE'],true)||!$r->one("SELECT bu.id FROM eq_handover_units bu JOIN eq_handover_documents b ON b.id=bu.handover_id WHERE bu.contract_unit_id=? AND bu.lifecycle_effect='RETURN' AND b.status='CONFIRMED'",[$u['id']]))throw new HttpError(409,'Penugasan operator tidak memenuhi syarat.');
        }
        $period=$r->one('SELECT * FROM eq_unit_periods WHERE id=? AND contract_unit_id=? FOR UPDATE',[$u['current_period_id'],$u['id']]);
        if(!$period||!$period['effective_at'])throw new HttpError(409,'Periode efektif tidak ditemukan.');
        $next=(new \DateTimeImmutable($date))->modify('+1 day')->format('Y-m-d');
        if(substr($body['entries'][0]['starts_at'],0,10)!==$date)throw new HttpError(422,'Tanggal kerja harus tanggal mulai interval pertama WITA.');
        foreach($body['entries'] as $entry){$start=$entry['starts_at'];$end=$entry['ends_at_exclusive'];$day=substr($start,0,10);
            if(!in_array($day,[$date,$next],true))throw new HttpError(422,'Awal interval harus pada tanggal kerja atau hari berikutnya.');
            $limit=(new \DateTimeImmutable($period['ends_on']))->modify('+1 day')->format('Y-m-d').' 00:00:00';
            if($start<$period['starts_on'].' 00:00:00'||$end>$limit||$start<$u['actual_start']||($u['actual_end']&&$end>$u['actual_end']))throw new HttpError(422,'Interval di luar periode efektif/penggunaan aktual unit.');
            if($o&&($start<$o['starts_at']||$end>$o['ends_at_exclusive']||($o['actual_start']&&$start<$o['actual_start'])||($o['actual_end']&&$end>$o['actual_end'])))throw new HttpError(422,'Interval di luar jadwal/penggunaan aktual operator.');
        }
        // Source rows serialize submission/approval even when no other work interval exists yet.
        $r->one('SELECT id FROM md_assets WHERE id=? FOR UPDATE',[$u['asset_id']]);if($o)$r->one('SELECT id FROM md_personnel WHERE id=? FOR UPDATE',[$o['operator_id']]);
    }
    private function overlap(array $ctx,int $root,array $body):void
    {
        $r=$this->records->data->repo;
        foreach($body['entries'] as $e){$hit=$r->one("SELECT w.id FROM eq_timesheets t JOIN eq_contract_units u ON u.id=t.contract_unit_id LEFT JOIN eq_operator_assignments o ON o.id=t.operator_assignment_id JOIN eq_timesheet_revisions v ON v.timesheet_id=t.id JOIN eq_timesheet_work_entries w ON w.revision_id=v.id WHERE t.id<>? AND (u.asset_id=? OR (?<>0 AND o.operator_id=?)) AND (v.id=t.effective_approved_revision_id OR (v.id=t.pending_revision_id AND v.status='SUBMITTED')) AND w.starts_at<? AND w.ends_at_exclusive>? LIMIT 1 FOR UPDATE",[$root,$ctx['unit']['asset_id'],$ctx['assignment']['operator_id']??0,$ctx['assignment']['operator_id']??0,$e['ends_at_exclusive'],$e['starts_at']]);if($hit)throw new HttpError(409,'Interval bertabrakan dengan pekerjaan submitted/approved unit atau operator lain.');}
    }
    private function snapshot(array $ctx,?array $body=null):string
    {
        $r=$this->records->data->repo;$u=$ctx['unit'];$o=$ctx['assignment'];$p=$o?$r->one('SELECT p.id,p.code,COALESCE(p.name,a.name) name FROM md_personnel p LEFT JOIN users a ON a.id=p.account_id WHERE p.id=?',[$o['operator_id']]):null;
        $customer=$r->one('SELECT id,code,name FROM md_customers WHERE id=? AND branch_id=?',[$ctx['contract']['customer_id'],$ctx['contract']['branch_id']]);
        $data=['requires_terminal_permission'=>in_array($u['status'],['COMPLETED','TERMINATED','CANCELLED'],true)||in_array($ctx['contract']['status'],['COMPLETED','TERMINATED','CANCELLED'],true),'contract_number'=>$ctx['contract']['official_number'],'customer'=>$customer,'customer_id'=>$ctx['contract']['customer_id'],'branch_id'=>$ctx['contract']['branch_id'],'unit'=>json_decode($u['snapshot'],true,512,JSON_THROW_ON_ERROR),'operator'=>$p,'assignment'=>$o?array_intersect_key($o,array_flip(['id','operator_id','effective_account_id','starts_at','ends_at_exclusive','status'])):null,'operator_mode'=>$u['operator_mode'],'actual_start'=>$u['actual_start'],'actual_end'=>$u['actual_end'],'period'=>$r->one('SELECT id,starts_on,ends_on FROM eq_unit_periods WHERE id=?',[$u['current_period_id']])];
        if($body!==null) foreach(['shift','project_location','standby_hours','breakdown_hours','billable_hours','breakdown_note','billable_reason'] as $key) $data[$key]=$body[$key]??'';
        return json_encode($data,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE);
    }
    private function event(array $t,int $revision,string $type,string $key,array $detail,?string $from,?string $to):void
    {
        $ctx=$t['context'];$actor=(int)$this->records->data->guard->access->user['id'];$detail+=['from'=>$from,'to'=>$to];
        $this->records->data->repo->run('INSERT INTO eq_events(contract_id,contract_unit_id,operator_assignment_id,timesheet_id,timesheet_revision_id,event_type,previous_state,next_state,actor_id,branch_id,request_key,detail,occurred_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,NOW())',[$ctx['contract']['id'],$t['contract_unit_id'],$t['operator_assignment_id'],$t['id'],$revision,$type,$from,$to,$actor,$ctx['contract']['branch_id'],$key,json_encode($detail,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE)]);
        $this->audit->record($actor,$type,'eq_timesheets',(int)$t['id'],$detail+['revision_id'=>$revision]);
    }
    private function body(array $v):array
    {
        $entries=$this->records->entries((int)$v['id']);foreach($entries as &$entry)$entry['break_minutes']=(string)$entry['break_minutes'];unset($entry);
        $snapshot=json_decode((string)($v['snapshot']??'{}'),true) ?: [];
        return array_merge(EquipmentWorkIntervals::parse(['entries'=>$entries,'hm_start'=>$v['hm_start']??'','hm_end'=>$v['hm_end']??'','work_note'=>$v['work_note']]),[
            'shift'=>(string)($snapshot['shift']??''),'project_location'=>(string)($snapshot['project_location']??''),
            'standby_hours'=>(string)($snapshot['standby_hours']??'0.000'),'breakdown_hours'=>(string)($snapshot['breakdown_hours']??'0.000'),
            'billable_hours'=>(string)($snapshot['billable_hours']??number_format(((int)0),3,'.','')),
            'breakdown_note'=>(string)($snapshot['breakdown_note']??''),'billable_reason'=>(string)($snapshot['billable_reason']??'')
        ]);
    }
    private function hash(array $t,array $v,array $body):string{return hash('sha256',json_encode(['unit'=>$t['contract_unit_id'],'assignment'=>$t['operator_assignment_id'],'date'=>$t['work_date'],'body'=>$body,'snapshot'=>$v['snapshot']],JSON_THROW_ON_ERROR));}
    private function entries(int $revision,array $entries):void
    {
        $r=$this->records->data->repo;$r->run('DELETE FROM eq_timesheet_work_entries WHERE revision_id=?',[$revision]);foreach($entries as $i=>$e)$r->run('INSERT INTO eq_timesheet_work_entries(revision_id,line_no,starts_at,ends_at_exclusive,break_minutes,activity_note) VALUES (?,?,?,?,?,?)',[$revision,$i+1,$e['starts_at'],$e['ends_at_exclusive'],$e['break_minutes'],$e['activity_note']]);
    }
    private function advanced(array $input,array $body):array
    {
        foreach (['standby_hours','breakdown_hours','billable_hours'] as $field) {
            $raw=trim((string)($input[$field]??'0')); if($raw==='')$raw='0';
            if(!preg_match('/^(?:0|[1-9][0-9]{0,8})(?:\.[0-9]{1,3})?$/D',$raw))throw new HttpError(422,'Nilai '.$field.' tidak sah.');
            $body[$field]=number_format((float)$raw,3,'.','');
        }
        $body['shift']=trim((string)($input['shift']??''));$body['project_location']=trim((string)($input['project_location']??''));
        $body['breakdown_note']=trim((string)($input['breakdown_note']??''));$body['billable_reason']=trim((string)($input['billable_reason']??''));
        return $body;
    }
    public function save(array $input):array
    {
        $id=Input::id($input,'id',true);$unit=Input::id($input,'unit_id');$assignment=Input::id($input,'assignment_id',true)?:null;$date=EquipmentContracts::date(Input::text($input,'work_date',10));$version=$id?Input::id($input,'version'):0;$rv=$id?Input::id($input,'revision_version'):0;$revision=$id?Input::id($input,'revision_id'):0;$reason=Input::text($input,'reason',2000,false);$key=Input::text($input,'request_key',64);$body=$this->advanced($input,EquipmentWorkIntervals::parse($input));
        $ctx=$this->records->context($unit,$assignment,$id?'update':'create');$permission=$this->records->permission($id?'update':'create');
        return $this->write->run($permission,'eq_timesheet_save',$key,['contract_branch_id'=>$ctx['contract']['branch_id']]+compact('id','unit','assignment','date','version','rv','revision','reason','body'),$ctx['access_branch'],(int)$ctx['contract']['id'],function()use($id,$unit,$assignment,$date,$version,$rv,$revision,$reason,$body,$key):array{
            $r=$this->records->data->repo;$ctx=$this->records->context($unit,$assignment,$id?'update':'create',true);$this->terminal($ctx,$reason);$before=null;
            if($id){$t=$this->records->find($id,true);$this->version($t,$version);if((int)$t['contract_unit_id']!==$unit||($t['operator_assignment_id']?(int)$t['operator_assignment_id']:null)!==$assignment||$t['work_date']!==$date)throw new HttpError(422,'Identitas root timesheet tidak boleh diubah.');$v=$this->records->revision($revision,$id,true);$this->version($v,$rv);if((int)$t['pending_revision_id']!==$revision||$v['status']!=='DRAFT')throw new HttpError(409,'Hanya revisi DRAFT pending dapat diedit.');if($v['previous_revision_id']&&$reason==='')throw new HttpError(422,'Alasan revisi wajib.');$before=$v+['entries'=>$this->records->entries($revision)];
                $this->validate($ctx,$date,$body,$v['snapshot']);$snapshot=($ctx['assignment']['status']??null)==='CANCELLED'?json_encode(array_replace(json_decode($v['snapshot'],true,512,JSON_THROW_ON_ERROR),['requires_terminal_permission'=>true]+$body),JSON_THROW_ON_ERROR):$this->snapshot($ctx,$body);
                $r->run('UPDATE eq_timesheet_revisions SET work_note=?,hm_start=?,hm_end=?,reason=?,snapshot=?,version=version+1 WHERE id=?',[$body['work_note'],$body['hm_start'],$body['hm_end'],$reason,$snapshot,$revision]);
            }else{
                $this->validate($ctx,$date,$body);$r->run('INSERT INTO eq_timesheets(contract_unit_id,operator_assignment_id,work_date,root_created_by) VALUES (?,?,?,?)',[$unit,$assignment,$date,$this->records->data->guard->access->user['id']]);$id=(int)$r->db->lastInsertId();
                $r->run('INSERT INTO eq_timesheet_revisions(timesheet_id,revision_no,created_by,reason,work_note,hm_start,hm_end,snapshot) VALUES (?,1,?,?,?,?,?,?)',[$id,$this->records->data->guard->access->user['id'],$reason,$body['work_note'],$body['hm_start'],$body['hm_end'],$this->snapshot($ctx,$body)]);$revision=(int)$r->db->lastInsertId();
            }
            $this->entries($revision,$body['entries']);$r->run('UPDATE eq_timesheets SET pending_revision_id=?,version=version+1 WHERE id=?',[$revision,$id]);$t=$this->records->find($id,true);$this->event($t,$revision,'eq_timesheet_draft_saved',$key,['before'=>$before,'after'=>$body,'reason'=>$reason],$before?'DRAFT':null,'DRAFT');return ['id'=>$id];
        },'timesheet');
    }
    public function revise(int $id,int $version,string $key,string $reason):array
    {
        if(trim($reason)===''||mb_strlen($reason)>2000)throw new HttpError(422,'Alasan revisi wajib.');$t=$this->records->find($id);$ctx=$t['context'];
        return $this->write->run($this->records->permission('revise'),'eq_timesheet_revise',$key,['contract_branch_id'=>$ctx['contract']['branch_id']]+compact('id','version','reason'),$ctx['access_branch'],(int)$ctx['contract']['id'],function()use($id,$version,$reason,$key):array{
            $r=$this->records->data->repo;$t=$this->records->find($id,true);$this->version($t,$version);$this->records->context((int)$t['contract_unit_id'],$t['operator_assignment_id']?(int)$t['operator_assignment_id']:null,'revise',true);$this->terminal($t['context'],$reason);
            if($t['pending_revision_id'])throw new HttpError(409,'Sudah ada revisi pending pada root ini.');$old=$r->one('SELECT * FROM eq_timesheet_revisions WHERE timesheet_id=? ORDER BY revision_no DESC LIMIT 1 FOR UPDATE',[$id]);if(!$old||!in_array($old['status'],['APPROVED','RETURNED','REJECTED'],true))throw new HttpError(409,'Sumber revisi belum diputuskan.');
            $snapshot=json_decode($old['snapshot'],true,512,JSON_THROW_ON_ERROR);if(in_array($t['context']['unit']['status'],['COMPLETED','TERMINATED','CANCELLED'],true)||in_array($t['context']['contract']['status'],['COMPLETED','TERMINATED','CANCELLED'],true))$snapshot['requires_terminal_permission']=true;
            $r->run('INSERT INTO eq_timesheet_revisions(timesheet_id,revision_no,previous_revision_id,base_approved_revision_id,created_by,reason,work_note,hm_start,hm_end,snapshot) VALUES (?,?,?,?,?,?,?,?,?,?)',[$id,(int)$old['revision_no']+1,$old['id'],$t['effective_approved_revision_id'],$this->records->data->guard->access->user['id'],$reason,$old['work_note'],$old['hm_start'],$old['hm_end'],json_encode($snapshot,JSON_THROW_ON_ERROR)]);$revision=(int)$r->db->lastInsertId();$this->entries($revision,$this->records->entries((int)$old['id']));$r->run('UPDATE eq_timesheets SET pending_revision_id=?,version=version+1 WHERE id=?',[$revision,$id]);$this->event($t,$revision,'eq_timesheet_revision_created',$key,['previous'=>$old['id'],'base_approved'=>$t['effective_approved_revision_id'],'reason'=>$reason],null,'DRAFT');return ['id'=>$id];
        },'timesheet');
    }
    public function submit(int $id,int $revision,int $version,int $rv,string $key):array
    {
        $t=$this->records->find($id);$ctx=$t['context'];
        return $this->write->run($this->records->permission('submit'),'eq_timesheet_submit',$key,['contract_branch_id'=>$ctx['contract']['branch_id']]+compact('id','revision','version','rv'),$ctx['access_branch'],(int)$ctx['contract']['id'],function()use($id,$revision,$version,$rv,$key):array{
            $r=$this->records->data->repo;$t=$this->records->find($id,true);$this->version($t,$version);$this->records->context((int)$t['contract_unit_id'],$t['operator_assignment_id']?(int)$t['operator_assignment_id']:null,'submit',true);$v=$this->records->revision($revision,$id,true);$this->version($v,$rv);
            if((int)$t['pending_revision_id']!==$revision||$v['status']!=='DRAFT')throw new HttpError(409,'Hanya revisi DRAFT pending dapat dikirim.');if(json_decode($v['snapshot'],true,512,JSON_THROW_ON_ERROR)['requires_terminal_permission']??false)$this->terminal($t['context'],$v['reason']);$body=$this->body($v);$this->validate($t['context'],$t['work_date'],$body,$v['snapshot']);$this->overlap($t['context'],$id,$body);$hash=$this->hash($t,$v,$body);
            $r->run("UPDATE eq_timesheet_revisions SET status='SUBMITTED',submitted_by=?,submitted_at=NOW(),content_hash=?,version=version+1 WHERE id=?",[$this->records->data->guard->access->user['id'],$hash,$revision]);$r->run('UPDATE eq_timesheets SET version=version+1 WHERE id=?',[$id]);$this->event($t,$revision,'eq_timesheet_submitted',$key,['content_hash'=>$hash],'DRAFT','SUBMITTED');return ['id'=>$id];
        },'timesheet');
    }
    public function decide(int $id,int $revision,int $version,int $rv,string $hash,string $decision,string $note,string $key):array
    {
        if($this->records->own)throw new HttpError(403,'Verifikasi memerlukan akses reviewer.');
        if(!in_array($decision,['APPROVED','RETURNED','REJECTED'],true)||mb_strlen($note)>2000||($decision!=='APPROVED'&&trim($note)==='')||!preg_match('/^[a-f0-9]{64}$/D',$hash))throw new HttpError(422,'Keputusan, alasan atau hash pemeriksaan tidak sah.');
        $t=$this->records->find($id,false,true);$ctx=$t['context'];
        return $this->write->run('equipment.verification.decide','eq_timesheet_decide',$key,['contract_branch_id'=>$ctx['contract']['branch_id']]+compact('id','revision','version','rv','hash','decision','note'),(int)$ctx['contract']['branch_id'],(int)$ctx['contract']['id'],function()use($id,$revision,$version,$rv,$hash,$decision,$note,$key):array{
            $r=$this->records->data->repo;$t=$this->records->find($id,true,true);$this->version($t,$version);$v=$this->records->revision($revision,$id,true);$this->version($v,$rv);$actor=(int)$this->records->data->guard->access->user['id'];
            if($actor===(int)$t['root_created_by']||$actor===(int)$v['created_by'])throw new HttpError(403,'Pembuat root/revisi tidak boleh memverifikasi timesheet sendiri.');
            if((int)$t['pending_revision_id']!==$revision||$v['status']!=='SUBMITTED'||!hash_equals((string)$v['content_hash'],$hash))throw new HttpError(409,'Submission/versi/hash yang diperiksa sudah berubah.');
            $body=$this->body($v);if(!hash_equals($hash,$this->hash($t,$v,$body)))throw new HttpError(409,'Integritas konten submission berubah.');
            if($decision==='APPROVED'){$this->validate($t['context'],$t['work_date'],$body,$v['snapshot']);$this->overlap($t['context'],$id,$body);if($t['effective_approved_revision_id']!==$v['base_approved_revision_id'])throw new HttpError(409,'Versi approved dasar sudah berubah.');}
            $r->run('INSERT INTO eq_timesheet_verifications(revision_id,timesheet_id,root_created_by,revision_created_by,reviewer_id,decision,note,decided_at,request_key) VALUES (?,?,?,?,?,?,?,NOW(),?)',[$revision,$id,$t['root_created_by'],$v['created_by'],$actor,$decision,$note,$key]);$r->run('UPDATE eq_timesheet_revisions SET status=?,version=version+1 WHERE id=?',[$decision,$revision]);
            $r->run('UPDATE eq_timesheets SET pending_revision_id=NULL,effective_approved_revision_id=?,version=version+1 WHERE id=?',[$decision==='APPROVED'?$revision:$t['effective_approved_revision_id'],$id]);$this->event($t,$revision,'eq_timesheet_verified',$key,['decision'=>$decision,'note'=>$note,'effective_before'=>$t['effective_approved_revision_id'],'effective_after'=>$decision==='APPROVED'?$revision:$t['effective_approved_revision_id']],'SUBMITTED',$decision);return ['id'=>$id];
        },'timesheet');
    }
}

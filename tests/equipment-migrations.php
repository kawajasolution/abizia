<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);

use Hls\Database;
use Hls\Repositories\Repository;
use Hls\Services\EquipmentMigration;
use Hls\Services\EquipmentPermissions;
use Hls\Services\Migrator;

$checks = []; $failure = null; $databases = []; $inventory = [];
function eqCheck(bool $pass, string $name): void {
    global $checks;
    $checks[] = ['name'=>$name,'passed'=>$pass];
    if (!$pass) throw new RuntimeException($name);
}
function eqReject(callable $work, string $name): void {
    try { $work(); } catch (PDOException $e) {
        eqCheck(in_array((int)($e->errorInfo[1] ?? 0), [1062,1451,1452,4025], true), $name . ' (constraint DB)'); return;
    }
    eqCheck(false, $name);
}
function eqStopped(callable $work, string $fragment, string $name): void {
    try { $work(); } catch (RuntimeException $e) { eqCheck(str_contains($e->getMessage(), $fragment), $name); return; }
    eqCheck(false, $name);
}
function eqDatabase(PDO $admin, bool $base = false): array {
    global $databases;
    $name = 'hls_v2_test_' . bin2hex(random_bytes(6)); Hls\Config::databaseName($name);
    $admin->exec("CREATE DATABASE `$name` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"); $databases[]=$name;
    $db=Database::connect(['database'=>$name,'host'=>'127.0.0.1','port'=>3306,'username'=>getenv('HLS_DB_ADMIN_USER') ?: 'root','password'=>getenv('HLS_DB_ADMIN_PASSWORD') ?: '']);
    if ($base) {
        foreach (['001_foundation','002_master_data','003_trucking','004_trucking_operations'] as $version) {
            foreach (explode(';',file_get_contents(dirname(__DIR__) . '/database/migrations/' . $version . '.sql')) as $sql) if(trim($sql)!=='') $db->exec($sql);
        }
        $repo=new Repository($db);
        Hls\Services\MasterPermissions::seed($repo,require dirname(__DIR__) . '/app/master-data.php');
        Hls\Services\ExpeditionPermissions::seed($repo); Hls\Services\ExpeditionPermissions::operations($repo);
        $db->exec("INSERT INTO schema_migrations(version) VALUES ('002_master_data'),('003_trucking'),('004_trucking_operations')");
    }
    return [$db,$name,new Repository($db)];
}
function eqMasters(Repository $r): void {
    $r->run("INSERT INTO branches(code,name) VALUES ('EA','Equipment A'),('EB','Equipment B')");
    $hash=password_hash(bin2hex(random_bytes(24)),PASSWORD_DEFAULT);
    foreach (['root','author','reviewer'] as $name) $r->run("INSERT INTO users(name,email,password_hash,role_id) VALUES (?,?,?,1)",[$name,$name.'@equipment.test',$hash]);
    $r->run("INSERT INTO md_customers(code,name,branch_id,customer_type) VALUES ('EA-C','Customer A',1,'company'),('EB-C','Customer B',2,'company')");
    $r->run("INSERT INTO md_assets(code,name,branch_id,kind,identity) VALUES ('EA-U','Unit A',1,'equipment','SERIAL-A'),('EB-U','Unit B',2,'equipment','SERIAL-B')");
    $r->run("INSERT INTO md_personnel(code,name,branch_id,kind) VALUES ('EA-P','Operator tanpa akun',1,'operator')");
    $r->run("INSERT INTO user_branches(user_id,branch_id) VALUES (1,1)");
}
function eqSnapshot(PDO $db): array {
    $result=[];
    foreach($db->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN) as $table) {
        $result[$table]=array_map(static fn(array $row):string=>hash('sha256',json_encode($row,JSON_THROW_ON_ERROR)),$db->query("SELECT * FROM `$table`")->fetchAll());
        sort($result[$table]);
    }
    return $result;
}
try {
    $admin=new PDO('mysql:host=127.0.0.1;port=3306;charset=utf8mb4',getenv('HLS_DB_ADMIN_USER') ?: 'root',getenv('HLS_DB_ADMIN_PASSWORD') ?: '',[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
    [$db,$name,$r]=eqDatabase($admin);
    eqCheck(Migrator::install($db,$name),'Fresh install 001–005 berhasil');
    eqCheck(!Migrator::install($db,$name),'Fresh migration replay no-op');
    eqCheck(count($r->all('SHOW TABLES'))===48,'48 tabel: 32 existing + 16 Equipment');
    $expectedTables=['eq_contracts','eq_contract_units','eq_unit_periods','eq_operator_assignments','eq_branch_authorizations','eq_handover_documents','eq_handover_units','eq_timesheets','eq_timesheet_revisions','eq_timesheet_work_entries','eq_timesheet_verifications','eq_meter_corrections','eq_events','eq_requests','eq_document_sequences','eq_evidence']; sort($expectedTables);
    $actualTables=array_column($r->all("SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND LEFT(TABLE_NAME,3)='eq_' ORDER BY TABLE_NAME"),'TABLE_NAME');
    sort($actualTables);
    eqCheck($actualTables===$expectedTables,'Nama 16 tabel tepat sesuai desain final termasuk eq_meter_corrections');
    eqCheck((bool)$r->one("SELECT version FROM schema_migrations WHERE version='005_equipment_operations'"),'Migrator fresh benar-benar menjalankan Equipment sampai marker 005 lengkap');
    eqCheck((int)$r->one('SELECT COUNT(*) n FROM users')['n']===0 && (int)$r->one('SELECT COUNT(*) n FROM branches')['n']===0,'Fresh seed tanpa akun/cabang/nomor/transaksi');
    eqCheck((int)$r->one('SELECT COUNT(*) n FROM permissions')['n']===63+count(EquipmentPermissions::catalog()),'Katalog permission aditif lengkap');
    eqCheck(count(EquipmentPermissions::catalog())===43,'Katalog Equipment berisi tepat 43 definisi desain M2');
    foreach (EquipmentPermissions::grants() as $role=>$codes) {
        $actual=array_column($r->all("SELECT p.code FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE ro.name=? AND p.code LIKE 'equipment.%'",[$role]),'code'); sort($actual);
        $expected=array_map(fn($code)=>'equipment.'.$code,$codes); sort($expected);
        eqCheck($actual===$expected,'Grant Equipment persis matriks: '.$role);
    }
    eqCheck((int)$r->one("SELECT COUNT(*) n FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE p.code LIKE 'equipment.%' AND ro.name IN('Finance','Gudang','Customer','Admin Pengirim','Admin Transit','Admin Penerima')")['n']===0,'Tidak memberi grant kepada role di luar Equipment');
    eqCheck((int)$r->one("SELECT COUNT(*) n FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id WHERE p.code IN ('equipment.handover.correct','equipment.handover.fact_correct','equipment.cross_branch.approve','equipment.recovery.close','equipment.meter.correct','equipment.timesheet.revise_terminal','equipment.operator.relink')")['n']===0,'Seluruh permission khusus C deny-by-default, termasuk Administrator');
    eqCheck((int)$r->one("SELECT COUNT(*) n FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE ro.name='Admin Sewa' AND p.code IN ('equipment.contract.terminate','equipment.contract.extend','equipment.verification.view','equipment.verification.decide')")['n']===0,'Admin Sewa tidak mendapat delegasi C');
    eqCheck(array_column($r->all("SELECT ro.name FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE p.code='equipment.verification.decide' ORDER BY ro.name"),'name')===['Administrator'],'verification.decide hanya Administrator sel Y; semua role lain deny');
    eqCheck((int)$r->one("SELECT COUNT(*) n FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE ro.name='Operator Alat Berat' AND p.code LIKE 'equipment.%' AND RIGHT(p.code,4)<>'_own'")['n']===0,'Operator hanya grant own, tanpa scoped/full');
    eqCheck((int)$r->one("SELECT COUNT(*) n FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE ro.name='Owner' AND p.code LIKE 'equipment.%' AND p.code NOT IN ('equipment.unit.view','equipment.contract.view','equipment.handover.view','equipment.timesheet.view_scoped','equipment.verification.view','equipment.evidence.view')")['n']===0,'Owner Equipment hanya baca tanpa grant mutasi');
    foreach (['TABLE_CONSTRAINTS','STATISTICS','KEY_COLUMN_USAGE'] as $source) $inventory[$source]=$r->all("SELECT * FROM information_schema.$source WHERE TABLE_SCHEMA=DATABASE() AND LEFT(TABLE_NAME,3)='eq_' ORDER BY TABLE_NAME");
    foreach($r->all("SHOW TABLE STATUS WHERE Name LIKE 'eq!_%' ESCAPE '!' ") as $table) eqCheck($table['Engine']==='InnoDB','Engine transaksi: '.$table['Name']);
    eqMasters($r);
    $contract=function(string $ref,int $branch=1,int $customer=1)use($r):int{
        $r->run("INSERT INTO eq_contracts(internal_ref,branch_id,customer_id,snapshot,created_by) VALUES (?,?,?,'{}',1)",[$ref,$branch,$customer]); return (int)$r->db->lastInsertId();
    };
    $a=$contract('A');$b=$contract('B',2,2);
    eqReject(fn()=>$contract('BAD',1,2),'Customer cabang lain ditolak FK');
    eqReject(fn()=>$contract('A'),'Identifier kontrak duplikat ditolak');
    $unit=function(int $contract,int $branch,int $asset,int $owner,int $line,string $state='DRAFT')use($r):int {
        $r->run("INSERT INTO eq_contract_units(contract_id,contract_branch_id,asset_id,asset_owner_branch_id,line_no,operator_mode,status,snapshot) VALUES (?,?,?,?,?,'WITHOUT',?,'{}')",[$contract,$branch,$asset,$owner,$line,$state]);return (int)$r->db->lastInsertId();
    };
    $u=$unit($a,1,1,1,1);$v=$unit($b,2,2,2,1);
    eqReject(fn()=>$unit($a,2,2,2,2),'Cabang header-detail palsu ditolak FK');
    eqReject(fn()=>$unit($a,1,1,2,2),'Cabang pemilik asset palsu ditolak FK');
    eqReject(fn()=>$unit($a,1,1,1,2),'Satu detail aktif per unit dalam kontrak');
    $r->run("UPDATE eq_contract_units SET status='CANCELLED' WHERE id=?",[$u]); $u2=$unit($a,1,1,1,2);
    eqCheck($u2>$u && $r->one('SELECT status FROM eq_contract_units WHERE id=?',[$u])['status']==='CANCELLED','Detail terminal tetap historis; detail baru dapat dibuat');
    eqReject(fn()=>$r->run("UPDATE eq_contract_units SET status='ACTIVE' WHERE id=?",[$u]),'Reaktivasi detail lama tidak menduplikasi unit aktif');
    $period=function(int $unit,string $start,string $end,int $rev=1,?int $previous=null)use($r):int {
        $r->run("INSERT INTO eq_unit_periods(contract_unit_id,revision_no,starts_on,ends_on,change_kind,actor_id,previous_period_id) VALUES (?,?,?,?,'INITIAL',1,?)",[$unit,$rev,$start,$end,$previous]);return (int)$r->db->lastInsertId();
    };
    $p=$period($u2,'2026-10-24','2026-10-24');$q=$period($v,'2026-10-24','2026-10-25');
    eqCheck($p>0,'Periode tanggal inklusif satu hari diterima');
    eqReject(fn()=>$period($u2,'2026-10-25','2026-10-24',2),'Periode terbalik ditolak');
    eqReject(fn()=>$period($u2,'2026-11-01','2026-11-02',2,$q),'Previous period sibling ditolak');
    eqReject(fn()=>$r->run('UPDATE eq_contract_units SET current_period_id=? WHERE id=?',[$q,$u2]),'Pointer periode silang ditolak');
    $r->run('UPDATE eq_contract_units SET current_period_id=? WHERE id=?',[$p,$u2]);
    $r->run("INSERT INTO eq_operator_assignments(contract_unit_id,operator_id,operator_owner_branch_id,starts_at,ends_at_exclusive) VALUES (?,1,1,'2026-10-24 22:00:00','2026-10-25 02:00:00')",[$u2]);$op=(int)$db->lastInsertId();
    eqCheck($r->one('SELECT effective_account_id FROM eq_operator_assignments WHERE id=?',[$op])['effective_account_id']===null,'Operator tanpa akun tidak membuat akun dummy');
    eqReject(fn()=>$r->run("INSERT INTO eq_operator_assignments(contract_unit_id,operator_id,operator_owner_branch_id,starts_at,ends_at_exclusive) VALUES (?,1,1,'2026-10-24 22:00:00','2026-10-24 22:00:00')",[$u2]),'Interval operator kosong ditolak');
    $foreignUnit=$unit($a,1,2,2,3); $foreignPeriod=$period($foreignUnit,'2026-10-24','2026-10-24');
    $authorization="INSERT INTO eq_branch_authorizations(contract_unit_id,period_id,resource_type,owner_branch_id,contract_branch_id,valid_from,valid_until_exclusive,requested_by,owner_approved_by,owner_approved_at,contract_approved_by,contract_approved_at,status,reason) VALUES (?,?,'UNIT',2,1,'2026-10-24','2026-10-25',1,?,NOW(),?,NOW(),'APPROVED','Lintas cabang')";
    eqReject(fn()=>$r->run($authorization,[$foreignUnit,$foreignPeriod,1,1]),'Persetujuan lintas cabang dengan akun sama ditolak');
    $r->run($authorization,[$foreignUnit,$foreignPeriod,1,3]);eqCheck(true,'Dua akun berbeda dapat disimpan sebagai approval');
    $ba=function(int $contract,string $ref,?int $correction=null)use($r):int{
        $r->run("INSERT INTO eq_handover_documents(contract_id,internal_ref,document_type,scope_mode,occurrence_at,created_by,correction_of_id,correction_reason) VALUES (?,?,'HANDOVER','SELECTED',NOW(),1,?,'Koreksi administratif')",[$contract,$ref,$correction]);return (int)$r->db->lastInsertId();
    };
    $baA=$ba($a,'BA-A');$baB=$ba($b,'BA-B');
    eqReject(fn()=>$ba($a,'BAD-BA',$baB),'BA koreksi lintas kontrak ditolak');
    $baUnit="INSERT INTO eq_handover_units(handover_id,contract_id,contract_unit_id,condition_note,occurrence_at,snapshot,lifecycle_effect) VALUES (?,?,?,'Baik',NOW(),'{}',?)";
    eqReject(fn()=>$r->run($baUnit,[$baA,$a,$v,null]),'BA tidak mencampur detail kontrak lain');
    $r->run($baUnit,[$baA,$a,$u2,'HANDOVER']);$baUnitId=(int)$db->lastInsertId();
    $baCorrection=$ba($a,'BA-C',$baA);
    eqReject(fn()=>$r->run($baUnit,[$baCorrection,$a,$u2,'HANDOVER']),'Efek lifecycle HANDOVER tidak dapat diulang dengan BA lain');
    $r->run($baUnit,[$baCorrection,$a,$u2,null]); eqCheck(true,'BA koreksi tanpa efek ulang dapat disimpan');
    $ts=function(int $unit,?int $assignment,string $date)use($r):int{
        $r->run('INSERT INTO eq_timesheets(contract_unit_id,operator_assignment_id,work_date,root_created_by) VALUES (?,?,?,1)',[$unit,$assignment,$date]);return (int)$r->db->lastInsertId();
    };
    $root=$ts($u2,null,'2026-10-24');$other=$ts($v,null,'2026-10-24');
    eqReject(fn()=>$ts($u2,null,'2026-10-24'),'Natural key WITHOUT NULL tidak mengizinkan root duplikat');
    eqReject(fn()=>$ts($v,$op,'2026-10-25'),'Timesheet assignment milik unit lain ditolak');
    $rev=function(int $root,int $no=1,string $state='DRAFT',?int $prev=null)use($r):int{
        $r->run("INSERT INTO eq_timesheet_revisions(timesheet_id,revision_no,status,created_by,snapshot,submitted_by,submitted_at,content_hash,previous_revision_id,reason) VALUES (?,?,?,2,'{}',2,NOW(),?,?, 'Revisi')",[$root,$no,$state,str_repeat('a',64),$prev]);return (int)$r->db->lastInsertId();
    };
    $revision=$rev($root);$otherRevision=$rev($other);
    eqReject(fn()=>$rev($root,2),'Maksimal satu revisi pending per root');
    eqReject(fn()=>$r->run('UPDATE eq_timesheets SET effective_approved_revision_id=? WHERE id=?',[$otherRevision,$root]),'Pointer approved tidak dapat menunjuk root lain');
    eqReject(fn()=>$r->run('UPDATE eq_timesheet_revisions SET hm_start=10,hm_end=NULL WHERE id=?',[$revision]),'HM wajib berpasangan');
    eqReject(fn()=>$r->run('UPDATE eq_timesheet_revisions SET hm_start=10,hm_end=9 WHERE id=?',[$revision]),'HM normal menurun ditolak');
    $r->run('UPDATE eq_timesheet_revisions SET hm_start=10,hm_end=12 WHERE id=?',[$revision]);
    $r->run("INSERT INTO eq_timesheet_work_entries(revision_id,line_no,starts_at,ends_at_exclusive,break_minutes) VALUES (?,1,'2026-10-24 22:00:00','2026-10-25 02:00:00',30)",[$revision]);
    eqCheck((int)$r->one('SELECT TIMESTAMPDIFF(MINUTE,starts_at,ends_at_exclusive)-break_minutes AS worked FROM eq_timesheet_work_entries WHERE revision_id=?',[$revision])['worked']===210,'Datetime lintas tengah malam dan istirahat; HM tetap terpisah');
    eqReject(fn()=>$r->run("INSERT INTO eq_timesheet_work_entries(revision_id,line_no,starts_at,ends_at_exclusive,break_minutes) VALUES (?,2,'2026-10-24 22:00:00','2026-10-24 23:00:00',61)",[$revision]),'Istirahat melebihi interval ditolak');
    $verify="INSERT INTO eq_timesheet_verifications(revision_id,timesheet_id,root_created_by,revision_created_by,reviewer_id,decision,decided_at,request_key) VALUES (?,?,1,2,?,'APPROVED',NOW(),?)";
    eqReject(fn()=>$r->run($verify,[$revision,$root,1,str_repeat('b',64)]),'Pembuat root tidak dapat approve');
    eqReject(fn()=>$r->run($verify,[$revision,$root,2,str_repeat('b',64)]),'Pembuat revisi tidak dapat approve');
    eqReject(fn()=>$r->run("INSERT INTO eq_timesheet_verifications(revision_id,timesheet_id,root_created_by,revision_created_by,reviewer_id,decision,decided_at,request_key) VALUES (?,?,2,1,3,'APPROVED',NOW(),?)",[$revision,$root,str_repeat('b',64)]),'Pemalsuan identitas pembuat reviewer ditolak FK');
    Database::transaction($db,function()use($r,$verify,$revision,$root):void{
        $r->run($verify,[$revision,$root,3,str_repeat('b',64)]);
        $r->run("UPDATE eq_timesheet_revisions SET status='APPROVED' WHERE id=?",[$revision]);
        $r->run('UPDATE eq_timesheets SET effective_approved_revision_id=? WHERE id=?',[$revision,$root]);
    });
    $approved=$r->one('SELECT * FROM eq_timesheet_revisions WHERE id=?',[$revision]);
    $next=$rev($root,2,'DRAFT',$revision);
    eqCheck($r->one('SELECT effective_approved_revision_id FROM eq_timesheets WHERE id=?',[$root])['effective_approved_revision_id']==$revision && $r->one('SELECT * FROM eq_timesheet_revisions WHERE id=?',[$revision])===$approved,'Revisi pending tidak menimpa konten atau pointer approved');
    eqReject(fn()=>$rev($root,3,'DRAFT',$otherRevision),'Previous revisi lintas root ditolak');
    $r->run("INSERT INTO eq_meter_corrections(timesheet_revision_id,correction_type,previous_reading,replacement_reading,reason,requested_by) VALUES (?,'RESET',500,0,'Penggantian meter',1)",[$next]);$meter=(int)$db->lastInsertId();
    eqReject(fn()=>$r->run("UPDATE eq_meter_corrections SET status='AUTHORIZED',authorized_by=3,authorized_at=NOW() WHERE id=?",[$meter]),'Koreksi meter tanpa bukti ditolak');
    $evidence="INSERT INTO eq_evidence(handover_unit_id,timesheet_revision_id,meter_correction_id,actor_id,storage_key,filename,mime_type,size_bytes,sha256) VALUES (?,?,?,1,?,'bukti.pdf','application/pdf',10,?)";
    eqReject(fn()=>$r->run($evidence,[$baUnitId,$next,null,'BAD',str_repeat('f',64)]),'Bukti multi-target ditolak');
    eqReject(fn()=>$r->run($evidence,[null,null,null,'NONE',str_repeat('f',64)]),'Bukti tanpa target ditolak');
    $r->run($evidence,[null,null,$meter,'RANDOM-PRIVATE-KEY',str_repeat('f',64)]);$evidenceId=(int)$db->lastInsertId();
    $r->run("UPDATE eq_meter_corrections SET status='AUTHORIZED',authorized_by=3,authorized_at=NOW(),evidence_id=? WHERE id=?",[$evidenceId,$meter]);eqCheck(true,'Koreksi meter menyimpan alasan, otorisasi dan bukti terkait');
    eqReject(fn()=>$r->run('DELETE FROM eq_evidence WHERE id=?',[$evidenceId]),'Bukti koreksi yang direferensikan tidak dapat dihapus');
    $request="INSERT INTO eq_requests(request_key,actor_id,action,resource_type,scope_branch_id,payload_hash,committed_result) VALUES (?,1,'test','contract',1,?,'{}')";
    $r->run($request,[str_repeat('c',64),str_repeat('d',64)]);
    eqReject(fn()=>$r->run($request,[str_repeat('c',64),str_repeat('d',64)]),'Token idempotensi duplikat ditolak');
    eqReject(fn()=>$r->run("INSERT INTO eq_document_sequences VALUES ('INV',1,2026,1)"),'Sequence Equipment tidak menerima INV');
    eqReject(fn()=>$r->run("INSERT INTO eq_document_sequences VALUES ('KS',1,2026,1000000)"),'Counter melebihi enam digit ditolak');
    $r->run("INSERT INTO eq_document_sequences VALUES ('KS',1,2026,1),('BA',1,2026,1),('KS',2,2026,1),('KS',1,2027,1)");eqCheck(true,'Namespace counter terpisah jenis/cabang/tahun');

    [$upgrade,$upName,$up]=eqDatabase($admin,true);eqMasters($up);
    $up->run("INSERT INTO md_locations(code,name,branch_id) VALUES ('LA','Asal',1),('LB','Tujuan',2)");
    $up->run("INSERT INTO md_routes(code,name,branch_id,destination_branch_id,origin_location_id,destination_location_id) VALUES ('AB','Lintasan',1,2,1,2)");
    $up->run("INSERT INTO md_parties(code,name,branch_id,party_role,identity_hash) VALUES ('S','Pengirim',1,'sender',?),('R','Penerima',2,'receiver',?)",[str_repeat('a',64),str_repeat('b',64)]);
    $up->run("INSERT INTO exp_dns(number,document_date,route_id,origin_branch_id,destination_branch_id,customer_id,sender_id,receiver_id,description,quantity,unit,snapshot,created_by,request_key,request_hash) VALUES ('DN-HISTORY','2026-10-01',1,1,2,1,1,2,'Barang',1,'Koli','{}',1,?,?)",[str_repeat('c',64),str_repeat('d',64)]);
    $up->run("INSERT INTO exp_manifests(number,document_date,route_id,origin_branch_id,destination_branch_id,snapshot,created_by,request_key,request_hash) VALUES ('MF-HISTORY','2026-10-01',1,1,2,'{}',1,?,?)",[str_repeat('e',64),str_repeat('f',64)]);
    $up->run('INSERT INTO exp_manifest_items(manifest_id,dn_id,attached_by) VALUES (1,1,1)');
    $up->run("INSERT INTO exp_events(dn_id,manifest_id,actor_id,branch_id,event_type,detail) VALUES (1,1,1,1,'document_created','{\"historical\":true}')");
    $up->run("INSERT INTO exp_trip_legs(manifest_id,position,route_id,origin_branch_id,destination_branch_id,origin_location_id,destination_location_id,snapshot) VALUES (1,1,1,1,2,1,2,'{\"historical\":true}')");
    $up->run("INSERT INTO exp_sequences VALUES ('DN',1,2026,1),('MF',1,2026,1)");
    $up->run("UPDATE exp_dns SET status='received',official_number='DN/EA/2026/000001',confirmed_at='2026-10-01 08:00:00',current_branch_id=2,current_location_id=2 WHERE id=1");
    $up->run("UPDATE exp_manifests SET status='completed',official_number='MF/EA/2026/000001',confirmed_at='2026-10-01 08:00:00',current_stop=1 WHERE id=1");
    $up->run("UPDATE exp_manifest_items SET removed_at='2026-10-02 08:00:00',removed_by=1,removal_reason='Turun aktual' WHERE id=1");
    $up->run("INSERT INTO exp_receipts(dn_id,branch_id,actor_id,recipient_name,quantity,condition_note) VALUES (1,2,1,'Penerima aktual',1,'Utuh')");
    $up->run("INSERT INTO exp_claims(dn_id,branch_id,problem_type,description,reporter_name,created_by) VALUES (1,2,'OTHER','Catatan operasional','Petugas',1)");
    $up->run("INSERT INTO exp_claim_events(claim_id,actor_id,previous_status,next_status,note) VALUES (1,1,NULL,'REPORTED','Laporan awal')");
    $up->run("INSERT INTO exp_evidence(claim_id,actor_id,storage_key,file_name,mime_type,file_size,sha256) VALUES (1,1,?,'historical.pdf','application/pdf',10,?)",[str_repeat('1',64),str_repeat('2',64)]);
    $up->run("INSERT INTO exp_requests(request_key,actor_id,branch_id,action,payload_hash,result) VALUES (?,1,1,'historical',?,'{\"id\":1}')",[str_repeat('3',64),str_repeat('4',64)]);
    $up->run("INSERT INTO audit_logs(actor_id,action,entity,entity_id,detail) VALUES (1,'upgrade.fixture','exp_dns',1,'{\"snapshot\":\"immutable\"}')");
    $before=eqSnapshot($upgrade);
    eqCheck(Migrator::install($upgrade,$upName),'Upgrade 004 berisi user/master/DN/Manifest/histori berhasil');
    $after=eqSnapshot($upgrade);
    foreach($before as $table=>$hashes) eqCheck(count(array_diff($hashes,$after[$table]))===0,'Seluruh row existing tetap identik: '.$table);
    eqCheck(!Migrator::install($upgrade,$upName),'Upgrade replay no-op tanpa perubahan data');
    $lock='hlsv2:005:'.$upName;
    $up->run('SELECT GET_LOCK(?,0)',[$lock]);
    $otherConnection=Database::connect(['database'=>$upName,'host'=>'127.0.0.1','port'=>3306,'username'=>getenv('HLS_DB_ADMIN_USER') ?: 'root','password'=>getenv('HLS_DB_ADMIN_PASSWORD') ?: '']);
    eqStopped(fn()=>EquipmentMigration::install($otherConnection,$upName),'koneksi lain','Dua koneksi migration tidak berjalan bersamaan');
    $up->run('SELECT RELEASE_LOCK(?)',[$lock]);

    [$partial,$partialName,$pr]=eqDatabase($admin,true);
    eqStopped(fn()=>EquipmentMigration::install($partial,$partialName,static function(int $step):void { if($step===4) throw new RuntimeException('injected interruption'); }),'injected interruption','Interupsi nyata setelah empat DDL terjournal');
    eqCheck(!$pr->one('SELECT version FROM schema_migrations WHERE version=?',[EquipmentMigration::VERSION]),'Kegagalan parsial tidak menandai migration lengkap');
    eqCheck((int)$pr->one("SELECT COUNT(*) n FROM permissions WHERE code LIKE 'equipment.%'")['n']===0,'Grant belum disemai ketika DDL belum lengkap');
    eqCheck(EquipmentMigration::install($partial,$partialName),'Resume langkah terverifikasi tanpa drop/reset');
    eqCheck(!EquipmentMigration::install($partial,$partialName),'Recovery replay no-op');
    $partial->exec('ALTER TABLE eq_contracts ADD COLUMN unexpected_column INT NULL');
    eqStopped(fn()=>EquipmentMigration::install($partial,$partialName),'Schema drift','Drift sesudah DDL ditolak; tidak diadopsi diam-diam');

    [$seedFail,$seedName,$sf]=eqDatabase($admin,true);
    $seedFail->exec("CREATE TRIGGER equipment_seed_failure BEFORE INSERT ON permissions FOR EACH ROW SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='injected seed failure'");
    eqStopped(fn()=>EquipmentMigration::install($seedFail,$seedName),'injected seed failure','Kegagalan seed setelah DDL benar-benar diinjeksi');
    eqCheck(!$sf->one('SELECT version FROM schema_migrations WHERE version=?',[EquipmentMigration::VERSION]) && (int)$sf->one("SELECT COUNT(*) n FROM permissions WHERE code LIKE 'equipment.%'")['n']===0,'Seed gagal rollback permission/grant/marker lengkap');
    $seedFail->exec('DROP TRIGGER equipment_seed_failure');
    eqCheck(EquipmentMigration::install($seedFail,$seedName),'Pemulihan seed tanpa menjalankan ulang DDL');
    eqCheck(!EquipmentMigration::install($seedFail,$seedName),'Pemulihan seed idempoten');
    [$unknown,$unknownName,$ur]=eqDatabase($admin,true);
    $unknown->exec('CREATE TABLE eq_contracts (id INT PRIMARY KEY) ENGINE=InnoDB');
    eqStopped(fn()=>EquipmentMigration::install($unknown,$unknownName),'ambigu','Tabel tanpa journal/DDL diketahui ditolak');
    eqCheck((int)$ur->one('SELECT COUNT(*) n FROM eq_contracts')['n']===0,'Penolakan instalasi asing tidak menulis/menghapus tabel');
} catch(Throwable $e) { $failure=get_class($e).': '.$e->getMessage(); if (!array_filter($checks,fn($c)=>!$c['passed'])) $checks[]=['name'=>'Eksekusi suite: '.$failure,'passed'=>false]; }
finally {
    foreach($databases as $database) {
        Hls\Config::databaseName($database);
        if(!str_starts_with($database,'hls_v2_test_')) throw new RuntimeException('Cleanup target invalid');
        $admin->exec("DROP DATABASE `$database`");
    }
}
$failed=count(array_filter($checks,fn($c)=>!$c['passed']));
$result=['date'=>date(DATE_ATOM),'passed'=>count($checks)-$failed,'failed'=>$failed,'failure'=>$failure,'checks'=>$checks,'inventory'=>$inventory,'temporary_databases_removed'=>count($databases)];
file_put_contents(__DIR__.'/results/equipment-migrations.json',json_encode($result,JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
echo $result['passed'].' PASS; '.$failed.' FAIL; '.($failure ?? 'cleanup '.count($databases).' database uji').PHP_EOL;
exit($failure!==null || $failed ? 1 : 0);

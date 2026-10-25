<?php
declare(strict_types=1);
require dirname(__DIR__).'/app/bootstrap.php';
if(PHP_SAPI!=='cli') exit(1);
$config=Hls\Config::load();
if($config['database']!=='hls_v2_dev') throw new RuntimeException('Hanya development V2.');
$db=Hls\Database::connect($config);$mode=$argv[1]??'';
$directory=dirname(__DIR__).'/storage/private/backups';
$path=$directory.'/phase6-m2-pre-migration.json';
if($mode==='snapshot') {
    if(is_file($path)) throw new RuntimeException('Backup awal sudah ada; tidak ditimpa.');
    $backup=['date'=>date(DATE_ATOM),'database'=>'hls_v2_dev','tables'=>[]];
    foreach($db->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN) as $table) {
        if(!preg_match('/^[a-z_]+$/D',$table)) throw new RuntimeException('Nama tabel tidak sah.');
        $backup['tables'][$table]=['ddl'=>$db->query("SHOW CREATE TABLE `$table`")->fetch(PDO::FETCH_NUM)[1],'rows'=>$db->query("SELECT * FROM `$table`")->fetchAll()];
    }
    if(count($backup['tables'])!==32) throw new RuntimeException('Snapshot harus sebelum migration 005.');
    if(!is_dir($directory)&&!mkdir($directory,0700,true)) throw new RuntimeException('Backup directory gagal.');
    if(file_put_contents($path,json_encode($backup,JSON_THROW_ON_ERROR|JSON_PRETTY_PRINT))===false) throw new RuntimeException('Backup gagal.');
    echo 'Snapshot privat 32 tabel disimpan; database hanya dibaca.'.PHP_EOL;exit;
}
if($mode!=='verify') throw new RuntimeException('Gunakan snapshot atau verify.');
$backup=json_decode(file_get_contents($path),true,512,JSON_THROW_ON_ERROR);$checks=[];$counts=[];
$hash=static fn(array $row):string=>hash('sha256',json_encode($row,JSON_THROW_ON_ERROR));
foreach($backup['tables'] as $table=>$saved) {
    $rows=$db->query("SELECT * FROM `$table`")->fetchAll();
    $before=array_map($hash,$saved['rows']);$after=array_map($hash,$rows);
    $checks[]=['name'=>'Existing rows identik: '.$table,'passed'=>!array_diff($before,$after)];
    $ddl=$db->query("SHOW CREATE TABLE `$table`")->fetch(PDO::FETCH_NUM)[1];
    // Seeding new permissions necessarily advances its AUTO_INCREMENT table option.
    // Compare structural DDL without that counter; retain exact comparison elsewhere.
    $normalize=static fn(string $sql):string=>preg_replace('/\bAUTO_INCREMENT=\d+\b/','AUTO_INCREMENT=<counter>',$sql);
    $checks[]=['name'=>'Existing DDL tidak berubah: '.$table,'passed'=>$table==='permissions' ? $normalize($ddl)===$normalize($saved['ddl']) : $ddl===$saved['ddl']];
}
foreach($db->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN) as $table) $counts[$table]=(int)$db->query("SELECT COUNT(*) FROM `$table`")->fetchColumn();
$checks[]=['name'=>'48 tabel aktual','passed'=>count($counts)===48];
$expectedTables=['eq_contracts','eq_contract_units','eq_unit_periods','eq_operator_assignments','eq_branch_authorizations','eq_handover_documents','eq_handover_units','eq_timesheets','eq_timesheet_revisions','eq_timesheet_work_entries','eq_timesheet_verifications','eq_meter_corrections','eq_events','eq_requests','eq_document_sequences','eq_evidence']; sort($expectedTables);
$actualTables=array_values(array_filter(array_keys($counts),fn($table)=>str_starts_with($table,'eq_'))); sort($actualTables);
$checks[]=['name'=>'16 nama tabel development tepat sesuai desain final','passed'=>$actualTables===$expectedTables];
$repo=new Hls\Repositories\Repository($db);
$sensitive=$repo->all("SELECT ro.name,p.code FROM role_permissions rp JOIN roles ro ON ro.id=rp.role_id JOIN permissions p ON p.id=rp.permission_id WHERE p.code LIKE 'equipment.%' ORDER BY ro.name,p.code");
$deciders=array_column(array_filter($sensitive,fn($grant)=>$grant['code']==='equipment.verification.decide'),'name');
$checks[]=['name'=>'verification.decide development hanya Administrator sel Y','passed'=>array_values($deciders)===['Administrator']];
$special=['equipment.handover.correct','equipment.handover.fact_correct','equipment.cross_branch.approve','equipment.recovery.close','equipment.meter.correct','equipment.timesheet.revise_terminal','equipment.operator.relink'];
$checks[]=['name'=>'Seluruh C khusus development tanpa grant termasuk Administrator','passed'=>!array_filter($sensitive,fn($grant)=>in_array($grant['code'],$special,true))];
$checks[]=['name'=>'Admin Sewa C tetap deny development','passed'=>!array_filter($sensitive,fn($grant)=>$grant['name']==='Admin Sewa'&&in_array($grant['code'],['equipment.contract.terminate','equipment.contract.extend','equipment.verification.view','equipment.verification.decide'],true))];
foreach($counts as $table=>$count) if(str_starts_with($table,'eq_')) $checks[]=['name'=>'Equipment tanpa data palsu: '.$table,'passed'=>$count===0];
$checks[]=['name'=>'Tanpa akun/cabang development palsu','passed'=>$counts['users']===count($backup['tables']['users']['rows'])&&$counts['branches']===count($backup['tables']['branches']['rows'])];
$failed=count(array_filter($checks,fn($c)=>!$c['passed']));
file_put_contents(__DIR__.'/results/equipment-development.json',json_encode(['date'=>date(DATE_ATOM),'read_only'=>true,'passed'=>count($checks)-$failed,'failed'=>$failed,'counts'=>$counts,'equipment_grants'=>$sensitive,'checks'=>$checks],JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
echo (count($checks)-$failed).' PASS; '.$failed.' FAIL preservation development.'.PHP_EOL;exit($failed?1:0);

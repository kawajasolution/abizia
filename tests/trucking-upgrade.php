<?php
declare(strict_types=1);
$upgradeStart=count($checks);$legacyName='hls_v2_test_'.bin2hex(random_bytes(6));Hls\Config::databaseName($legacyName);
$adminDb->exec("CREATE DATABASE `$legacyName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
try{
    $adminDb->exec("GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER,INDEX,REFERENCES,TRIGGER ON `$legacyName`.* TO '$account'@'127.0.0.1'");
    $legacyDb=Hls\Database::connect(array_replace($config,['database'=>$legacyName]));$legacyRepo=new Hls\Repositories\Repository($legacyDb);
    foreach(['001_foundation','002_master_data','003_trucking'] as $migration)foreach(explode(';',file_get_contents($root.'/database/migrations/'.$migration.'.sql')) as $statement)if(trim($statement)!=='')$legacyDb->exec($statement);
    Hls\Services\MasterPermissions::seed($legacyRepo,require $root.'/app/master-data.php');Hls\Services\ExpeditionPermissions::seed($legacyRepo);$legacyRepo->run("INSERT INTO schema_migrations(version) VALUES ('002_master_data'),('003_trucking')");
    $legacyActor=Hls\Services\BootstrapAdmin::create($legacyRepo,'Legacy test actor','legacy-upgrade@example.test',$password);
    $legacyRepo->run("INSERT INTO branches(code,name) VALUES ('OLDA','Cabang lama A'),('OLDB','Cabang lama B')");
    $legacyRepo->run("INSERT INTO md_locations(code,name,branch_id) VALUES ('OLD-LA','Lokasi historis A',1),('OLD-LB','Lokasi historis B',2)");
    $legacyRepo->run("INSERT INTO md_routes(code,name,branch_id,destination_branch_id,origin_location_id,destination_location_id) VALUES ('OLD-AB','Rute historis AB',1,2,1,2)");
    $legacyRepo->run("INSERT INTO md_customers(code,name,branch_id,customer_type) VALUES ('OLD-C','Customer historis',1,'company')");
    $legacyRepo->run("INSERT INTO md_parties(code,name,branch_id,party_role,identity_hash) VALUES ('OLD-S','Pengirim historis',1,'sender',?),('OLD-R','Penerima historis',2,'receiver',?)",[hash('sha256','legacy-sender'),hash('sha256','legacy-receiver')]);
    $legacySnapshot=json_encode(['route'=>['id'=>1,'name'=>'Rute historis AB'],'origin'=>['id'=>1,'name'=>'Cabang lama A'],'destination'=>['id'=>2,'name'=>'Cabang lama B'],'origin_location'=>['id'=>1,'name'=>'Lokasi historis A'],'destination_location'=>['id'=>2,'name'=>'Lokasi historis B'],'customer'=>['name'=>'Customer historis'],'sender'=>['name'=>'Pengirim historis'],'receiver'=>['name'=>'Penerima historis']],JSON_THROW_ON_ERROR);
    $legacyRepo->run("INSERT INTO exp_dns(number,document_date,route_id,origin_branch_id,destination_branch_id,customer_id,sender_id,receiver_id,description,quantity,unit,snapshot,created_by,request_key,request_hash) VALUES ('INT-DN-OLD','2026-10-01',1,1,2,1,1,2,'Barang historis',1,'Koli',?,?,?,?)",[$legacySnapshot,$legacyActor,str_repeat('a',64),str_repeat('b',64)]);
    $legacyRepo->run("INSERT INTO exp_manifests(number,document_date,route_id,origin_branch_id,destination_branch_id,snapshot,created_by,request_key,request_hash) VALUES ('INT-MF-OLD','2026-10-01',1,1,2,?,?,?,?)",[$legacySnapshot,$legacyActor,str_repeat('c',64),str_repeat('d',64)]);
    $legacyRepo->run('INSERT INTO exp_manifest_items(manifest_id,dn_id,attached_by) VALUES (1,1,?)',[$legacyActor]);$legacyRepo->run("INSERT INTO exp_events(dn_id,actor_id,branch_id,event_type,detail) VALUES (1,?,1,'document_created','{}')",[$legacyActor]);
    $legacyRepo->run("UPDATE exp_dns SET created_at='2020-01-01 08:00:00',updated_at='2020-01-02 08:00:00' WHERE id=1");
    $oldDn=$legacyRepo->one('SELECT * FROM exp_dns WHERE id=1');$oldMf=$legacyRepo->one('SELECT * FROM exp_manifests WHERE id=1');$oldMember=$legacyRepo->one('SELECT * FROM exp_manifest_items WHERE id=1');$oldEvents=$legacyRepo->all('SELECT * FROM exp_events');$oldAudits=$legacyRepo->all('SELECT * FROM audit_logs');
    $legacyRepo->run("UPDATE md_routes SET name='Nama master terbaru' WHERE id=1");$legacyRepo->run("UPDATE md_locations SET name=CONCAT(name,' terbaru')");
    check(Hls\Services\Migrator::install($legacyDb,$legacyName),'Upgrade 003 berisi DN/Manifest/histori ke 004 berhasil');
    $upDn=$legacyRepo->one('SELECT * FROM exp_dns WHERE id=1');$upMf=$legacyRepo->one('SELECT * FROM exp_manifests WHERE id=1');
    check(array_intersect_key($upDn,$oldDn)===$oldDn,'Upgrade mempertahankan seluruh kolom/ID/identifier DN lama');check(array_intersect_key($upMf,$oldMf)===$oldMf,'Upgrade mempertahankan seluruh kolom/ID/identifier Manifest lama');
    check(array_intersect_key($legacyRepo->one('SELECT * FROM exp_manifest_items WHERE id=1'),$oldMember)===$oldMember,'Keanggotaan dan histori lama tidak dihapus');
    check($legacyRepo->all('SELECT * FROM exp_events')===$oldEvents&&$legacyRepo->all('SELECT * FROM audit_logs')===$oldAudits,'Upgrade tidak membuat/mengubah event atau audit operasional rekaan');
    $legacyLeg=$legacyRepo->one('SELECT * FROM exp_trip_legs WHERE manifest_id=1');$legSnapshot=json_decode($legacyLeg['snapshot'],true,512,JSON_THROW_ON_ERROR);
    check($legSnapshot===['route'=>'Rute historis AB','origin'=>'Lokasi historis A','destination'=>'Lokasi historis B'],'Backfill leg memakai snapshot historis, bukan nama master yang telah berubah');
    check((int)$upDn['current_branch_id']===1&&(int)$upDn['current_location_id']===1&&$legacyLeg['arrived_at']===null,'Posisi awal dibackfill tanpa kedatangan rekaan');
    check($upDn['official_number']===null&&$upMf['official_number']===null,'Upgrade tidak otomatis menerbitkan nomor resmi');
    foreach(['exp_receipts','exp_claims','exp_sequences','exp_requests'] as $table)check((int)$legacyRepo->one("SELECT COUNT(*) n FROM $table")['n']===0,'Upgrade tidak mengisi transaksi/nomor dummy '.$table);
    check(!Hls\Services\Migrator::install($legacyDb,$legacyName),'Upgrade 004 ulang no-op pada dokumen legacy');
}finally{$legacyRepo=null;$legacyDb=null;Hls\Config::databaseName($legacyName);$adminDb->exec("DROP DATABASE `$legacyName`");}
file_put_contents(__DIR__.'/results/trucking-upgrade.json',json_encode(['date'=>date(DATE_ATOM),'passed'=>count($checks)-$upgradeStart,'checks'=>array_slice($checks,$upgradeStart)],JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));

<?php
declare(strict_types=1);
use Hls\Repositories\MasterDataRepository;
use Hls\Services\MasterData;
use Hls\Middleware\Access;
$masterStart=count($checks);$catalog=require $root.'/app/master-data.php';
$makeMaster=fn(Access $who)=>new MasterData(new MasterDataRepository($repo,$who,$catalog),$audit);
$md=$makeMaster($access);$mdScoped=$makeMaster($scoped);$mdOwner=$makeMaster($owner);
// Upgrade a separate legacy-foundation-only test database, never reset an existing DB.
$upgradeName='hls_v2_test_'.bin2hex(random_bytes(6));Hls\Config::databaseName($upgradeName);
$adminDb->exec("CREATE DATABASE `$upgradeName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
try{
 $adminDb->exec("GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER,INDEX,REFERENCES ON `$upgradeName`.* TO '$account'@'127.0.0.1'");
 $upgrade=Hls\Database::connect(array_replace($config,['database'=>$upgradeName]));
 foreach(explode(';',file_get_contents($root.'/database/migrations/001_foundation.sql')) as $sql)if(trim($sql)!=='')$upgrade->exec($sql);
 $upgrade->exec("INSERT INTO branches(code,name,address) VALUES('HIST','Cabang historis uji','Alamat historis')");
 $upgrade->exec("INSERT INTO audit_logs(action,entity,detail) VALUES('historical_test','test','{}')");
 $before=$upgrade->query('SELECT id,code,name,address,active FROM branches')->fetchAll();$auditBefore=$upgrade->query('SELECT * FROM audit_logs')->fetchAll();
 check(Hls\Services\Migrator::install($upgrade,$upgradeName),'Migration upgrade dari fondasi lama berhasil');
 check($upgrade->query('SELECT id,code,name,address,active FROM branches')->fetchAll()===$before,'Upgrade mempertahankan ID/nilai cabang lama');
 check($upgrade->query('SELECT * FROM audit_logs')->fetchAll()===$auditBefore,'Upgrade tidak menghapus/mengubah audit lama');
 check(!$upgrade->query('SELECT created_at FROM branches')->fetchColumn(),'Cabang lama tidak diberi tanggal penciptaan rekaan');
 check(!Hls\Services\Migrator::install($upgrade,$upgradeName),'Upgrade ulang idempoten');
 check((int)$upgrade->query('SELECT COUNT(*) FROM md_customers')->fetchColumn()===0,'Migration tidak mengisi master/customer dummy');
}finally{$upgrade=null;Hls\Config::databaseName($upgradeName);$adminDb->exec("DROP DATABASE `$upgradeName`");}
$samples=[];$masterBase=['active'=>'1','branch_id'=>(string)$a];
$create=function(string $key,array $fields)use($md,$masterBase,&$samples){$payload=$fields+$masterBase;$id=$md->save($key,$payload);$samples[$key]=['id'=>$id,'fields'=>$payload];return $id;};
$create('branches',['code'=>'MASTER','name'=>'Cabang Master Uji']);
$category=$create('categories',['code'=>'CAT-TEST','name'=>'Kategori uji']);
$uom=$create('uoms',['code'=>'PCS-TEST','name'=>'Satuan uji']);
$item=$create('items',['code'=>'ITEM-TEST','name'=>'Barang uji','category_id'=>(string)$category,'unit_id'=>(string)$uom]);
$customer=$create('customers',['code'=>'CUST-TEST','name'=>'Customer uji','customer_type'=>'company','phone'=>'08123456789','email'=>'customer@example.test']);
$party=$create('parties',['code'=>'PARTY-TEST','name'=>'Pihak uji','party_role'=>'both','company'=>'Perusahaan uji','address'=>'Alamat pihak uji','phone'=>'08123456789']);
$locA=$create('locations',['code'=>'LOCA-TEST','name'=>'Lokasi asal uji']);
$locB=$md->save('locations',['code'=>'LOCB-TEST','name'=>'Lokasi tujuan uji','branch_id'=>(string)$b,'active'=>'1']);
$route=$create('routes',['code'=>'ROUTE-TEST','name'=>'Lintasan uji','destination_branch_id'=>(string)$b,'origin_location_id'=>(string)$locA,'destination_location_id'=>(string)$locB]);
$vehicle=$create('vehicles',['code'=>'VEH-TEST','name'=>'Truk uji','identity'=>'DA 1234 AB','capacity'=>'Referensi 10 ton']);
$unit=$create('units',['code'=>'UNIT-TEST','name'=>'Unit uji','identity'=>'SN-TEST-001','condition_code'=>'ready','category'=>'Alat uji']);
$driver=$create('drivers',['code'=>'DRIVER-TEST','name'=>'Driver uji']);
$operator=$create('operators',['code'=>'OPERATOR-TEST','name'=>'Operator uji']);
$tariff=$create('trucking-tariffs',['code'=>'TRATE-TEST','name'=>'Tarif uji','service'=>'regular','route_id'=>(string)$route,'basis'=>'Referensi manual']);
$rate=$create('equipment-tariffs',['code'=>'ERATE-TEST','name'=>'Tarif alat uji','asset_id'=>(string)$unit,'period'=>'hour','amount'=>'0']);
$supplier=$create('suppliers',['code'=>'SUP-TEST','name'=>'Supplier uji','email'=>'supplier@example.test']);
foreach($samples as $key=>$sample){
 $id=$sample['id'];$entity=$catalog['entities'][$key];$stored=$md->data->find($key,$id);
 check($stored['code']===$sample['fields']['code'],'Tambah/detail nyata '.$key);
 $payload=$sample['fields'];$payload['id']=(string)$id;$payload['version']=(string)$stored['version'];$payload['name'].=' diperbarui';
 check($md->save($key,$payload)===$id,'Edit master '.$key);
 rejects(fn()=>$md->save($key,$payload),'Versi formulir usang ditolak '.$key,409);
 $record=$md->data->find($key,$id);$md->status($key,$id,(int)$record['version'],0);check(!$md->data->find($key,$id)['active'],'Nonaktif tanpa hapus '.$key);
 $record=$md->data->find($key,$id);$md->status($key,$id,(int)$record['version'],1);check((bool)$md->data->find($key,$id)['active'],'Aktif kembali '.$key);
 rejects(fn()=>$md->save($key,$sample['fields']),'Duplikasi kode ditolak '.$key);
 $events=$repo->all('SELECT action FROM audit_logs WHERE entity=? AND entity_id=?',[$entity['table'],$id]);
 foreach(['master_created','master_updated','master_deactivated','master_reactivated'] as $action)check(in_array($action,array_column($events,'action'),true),'Audit '.$action.' '.$key);
 $list=$md->data->listing($key,['q'=>$sample['fields']['code']]);check($list['pagination']['total']===1,'Pencarian tepat '.$key);
 check($md->data->listing($key,['status'=>'0'])['pagination']['total']===0,'Filter status aktif '.$key);
}
rejects(fn()=>$md->save('customers',$masterBase+['code'=>'INVALID','name'=>'','customer_type'=>'company']),'Field wajib kosong ditolak',422);
rejects(fn()=>$md->save('customers',$masterBase+['code'=>'INVALID','name'=>'Alamat','customer_type'=>'company','email'=>'invalid']),'Format email ditolak',422);
rejects(fn()=>$md->save('items',['code'=>'BADFK','name'=>'Barang FK','category_id'=>'99999','unit_id'=>(string)$uom,'active'=>'1']),'Referensi tidak ditemukan ditolak',404);
rejects(fn()=>$repo->run("INSERT INTO md_items(code,name,category_id,unit_id) VALUES ('FK-DB','Invalid',99999,?)",[$uom]),'Foreign key DB menolak data yatim');
rejects(fn()=>$mdScoped->data->find('locations',$locB),'Detail cabang lain ditolak',404);
check($mdScoped->data->listing('routes',[])['pagination']['total']===0,'Rute lintas cabang tidak bocor jika hanya satu endpoint diizinkan');
rejects(fn()=>$mdOwner->save('customers',$samples['customers']['fields']),'Owner baca tidak mendapat hak tulis',403);
rejects(fn()=>$mdScoped->save('categories',['code'=>'DENIED','name'=>'Tidak boleh','active'=>'1']),'Katalog global tidak dapat diubah admin scoped',403);
$record=$md->data->find('customers',$customer);
rejects(fn()=>$md->save('customers',array_replace($samples['customers']['fields'],['id'=>(string)$customer,'version'=>(string)$record['version'],'branch_id'=>(string)$b])),'Edit tidak dapat memindahkan pemilik cabang',422);
rejects(fn()=>$md->save('routes',$masterBase+['code'=>'WRONG-ROUTE','name'=>'Rute salah','destination_branch_id'=>(string)$b,'origin_location_id'=>(string)$locB,'destination_location_id'=>(string)$locA]),'Lokasi rute harus sesuai cabang',422);
$record=$md->data->find('units',$unit);
rejects(fn()=>$md->save('units',array_replace($samples['units']['fields'],['id'=>(string)$unit,'version'=>(string)$record['version'],'identity'=>'CHANGED'])),'Identitas unit tertaut tarif tidak berubah diam-diam',409);
rejects(fn()=>$md->save('parties',$masterBase+['code'=>'PARTY-DUP','name'=>'Pihak uji diperbarui','party_role'=>'sender','company'=>'Perusahaan uji','address'=>'Alamat pihak uji','phone'=>'08123456789']),'Identitas pihak sama tidak diduplikasi per peran');
check($md->data->find('trucking-tariffs',$tariff)['amount']===null,'Tarif kosong tetap NULL');
check($md->data->find('equipment-tariffs',$rate)['amount']==='0.00','Tarif nol manual berbeda dari NULL');
rejects(fn()=>$md->save('equipment-tariffs',$masterBase+['code'=>'RATE-BAD','name'=>'Salah','asset_id'=>(string)$unit,'period'=>'day']),'Tarif harian yang belum disetujui tidak diaktifkan',422);
rejects(fn()=>$md->save('equipment-tariffs',$masterBase+['code'=>'RATE-BAD','name'=>'Salah','asset_id'=>(string)$unit,'period'=>'hour','amount'=>'1.001']),'Presisi uang lebih dari dua desimal ditolak',422);
$linked=$md->save('operators',$masterBase+['code'=>'OP-LINK','name'=>'Nama tidak disalin','account_id'=>(string)$ownerId]);
check($md->data->find('operators',$linked)['name']===null && $md->data->find('operators',$linked)['display_name']===$users->find($ownerId)['name'],'Personel tertaut memakai nama akun tanpa duplikasi identitas');
rejects(fn()=>$md->save('drivers',$masterBase+['code'=>'DUP-LINK','account_id'=>(string)$ownerId]),'Satu akun tidak diduplikasi di personel');
$repo->run("CREATE TRIGGER master_audit_fail BEFORE INSERT ON audit_logs FOR EACH ROW SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='master test rollback'");
try{rejects(fn()=>$md->save('suppliers',$masterBase+['code'=>'ATOMIC','name'=>'Rollback']),'Kegagalan audit menggagalkan master');check(!$repo->one("SELECT id FROM md_suppliers WHERE code='ATOMIC'"),'Rollback master saat audit gagal');}finally{$repo->run('DROP TRIGGER master_audit_fail');}
for($i=1;$i<=12;$i++)$md->save('customers',$masterBase+['code'=>'PAGE-'.str_pad((string)$i,2,'0',STR_PAD_LEFT),'name'=>'Pelanggan halaman '.$i,'customer_type'=>'individual']);
$pageOne=$md->data->listing('customers',['q'=>'PAGE-']);$pageTwo=$md->data->listing('customers',['q'=>'PAGE-','page'=>'2']);check(count($pageOne['rows'])===10&&count($pageTwo['rows'])===2,'Pagination database 10/2 tanpa hilang/duplikasi');
check($md->data->listing('customers',['q'=>'%'])['pagination']['total']===0,'Wildcard pencarian literal tidak membuka seluruh data');
rejects(fn()=>$repo->run('DELETE FROM md_categories WHERE id=?',[$category]),'FK mencegah penghapusan master yang sudah direferensikan');
$catRow=$md->data->find('categories',$category);$md->status('categories',$category,(int)$catRow['version'],0);
try{
 rejects(fn()=>$md->save('items',['code'=>'INACTIVE-REF','name'=>'Ditolak','category_id'=>(string)$category,'unit_id'=>(string)$uom,'active'=>'1']),'Referensi nonaktif ditolak untuk data baru',422);
 $itemRow=$md->data->find('items',$item);$md->save('items',array_replace($samples['items']['fields'],['id'=>(string)$item,'version'=>(string)$itemRow['version'],'name'=>'Riwayat kategori tetap terbaca']));
 check($md->data->find('items',$item)['category_id']==$category,'Relasi nonaktif historis tidak dihapus atau diganti');
}finally{$catRow=$md->data->find('categories',$category);$md->status('categories',$category,(int)$catRow['version'],1);}
foreach($catalog['groups'] as $path=>$group){
 check(http($path,$anonJar)['status']===200,'Route daftar admin nyata '.$path);
 foreach($group['tabs'] as $key){
  $id=$samples[$key]['id'];$uri=$path.'?'.http_build_query(['tab'=>$key,'mode'=>'detail','id'=>$id]);
  check(http($uri,$anonJar)['status']===200,'Route detail '.$key);
  check(http($path.'?tab='.$key.'&mode=create',$anonJar)['status']===200,'Route tambah terpisah '.$key);
  check(http($path.'?'.http_build_query(['tab'=>$key,'mode'=>'edit','id'=>$id]),$anonJar)['status']===200,'Route edit terpisah '.$key);
  check(http($path,$anonJar,['tab'=>$key,'action'=>'save'])['status']===403,'CSRF mutasi master '.$key);
 }
}
check(http('/master/customers?mode=create',$ownerJar)['status']===403,'Owner tidak melihat form tambah melalui URL');
check(http('/master/assets?tab=vehicles',$ownerJar)['status']===200,'Owner baca tab kendaraan dalam cakupan');
check(http('/master/routes?tab=routes&mode=detail&id='.$route,$scopeJar)['status']===404,'HTTP rute lintas endpoint dicegah');
$masterToken=token(http('/master/customers',$anonJar));
check(http('/master/customers',$anonJar,['csrf'=>$masterToken,'tab'=>'customers','action'=>'delete','id'=>(string)$customer])['status']===405,'Tidak ada endpoint hard delete master');
check((bool)$repo->one('SELECT id FROM md_customers WHERE id=?',[$customer]),'Permintaan hapus tidak menghilangkan data');
$tests=array_slice($checks,$masterStart);file_put_contents(__DIR__.'/results/master-integration.json',json_encode(['date'=>date(DATE_ATOM),'passed'=>count($tests),'checks'=>$tests],JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));
$masterFixtures=$samples;

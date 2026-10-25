<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
try {
    $config=require dirname(__DIR__).'/config/demo.php'; if (($config['database']??'')!=='hls_v2_demo') throw new RuntimeException('Seed hanya boleh hls_v2_demo.');
    $db=Hls\Database::connect($config); $db->beginTransaction();
    $q=static function(PDO $db,string $sql,array $a=[]):array{$s=$db->prepare($sql);$s->execute($a);return $s->fetch(PDO::FETCH_ASSOC)?:[];};
    $branch=$q($db,"SELECT id FROM branches WHERE code='DMO'"); if(!$branch) throw new RuntimeException('Cabang DMO belum tersedia.'); $b=(int)$branch['id'];
    $ins=function(string $table,array $fields,array $key)use($db,$q){$where=implode(' AND ',array_map(fn($k)=>"`$k`=?",array_keys($key)));$old=$q($db,"SELECT id FROM `$table` WHERE $where LIMIT 1",array_values($key));if($old)return (int)$old['id'];$cols=implode(',',array_keys($fields));$marks=implode(',',array_fill(0,count($fields),'?'));$s=$db->prepare("INSERT INTO `$table` ($cols) VALUES ($marks)");$s->execute(array_values($fields));return (int)$db->lastInsertId();};
    $customer=$ins('md_customers',['code'=>'DEMO-CUST-01','name'=>'DEMO Customer Nusantara','branch_id'=>$b,'customer_type'=>'company','address'=>'Alamat simulasi DEMO'],['code'=>'DEMO-CUST-01']);
    $sender=$ins('md_parties',['code'=>'DEMO-SENDER-01','name'=>'DEMO Pengirim','branch_id'=>$b,'company'=>'DEMO Logistics','party_role'=>'sender','identity_hash'=>hash('sha256','DEMO-SENDER-01')],['code'=>'DEMO-SENDER-01']);
    $receiver=$ins('md_parties',['code'=>'DEMO-RECEIVER-01','name'=>'DEMO Penerima','branch_id'=>$b,'company'=>'DEMO Site','party_role'=>'receiver','identity_hash'=>hash('sha256','DEMO-RECEIVER-01')],['code'=>'DEMO-RECEIVER-01']);
    $origin=$ins('md_locations',['code'=>'DEMO-LOC-A','name'=>'DEMO Gudang A','branch_id'=>$b,'city'=>'Makassar','province'=>'Sulawesi Selatan'],['code'=>'DEMO-LOC-A']);
    $dest=$ins('md_locations',['code'=>'DEMO-LOC-B','name'=>'DEMO Proyek B','branch_id'=>$b,'city'=>'Gowa','province'=>'Sulawesi Selatan'],['code'=>'DEMO-LOC-B']);
    $route=$ins('md_routes',['code'=>'DEMO-ROUTE-01','name'=>'DEMO Gudang A - Proyek B','branch_id'=>$b,'destination_branch_id'=>$b,'origin_location_id'=>$origin,'destination_location_id'=>$dest],['code'=>'DEMO-ROUTE-01']);
    $truck=$ins('md_assets',['code'=>'DEMO-TRUCK-01','name'=>'DEMO Truck 01','branch_id'=>$b,'kind'=>'truck','identity'=>'DEMO-TRUCK-01','category'=>'Trucking','condition_code'=>'ready'],['code'=>'DEMO-TRUCK-01']);
    $equipment=$ins('md_assets',['code'=>'DEMO-EQUIP-01','name'=>'DEMO Excavator 01','branch_id'=>$b,'kind'=>'equipment','identity'=>'DEMO-EQUIP-01','category'=>'Excavator','condition_code'=>'ready'],['code'=>'DEMO-EQUIP-01']);
    $driver=$ins('md_personnel',['code'=>'DEMO-DRIVER-01','name'=>'DEMO Driver','branch_id'=>$b,'kind'=>'driver'],['code'=>'DEMO-DRIVER-01']);
    $operator=$ins('md_personnel',['code'=>'DEMO-OPERATOR-01','name'=>'DEMO Operator','branch_id'=>$b,'kind'=>'operator'],['code'=>'DEMO-OPERATOR-01']);
    $category=$ins('md_categories',['code'=>'DEMO-CAT','name'=>'DEMO Category'],['code'=>'DEMO-CAT']);$unit=$ins('md_units',['code'=>'DEMO-UNIT','name'=>'DEMO Unit'],['code'=>'DEMO-UNIT']);$item=$ins('md_items',['code'=>'DEMO-ITEM','name'=>'DEMO Item','category_id'=>$category,'unit_id'=>$unit],['code'=>'DEMO-ITEM']);
    $db->commit(); echo json_encode(['database'=>'hls_v2_demo','master'=>['customer'=>1,'parties'=>2,'locations'=>2,'routes'=>1,'truck'=>1,'equipment'=>1,'driver'=>1,'operator'=>1,'category'=>1,'unit'=>1,'item'=>1]],JSON_PRETTY_PRINT).PHP_EOL;
}catch(Throwable $e){if(isset($db)&&$db instanceof PDO&&$db->inTransaction())$db->rollBack();fwrite(STDERR,'Seed demo gagal: '.$e->getMessage().PHP_EOL);exit(1);}

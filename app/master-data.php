<?php
declare(strict_types=1);
return (static function():array {
$text=static fn(string $label,int $max=150,bool $required=false):array=>compact('label','max','required')+['type'=>'text'];
$ref=static fn(string $label,string $target,bool $required=true):array=>compact('label','target','required')+['type'=>'ref'];
$choice=static fn(string $label,array $options):array=>compact('label','options')+['type'=>'select','required'=>true];
$base=['code'=>$text('Kode',40,true),'name'=>$text('Nama',150,true)];
$contact=['address'=>$text('Alamat',500),'phone'=>$text('Telepon',30),'email'=>$text('Email',190)];
$branch=['branch_id'=>$ref('Cabang','branches')];
$validity=['valid_from'=>['label'=>'Berlaku mulai','type'=>'date'],'valid_until'=>['label'=>'Berlaku sampai','type'=>'date']];
$amount=['amount'=>['label'=>'Nominal referensi (Rp)','type'=>'money','hint'=>'Opsional. Kosong berarti belum ditentukan; tidak dihitung menjadi tagihan.']];
$entity=static fn(string $label,string $table,string $permission,string $scope,array $fields,?string $kind=null):array=>compact('label','table','permission','scope','fields','kind');
$entities=[
 'branches'=>$entity('Cabang','branches','branches','self',['code'=>$text('Kode',12,true),'name'=>$text('Nama',100,true)]+$contact+['city'=>$text('Kota/kabupaten',100),'province'=>$text('Provinsi',100)]),
 'customers'=>$entity('Customer','md_customers','master.customer','branch',$base+$branch+['customer_type'=>$choice('Jenis customer',['individual'=>'Perorangan','company'=>'Perusahaan'])]+$contact+['contact_name'=>$text('Penanggung jawab')]),
 'parties'=>$entity('Pengirim & Penerima','md_parties','master.party','branch',$base+$branch+['party_role'=>$choice('Peran',['sender'=>'Pengirim','receiver'=>'Penerima','both'=>'Pengirim dan penerima']),'company'=>$text('Perusahaan'),'address'=>$text('Alamat',500),'phone'=>$text('Telepon',30)]),
 'locations'=>$entity('Lokasi','md_locations','master.location','branch',$base+$branch+['city'=>$text('Kota/kabupaten',100),'province'=>$text('Provinsi',100)]),
 'routes'=>$entity('Rute','md_routes','master.route','branch',$base+['branch_id'=>$ref('Cabang asal','branches'),'destination_branch_id'=>$ref('Cabang tujuan','branches'),'origin_location_id'=>$ref('Lokasi asal','locations'),'destination_location_id'=>$ref('Lokasi tujuan','locations')]),
 'trucking-tariffs'=>$entity('Tarif Trucking','md_trucking_tariffs','master.trucking_tariff','branch',$base+$branch+['service'=>$choice('Layanan',['regular'=>'Reguler','charter'=>'Carter','pickup'=>'Pickup tambahan']),'route_id'=>$ref('Rute (kosong untuk pickup)','routes',false),'basis'=>$text('Dasar/satuan referensi',150,true)]+$amount+$validity),
 'equipment-tariffs'=>$entity('Tarif Equipment','md_equipment_tariffs','master.equipment_tariff','branch',$base+$branch+['asset_id'=>$ref('Unit Equipment','units'),'period'=>$choice('Paket referensi',['hour'=>'Per jam','shift'=>'Per shift','month'=>'Per bulan'])]+$amount+$validity),
 'vehicles'=>$entity('Kendaraan Trucking','md_assets','master.vehicle','branch',$base+$branch+['identity'=>$text('Nomor polisi',100,true),'category'=>$text('Jenis kendaraan',100),'capacity'=>$text('Kapasitas (referensi teks)',100)],'truck'),
 'units'=>$entity('Unit Equipment','md_assets','master.unit','branch',$base+$branch+['identity'=>$text('Nomor seri',100,true),'category'=>$text('Kategori alat',100),'brand'=>$text('Merek',100),'model'=>$text('Model',100),'condition_code'=>$choice('Kondisi fisik',['ready'=>'Siap','maintenance'=>'Perawatan'])],'equipment'),
 'drivers'=>$entity('Driver','md_personnel','master.driver','branch',$base+$branch+['phone'=>$text('Telepon',30),'account_id'=>$ref('Akun login (opsional)','users',false)],'driver'),
 'operators'=>$entity('Operator','md_personnel','master.operator','branch',$base+$branch+['phone'=>$text('Telepon',30),'account_id'=>$ref('Akun login (opsional)','users',false)],'operator'),
 'items'=>$entity('Barang','md_items','master.item','global',$base+['category_id'=>$ref('Kategori barang','categories'),'unit_id'=>$ref('Satuan','uoms')]),
 'categories'=>$entity('Kategori Barang','md_categories','master.category','global',$base),
 'uoms'=>$entity('Satuan','md_units','master.uom','global',$base),
 'suppliers'=>$entity('Supplier','md_suppliers','master.supplier','branch',$base+$branch+$contact),
];
// Branch does not have an email column. Preserve its existing identifiers.
unset($entities['branches']['fields']['email']);
$entities['drivers']['fields']['name']['required']=false;
$entities['operators']['fields']['name']['required']=false;
return ['entities'=>$entities,'groups'=>[
 '/branches'=>['label'=>'Cabang','permission'=>'branches.view','tabs'=>['branches']],
 '/master/customers'=>['label'=>'Customer','permission'=>'master.customer.view','tabs'=>['customers']],
 '/master/parties'=>['label'=>'Pengirim & Penerima','permission'=>'master.party.view','tabs'=>['parties']],
 '/master/routes'=>['label'=>'Lokasi & Rute','permission'=>'master.routes.view','tabs'=>['locations','routes']],
 '/master/trucking-tariffs'=>['label'=>'Tarif Trucking','permission'=>'master.trucking_tariff.view','tabs'=>['trucking-tariffs']],
 '/master/equipment-tariffs'=>['label'=>'Tarif Equipment','permission'=>'master.equipment_tariff.view','tabs'=>['equipment-tariffs']],
 '/master/assets'=>['label'=>'Kendaraan & Unit','permission'=>'master.assets.view','tabs'=>['vehicles','units']],
 '/master/personnel'=>['label'=>'Driver & Operator','permission'=>'master.personnel.view','tabs'=>['drivers','operators']],
 '/master/items'=>['label'=>'Barang & Kategori','permission'=>'master.catalog.view','tabs'=>['items','categories','uoms']],
 '/master/suppliers'=>['label'=>'Supplier','permission'=>'master.supplier.view','tabs'=>['suppliers']],
]];
})();

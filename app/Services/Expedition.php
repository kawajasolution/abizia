<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\ExpeditionRepository;
final class Expedition
{
    public function __construct(public readonly ExpeditionRepository $data,private Audit $audit) {}
    private function decimal(array $input,string $field,bool $required=false): ?string
    {
        $value=Input::text($input,$field,13,$required);
        if($value==='')return null;
        if(!preg_match('/^(?:0|[1-9][0-9]{0,8})(?:\.[0-9]{1,3})?$/D',$value)||($required&&!preg_match('/[1-9]/',$value)))throw new HttpError(422,'Jumlah/berat/volume harus nonnegatif, maksimal tiga desimal; jumlah harus lebih dari nol.');
        return $value;
    }
    private function parent(string $table,int $id): array
    {
        if(!in_array($table,['md_routes','branches','md_locations','md_customers','md_parties','md_assets','md_personnel','users'],true))throw new \LogicException('Referensi tidak dikenal.');
        $row=$this->data->repo->one("SELECT * FROM $table WHERE id=? FOR UPDATE",[$id]);
        if(!$row||!$row['active'])throw new HttpError(422,'Referensi tidak aktif atau tidak tersedia.');
        return $row;
    }
    public function save(string $kind,array $input): int
    {
        $permission=$kind==='dn'?'expedition.ship':'expedition.manifest';$this->data->table($kind);
        $this->data->guard->actor($permission);$id=Input::id($input,'id',true);
        if($id&&$kind!=='dn')throw new HttpError(405,'Perubahan manifest belum tersedia.');
        $date=Input::text($input,'document_date',10);$dt=\DateTimeImmutable::createFromFormat('!Y-m-d',$date);
        if(!$dt||$dt->format('Y-m-d')!==$date||$dt->format('Y')<'1000')throw new HttpError(422,'Tanggal dokumen tidak valid.');
        $routeId=Input::id($input,'route_id');$note=Input::text($input,'note',1000,false);
        $key=Input::text($input,'request_key',64);if(!preg_match('/^[a-f0-9]{64}$/D',$key))throw new HttpError(422,'Token permintaan tidak valid.');
        $values=['document_date'=>$date,'route_id'=>$routeId,'note'=>$note];
        if($kind==='dn'){
            foreach(['customer_id','sender_id','receiver_id'] as $field)$values[$field]=Input::id($input,$field);
            $values['description']=Input::text($input,'description',1000);$values['quantity']=$this->decimal($input,'quantity',true);$values['unit']=Input::text($input,'unit',60);
            $values['weight']=$this->decimal($input,'weight');$values['volume']=$this->decimal($input,'volume');
        }else foreach(['vehicle_id','driver_id'] as $field)$values[$field]=Input::id($input,$field,true)?:null;
        $hash=hash('sha256',json_encode($values,JSON_THROW_ON_ERROR));$table=$this->data->table($kind);
        return Database::transaction($this->data->repo->db,function()use($kind,$input,$id,$values,$hash,$key,$table,$permission):int{
            $actor=$this->data->guard->actor($permission,true);
            if(!$id){$prior=$this->data->repo->one("SELECT id,created_by,request_hash,origin_branch_id FROM $table WHERE request_key=? FOR UPDATE",[$key]);if($prior){$this->data->guard->branch((int)$prior['origin_branch_id'],$permission,true);if((int)$prior['created_by']!==(int)$actor['id']||!hash_equals($prior['request_hash'],$hash))throw new HttpError(409,'Token permintaan sudah digunakan untuk data lain.');return (int)$prior['id'];}}
            $before=$id?$this->data->find($kind,$id,true):null;
            if($before){$this->data->guard->branch((int)$before['origin_branch_id'],$permission,true);if($before['status']!=='created'||$this->data->active($id,true))throw new HttpError(409,'DN hanya dapat diedit sebelum masuk manifest/perjalanan.');if((int)$before['version']!==Input::id($input,'version'))throw new HttpError(409,'Versi berubah. Muat ulang dokumen.');if((int)$before['route_id']!==$values['route_id'])throw new HttpError(422,'Rute/asal/tujuan tidak dipindah melalui edit.');}
            $route=$this->parent('md_routes',$values['route_id']);$this->data->guard->branch((int)$route['branch_id'],$permission,true);
            $origin=$this->parent('branches',(int)$route['branch_id']);$destination=$this->parent('branches',(int)$route['destination_branch_id']);
            $lo=$this->parent('md_locations',(int)$route['origin_location_id']);$ld=$this->parent('md_locations',(int)$route['destination_location_id']);
            $snapshot=['route'=>['id'=>$route['id'],'code'=>$route['code'],'name'=>$route['name']],'origin'=>['id'=>$origin['id'],'name'=>$origin['name']],'destination'=>['id'=>$destination['id'],'name'=>$destination['name']],'origin_location'=>['id'=>$lo['id'],'name'=>$lo['name']],'destination_location'=>['id'=>$ld['id'],'name'=>$ld['name']]];
            $new=$values+['origin_branch_id'=>$route['branch_id'],'destination_branch_id'=>$route['destination_branch_id']];
            if($kind==='dn'){
                foreach(['customer_id'=>['md_customers',$route['branch_id'],'customer'],'sender_id'=>['md_parties',$route['branch_id'],'sender'],'receiver_id'=>['md_parties',$route['destination_branch_id'],'receiver']] as $field=>[$source,$branch,$label]){
                    $ref=$this->parent($source,$values[$field]);if((int)$ref['branch_id']!==(int)$branch)throw new HttpError(422,'Pihak/customer tidak sesuai cabang rute.');
                    if($label!=='customer'&&!in_array($ref['party_role'],[$label,'both'],true))throw new HttpError(422,'Peran pihak tidak sesuai.');
                    $snapshot[$label]=array_intersect_key($ref,array_flip(['id','code','name','company','address','phone','email']));
                }
            }else{
                foreach(['vehicle_id'=>['md_assets','truck','vehicle'],'driver_id'=>['md_personnel','driver','driver']] as $field=>[$source,$type,$label])if($values[$field]){
                    $ref=$this->parent($source,$values[$field]);if((int)$ref['branch_id']!==(int)$route['branch_id']||$ref['kind']!==$type)throw new HttpError(422,'Kendaraan/driver tidak sesuai cabang atau jenis.');
                    if($label==='driver'&&$ref['account_id']){$account=$this->parent('users',(int)$ref['account_id']);if(!$account['all_branches']&&!$this->data->repo->one('SELECT 1 FROM user_branches WHERE user_id=? AND branch_id=? FOR UPDATE',[$account['id'],$route['branch_id']]))throw new HttpError(422,'Akun driver tidak mempunyai akses cabang.');$ref['name']=$account['name'];}
                    $snapshot[$label]=array_intersect_key($ref,array_flip(['id','code','name','identity']));
                }
            }
            $new['snapshot']=json_encode($snapshot,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE);
            if($kind==='dn')$new+=['current_branch_id'=>$origin['id'],'current_location_id'=>$lo['id']];
            if($before){$sets=implode(',',array_map(fn($f)=>"`$f`=?",array_keys($new)));$this->data->repo->run("UPDATE $table SET $sets,version=version+1 WHERE id=?",[...array_values($new),$id]);$saved=$id;}
            else{
                $new+=['number'=>($kind==='dn'?'INT-DN-':'INT-MF-').strtoupper(bin2hex(random_bytes(16))),'created_by'=>$actor['id'],'request_key'=>$key,'request_hash'=>$hash];
                $cols='`'.implode('`,`',array_keys($new)).'`';$marks=implode(',',array_fill(0,count($new),'?'));$this->data->repo->run("INSERT INTO $table ($cols) VALUES ($marks)",array_values($new));$saved=(int)$this->data->repo->db->lastInsertId();
                if($kind==='manifest')$this->data->repo->run('INSERT INTO exp_trip_legs(manifest_id,position,route_id,origin_branch_id,destination_branch_id,origin_location_id,destination_location_id,snapshot) VALUES (?,1,?,?,?,?,?,?)',[$saved,$route['id'],$origin['id'],$destination['id'],$lo['id'],$ld['id'],json_encode(['route'=>$route['name'],'origin'=>$lo['name'],'destination'=>$ld['name']],JSON_THROW_ON_ERROR)]);
            }
            $event=$before?'document_edited':'document_created';$detail=['before'=>$before?array_intersect_key($before,array_flip(['version','description','quantity','unit','weight','volume','note'])):null,'after'=>$new];unset($detail['after']['request_key'],$detail['after']['request_hash']);
            $this->event($kind==='dn'?$saved:null,$kind==='manifest'?$saved:null,(int)$route['branch_id'],$event,$detail);
            $this->audit->record((int)$actor['id'],$event,$table,$saved,$detail);return $saved;
        });
    }
    public function attach(int $manifestId,array $ids,int $version,?string $key=null): void
    {
        (new TruckingOperations($this->data,$this->audit))->attach($manifestId,$ids,$version,$key??bin2hex(random_bytes(32)));
    }
    private function event(?int $dn,?int $manifest,int $branch,string $type,array $detail): void
    {
        $this->data->repo->run('INSERT INTO exp_events(dn_id,manifest_id,actor_id,branch_id,event_type,detail) VALUES (?,?,?,?,?,?)',[$dn,$manifest,$this->data->guard->access->user['id'],$branch,$type,json_encode($detail,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE)]);
    }
}

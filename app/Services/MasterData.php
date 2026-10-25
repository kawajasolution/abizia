<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Database;
use Hls\Http\Input;
use Hls\Http\HttpError;
use Hls\Repositories\MasterDataRepository;
final class MasterData
{
    public function __construct(public readonly MasterDataRepository $data,private Audit $audit){}
    public function save(string $key,array $input):int
    {
        $id=Input::id($input,'id',true);$this->data->demand($key,'view');$this->data->demand($key,$id?'update':'create');
        if($id)$this->data->find($key,$id);
        $e=$this->data->entity($key);if($key==='branches'&&!$id)$this->data->access->global();
        $values=[];
        foreach($e['fields'] as $name=>$field){
            if($field['type']==='ref'){$values[$name]=Input::id($input,$name,!$field['required'])?:null;continue;}
            $value=Input::text($input,$name,$field['max']??190,($field['required']??false)&&!in_array($key,['drivers','operators'],true));
            if($field['type']==='select'&&!array_key_exists($value,$field['options']))throw new HttpError(422,'Pilihan '.$field['label'].' tidak valid.');
            if($field['type']==='money'){
                if($value!==''&&!preg_match('/^(?:0|[1-9][0-9]{0,9})(?:\.[0-9]{1,2})?$/D',$value))throw new HttpError(422,'Nominal harus rupiah nonnegatif, maksimal dua desimal tanpa pembulatan.');
                $value=$value===''?null:$value;
            }
            if($field['type']==='date'){
                $date=$value!==''?\DateTimeImmutable::createFromFormat('!Y-m-d',$value):null;
                if($value!==''&&(!$date||$date->format('Y-m-d')!==$value||$date->format('Y')<'1000'))throw new HttpError(422,'Tanggal tidak valid.');$value=$value===''?null:$value;
            }
            if($name==='email'&&$value!==''&&!filter_var($value,FILTER_VALIDATE_EMAIL))throw new HttpError(422,'Email tidak valid.');
            if($name==='phone'&&$value!==''&&!preg_match('/^(?=.*[0-9])[0-9+(). -]+$/D',$value))throw new HttpError(422,'Format telepon tidak valid.');
            $values[$name]=$value;
        }
        $values['code']=strtoupper($values['code']);if(!preg_match('/^[A-Z0-9_-]+$/D',$values['code']))throw new HttpError(422,'Kode hanya huruf, angka, garis bawah dan tanda hubung.');
        $values['active']=Input::flag($input,'active');
        if($e['kind']!==null)$values['kind']=$e['kind'];
        if(isset($values['identity']))$values['identity']=mb_strtoupper(preg_replace('/\s+/u','',$values['identity']));
        if(isset($values['valid_from'],$values['valid_until'])&&$values['valid_from']>$values['valid_until'])throw new HttpError(422,'Masa berlaku tidak berurutan.');
        if($key==='trucking-tariffs'&&(($values['service']==='pickup'&&$values['route_id']!==null)||($values['service']!=='pickup'&&$values['route_id']===null)))throw new HttpError(422,'Reguler/carter memerlukan rute; pickup memakai cabang tanpa rute.');
        if($key==='parties')$values['identity_hash']=hash('sha256',mb_strtolower(preg_replace('/\s+/u',' ',trim(implode('|',[$values['name'],$values['company'],$values['address'],preg_replace('/[^0-9+]/','',$values['phone'])])))));
        if(in_array($key,['drivers','operators'],true)){
            if($values['account_id']!==null)$values['name']=null;
            elseif($values['name']==='')throw new HttpError(422,'Nama wajib jika tidak ditautkan ke akun.');
        }
        $version=$id?Input::id($input,'version'):null;
        return Database::transaction($this->data->repo->db,function()use($key,$e,$id,$version,$values):int{
            $before=$id?$this->data->find($key,$id,true):null;
            if($before&&(int)$before['version']!==$version)throw new HttpError(409,'Data telah berubah. Muat ulang sebelum menyimpan.');
            if($before&&isset($values['branch_id'])&&(int)$before['branch_id']!==$values['branch_id'])throw new HttpError(422,'Cabang pemilik tidak dapat dipindahkan melalui edit.');
            if($before&&$key==='branches'&&$before['code']!==$values['code']&&$this->data->branchHasNumbers($id))throw new HttpError(409,'Kode cabang dikunci setelah nomor resmi pertama diterbitkan. Nama, alamat dan kontak tetap dapat diubah.');
            $this->validateReferences($key,$e,$values,$before);
            $identityFields=match($key){'routes'=>['destination_branch_id','origin_location_id','destination_location_id'],'vehicles','units'=>['identity'],'items'=>['unit_id'],'uoms'=>['code'],default=>[]};
            if($before&&$identityFields&&$this->data->references($key,$id))foreach($identityFields as $field)if((string)$before[$field] !== (string)$values[$field])throw new HttpError(409,'Identitas/satuan sudah dipakai referensi. Pertahankan histori dan gunakan data baru bila diperlukan.');
            $rowId=$id;
            if($id){
                $sets=implode(',',array_map(fn($f)=>"`$f`=?",array_keys($values)));
                $this->data->repo->run("UPDATE `{$e['table']}` SET $sets,version=version+1 WHERE id=?",[...array_values($values),$id]);
            }else{
                $cols='`'.implode('`,`',array_keys($values)).'`';$marks=implode(',',array_fill(0,count($values),'?'));
                $this->data->repo->run("INSERT INTO `{$e['table']}` ($cols) VALUES ($marks)",array_values($values));$rowId=(int)$this->data->repo->db->lastInsertId();
                if($key==='branches')$this->data->repo->run('UPDATE branches SET created_at=NOW() WHERE id=?',[$rowId]);
            }
            $action=$before?((int)$before['active']!==$values['active']?($values['active']?'master_reactivated':'master_deactivated'):'master_updated'):'master_created';
            $safeBefore=$before;unset($safeBefore['display_name']);
            $this->audit->record((int)$this->data->access->user['id'],$action,$e['table'],$rowId,['before'=>$safeBefore,'after'=>$values]);
            return $rowId;
        });
    }
    private function validateReferences(string $key,array $e,array $values,?array $before):void
    {
        foreach($e['fields'] as $field=>$definition){
            if($definition['type']!=='ref'||$values[$field]===null)continue;
            $target=$definition['target'];$id=$values[$field];
            if($target==='users'){
                $this->data->access->demand('users.view');$this->data->access->global();
                $parent=$this->data->repo->one('SELECT id,active,all_branches FROM users WHERE id=? FOR UPDATE',[$id]);
                if(!$parent||(!$parent['all_branches']&&!$this->data->repo->one('SELECT 1 FROM user_branches WHERE user_id=? AND branch_id=?',[$id,$values['branch_id']])))throw new HttpError(422,'Akun personel tidak mempunyai akses cabang yang sesuai.');
            }elseif($target==='branches'){
                $this->data->access->demandBranch($id);$parent=$this->data->repo->one('SELECT id,active FROM branches WHERE id=? FOR UPDATE',[$id]);
            }else $parent=$this->data->find($target,$id,true);
            if(!$parent)throw new HttpError(422,'Referensi tidak tersedia.');
            if(!$parent['active']&&(!$before||(string)($before[$field]??'')!==(string)$id||(!$before['active']&&$values['active'])))throw new HttpError(422,'Referensi nonaktif tidak dapat digunakan untuk penetapan baru.');
            if($key==='routes'&&$field==='origin_location_id'&&(int)$parent['branch_id']!==$values['branch_id'])throw new HttpError(422,'Lokasi asal tidak sesuai cabang asal.');
            if($key==='routes'&&$field==='destination_location_id'&&(int)$parent['branch_id']!==$values['destination_branch_id'])throw new HttpError(422,'Lokasi tujuan tidak sesuai cabang tujuan.');
            if(in_array($key,['trucking-tariffs','equipment-tariffs'],true)&&in_array($field,['route_id','asset_id'],true)&&(int)$parent['branch_id']!==$values['branch_id'])throw new HttpError(422,'Referensi tarif tidak sesuai cabang.');
        }
    }
    public function status(string $key,int $id,int $version,int $active):int
    {
        if(!in_array($active,[0,1],true))throw new HttpError(422,'Status tidak valid.');
        $row=$this->data->find($key,$id);$input=[];
        foreach($this->data->entity($key)['fields'] as $field=>$definition)$input[$field]=(string)($row[$field]??'');
        return $this->save($key,$input+['id'=>(string)$id,'version'=>(string)$version,'active'=>(string)$active]);
    }
}

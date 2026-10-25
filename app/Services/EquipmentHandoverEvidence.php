<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;

final class EquipmentHandoverEvidence
{
    public function __construct(private EquipmentHandovers $ba,private Audit $audit,private string $directory) {}
    private function file(array $upload):array
    {
        if(($upload['error']??null)!==UPLOAD_ERR_OK||!is_string($upload['tmp_name']??null)||!is_uploaded_file($upload['tmp_name']))throw new HttpError(422,'Upload bukti tidak sah.');
        $size=filesize($upload['tmp_name']);if(!$size||$size>5*1024*1024)throw new HttpError(422,'Ukuran bukti harus 1 byte sampai 5 MB.');
        $mime=(new \finfo(FILEINFO_MIME_TYPE))->file($upload['tmp_name']);$allowed=['image/jpeg'=>['jpg','jpeg'],'image/png'=>['png'],'application/pdf'=>['pdf']];
        $name=basename(str_replace('\\','/',(string)($upload['name']??'')));$extension=strtolower(pathinfo($name,PATHINFO_EXTENSION));
        if(!isset($allowed[$mime])||!in_array($extension,$allowed[$mime],true)||mb_strlen($name)>255||preg_match('/[\x00-\x1f\x7f]/',$name))throw new HttpError(422,'Bukti harus JPEG, PNG atau PDF dengan ekstensi sesuai MIME aktual.');
        return ['tmp'=>$upload['tmp_name'],'name'=>$name,'mime'=>$mime,'size'=>$size,'hash'=>hash_file('sha256',$upload['tmp_name'])];
    }
    public function upload(int $id,int $unit,int $version,string $key,array $upload):array
    {
        $b=$this->ba->records->find($id);$c=$this->ba->records->contract((int)$b['contract_id']);$f=$this->file($upload);$created=null;
        try{return $this->ba->write->run('equipment.evidence.add','eq_ba_evidence',$key,['id'=>$id,'unit'=>$unit,'version'=>$version,'hash'=>$f['hash'],'name'=>$f['name'],'mime'=>$f['mime'],'size'=>$f['size']],(int)$c['branch_id'],(int)$c['id'],function()use($id,$unit,$version,$key,$f,&$created):array{
            $r=$this->ba->records->data->repo;$b=$this->ba->records->find($id,true);if($b['status']!=='DRAFT'||(int)$b['version']!==$version)throw new HttpError(409,'Bukti hanya dapat ditambahkan pada versi DRAFT terkini.');
            if($b['correction_of_id'])$this->ba->records->data->guard->actor('equipment.handover.correct',true);
            $target=$r->one('SELECT id FROM eq_handover_units WHERE handover_id=? AND contract_unit_id=? FOR UPDATE',[$id,$unit]);if(!$target)throw new HttpError(404,'Detail BA tidak ditemukan.');
            if(!is_dir($this->directory)&&!mkdir($this->directory,0700,true)&&!is_dir($this->directory))throw new \RuntimeException('Penyimpanan bukti tidak tersedia.');
            $storage=bin2hex(random_bytes(32));$path=$this->directory.DIRECTORY_SEPARATOR.$storage;if(!move_uploaded_file($f['tmp'],$path))throw new \RuntimeException('Bukti gagal disimpan.');$created=$path;
            $actor=(int)$this->ba->records->data->guard->access->user['id'];
            $r->run('INSERT INTO eq_evidence(handover_unit_id,actor_id,storage_key,filename,mime_type,size_bytes,sha256) VALUES (?,?,?,?,?,?,?)',[$target['id'],$actor,$storage,$f['name'],$f['mime'],$f['size'],$f['hash']]);$evidence=(int)$r->db->lastInsertId();
            $r->run('UPDATE eq_handover_documents SET version=version+1 WHERE id=?',[$id]);
            $detail=['evidence_id'=>$evidence,'unit_id'=>$unit,'sha256'=>$f['hash'],'mime'=>$f['mime'],'size'=>$f['size']];
            $r->run("INSERT INTO eq_events(contract_id,handover_id,event_type,actor_id,branch_id,request_key,detail,occurred_at) VALUES (?,?,'eq_ba_evidence_added',?,?,?,?,NOW())",[$b['contract_id'],$id,$actor,$this->ba->records->data->header((int)$b['contract_id'])['branch_id'],$key,json_encode($detail,JSON_THROW_ON_ERROR)]);
            $this->audit->record($actor,'eq_ba_evidence_added','eq_handover_documents',$id,$detail);return ['id'=>$id];
        },'handover');}catch(\Throwable $e){if($created&&is_file($created))unlink($created);throw $e;}
    }
    public function download(int $id):array
    {
        $this->ba->records->data->guard->actor('equipment.evidence.view');$r=$this->ba->records->data->repo->one('SELECT e.*,u.handover_id FROM eq_evidence e JOIN eq_handover_units u ON u.id=e.handover_unit_id WHERE e.id=?',[$id]);
        if(!$r)throw new HttpError(404,'Bukti tidak ditemukan.');$b=$this->ba->records->find((int)$r['handover_id']);$c=$this->ba->records->contract((int)$b['contract_id']);$this->ba->records->data->guard->branch((int)$c['branch_id'],'equipment.evidence.view');
        if(!preg_match('/^[a-f0-9]{64}$/D',$r['storage_key']))throw new HttpError(404,'Bukti tidak ditemukan.');$path=$this->directory.DIRECTORY_SEPARATOR.$r['storage_key'];
        if(!is_file($path)||!hash_equals($r['sha256'],hash_file('sha256',$path))||(int)filesize($path)!==(int)$r['size_bytes'])throw new HttpError(404,'Integritas bukti tidak sesuai.');
        $extension=match($r['mime_type']){'image/jpeg'=>'jpg','image/png'=>'png','application/pdf'=>'pdf',default=>throw new HttpError(404,'Bukti tidak tersedia.')};
        return ['path'=>$path,'size'=>$r['size_bytes'],'extension'=>$extension];
    }
}

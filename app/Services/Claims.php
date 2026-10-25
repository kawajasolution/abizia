<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Repositories\TruckingRepository;
final class Claims
{
    public function __construct(public readonly TruckingRepository $records,private OperationalWrite $write,private Audit $audit,private string $directory) {}
    private function file(array $file): ?array
    {
        if(!$file||($file['error']??UPLOAD_ERR_NO_FILE)===UPLOAD_ERR_NO_FILE)return null;
        if(($file['error']??-1)!==UPLOAD_ERR_OK||!is_string($file['tmp_name']??null)||!is_uploaded_file($file['tmp_name']))throw new HttpError(422,'Unggahan bukti tidak valid.');
        $size=filesize($file['tmp_name']);if($size<1||$size>5*1024*1024)throw new HttpError(422,'Bukti maksimal 5 MB.');
        $mime=(new \finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);if(!in_array($mime,['image/jpeg','image/png','application/pdf'],true))throw new HttpError(422,'Bukti harus JPEG, PNG atau PDF.');
        $name=Input::text(['name'=>basename(str_replace('\\','/',(string)($file['name']??'bukti')))],'name',190);
        if(!in_array(strtolower(pathinfo($name,PATHINFO_EXTENSION)),match($mime){'image/png'=>['png'],'image/jpeg'=>['jpg','jpeg'],default=>['pdf']},true))throw new HttpError(422,'Ekstensi bukti tidak sesuai isi berkas.');
        return ['tmp'=>$file['tmp_name'],'name'=>$name,'mime'=>$mime,'size'=>$size,'hash'=>hash_file('sha256',$file['tmp_name'])];
    }
    private function store(int $claim,array $file): string
    {
        if(!is_dir($this->directory)&&!mkdir($this->directory,0700,true)&&!is_dir($this->directory))throw new \RuntimeException('Penyimpanan bukti tidak tersedia.');
        $storage=bin2hex(random_bytes(32));$path=$this->directory.DIRECTORY_SEPARATOR.$storage;
        if(!move_uploaded_file($file['tmp'],$path))throw new \RuntimeException('Penyimpanan bukti gagal.');
        try{$this->records->data->repo->run('INSERT INTO exp_evidence(claim_id,actor_id,storage_key,file_name,mime_type,file_size,sha256) VALUES (?,?,?,?,?,?,?)',[$claim,$this->records->data->guard->access->user['id'],$storage,$file['name'],$file['mime'],$file['size'],$file['hash']]);}
        catch(\Throwable $e){unlink($path);throw $e;}return $path;
    }
    public function report(array $input,array $upload=[]): array
    {
        $id=Input::id($input,'dn_id');$branch=Input::id($input,'branch_id');$this->records->data->find('dn',$id);
        $type=Input::text($input,'problem_type',60);$description=Input::text($input,'description',2000);$reporter=Input::text($input,'reporter_name',150);$key=Input::text($input,'request_key',64);$file=$this->file($upload);$created=null;
        $payload=compact('id','branch','type','description','reporter')+['file_hash'=>$file['hash']??null,'file_name'=>$file['name']??null,'file_mime'=>$file['mime']??null,'file_size'=>$file['size']??null];
        try{return $this->write->run('expedition.claim.report','claim_report',$key,$payload,$branch,function()use($id,$branch,$type,$description,$reporter,$file,&$created):array{
            $d=$this->records->data->find('dn',$id,true);$related=in_array($branch,array_map('intval',[$d['origin_branch_id'],$d['destination_branch_id'],$d['current_branch_id']]),true)||$this->records->data->repo->one('SELECT 1 FROM exp_manifest_items i JOIN exp_trip_legs l ON l.manifest_id=i.manifest_id WHERE i.dn_id=? AND (l.origin_branch_id=? OR l.destination_branch_id=?) LIMIT 1',[$id,$branch,$branch]);
            if(!$related)throw new HttpError(422,'Cabang pelapor tidak terkait perjalanan DN.');
            $actor=(int)$this->records->data->guard->access->user['id'];$this->records->data->repo->run('INSERT INTO exp_claims(dn_id,branch_id,problem_type,description,reporter_name,created_by) VALUES (?,?,?,?,?,?)',[$id,$branch,$type,$description,$reporter,$actor]);$claim=(int)$this->records->data->repo->db->lastInsertId();
            $this->records->data->repo->run("INSERT INTO exp_claim_events(claim_id,actor_id,previous_status,next_status,note) VALUES (?,?,NULL,'REPORTED',?)",[$claim,$actor,$description]);if($file)$created=$this->store($claim,$file);
            $this->audit->record($actor,'claim_reported','exp_claims',$claim,['dn_id'=>$id,'problem_type'=>$type,'status'=>'REPORTED','evidence_sha256'=>$file['hash']??null]);return ['id'=>$claim];
        });}catch(\Throwable $e){if($created&&is_file($created))unlink($created);throw $e;}
    }
    public function transition(int $id,int $version,string $next,string $note,string $key): array
    {
        $claim=$this->records->claim($id);$note=Input::text(['note'=>$note],'note',2000);
        return $this->write->run('expedition.claim.review','claim_transition',$key,compact('id','version','next','note'),(int)$claim['branch_id'],function()use($id,$version,$next,$note):array{
            $c=$this->records->claim($id,true);$allowed=['REPORTED'=>['REVIEWING'],'REVIEWING'=>['APPROVED','REJECTED'],'APPROVED'=>['CLOSED'],'REJECTED'=>['CLOSED'],'CLOSED'=>[]];
            if((int)$c['version']!==$version||!in_array($next,$allowed[$c['status']],true))throw new HttpError(409,'Transisi/versi klaim tidak valid.');
            $actor=(int)$this->records->data->guard->access->user['id'];$this->records->data->repo->run('UPDATE exp_claims SET status=?,version=version+1 WHERE id=?',[$next,$id]);$this->records->data->repo->run('INSERT INTO exp_claim_events(claim_id,actor_id,previous_status,next_status,note) VALUES (?,?,?,?,?)',[$id,$actor,$c['status'],$next,$note]);
            $this->audit->record($actor,'claim_status_changed','exp_claims',$id,['from'=>$c['status'],'to'=>$next,'note'=>$note]);return ['id'=>$id];
        });
    }
    public function upload(int $id,string $key,array $upload): array
    {
        $c=$this->records->claim($id);$file=$this->file($upload);if(!$file)throw new HttpError(422,'Pilih bukti.');$created=null;
        try{return $this->write->run('expedition.claim.report','claim_evidence',$key,['id'=>$id,'sha256'=>$file['hash'],'name'=>$file['name'],'mime'=>$file['mime'],'size'=>$file['size']],(int)$c['branch_id'],function()use($id,$file,&$created):array{
            $this->records->claim($id,true);$created=$this->store($id,$file);$this->audit->record((int)$this->records->data->guard->access->user['id'],'claim_evidence_added','exp_claims',$id,['sha256'=>$file['hash']]);return ['id'=>$id];
        });}catch(\Throwable $e){if($created&&is_file($created))unlink($created);throw $e;}
    }
    public function download(int $id): array
    {
        $r=$this->records->data->repo->one('SELECT * FROM exp_evidence WHERE id=?',[$id]);if(!$r)throw new HttpError(404,'Bukti tidak tersedia.');$this->records->claim((int)$r['claim_id']);
        if(!preg_match('/^[a-f0-9]{64}$/D',$r['storage_key']))throw new HttpError(404,'Bukti tidak tersedia.');$path=$this->directory.DIRECTORY_SEPARATOR.$r['storage_key'];
        if(!is_file($path)||!hash_equals($r['sha256'],hash_file('sha256',$path)))throw new HttpError(404,'Bukti tidak tersedia atau integritas tidak sesuai.');
        return ['path'=>$path,'size'=>$r['file_size'],'extension'=>match($r['mime_type']){'image/png'=>'png','image/jpeg'=>'jpg',default=>'pdf'}];
    }
}

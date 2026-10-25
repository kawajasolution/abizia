<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\EquipmentHandovers;
use Hls\Services\EquipmentHandoverEvidence;

final class EquipmentHandoverController
{
    public function __construct(private EquipmentHandovers $ba,private EquipmentHandoverEvidence $evidence,private View $view) {}
    public function handle():void
    {
        $mode=Input::text($_GET,'mode',10,false)?:'list';if(!in_array($mode,['list','create','edit','detail','print'],true))throw new HttpError(404,'Halaman tidak tersedia.');
        $id=Input::id($_GET,'id',true);$contract=Input::id($_GET,'contract_id',true);$error=null;
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $action=Input::text($_POST,'action',20);$id=Input::id($_POST,'id',true);$version=$id?Input::id($_POST,'version'):0;$key=Input::text($_POST,'request_key',64);
            try{$result=match($action){
                'save'=>$this->ba->save($_POST),
                'confirm'=>$this->ba->confirm($id,$version,$key,Input::text($_POST,'closure',6,false)?:'NORMAL',Input::text($_POST,'reason',2000,false)),
                'cancel'=>$this->ba->cancel($id,$version,$key,Input::text($_POST,'reason',2000)),
                'correct'=>$this->ba->correct($id,$key,Input::text($_POST,'reason',2000)),
                'upload'=>$this->evidence->upload($id,Input::id($_POST,'unit_id'),$version,$key,$_FILES['evidence']??[]),
                default=>throw new HttpError(405,'Aksi BA tidak tersedia. Koreksi fakta operasional belum mempunyai prosedur yang disetujui.'),
            };$_SESSION['flash']='Berita Acara tersimpan.';$this->view->redirect('/equipment/handovers?mode=detail&id='.$result['id']);}
            catch(HttpError $e){if(!in_array($e->status,[409,422],true))throw $e;http_response_code($e->status);$error=$e->getMessage();$mode=$action==='save'?($id?'edit':'create'):'detail';$contract=Input::id($_POST,'contract_id',true);}
        }
        $records=$this->ba->records;$row=$id?$records->detail($id):null;
        if(in_array($mode,['detail','edit','print'],true)&&!$row)throw new HttpError(404,'BA tidak ditemukan.');
        if($row)$contract=(int)$row['contract_id'];$c=$contract?$records->contract($contract):null;
        if(in_array($mode,['create','edit'],true)){$records->data->guard->actor('equipment.handover.'.($id?'update':'create'));if($row&&($row['status']!=='DRAFT'||$row['correction_of_id']))throw new HttpError(409,'BA ini tidak dapat diedit langsung.');}
        $units=$c?$records->data->units($contract):[];$listing=$mode==='list'?$records->listing($_GET):null;$title='Berita Acara Equipment';
        $contracts=[];
        if($mode==='create'&&!$c){$actor=$records->data->guard->actor('equipment.handover.create');$contracts=$records->data->repo->all("SELECT c.id,c.official_number FROM eq_contracts c JOIN branches b ON b.id=c.branch_id WHERE b.active=1 AND c.status IN('CONFIRMED','ACTIVE') AND (?=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=c.branch_id)) ORDER BY c.id DESC LIMIT 100",[$actor['all_branches'],$actor['id']]);}
        $this->view->render('equipment-handovers',compact('mode','row','c','units','listing','contracts','title','error'));
    }
    public function download():void
    {
        $f=$this->evidence->download(Input::id($_GET,'id'));
        header('Content-Type: application/octet-stream');header('Content-Disposition: attachment; filename="bukti-ba.'.$f['extension'].'"');header('Content-Length: '.$f['size']);readfile($f['path']);
    }
}

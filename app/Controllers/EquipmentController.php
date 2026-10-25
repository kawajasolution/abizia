<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\EquipmentContracts;
final class EquipmentController
{
    public function __construct(private EquipmentContracts $service,private View $view) {}
    public function handle():void
    {
        $mode=Input::text($_GET,'mode',10,false)?:'list';if(!in_array($mode,['list','create','edit','detail'],true))throw new HttpError(404,'Halaman tidak tersedia.');$id=Input::id($_GET,'id',true);$error=null;$values=[];
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $action=Input::text($_POST,'action',30);$id=Input::id($_POST,'id',true);$version=$id?Input::id($_POST,'version'):0;$key=Input::text($_POST,'request_key',64);
            try{$result=match($action){
                'save'=>$this->service->save($_POST),
                'unit'=>$this->service->saveUnit($id,$version,$key,$_POST),
                'operator'=>$this->service->operator($id,$version,$key,$_POST),
                'confirm'=>$this->service->confirm($id,$version,$key),
                'confirm_unit'=>$this->service->confirm($id,$version,$key,Input::id($_POST,'unit_id')),
                'confirm_operator'=>$this->service->confirmOperator($id,$version,$key,Input::id($_POST,'assignment_id')),
                'cancel'=>$this->service->cancel($id,$version,$key,Input::text($_POST,'reason',2000),Input::id($_POST,'unit_id',true)?:null,Input::id($_POST,'assignment_id',true)?:null),
                'extension'=>$this->service->extension($id,$version,$key,Input::id($_POST,'unit_id'),Input::text($_POST,'ends_on',10,false),Input::text($_POST,'reason',2000),Input::id($_POST,'period_id',true)?:null),
                'request_approval'=>$this->service->requestApproval($id,$version,$key,Input::id($_POST,'unit_id'),Input::id($_POST,'period_id'),Input::id($_POST,'assignment_id',true)?:null,Input::text($_POST,'reason',2000)),
                default=>throw new HttpError(405,'Aksi Equipment di luar M3.'),
            };$_SESSION['flash']='Kontrak tersimpan.';$this->view->redirect('/equipment/contracts?mode=detail&id='.$result['id']);}
            catch(HttpError $e){if(!in_array($e->status,[409,422],true))throw $e;http_response_code($e->status);$error=$e->getMessage();$mode=$action==='save'?($id?'edit':'create'):'detail';$values=array_intersect_key($_POST,array_flip(['branch_id','customer_id','project_address','request_key']));}
        }
        $row=$id?$this->service->data->detail($id):null;if(in_array($mode,['edit','detail'],true)&&!$row)throw new HttpError(404,'Kontrak tidak ditemukan.');
        if(in_array($mode,['create','edit'],true)){$this->service->data->guard->actor($mode==='create'?'equipment.contract.create':'equipment.contract.update');if($row&&$row['status']!=='DRAFT')throw new HttpError(409,'Header bukan DRAFT.');}
        $choices=$this->service->data->choices();$listing=$mode==='list'?$this->service->data->listing($_GET):null;$values+=($row??[]);$title='Kontrak Sewa';$approvals=null;
        $this->view->render('equipment-contracts',compact('mode','row','values','choices','listing','error','title','approvals'));
    }
    public function approvals():void
    {
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $id=Input::id($_POST,'authorization_id');$version=Input::id($_POST,'version');$side=Input::text($_POST,'side',8);$key=Input::text($_POST,'request_key',64);
            $action=Input::text($_POST,'action',10,false)?:'approve';if(!in_array($action,['approve','revoke'],true))throw new HttpError(405,'Aksi persetujuan tidak sah.');
            if($action==='revoke')$this->service->revoke($id,$version,$side,Input::text($_POST,'reason',2000),$key);else $this->service->approve($id,$version,$side,$key);
            $this->view->redirect('/equipment/authorizations');
        }
        $approvals=$this->service->data->approvals();$title='Persetujuan Sumber Kontrak';$mode='approvals';$this->view->render('equipment-contracts',compact('approvals','mode','title'));
    }
}

<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\EquipmentTimesheets;

final class EquipmentTimesheetController
{
    public function __construct(private EquipmentTimesheets $service,private View $view) {}
    public function handle():void{$this->page(false);}
    public function verification():void{$this->page(true);}
    private function page(bool $review):void
    {
        $records=$this->service->records;$url=$review?'/equipment/verification':($records->own?'/equipment/my-timesheets':'/equipment/timesheets');
        $mode=Input::text($_GET,'mode',10,false)?:'list';if(!in_array($mode,['list','create','edit','detail','print'],true)||($review&&!in_array($mode,['list','detail','print'],true)))throw new HttpError(404,'Halaman tidak tersedia.');
        $id=Input::id($_GET,'id',true);$error=null;
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $action=Input::text($_POST,'action',15);$id=Input::id($_POST,'id',true);$key=Input::text($_POST,'request_key',64);$version=$id?Input::id($_POST,'version'):0;
            try{
                if($review){if($action!=='decide')throw new HttpError(405,'Aksi tidak tersedia.');$result=$this->service->decide($id,Input::id($_POST,'revision_id'),$version,Input::id($_POST,'revision_version'),Input::text($_POST,'content_hash',64),Input::text($_POST,'decision',10),Input::text($_POST,'note',2000,false),$key);}
                else{
                    $input=$_POST;
                    if($action==='save'&&!$id){$choice=Input::text($_POST,'assignment_choice',32);if(!preg_match('/^([1-9][0-9]*):([0-9]*)$/D',$choice,$m))throw new HttpError(422,'Pilih unit/penugasan yang sah.');$input['unit_id']=$m[1];$input['assignment_id']=$m[2]==='0'?'':$m[2];}
                    $result=match($action){'save'=>$this->service->save($input),'submit'=>$this->service->submit($id,Input::id($_POST,'revision_id'),$version,Input::id($_POST,'revision_version'),$key),'revise'=>$this->service->revise($id,$version,$key,Input::text($_POST,'reason',2000)),default=>throw new HttpError(405,'Aksi tidak tersedia. Koreksi/reset HM belum mempunyai prosedur khusus yang disetujui.')};
                }
                $_SESSION['flash']='Timesheet tersimpan.';$this->view->redirect($url.'?mode=detail&id='.$result['id']);
            }catch(HttpError $e){if(!in_array($e->status,[409,422],true))throw $e;http_response_code($e->status);$error=$e->getMessage();$mode=$action==='save'?($id?'edit':'create'):'detail';}
        }
        $row=$id?$records->detail($id,$review):null;if(in_array($mode,['detail','edit'],true)&&!$row)throw new HttpError(404,'Timesheet tidak ditemukan.');
        $revision=null;if($row&&$row['pending_revision_id'])$revision=$records->revision((int)$row['pending_revision_id'],$id);
        if(in_array($mode,['create','edit'],true)){$records->data->guard->actor($records->permission($id?'update':'create'));if($id&&(!$revision||$revision['status']!=='DRAFT'))throw new HttpError(409,'Revisi tidak dapat diedit.');}
        $choices=$mode==='create'?$records->choices():[];$listing=$mode==='list'?$records->listing($_GET,$review):null;$title=$review?'Verifikasi Timesheet':($records->own?'Timesheet Saya':'Timesheet Equipment');
        $this->view->render('equipment-timesheets',compact('mode','row','revision','choices','listing','review','url','title','error','records'));
    }
}

<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\Input;
use Hls\Http\HttpError;
use Hls\Http\View;
use Hls\Services\MasterData;
final class MasterDataController
{
    public function __construct(private MasterData $service,private View $view){}
    public function handle():void
    {
        $data=$this->service->data;$catalog=$data->catalog;$path=$this->view->path();
        $group=$catalog['groups'][$path]??throw new HttpError(404,'Halaman master tidak tersedia.');
        $data->access->demand($group['permission']);
        $tabs=array_values(array_filter($group['tabs'],fn($key)=>$data->access->can($data->permission($key,'view'))));
        if(!$tabs)throw new HttpError(403,'Anda tidak memiliki izin tab master ini.');
        $key=Input::text($_SERVER['REQUEST_METHOD']==='POST'?$_POST:$_GET,'tab',40,false)?:$tabs[0];
        if(!in_array($key,$group['tabs'],true))throw new HttpError(404,'Tab tidak tersedia.');
        $data->demand($key,'view');$entity=$data->entity($key);$error=null;$old=null;
        $mode=Input::text($_GET,'mode',10,false)?: (isset($_GET['edit'])?'edit':'list');
        if(!in_array($mode,['list','create','edit','detail'],true))throw new HttpError(404,'Halaman master tidak tersedia.');
        $id=isset($_GET['edit'])?Input::id($_GET,'edit'):Input::id($_GET,'id',true);
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $action=Input::text($_POST,'action',10,false)?:'save';$id=Input::id($_POST,'id',true);
            try{
                if($action==='status')$id=$this->service->status($key,Input::id($_POST,'id'),Input::id($_POST,'version'),Input::flag($_POST,'active'));
                elseif($action==='save')$id=$this->service->save($key,$_POST);
                else throw new HttpError(405,'Aksi master tidak tersedia.');
                $_SESSION['flash']='Data master disimpan.';$this->view->redirect($path.'?'.http_build_query(['tab'=>$key,'mode'=>'detail','id'=>$id]));
            }catch(HttpError $exception){if(!in_array($exception->status,[422,409],true))throw $exception;http_response_code($exception->status);$error=$exception->getMessage();}
            catch(\PDOException $exception){if($exception->getCode()!=='23000')throw $exception;http_response_code(409);$error='Kode, identitas atau relasi sudah digunakan/tidak sesuai. Data tidak disimpan.';}
            $mode=$action==='status'?'detail':($id?'edit':'create');$old=$_POST;
        }
        $row=null;$history=[];$references=[];$choices=[];$listing=null;
        if($id)$row=$data->find($key,$id);
        if(in_array($mode,['edit','detail'],true)&&!$row)throw new HttpError(404,'Data tidak ditemukan.');
        $writable=$entity['scope']!=='global'||$data->access->user['all_branches'];
        $canCreate=$writable&&$data->access->can($data->permission($key,'create'))&&($key!=='branches'||$data->access->user['all_branches']);
        $canUpdate=$writable&&$data->access->can($data->permission($key,'update'));
        if($mode==='create'&&!$canCreate)throw new HttpError(403,'Anda tidak memiliki izin tambah data.');
        if($mode==='edit'&&!$canUpdate)throw new HttpError(403,'Anda tidak memiliki izin edit data.');
        $values=$row??[];
        if($old!==null)foreach($entity['fields']+['active'=>[],'version'=>[]] as $field=>$definition)$values[$field]=is_string($old[$field]??null)?$old[$field]:'';
        if(in_array($mode,['create','edit'],true))foreach($entity['fields'] as $field=>$definition)if($definition['type']==='ref')$choices[$field]=$data->choices($definition['target'],isset($values[$field])?(int)$values[$field]:null);
        if($mode==='list')$listing=$data->listing($key,$_GET);
        $canAudit=$data->access->can('audit.view')&&$data->access->user['all_branches'];
        if($mode==='detail'&&$canAudit){$history=$data->history($key,$id);$references=$data->references($key,$id);}
        $display=[];
        if($mode==='detail')foreach($entity['fields'] as $field=>$definition){
            $value=$row[$field]??'';
            if($field==='name')$value=$row['display_name'];
            if($definition['type']==='select')$value=$definition['options'][$value]??$value;
            if($definition['type']==='ref'&&$value){
                if($definition['target']==='users')$value=$canAudit?'Akun #'.$value:'Ditautkan ke akun';
                else{foreach($data->choices($definition['target'],(int)$value) as $choice)if((int)$choice['id']===(int)$value){$value=$choice['code']??'';$value=($value!==''?$value.' — ':'').($choice['display_name']??$choice['name']);break;}}
            }
            $display[]=['label'=>$definition['label'],'value'=>$value];
        }
        $branches=$data->branches();$title=$group['label'];
        $this->view->render('master-data',compact('title','group','path','tabs','key','entity','mode','id','row','values','choices','canCreate','canUpdate','canAudit','history','references','listing','error','display','branches')+['entities'=>$catalog['entities']]);
    }
}

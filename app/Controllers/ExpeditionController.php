<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\Expedition;
final class ExpeditionController
{
    public function __construct(private Expedition $service,private View $view) {}
    public function handle(): void
    {
        $path=$this->view->path();$tracking=$path==='/trucking/tracking';$kind=$path==='/trucking/manifests'?'manifest':'dn';
        $data=$this->service->data;$permission=$kind==='dn'?'expedition.ship':'expedition.manifest';$data->guard->actor($data->permission($kind));
        $operations=new \Hls\Services\TruckingOperations($data,new \Hls\Services\Audit($data->repo));
        $modelB=new \Hls\Services\ManifestModelB($data,new \Hls\Services\ManifestAllocation($data));
        $mode=Input::text($_GET,'mode',10,false)?:'list';if(!in_array($mode,['list','create','edit','detail'],true)||($tracking&&!in_array($mode,['list','detail'],true)))throw new HttpError(404,'Halaman tidak tersedia.');
        $id=Input::id($_GET,'id',true);$error=null;$values=[];
        if($_SERVER['REQUEST_METHOD']==='POST'){
            if($tracking)throw new HttpError(405,'Tracking hanya baca.');
            $action=Input::text($_POST,'action',30);$id=Input::id($_POST,'id',true);
            if($action==='move'&&isset($_POST['target_choice'])){
                $choice=Input::text($_POST,'target_choice',30);if(!preg_match('/^([1-9][0-9]*):([1-9][0-9]*)$/D',$choice,$parts))throw new HttpError(422,'Pilihan Manifest tujuan tidak valid.');
                $_POST['target_manifest_id']=$parts[1];$_POST['target_version']=$parts[2];
            }
            try{
                if($action==='save')$id=$this->service->save($kind,$_POST);
                elseif($action==='attach'&&$kind==='manifest'){$ids=$_POST['dn_ids']??[];if(!is_array($ids))throw new HttpError(422,'Pilihan DN tidak valid.');$this->service->attach(Input::id($_POST,'id'),$ids,Input::id($_POST,'version'),Input::text($_POST,'request_key',64));}
                elseif($action==='confirm_dn'&&$kind==='dn')$operations->confirmDn(Input::id($_POST,'id'),Input::id($_POST,'version'),Input::text($_POST,'request_key',64));
                elseif($action==='append_leg'&&$kind==='manifest')$operations->appendLeg(Input::id($_POST,'id'),Input::id($_POST,'route_id'),Input::id($_POST,'version'),Input::text($_POST,'request_key',64));
                elseif($action==='assign_vehicle'&&$kind==='manifest')$operations->assignVehicle(Input::id($_POST,'id'),Input::id($_POST,'vehicle_id'),Input::id($_POST,'driver_id',true)?:null,Input::id($_POST,'version'),Input::text($_POST,'request_key',64));
                elseif($action==='move'&&$kind==='manifest')$operations->move(Input::id($_POST,'dn_id'),Input::id($_POST,'target_manifest_id'),Input::id($_POST,'version'),Input::id($_POST,'target_version'),Input::text($_POST,'note',1000),Input::text($_POST,'request_key',64));
                elseif($action==='allocate_b'&&$kind==='manifest'){$data->guard->actor('expedition.manifest');$modelB->allocate(Input::id($_POST,'dn_id'),Input::id($_POST,'target_manifest_id'),(float)($_POST['quantity']??0),Input::text($_POST,'unit',30),Input::text($_POST,'request_key',64));}
                elseif($action==='receive_b'&&$kind==='manifest'){$data->guard->actor('expedition.transit');$modelB->receive(Input::id($_POST,'allocation_id'),(float)($_POST['quantity_received']??0),(float)($_POST['quantity_short']??0),(float)($_POST['quantity_damaged']??0),Input::text($_POST,'note',1000,false),Input::text($_POST,'request_key',64));}
                elseif($kind==='manifest'&&in_array($action,['confirm','depart','arrive','record_arrival','unload','complete','cancel'],true))$operations->manifest(Input::id($_POST,'id'),$action,Input::id($_POST,'version'),Input::text($_POST,'request_key',64),$_POST);
                else throw new HttpError(405,'Aksi tidak tersedia.');
                $_SESSION['flash']='Perubahan tersimpan.';$this->view->redirect($path.'?mode=detail&id='.$id);
            }catch(HttpError $e){if(!in_array($e->status,[422,409],true))throw $e;http_response_code($e->status);$error=$e->getMessage();}
            catch(\PDOException $e){if(!in_array((string)$e->getCode(),['23000','40001'],true))throw $e;http_response_code(409);$error='Permintaan bentrok atau referensi tidak sesuai. Muat ulang dokumen.';}
            $mode=$action==='save'?($id?'edit':'create'):'detail';
            foreach(['document_date','route_id','note','customer_id','sender_id','receiver_id','description','quantity','unit','weight','volume','vehicle_id','driver_id','request_key','version'] as $f)$values[$f]=is_string($_POST[$f]??null)?$_POST[$f]:'';
        }
        $row=$id?$data->find($kind,$id):null;if(in_array($mode,['detail','edit'],true)&&!$row)throw new HttpError(404,'Dokumen tidak ditemukan.');
        $canWrite=$data->guard->access->can($permission);$canOrigin=$canWrite&&(!$row||$data->canOperateAt($permission,(int)$row['origin_branch_id']));
        if(in_array($mode,['create','edit'],true)){
            if(!$canOrigin||($kind==='manifest'&&$mode==='edit'))throw new HttpError(403,'Tidak memiliki kewenangan dokumen ini.');
            if($row){$data->guard->branch((int)$row['origin_branch_id'],$permission);if($row['status']!=='created'||$data->active($id))throw new HttpError(409,'DN sudah masuk manifest/proses.');}
        }
        $values=$values+($row??[])+['document_date'=>date('Y-m-d'),'request_key'=>bin2hex(random_bytes(32))];
        $routes=[];$selected=null;$choices=[];
        if(in_array($mode,['create','edit'],true)){
            $routes=$data->routes($permission);$routeId=(int)($values['route_id']??Input::id($_GET,'route_id',true));
            foreach($routes as $r)if((int)$r['id']===$routeId)$selected=$r;
            if($routeId&&!$selected)throw new HttpError(404,'Rute tidak tersedia dalam kewenangan asal.');
            if($selected){$values['route_id']=(string)$selected['id'];$choices=$data->choices($selected,$kind);}
        }
        $listing=$mode==='list'?$data->listing($kind,$_GET):null;$snapshot=$row?json_decode($row['snapshot'],true,512,JSON_THROW_ON_ERROR):[];
        $events=$row?$data->events($kind,$id):[];$members=$row&&$kind==='manifest'?$data->members($id):[];
        $candidates=$row&&$kind==='manifest'&&$canOrigin&&$row['status']==='draft'?$data->candidates($row):[];
        $modelBEnabled=$modelB->enabled();$modelBCandidates=[];$modelBAllocations=[];
        if($kind==='manifest'&&$row&&$modelBEnabled){foreach($candidates as $candidate){$candidate['balance']=$modelB->transitBalance((int)$candidate['id']);$modelBCandidates[]=$candidate;}$modelBAllocations=$data->repo->all('SELECT a.*,d.number,d.description FROM exp_manifest_allocations a JOIN exp_dns d ON d.id=a.dn_id WHERE a.target_manifest_id=? ORDER BY a.id',[$id]);}
        $membership=$row&&$kind==='dn'?$data->active($id):null;
        $branches=(new \Hls\Repositories\MasterDataRepository($data->repo,$data->guard->access,require dirname(__DIR__).'/master-data.php'))->branches();
        $title=$tracking?'Tracking':($kind==='dn'?'Delivery Note (DN)':'Manifest');
        $opModel=$row?$operations->records->detail($kind,$row):[];
        $workflow='all';$this->view->render('expedition',compact('path','tracking','kind','mode','id','row','values','routes','selected','choices','listing','snapshot','events','members','candidates','membership','branches','canWrite','canOrigin','error','title','operations','workflow','opModel','modelBEnabled','modelBCandidates','modelBAllocations'));
    }
}

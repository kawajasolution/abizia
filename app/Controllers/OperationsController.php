<?php
declare(strict_types=1);
namespace Hls\Controllers;
use Hls\Http\HttpError;
use Hls\Http\Input;
use Hls\Http\View;
use Hls\Services\Claims;
use Hls\Services\TruckingOperations;
final class OperationsController
{
    public function __construct(private TruckingOperations $operations,private Claims $claims,private View $view) {}
    public function handle(): void
    {
        $path=$this->view->path();if($path==='/trucking/claims'){$this->claimPage();return;}
        $workflow=$path==='/trucking/transit'?'transit':'receipts';$permission=$workflow==='transit'?'expedition.transit':'expedition.receive';
        $operations=$this->operations;$data=$operations->data;$data->guard->actor($permission);$error=null;$id=Input::id($_GET,'id',true);$mode=Input::text($_GET,'mode',10,false)?:'list';
        $modelB=new \Hls\Services\ManifestModelB($data,new \Hls\Services\ManifestAllocation($data));
        if(!in_array($mode,['list','detail'],true))throw new HttpError(404,'Halaman tidak tersedia.');
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $id=Input::id($_POST,'id');$mode='detail';$action=Input::text($_POST,'action',20);
            try{if($workflow==='transit'&&$action==='receive_b'){$data->guard->actor('expedition.transit');$modelB->receive(Input::id($_POST,'allocation_id'),(float)($_POST['quantity_received']??0),(float)($_POST['quantity_short']??0),(float)($_POST['quantity_damaged']??0),Input::text($_POST,'note',1000,false),Input::text($_POST,'request_key',64));}
            elseif($workflow==='transit'&&$action==='allocate_b'){$data->guard->actor('expedition.transit');$modelB->allocate(Input::id($_POST,'dn_id'),Input::id($_POST,'target_manifest_id'),(float)($_POST['quantity']??0),Input::text($_POST,'unit',30),Input::text($_POST,'request_key',64));}
            elseif($workflow==='receipts'&&in_array($action,['receive','finish'],true))$operations->receive($id,Input::id($_POST,'version'),Input::text($_POST,'request_key',64),$_POST,$action==='finish');
            else throw new HttpError(405,'Aksi penerimaan tidak tersedia.');$_SESSION['flash']='Transaksi tersimpan.';$this->view->redirect($path.'?mode=detail&id='.$id);}catch(HttpError $e){if(!in_array($e->status,[422,409,503],true))throw $e;http_response_code($e->status);$error=$e->getMessage();}
        }
        $kind=$workflow==='transit'?'manifest':'dn';$title=$workflow==='transit'?'Transit':'Penerimaan';$tracking=false;$canWrite=false;$canOrigin=false;$values=[];$routes=[];$choices=[];$selected=null;$candidates=[];
        $row=$id?$data->find($kind,$id):null;if($mode==='detail'&&!$row)throw new HttpError(404,'Dokumen tidak ditemukan.');$canOrigin=(bool)$row&&$data->guard->access->can($permission);
        $snapshot=$row?json_decode($row['snapshot'],true,512,JSON_THROW_ON_ERROR):[];$events=$row?$data->events($kind,$id):[];$members=$row&&$kind==='manifest'?$data->members($id):[];$membership=$row&&$kind==='dn'?$data->active($id):null;
        $listing=$mode==='list'?$data->listing($kind,$_GET,$workflow):null;$branches=(new \Hls\Repositories\MasterDataRepository($data->repo,$data->guard->access,require dirname(__DIR__).'/master-data.php'))->branches();
        $opModel=$row?$operations->records->detail($kind,$row):[];$modelBEnabled=$modelB->enabled();$modelBAllocations=[];$modelBTargets=[];
        if($workflow==='transit'&&$row&&$modelBEnabled){$modelBAllocations=$data->repo->all('SELECT a.*,d.number,d.description FROM exp_manifest_allocations a JOIN exp_dns d ON d.id=a.dn_id WHERE a.source_manifest_id=? OR a.target_manifest_id=? ORDER BY a.id',[$id,$id]);$stop=$operations->records->stop($row);$modelBTargets=$modelB->targets((int)$stop['branch'],(int)$stop['location'],(int)$id);}
        $this->view->render('expedition',compact('path','workflow','kind','title','tracking','canWrite','canOrigin','values','routes','choices','selected','candidates','row','id','mode','snapshot','events','members','membership','listing','branches','error','operations','opModel','modelBEnabled','modelBAllocations','modelBTargets'));
    }
    private function claimPage(): void
    {
        $records=$this->claims->records;$data=$records->data;$data->guard->actor('expedition.claim.view');$title='Klaim';$mode=Input::text($_GET,'mode',10,false)?:'list';$id=Input::id($_GET,'id',true);$error=null;$values=[];
        if(!in_array($mode,['list','create','detail'],true))throw new HttpError(404,'Halaman tidak tersedia.');
        if($_SERVER['REQUEST_METHOD']==='POST'){
            $action=Input::text($_POST,'action',20);$id=Input::id($_POST,'id',true);
            try{
                if($action==='report')$id=$this->claims->report($_POST,$_FILES['evidence']??[])['id'];
                elseif($action==='transition')$this->claims->transition(Input::id($_POST,'id'),Input::id($_POST,'version'),Input::text($_POST,'next_status',20),Input::text($_POST,'note',2000),Input::text($_POST,'request_key',64));
                elseif($action==='evidence')$this->claims->upload(Input::id($_POST,'id'),Input::text($_POST,'request_key',64),$_FILES['evidence']??[]);
                else throw new HttpError(405,'Aksi klaim tidak tersedia.');
                $_SESSION['flash']='Klaim operasional tersimpan tanpa perubahan keuangan.';$this->view->redirect('/trucking/claims?mode=detail&id='.$id);
            }catch(HttpError $e){if(!in_array($e->status,[422,409],true))throw $e;http_response_code($e->status);$error=$e->getMessage();}
            $mode=$action==='report'?'create':'detail';foreach(['dn_id','branch_id','problem_type','description','reporter_name','request_key'] as $f)$values[$f]=is_string($_POST[$f]??null)?$_POST[$f]:'';
        }
        $canReport=$data->guard->access->can('expedition.claim.report');$canReview=$data->guard->access->can('expedition.claim.review');
        if($mode==='create'&&!$canReport)throw new HttpError(403,'Tidak memiliki izin pelaporan.');
        $claim=$mode==='detail'?$records->claim($id):null;$history=$claim?$records->claimHistory($id):[];$evidence=$claim?$records->evidence($id):[];$dn=$claim?$data->find('dn',(int)$claim['dn_id']):null;
        $listing=$mode==='list'?$records->claims($_GET):null;$documents=[];
        if($mode==='create'){
            $documents=$data->listing('dn',['q'=>Input::text($_GET,'q',100,false)])['rows'];$selected=Input::id($values+$_GET,'dn_id',true);if($selected){$selectedDn=$data->find('dn',$selected);if(!in_array($selected,array_map('intval',array_column($documents,'id')),true))$documents[]=$selectedDn;$values['dn_id']=(string)$selected;}
        }
        $branches=(new \Hls\Repositories\MasterDataRepository($data->repo,$data->guard->access,require dirname(__DIR__).'/master-data.php'))->branches();$values+=['request_key'=>bin2hex(random_bytes(32))];
        $this->view->render('claims',compact('title','mode','id','error','values','canReport','canReview','claim','history','evidence','dn','listing','documents','branches'));
    }
    public function evidence(): void
    {
        $id=Input::id($_GET,'id');$file=$this->claims->download($id);
        header("Content-Security-Policy: default-src 'none'; frame-ancestors 'none'");header('Content-Type: application/octet-stream');header('Content-Disposition: attachment; filename="bukti-'.$id.'.'.$file['extension'].'"');header('Content-Length: '.$file['size']);readfile($file['path']);
    }
}

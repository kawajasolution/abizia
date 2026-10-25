<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\Input;
use Hls\Http\HttpError;
use Hls\Middleware\Access;
use Hls\Repositories\DashboardRepository;
final class Dashboard
{
    public function __construct(private DashboardRepository $repo, private Access $access, private array $catalog, private Navigation $navigation) {}
    private function date(array $query,string $key,string $default): string
    {
        $value=Input::text($query,$key,10,false) ?: $default;
        $date=\DateTimeImmutable::createFromFormat('!Y-m-d',$value);
        if (!$date || $date->format('Y-m-d')!==$value || $date->format('Y')<'1970') throw new HttpError(422,'Tanggal filter tidak valid.');
        return $value;
    }
    public function build(array $query): array
    {
        return $this->repo->snapshot(fn()=>$this->read($query));
    }
    private function read(array $query): array
    {
        $this->access->demand('foundation.view');
        $role=$this->access->user['role_name'];
        $definition=$this->catalog[$role] ?? ['focus'=>'Akses akun','sections'=>[]];
        $options=$this->repo->branches();
        $branchId=Input::id($query,'branch',true) ?: null;
        if ($branchId!==null && !in_array($branchId,array_map('intval',array_column($options,'id')),true)) throw new HttpError(403,'Cabang filter di luar cakupan akses.');
        $canAudit=(bool)$this->access->user['all_branches'] && $this->access->can('audit.view');
        $owner=$role==='Owner';
        if (!$canAudit && !$owner && (isset($query['start']) || isset($query['end']))) throw new HttpError(403,'Filter periode tidak tersedia dalam akses Anda.');
        $start=$this->date($query,'start',date('Y-m-01')); $end=$this->date($query,'end',date('Y-m-d'));
        if ($start>$end) throw new HttpError(422,'Tanggal awal harus sebelum atau sama dengan tanggal akhir.');
        $branches=$branchId===null ? $options : array_values(array_filter($options,fn($b)=>(int)$b['id']===$branchId));
        $sources=$this->repo->sources(); $pending=[]; $operational=$owner ? $this->repo->operational($branchId,$start,$end) : null;
        foreach ($definition['sections'] as $section) {
            // No business adapter is registered at this stage. Even a coincidentally
            // named table cannot authorize or activate a business aggregation.
            $section['state']='unavailable'; $section['missing']=array_values(array_diff($section['requires'],$sources));
            $section['missing'][]='adapter:'.$section['id'];
            $pending[]=$section;
        }
        if ($owner) $pending=[];
        $metrics=[]; $attention=[]; $roleUsers=null; $audit=null;
        if ($this->access->can('branches.view')) {
            $metrics[]=['id'=>'branches','label'=>'Cabang dalam cakupan','value'=>count($branches),'note'=>'Saat ini · mengikuti filter cabang','icon'=>'building'];
            $inactive=count(array_filter($branches,fn($b)=>!$b['active']));
            if ($inactive) $attention[]=['label'=>'Cabang nonaktif','count'=>$inactive,'route'=>'/branches'];
        }
        if ($this->access->user['all_branches'] && $this->access->can('users.view')) {
            $users=$this->repo->users($branchId);
            array_unshift($metrics,['id'=>'active-users','label'=>'Pengguna aktif','value'=>(int)$users['active'],'note'=>'Saat ini · akun dengan akses cabang terpilih','icon'=>'users']);
            foreach (['inactive'=>'Pengguna nonaktif','unassigned'=>'Pengguna aktif tanpa penetapan cabang'] as $key=>$label) if ((int)$users[$key]) $attention[]=['label'=>$label,'count'=>(int)$users[$key],'route'=>'/users'];
        }
        if ($this->access->user['all_branches'] && $this->access->can('roles.view')) {
            $roles=$this->repo->roles();
            foreach (['roles'=>'Role terdaftar','permissions'=>'Permission terdaftar'] as $id=>$label) $metrics[]=['id'=>$id,'label'=>$label,'value'=>$roles[$id],'note'=>'Matriks global · saat ini','icon'=>'shield'];
            if ($this->access->can('users.view')) $roleUsers=$this->repo->roleUsers($branchId);
        }
        if ($canAudit && $branchId===null) $audit=$this->repo->audit($start,$end);
        $actions=array_values(array_filter($this->navigation->visible($this->access),fn($item)=>$item['id']!=='dashboard'));
        return compact('role','definition','options','branchId','branches','start','end','canAudit','owner','operational','metrics','attention','roleUsers','audit','pending','actions');
    }
}

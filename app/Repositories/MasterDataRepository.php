<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Middleware\Access;
use Hls\Http\HttpError;
use Hls\Http\Input;
final class MasterDataRepository
{
    public function __construct(public readonly Repository $repo,public readonly Access $access,public readonly array $catalog){}
    public function entity(string $key):array { return $this->catalog['entities'][$key]??throw new HttpError(404,'Jenis master tidak tersedia.'); }
    public function permission(string $key,string $action):string { return $key==='branches' ? ($action==='view'?'branches.view':'branches.manage') : $this->entity($key)['permission'].'.'.$action; }
    public function demand(string $key,string $action):void
    {
        $this->access->demand($this->permission($key,$action));
        if($this->entity($key)['scope']==='global' && $action!=='view')$this->access->global();
    }
    public function scope(string $key,string $alias='t'):array
    {
        $e=$this->entity($key);$parts=[];$args=[];
        if($e['kind']!==null){$parts[]="$alias.kind=?";$args[]=$e['kind'];}
        if($e['scope']!=='global' && !$this->access->user['all_branches']){
            $column=$e['scope']==='self'?'id':'branch_id';
            $parts[]="EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=$alias.$column)";$args[]=$this->access->user['id'];
            if($key==='routes'){$parts[]="EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=$alias.destination_branch_id)";$args[]=$this->access->user['id'];}
        }
        return [$parts?implode(' AND ',$parts):'1=1',$args];
    }
    private function select(string $key):string
    {
        $table=$this->entity($key)['table'];
        return in_array($key,['drivers','operators'],true)?"SELECT t.*,COALESCE(u.name,t.name) AS display_name FROM `$table` t LEFT JOIN users u ON u.id=t.account_id":"SELECT t.*,t.name AS display_name FROM `$table` t";
    }
    public function find(string $key,int $id,bool $lock=false):array
    {
        if($key==='branches')$this->access->demandBranch($id);
        $this->demand($key,'view');[$where,$args]=$this->scope($key);$args[]=$id;
        $row=$this->repo->one($this->select($key)." WHERE $where AND t.id=?".($lock?' FOR UPDATE':''),$args);
        if(!$row)throw new HttpError(404,'Data tidak ditemukan dalam akses Anda.');return $row;
    }
    public function listing(string $key,array $query):array
    {
        $this->demand($key,'view');[$where,$args]=$this->scope($key);$e=$this->entity($key);
        $q=Input::text($query,'q',100,false);$active=Input::text($query,'status',8,false);$branch=Input::id($query,'branch',true);
        if($active!==''&&!in_array($active,['0','1'],true))throw new HttpError(422,'Filter status tidak valid.');
        if($active!==''){$where.=' AND t.active=?';$args[]=(int)$active;}
        if($branch){$this->access->demandBranch($branch);if($e['scope']!=='global'){$where.=$e['scope']==='self'?' AND t.id=?':' AND t.branch_id=?';$args[]=$branch;}}
        if($q!==''){
            $pattern='%'.strtr($q,['!'=>'!!','%'=>'!%','_'=>'!_']).'%';
            $name=in_array($key,['drivers','operators'],true)?'COALESCE((SELECT u.name FROM users u WHERE u.id=t.account_id),t.name)':'t.name';
            $where.=" AND (t.code LIKE ? ESCAPE '!' OR $name LIKE ? ESCAPE '!')";array_push($args,$pattern,$pattern);
        }
        $total=(int)$this->repo->one("SELECT COUNT(*) AS n FROM `{$e['table']}` t WHERE $where",$args)['n'];
        $raw=Input::text($query,'page',6,false)?:'1';if(!ctype_digit($raw)||(int)$raw<1)throw new HttpError(422,'Halaman tidak valid.');
        $perPage=10;$pages=max(1,(int)ceil($total/$perPage));$page=min((int)$raw,$pages);$offset=($page-1)*$perPage;
        $rows=$this->repo->all($this->select($key)." WHERE $where ORDER BY t.id DESC LIMIT $perPage OFFSET $offset",$args);
        return compact('rows','q','active','branch')+['pagination'=>compact('total','perPage','pages','page')];
    }
    public function choices(string $target,?int $current=null):array
    {
        if($target==='users'){
            if(!$this->access->can('users.view')||!$this->access->user['all_branches'])return [];
            return $this->repo->all('SELECT id,name FROM users WHERE active=1 OR id=? ORDER BY name',[$current??0]);
        }
        if($target==='branches'){
            return array_values(array_filter($this->branches(),fn($b)=>$b['active']||(int)$b['id']===$current));
        }
        if(!$this->access->can($this->permission($target,'view')))return [];
        [$where,$args]=$this->scope($target);$args[]=$current??0;
        return $this->repo->all($this->select($target)." WHERE $where AND (t.active=1 OR t.id=?) ORDER BY t.name",$args);
    }
    public function branches():array
    {
        $this->access->demand('foundation.view');
        return $this->access->user['all_branches']?$this->repo->all('SELECT id,code,name,active FROM branches ORDER BY name,id'):$this->repo->all('SELECT b.id,b.code,b.name,b.active FROM branches b JOIN user_branches ub ON ub.branch_id=b.id WHERE ub.user_id=? ORDER BY b.name,b.id',[$this->access->user['id']]);
    }
    public function references(string $key,int $id):array
    {
        $table=$this->entity($key)['table'];$refs=[];
        $keys=$this->repo->all("SELECT TABLE_NAME AS child,COLUMN_NAME AS col FROM information_schema.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_SCHEMA=DATABASE() AND REFERENCED_TABLE_NAME=? AND REFERENCED_COLUMN_NAME='id'",[$table]);
        foreach($keys as $fk){if(!preg_match('/^[a-zA-Z0-9_]+$/D',$fk['child'])||!preg_match('/^[a-zA-Z0-9_]+$/D',$fk['col']))continue;$n=(int)$this->repo->one("SELECT COUNT(*) AS n FROM `{$fk['child']}` WHERE `{$fk['col']}`=?",[$id])['n'];if($n)$refs[]=['table'=>$fk['child'],'count'=>$n];}
        return $refs;
    }
    public function branchHasNumbers(int $id): bool
    {
        $exists=$this->repo->one("SELECT 1 FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name='exp_sequences'");
        if($exists&&(bool)$this->repo->one('SELECT branch_id FROM exp_sequences WHERE branch_id=? AND last_value>0 LIMIT 1 FOR UPDATE',[$id]))return true;
        $equipment=$this->repo->one("SELECT 1 FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name='eq_document_sequences'");
        return $equipment&&(bool)$this->repo->one('SELECT branch_id FROM eq_document_sequences WHERE branch_id=? AND last_value>0 LIMIT 1 FOR UPDATE',[$id]);
    }
    public function history(string $key,int $id):array
    {
        $this->access->demand('audit.view');$this->access->global();$this->find($key,$id);
        return $this->repo->all('SELECT a.action,a.created_at,a.detail,u.name AS actor FROM audit_logs a LEFT JOIN users u ON u.id=a.actor_id WHERE a.entity=? AND a.entity_id=? ORDER BY a.id DESC LIMIT 20',[$this->entity($key)['table'],$id]);
    }
}

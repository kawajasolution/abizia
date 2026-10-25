<?php
declare(strict_types=1);
namespace Hls\Repositories;
use Hls\Middleware\Access;
final class DashboardRepository
{
    public function __construct(private Repository $repo, private Access $access) {}
    public function snapshot(callable $read): array { return \Hls\Database::transaction($this->repo->db,$read); }
    public function sources(): array { return array_column($this->repo->all('SELECT table_name FROM information_schema.tables WHERE table_schema=DATABASE()'), 'table_name'); }
    public function branches(): array
    {
        $this->access->demand('foundation.view');
        return $this->access->user['all_branches'] ? $this->repo->all('SELECT id,code,name,active FROM branches ORDER BY name,id') : $this->repo->all('SELECT b.id,b.code,b.name,b.active FROM branches b JOIN user_branches ub ON ub.branch_id=b.id WHERE ub.user_id=? ORDER BY b.name,b.id', [$this->access->user['id']]);
    }
    private function usersScope(?int $branch): array
    {
        $this->access->demand('users.view'); $this->access->global();
        if ($branch !== null) $this->access->demandBranch($branch);
        return $branch === null ? ['1=1',[]] : ['(u.all_branches=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=u.id AND ub.branch_id=?))',[$branch]];
    }
    public function users(?int $branch): array
    {
        [$where,$args] = $this->usersScope($branch);
        return $this->repo->one("SELECT COUNT(*) AS total,COALESCE(SUM(u.active=1),0) AS active,COALESCE(SUM(u.active=0),0) AS inactive,COALESCE(SUM(u.active=1 AND u.all_branches=0 AND NOT EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=u.id)),0) AS unassigned FROM users u WHERE $where",$args);
    }
    public function roles(): array
    {
        $this->access->demand('roles.view'); $this->access->global();
        return ['roles'=>(int)$this->repo->one('SELECT COUNT(*) AS n FROM roles')['n'],'permissions'=>(int)$this->repo->one('SELECT COUNT(*) AS n FROM permissions')['n'],'grants'=>(int)$this->repo->one('SELECT COUNT(*) AS n FROM role_permissions')['n']];
    }
    public function roleUsers(?int $branch): array
    {
        $this->access->demand('roles.view');
        [$where,$args] = $this->usersScope($branch);
        return $this->repo->all("SELECT r.name,COUNT(u.id) AS active FROM roles r LEFT JOIN users u ON u.role_id=r.id AND u.active=1 AND $where GROUP BY r.id,r.name ORDER BY r.id",$args);
    }
    public function audit(string $start, string $end): array
    {
        $this->access->demand('audit.view'); $this->access->global();
        return $this->repo->all('SELECT a.id,a.action,a.entity,a.entity_id,a.created_at,u.name AS actor FROM audit_logs a LEFT JOIN users u ON u.id=a.actor_id WHERE a.created_at>=? AND a.created_at<=? ORDER BY a.id DESC LIMIT 8',[$start.' 00:00:00',$end.' 23:59:59']);
    }
    public function operational(?int $branch,string $start,string $end): array
    {
        $this->access->demand('foundation.view');
        $args=[];$scope='1=1';
        if($branch!==null){$scope='x.branch_id=?';$args[]=$branch;}elseif(!$this->access->user['all_branches']){$scope='EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=? AND ub.branch_id=x.branch_id)';$args[]=$this->access->user['id'];}
        $dn=$this->repo->one("SELECT COUNT(*) total,COALESCE(SUM(x.status IN ('departed','transit','arrived')),0) active,COALESCE(SUM(x.status IN ('completed','received')),0) completed FROM (SELECT d.*,d.origin_branch_id branch_id FROM exp_dns d) x WHERE $scope AND x.document_date BETWEEN ? AND ?",[...$args,$start,$end])??['total'=>0,'active'=>0,'completed'=>0];
        $claims=$this->repo->one("SELECT COUNT(*) total,COALESCE(SUM(c.status IN ('REPORTED','REVIEWING')),0) open FROM exp_claims c JOIN exp_dns d ON d.id=c.dn_id WHERE ".str_replace('x.branch_id','d.origin_branch_id',$scope)." AND c.created_at BETWEEN ? AND ?",[...$args,$start.' 00:00:00',$end.' 23:59:59'])??['total'=>0,'open'=>0];
        $mf=$this->repo->one("SELECT COUNT(*) total FROM exp_manifests x WHERE ".str_replace('x.branch_id','x.origin_branch_id',$scope)." AND x.document_date BETWEEN ? AND ? AND x.status IN ('draft','departed','transit')",[...$args,$start,$end])??['total'=>0];
        $units=$this->repo->one("SELECT COUNT(*) total,COALESCE(SUM(x.status IN ('DRAFT','CONFIRMED','COMPLETED','CANCELLED','TERMINATED')),0) available,COALESCE(SUM(x.status='ACTIVE'),0) in_use FROM eq_contract_units x WHERE ".str_replace('x.branch_id','x.contract_branch_id',$scope),$args)??['total'=>0,'available'=>0,'in_use'=>0];
        $contracts=$this->repo->one("SELECT COUNT(*) total FROM eq_contracts x WHERE $scope AND x.status='ACTIVE'",$args)??['total'=>0];
        $ts=$this->repo->one("SELECT COUNT(*) total FROM eq_timesheets t JOIN eq_contract_units u ON u.id=t.contract_unit_id JOIN eq_contracts x ON x.id=u.contract_id WHERE $scope AND EXISTS(SELECT 1 FROM eq_timesheet_revisions r WHERE r.timesheet_id=t.id AND r.status='SUBMITTED')",$args)??['total'=>0];
        return ['dn'=>array_map('intval',$dn),'claims'=>array_map('intval',$claims),'manifests'=>['total'=>(int)$mf['total']],'units'=>array_map('intval',$units),'contracts'=>['total'=>(int)$contracts['total']],'timesheets'=>['total'=>(int)$ts['total']]];
    }
}

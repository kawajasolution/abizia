<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
use Hls\Middleware\Access;
use Hls\Repositories\Repository;
final class EquipmentAccess
{
    public function __construct(public readonly Repository $repo,public readonly Access $access) {}
    public function actor(string $permission,bool $lock=false):array
    {
        $u=$this->repo->one('SELECT * FROM users WHERE id=?'.($lock?' FOR UPDATE':''),[$this->access->user['id']]);
        foreach(['role_id','auth_version','all_branches'] as $key)if(!$u||(int)$u[$key] !== (int)$this->access->user[$key])throw new HttpError(403,'Kewenangan berubah. Masuk kembali.');
        if(!$u['active']||!$this->repo->one('SELECT rp.permission_id FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id WHERE rp.role_id=? AND p.code=?'.($lock?' FOR UPDATE':''),[$u['role_id'],$permission]))throw new HttpError(403,'Tidak memiliki izin Equipment.');
        return $u;
    }
    public function branch(int $branch,string $permission,bool $lock=false):void
    {
        $u=$this->actor($permission,$lock);$b=$this->repo->one('SELECT active FROM branches WHERE id=?'.($lock?' FOR UPDATE':''),[$branch]);
        if(!$b||!$b['active']||(!$u['all_branches']&&!$this->repo->one('SELECT user_id FROM user_branches WHERE user_id=? AND branch_id=?'.($lock?' FOR UPDATE':''),[$u['id'],$branch])))throw new HttpError(403,'Tidak ada cakupan cabang efektif.');
    }
}

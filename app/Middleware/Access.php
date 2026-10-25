<?php
declare(strict_types=1);
namespace Hls\Middleware;
use Hls\Repositories\Repository;
use Hls\Http\HttpError;
final class Access
{
    public function __construct(private Repository $repo, public readonly array $user) {}
    public function can(string $permission): bool { return (bool)$this->repo->one('SELECT 1 FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id WHERE rp.role_id=? AND p.code=?', [$this->user['role_id'], $permission]); }
    public function demand(string $permission): void { if (!$this->can($permission)) throw new HttpError(403, 'Anda tidak memiliki izin untuk aksi ini.'); }
    public function global(): void { if (!(bool)$this->user['all_branches']) throw new HttpError(403, 'Aksi memerlukan cakupan seluruh cabang.'); }
    public function branch(int $id): bool { return (bool)$this->user['all_branches'] || (bool)$this->repo->one('SELECT 1 FROM user_branches WHERE user_id=? AND branch_id=?', [$this->user['id'], $id]); }
    public function demandBranch(int $id): void { if (!$this->branch($id)) throw new HttpError(403, 'Cabang di luar cakupan akses.'); }
}

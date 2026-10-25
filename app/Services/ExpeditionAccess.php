<?php
declare(strict_types=1);
namespace Hls\Services;

use Hls\Http\HttpError;
use Hls\Middleware\Access;
use Hls\Repositories\Repository;

/** Operational membership checks; does not change foundation/master access policies. */
final class ExpeditionAccess
{
    public function __construct(private Repository $repo, public readonly Access $access) {}

    public function actor(string $permission, bool $lock = false): array
    {
        $actor = $this->repo->one('SELECT id,active,role_id,auth_version,all_branches FROM users WHERE id=?' . ($lock ? ' FOR UPDATE' : ''), [$this->access->user['id']]);
        if (!$actor || !$actor['active'] || (int)$actor['role_id'] !== (int)$this->access->user['role_id'] || (int)$actor['auth_version'] !== (int)$this->access->user['auth_version'] || (int)$actor['all_branches'] !== (int)$this->access->user['all_branches']) {
            throw new HttpError(403, 'Akun atau kewenangan telah berubah. Masuk kembali.');
        }
        $grant = $this->repo->one('SELECT rp.permission_id FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id WHERE rp.role_id=? AND p.code=?' . ($lock ? ' FOR UPDATE' : ''), [$actor['role_id'], $permission]);
        if (!$grant) throw new HttpError(403, 'Anda tidak memiliki izin untuk aksi ini.');
        return $actor;
    }

    public function branch(int $id, string $permission, bool $lock = false): void
    {
        $actor = $this->actor($permission, $lock);
        $branch = $this->repo->one('SELECT id,active FROM branches WHERE id=?' . ($lock ? ' FOR UPDATE' : ''), [$id]);
        if (!$branch || !$branch['active']) throw new HttpError(403, 'Cabang operasional tidak aktif atau tidak tersedia.');
        if (!$actor['all_branches']) {
            $membership = $this->repo->one('SELECT user_id FROM user_branches WHERE user_id=? AND branch_id=?' . ($lock ? ' FOR UPDATE' : ''), [$actor['id'], $id]);
            if (!$membership) throw new HttpError(403, 'Tidak ada penetapan aktif pada cabang operasional ini.');
        }
    }
}

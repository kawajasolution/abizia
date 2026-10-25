<?php
declare(strict_types=1);
use Hls\Middleware\Access;
// Only disposable V2 fixtures from run.php; never changes development membership.
$expeditionAccessStart = count($checks);
$operational = new Hls\Services\ExpeditionAccess($repo, new Access($repo, $users->find($scopedId)));
$globalOperational = new Hls\Services\ExpeditionAccess($repo, new Access($repo, $users->find($adminId)));
$operational->branch($a, 'foundation.view');
check(true, 'Operasional: akun/cabang/penetapan aktif diterima');
rejects(fn() => $operational->branch($b, 'foundation.view'), 'Operasional: cabang di luar penetapan ditolak', 403);
$readOnlyOperational = new Hls\Services\ExpeditionAccess($repo, new Access($repo, $users->find($ownerId)));
rejects(fn() => $readOnlyOperational->branch($a, 'users.manage'), 'Operasional: izin backend tetap wajib', 403);
$repo->db->beginTransaction();
try {
    $operational->branch($a, 'foundation.view', true);
    check(true, 'Operasional: current locking read akun/cabang/penetapan berhasil');
    $repo->run('DELETE FROM user_branches WHERE user_id=? AND branch_id=?', [$scopedId, $a]);
    rejects(fn() => $operational->branch($a, 'foundation.view'), 'Operasional: penetapan dicabut menolak principal lama', 403);
    $repo->run('INSERT INTO user_branches(user_id,branch_id) VALUES (?,?)', [$scopedId, $a]);
    $repo->run('UPDATE branches SET active=0 WHERE id=?', [$a]);
    rejects(fn() => $operational->branch($a, 'foundation.view'), 'Operasional: cabang nonaktif ditolak', 403);
    rejects(fn() => $globalOperational->branch($a, 'foundation.view'), 'Operasional: cakupan global tidak melewati cabang nonaktif', 403);
    $repo->run('UPDATE branches SET active=1 WHERE id=?', [$a]);
    $repo->run('UPDATE users SET active=0 WHERE id=?', [$scopedId]);
    rejects(fn() => $operational->branch($a, 'foundation.view'), 'Operasional: akun nonaktif ditolak meski principal lama aktif', 403);
    $repo->run('UPDATE users SET active=1,auth_version=auth_version+1 WHERE id=?', [$scopedId]);
    rejects(fn() => $operational->branch($a, 'foundation.view'), 'Operasional: versi otorisasi lama ditolak', 403);
    $currentOperational = new Hls\Services\ExpeditionAccess($repo, new Access($repo, $users->find($scopedId)));
    $repo->run("DELETE rp FROM role_permissions rp JOIN permissions p ON p.id=rp.permission_id WHERE rp.role_id=? AND p.code='foundation.view'", [$roles['Administrator']]);
    rejects(fn() => $currentOperational->branch($a, 'foundation.view', true), 'Operasional: grant dicabut ditolak pada current read', 403);
} finally {
    $repo->db->rollBack();
}
file_put_contents(__DIR__ . '/results/expedition-access.json', json_encode(['date'=>date(DATE_ATOM),'passed'=>count($checks)-$expeditionAccessStart,'checks'=>array_slice($checks,$expeditionAccessStart)], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

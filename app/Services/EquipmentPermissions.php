<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Repositories\Repository;

final class EquipmentPermissions
{
    /** Ordinary grants follow Y/O cells; special C cells remain ungranted pending approval. */
    public static function grants(): array
    {
        $admin = ['unit.view','contract.view','contract.create','contract.update','contract.confirm','contract.activate','contract.close','contract.cancel','contract.terminate','contract.extend','assignment.manage','handover.view','handover.create','handover.update','handover.confirm','handover.cancel','timesheet.view_scoped','timesheet.create_scoped','timesheet.update_scoped','timesheet.submit_scoped','timesheet.revise_scoped','verification.view','verification.decide','cross_branch.request','evidence.view','evidence.add','p2h.view','p2h.create','p2h.submit','p2h.review','p2h.hold.release'];
        return [
            'Administrator'=>$admin,
            'Admin Sewa'=>array_values(array_diff($admin, ['contract.terminate','contract.extend','verification.view','verification.decide'])),
            'Operator Alat Berat'=>['unit.view_own','contract.view_own','handover.view_own','timesheet.view_own','timesheet.create_own','timesheet.update_own','timesheet.submit_own','timesheet.revise_own','evidence.view_own','evidence.add_own'],
            'Owner'=>['unit.view','contract.view','handover.view','timesheet.view_scoped','verification.view','evidence.view','p2h.view'],
        ];
    }

    public static function catalog(): array
    {
        $codes = array_merge(...array_values(self::grants()));
        $codes = array_merge($codes, ['handover.correct','cross_branch.approve','recovery.close','meter.correct','timesheet.revise_terminal','operator.relink','handover.fact_correct']);
        $codes = array_values(array_unique($codes)); sort($codes);
        return array_map(static fn(string $code): string => 'equipment.' . $code, $codes);
    }

    public static function seed(Repository $repo): void
    {
        foreach (self::catalog() as $code) $repo->run('INSERT IGNORE INTO permissions(code,name) VALUES (?,?)', [$code, 'Equipment: ' . substr($code, 10)]);
        foreach (self::grants() as $role=>$codes) foreach ($codes as $code) {
            $repo->run('INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name=? AND p.code=?', [$role, 'equipment.' . $code]);
        }
    }
}

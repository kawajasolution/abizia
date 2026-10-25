<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Repositories\Repository;
final class ExpeditionPermissions
{
    public static function seed(Repository $repo): void
    {
        $permissions = ['expedition.view'=>'Lihat DN dan tracking internal','expedition.ship'=>'Buat/ubah DN awal','expedition.manifest.view'=>'Lihat manifest','expedition.manifest'=>'Buat manifest draf dan susun DN'];
        $grants = ['Administrator'=>array_keys($permissions),'Owner'=>['expedition.view','expedition.manifest.view'],'Admin Pengirim'=>['expedition.view','expedition.ship','expedition.manifest.view'],'Admin Transit'=>['expedition.view','expedition.manifest.view','expedition.manifest'],'Admin Penerima'=>['expedition.view','expedition.manifest.view']];
        foreach ($permissions as $code=>$label) $repo->run('INSERT IGNORE INTO permissions(code,name) VALUES (?,?)',[$code,$label]);
        foreach ($grants as $role=>$codes) foreach ($codes as $code) $repo->run('INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name=? AND p.code=?',[$role,$code]);
    }
    public static function operations(Repository $repo): void
    {
        $permissions=['expedition.confirm'=>'Konfirmasi DN dan nomor resmi','expedition.transit'=>'Catat perjalanan dan posisi aktual','expedition.receive'=>'Penerimaan utuh aktual','expedition.claim.view'=>'Lihat klaim operasional','expedition.claim.report'=>'Laporkan klaim dan bukti','expedition.claim.review'=>'Periksa/putuskan/tutup klaim operasional'];
        foreach($permissions as $code=>$name)$repo->run('INSERT IGNORE INTO permissions(code,name) VALUES (?,?)',[$code,$name]);
        $grants=['Administrator'=>array_keys($permissions),'Owner'=>['expedition.claim.view'],'Admin Pengirim'=>['expedition.confirm','expedition.claim.view','expedition.claim.report'],'Admin Transit'=>['expedition.transit','expedition.claim.view','expedition.claim.report'],'Admin Penerima'=>['expedition.receive','expedition.claim.view','expedition.claim.report']];
        foreach($grants as $role=>$codes)foreach($codes as $code)$repo->run('INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name=? AND p.code=?',[$role,$code]);
    }
}

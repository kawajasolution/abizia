<?php
declare(strict_types=1);
// Loaded by run.php with the already-isolated fixture database and HTTP clients.
use Hls\Middleware\Access;
use Hls\Repositories\DashboardRepository;
use Hls\Services\Dashboard;
use Hls\Services\Navigation;

$dashboardChecksBefore=count($checks);
$catalog=require $root.'/app/dashboard.php';
$makeDashboard=fn(Access $who)=>new Dashboard(new DashboardRepository($repo,$who),$who,$catalog,new Navigation(require $root.'/app/navigation.php',require $root.'/app/routes.php'));
$globalDashboard=$makeDashboard($access);
check(in_array('users',(new DashboardRepository($repo,$access))->sources(),true),'Ketersediaan sumber diperiksa dari database v2 aktual');
$result=$globalDashboard->build([]);
$metricMap=fn($result)=>array_column($result['metrics'],'value','id');
$metrics=$metricMap($result);
check($metrics['active-users']===(int)$repo->one('SELECT COUNT(*) AS n FROM users WHERE active=1')['n'],'Dashboard pengguna aktif sesuai query sumber');
check($metrics['branches']===(int)$repo->one('SELECT COUNT(*) AS n FROM branches')['n'],'Dashboard cabang sesuai query sumber');
check($metrics['roles']===10 && $metrics['permissions']===63+count(Hls\Services\EquipmentPermissions::catalog()),'Dashboard matriks role/permission nyata termasuk katalog Equipment');
check($result['pending']===[],'Administrator tidak mendapat widget finansial tanpa sumber');
check(count($result['audit'])<=8,'Dashboard hanya delapan audit terbaru');
check(array_sum(array_map(fn($r)=>(int)$r['active'],$result['roleUsers']))===$metrics['active-users'],'Distribusi role merekonsiliasi pengguna aktif');
$scopedResult=$makeDashboard($scoped)->build([]);
check(array_column($scopedResult['branches'],'id')===[$a] || array_map('intval',array_column($scopedResult['branches'],'id'))===[$a],'Dashboard scoped hanya memuat cabang sendiri');
check(array_keys($metricMap($scopedResult))===['branches'],'Dashboard admin scoped tanpa jumlah pengguna/role global');
check($scopedResult['audit']===null && $scopedResult['roleUsers']===null,'Dashboard admin scoped tanpa audit dan distribusi akun');
rejects(fn()=>$makeDashboard($scoped)->build(['branch'=>(string)$b]),'Dashboard menolak filter cabang lain',403);
rejects(fn()=>$makeDashboard($scoped)->build(['start'=>'2026-01-01']),'Dashboard menolak periode audit tanpa cakupan global',403);
rejects(fn()=>$globalDashboard->build(['branch'=>'999999']),'Dashboard menolak cabang tidak tersedia',403);
rejects(fn()=>$globalDashboard->build(['branch'=>['array']]),'Dashboard menolak filter array',422);
rejects(fn()=>$globalDashboard->build(['start'=>'2026-02-30']),'Dashboard menolak tanggal tidak nyata',422);
rejects(fn()=>$globalDashboard->build(['start'=>'2026-10-24','end'=>'2026-10-01']),'Dashboard menolak rentang terbalik',422);
$filtered=$globalDashboard->build(['branch'=>(string)$a]);
$expected=(int)$repo->one('SELECT COUNT(*) AS n FROM users u WHERE active=1 AND (all_branches=1 OR EXISTS(SELECT 1 FROM user_branches ub WHERE ub.user_id=u.id AND ub.branch_id=?))',[$a])['n'];
check($metricMap($filtered)['active-users']===$expected && $metricMap($filtered)['branches']===1,'Filter cabang mengubah KPI akun/cabang sesuai definisi');
check($filtered['audit']===null,'Filter cabang tidak menampilkan audit global yang tak dapat diatribusikan');
try {
    $repo->run('UPDATE branches SET active=0 WHERE id=?',[$b]);
    check(in_array('Cabang nonaktif',array_column($globalDashboard->build([])['attention'],'label'),true),'Cabang nonaktif nyata muncul sebagai tindak lanjut');
    check(!in_array('Cabang nonaktif',array_column($makeDashboard($scoped)->build([])['attention'],'label'),true),'Tindak lanjut cabang lain tidak bocor ke admin scoped');
    $repo->run('UPDATE users SET active=0 WHERE id=?',[$ownerId]);
    check($metricMap($globalDashboard->build([]))['active-users']===$metrics['active-users']-1,'KPI bereaksi pada perubahan status akun nyata');
    check(in_array('Pengguna nonaktif',array_column($globalDashboard->build([])['attention'],'label'),true),'Pengguna nonaktif nyata muncul sebagai tindak lanjut');
    $repo->run('UPDATE users SET active=1 WHERE id=?',[$ownerId]);
    $repo->run('DELETE FROM user_branches WHERE user_id=?',[$ownerId]);
    check(in_array('Pengguna aktif tanpa penetapan cabang',array_column($globalDashboard->build([])['attention'],'label'),true),'Penetapan cabang kosong terdeteksi tanpa mengarang aturan');
} finally {
    $repo->run('UPDATE branches SET active=1 WHERE id=?',[$b]);
    $repo->run('UPDATE users SET active=1 WHERE id=?',[$ownerId]);
    $repo->run('INSERT IGNORE INTO user_branches(user_id,branch_id) VALUES (?,?)',[$ownerId,$a]);
}
$boundaryIds=[];
foreach (['2025-02-09 23:59:59','2025-02-10 00:00:00','2025-02-10 23:59:59','2025-02-11 00:00:00'] as $stamp) {
    $repo->run("INSERT INTO audit_logs(actor_id,action,entity,detail,created_at) VALUES (?,'dashboard_boundary','test','{}',?)",[$adminId,$stamp]);
    $boundaryIds[]=(int)$repo->db->lastInsertId();
}
$period=$globalDashboard->build(['start'=>'2025-02-10','end'=>'2025-02-10']);
check(array_map('intval',array_column($period['audit'],'id'))===[$boundaryIds[2],$boundaryIds[1]],'Periode audit inklusif dua batas hari WITA');
check($metricMap($period)===$metrics,'Periode audit tidak mengubah KPI keadaan saat ini');
check($globalDashboard->build(['start'=>'2024-01-01','end'=>'2024-01-01'])['audit']===[],'Periode audit tanpa data benar-benar kosong');
foreach ($boundaryIds as $id) $repo->run('DELETE FROM audit_logs WHERE id=?',[$id]);
foreach ($roleAccounts as $accountData) {
    $principal=$users->byEmail($accountData['email']);$principal=$users->find((int)$principal['id']);
    $model=$makeDashboard(new Access($repo,$principal))->build(['role'=>'Administrator']);
    check($model['role']===$accountData['role'],'Dispatch role dari akun, bukan query: '.$accountData['role']);
    if ($accountData['role']!=='Administrator') {
        check(($accountData['role']==='Owner' ? array_keys($metricMap($model))===['branches'] : $model['metrics']===[]) && $model['audit']===null && $model['roleUsers']===null,'Widget administrasi tidak bocor ke '.$accountData['role']);
        check((bool)$model['pending'],'Dashboard mencatat sumber bisnis belum tersedia: '.$accountData['role']);
        foreach ($model['pending'] as $section) check($section['state']==='unavailable' && !isset($section['value']) && (bool)$section['missing'],'Tidak ada angka nol pengganti sumber: '.$accountData['role'].'/'.$section['id']);
    }
}
$ownerDashboard=$makeDashboard($owner);
rejects(fn()=>(new DashboardRepository($repo,$owner))->users(null),'Repository KPI pengguna memeriksa izin',403);
rejects(fn()=>(new DashboardRepository($repo,$scoped))->roles(),'Repository role memeriksa global scope',403);
rejects(fn()=>(new DashboardRepository($repo,$owner))->audit('2026-01-01','2026-12-31'),'Repository audit memeriksa izin',403);
check(array_keys($metricMap($makeDashboard($globalOwner)->build([])))===['branches'],'Owner global tidak mendapat grant dari nama/cakupan');
$noScope=array_replace($users->find($ownerId),['id'=>0]);
check($makeDashboard(new Access($repo,$noScope))->build([])['branches']===[],'Akun tanpa penetapan cabang tidak membaca semua cabang');
// Revoke a foundation permission inside a test transaction; restore it unconditionally.
$ownerPermission=$repo->one("SELECT id FROM permissions WHERE code='foundation.view'")['id'];
$repo->run('DELETE FROM role_permissions WHERE role_id=? AND permission_id=?',[$roles['Owner'],$ownerPermission]);
try { rejects(fn()=>$ownerDashboard->build([]),'Dashboard service memeriksa foundation.view',403); check(http('/',$ownerJar)['status']===403,'HTTP dashboard memeriksa foundation.view sebelum widget'); }
finally { $repo->run('INSERT INTO role_permissions(role_id,permission_id) VALUES (?,?)',[$roles['Owner'],$ownerPermission]); }
check(http('/?branch='.$b,$scopeJar)['status']===403,'HTTP dashboard menolak filter cabang lintas akses');
check(http('/?start=2026-02-30',$anonJar)['status']===422,'HTTP dashboard menolak tanggal tidak sah');
$ownerPage=http('/',$ownerJar);
check($ownerPage['status']===200 && str_contains($ownerPage['body'],'data-dashboard-role="Owner"'),'HTTP Owner langsung ke dashboard sendiri');
check(!str_contains($ownerPage['body'],'data-kpi="active-users"') && !str_contains($ownerPage['body'],'Cabang B Privat'),'HTTP Owner tanpa KPI terlarang/cabang lain');
check(str_contains($ownerPage['body'],'Belum tersedia'),'HTTP Owner menandai sumber data belum tersedia');
$dashboardChecks=array_slice($checks,$dashboardChecksBefore);
file_put_contents(__DIR__.'/results/dashboard-integration.json',json_encode(['date'=>date(DATE_ATOM),'passed'=>count($dashboardChecks),'checks'=>$dashboardChecks],JSON_PRETTY_PRINT|JSON_UNESCAPED_UNICODE));

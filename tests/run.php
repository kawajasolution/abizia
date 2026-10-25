<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
use Hls\Repositories\Repository;
use Hls\Repositories\UserRepository;
use Hls\Services\Audit;
use Hls\Services\Auth;
use Hls\Services\BootstrapAdmin;
use Hls\Services\MasterService;
use Hls\Services\Migrator;
use Hls\Middleware\Access;
use Hls\Http\HttpError;

if (PHP_SAPI !== 'cli') exit(1);
$root = dirname(__DIR__); @mkdir(__DIR__ . '/tmp', 0700, true); @mkdir(__DIR__ . '/results', 0700, true);
$suffix = bin2hex(random_bytes(6)); $database = 'hls_v2_test_' . $suffix; Hls\Config::databaseName($database);
$account = 'hlsv2t_' . $suffix; $server = null; $adminDb = null; $repo = null; $checks = []; $failure = null;
$temporary = []; $configPath = __DIR__ . '/tmp/config-' . $suffix . '.php'; $fixturePath = __DIR__ . '/tmp/browser-' . $suffix . '.json';
function check(bool $pass, string $label): void { global $checks; $checks[] = ['name' => $label, 'passed' => $pass]; if (!$pass) throw new RuntimeException('FAIL: ' . $label); }
function rejects(callable $work, string $label, ?int $status = null): void { try { $work(); } catch (Throwable $e) { check($status === null || ($e instanceof HttpError && $e->status === $status), $label); return; } check(false, $label); }
function http(string $path, string $jar, ?array $data = null, string $method = 'GET'): array {
    global $base;
    $ch = curl_init($base . $path); curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_HEADER => true, CURLOPT_FOLLOWLOCATION => false, CURLOPT_COOKIEFILE => $jar, CURLOPT_COOKIEJAR => $jar, CURLOPT_TIMEOUT => 10]);
    if ($data !== null) { $method = 'POST'; curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data)); }
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method); $raw = curl_exec($ch); if ($raw === false) throw new RuntimeException(curl_error($ch));
    $size = curl_getinfo($ch, CURLINFO_HEADER_SIZE); $status = curl_getinfo($ch, CURLINFO_HTTP_CODE); curl_close($ch);
    return ['status' => $status, 'headers' => substr($raw, 0, $size), 'body' => substr($raw, $size)];
}
function token(array $response): string { if (!preg_match('/name="csrf" value="([a-f0-9]{64})"/', $response['body'], $m)) throw new RuntimeException('Token CSRF tidak ditemukan.'); return $m[1]; }
function login(string $email, string $password, string $jar): array { return http('/login', $jar, ['csrf' => token(http('/login', $jar)), 'email' => $email, 'password' => $password]); }
try {
    $adminDb = new PDO('mysql:host=127.0.0.1;port=3306;charset=utf8mb4', getenv('HLS_DB_ADMIN_USER') ?: 'root', getenv('HLS_DB_ADMIN_PASSWORD') ?: '', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    $adminDb->exec("CREATE DATABASE `$database` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    $dbPassword = bin2hex(random_bytes(32));
    $adminDb->exec("CREATE USER '$account'@'127.0.0.1' IDENTIFIED BY " . $adminDb->quote($dbPassword));
    $adminDb->exec("GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER,INDEX,REFERENCES,TRIGGER ON `$database`.* TO '$account'@'127.0.0.1'");
    $sessionDirectory = $root . '/storage/test-sessions-' . $suffix;
    $config = ['database' => $database, 'host' => '127.0.0.1', 'port' => 3306, 'username' => $account, 'password' => $dbPassword, 'base_path' => '', 'secure_cookie' => false, 'idle_timeout' => 1800, 'claim_dir' => $sessionDirectory . '/claims', 'equipment_dir'=>$sessionDirectory.'/equipment', 'session_dir' => $sessionDirectory];
    $db = Hls\Database::connect($config); $repo = new Repository($db); $users = new UserRepository($db); $audit = new Audit($repo);
    check(Migrator::install($db, $database), 'Fresh migration pada DB kosong');
    check(!Migrator::install($db, $database), 'Migration ulang idempoten');
    check(count($repo->all('SHOW TABLES')) === 48, '32 tabel T1–5 dan 16 tabel Equipment tanpa transaksi bawaan');
    check((int)$repo->one('SELECT COUNT(*) AS n FROM users')['n'] === 0, 'Migration tanpa akun/password bawaan');
    rejects(fn() => Hls\Config::databaseName('hlstransport'), 'Target database lama ditolak');
    rejects(fn() => Hls\Config::databaseName('mysql'), 'Target database sistem ditolak');
    $password = 'T!' . bin2hex(random_bytes(16));
    rejects(fn() => BootstrapAdmin::create($repo, 'Uji', 'admin@example.test', 'short'), 'Bootstrap menolak password lemah', 422);
    file_put_contents($configPath, '<?php return ' . var_export($config, true) . ';'); $temporary[] = $configPath;
    $cliEnv = getenv(); $cliEnv['HLS_V2_CONFIG'] = $configPath;
    $bootstrap = proc_open([PHP_BINARY, $root . '/bin/bootstrap-admin.php', 'Administrator Uji', 'admin@example.test'], [['pipe','r'],['pipe','w'],['pipe','w']], $cliPipes, $root, $cliEnv);
    if (!is_resource($bootstrap)) throw new RuntimeException('Bootstrap CLI tidak dapat dimulai.');
    fwrite($cliPipes[0], $password . "\n"); fclose($cliPipes[0]);
    $bootstrapOutput = stream_get_contents($cliPipes[1]); fclose($cliPipes[1]); $bootstrapError = stream_get_contents($cliPipes[2]); fclose($cliPipes[2]);
    check(proc_close($bootstrap) === 0, 'Bootstrap administrator melalui CLI dan STDIN berhasil');
    check(!str_contains($bootstrapOutput . $bootstrapError, $password), 'Bootstrap CLI tidak membocorkan password');
    $adminId = (int)$users->byEmail('admin@example.test')['id'];
    check(password_verify($password, $users->find($adminId)['password_hash']), 'Bootstrap menyimpan hash password');
    rejects(fn() => BootstrapAdmin::create($repo, 'Kedua', 'other@example.test', $password), 'Bootstrap tidak mereset/membuat admin kedua');
    $access = new Access($repo, $users->find($adminId)); $master = new MasterService($repo, $access, $audit);
    $a = $master->branch(['code' => 'TESTA', 'name' => 'Cabang A Uji', 'active' => '1']);
    $b = $master->branch(['code' => 'TESTB', 'name' => 'Cabang B Privat', 'active' => '1']);
    $roles = array_column($repo->all('SELECT id,name FROM roles'), 'id', 'name');
    check(count($roles) === 10, 'Sepuluh role fondasi tersedia');
    $scopedId = $master->user(['name' => 'Admin Cabang Uji', 'email' => 'scoped@example.test', 'role_id' => (string)$roles['Administrator'], 'password' => $password, 'active' => '1', 'branches' => [(string)$a]]);
    $ownerId = $master->user(['name' => 'Pembaca Uji', 'email' => 'owner@example.test', 'role_id' => (string)$roles['Owner'], 'password' => $password, 'active' => '1', 'branches' => [(string)$a]]);
    $scoped = new Access($repo, $users->find($scopedId)); $scopedMaster = new MasterService($repo, $scoped, $audit);
    rejects(fn() => $scopedMaster->branch(['id' => (string)$b, 'code' => 'TESTB', 'name' => 'Bocor', 'active' => '1']), 'Service menolak edit cabang lain', 403);
    rejects(fn() => $scopedMaster->branch(['code' => 'TESTC', 'name' => 'Baru', 'active' => '1']), 'Service menolak create cabang oleh admin scoped', 403);
    check($scopedMaster->branch(['id' => (string)$a, 'code' => 'TESTA', 'name' => 'Cabang A Uji', 'address' => 'Perubahan sah', 'active' => '1']) === $a, 'Admin scoped boleh mengubah cabang sendiri');
    rejects(fn() => $master->user(['id' => (string)$adminId]), 'Service menolak perubahan akun sendiri', 403);
    rejects(fn() => (new Access($repo, $users->find($ownerId)))->demand('users.manage'), 'Role tanpa izin ditolak server-side', 403);
    rejects(fn() => $master->user(['name' => 'No Branch', 'email' => 'none@example.test', 'role_id' => (string)$roles['Owner'], 'password' => $password, 'active' => '1']), 'User scoped wajib memiliki cabang', 422);
    $items = require $root . '/app/navigation.php';
    $navigation = new Hls\Services\Navigation($items, require $root . '/app/routes.php');
    check(count(array_column($items, 'id')) === count(array_unique(array_column($items, 'id'))), 'ID registry navigasi unik');
    check(count($navigation->visible($access)) === 24, 'Registry route nyata termasuk Timesheet dan Verifikasi M5');
    check(array_column($navigation->shortcuts($access), 'id') === ['dashboard','users','branches','roles'], 'Shortcut admin dari registry yang sama');
    check(count($navigation->visible($scoped)) === 21, 'Registry memeriksa cakupan global');
    $owner = new Access($repo, $users->find($ownerId));
    check(count($navigation->visible($owner)) === 19, 'Registry Owner mencakup Equipment baca berizin');
    $globalOwner = new Access($repo, array_replace($users->find($ownerId), ['all_branches' => 1]));
    check(count($navigation->visible($globalOwner)) === 19, 'Cakupan global tidak memberikan permission menu');
    check(Hls\Http\Pagination::slice(range(1, 21), ['page' => '2'])['rows'][0] === 11, 'Pagination mengiris data nyata dengan benar');
    rejects(fn() => Hls\Http\Pagination::slice([], ['page' => '-1']), 'Pagination invalid ditolak', 422);
    $repo->run("CREATE TRIGGER test_audit_fail BEFORE INSERT ON audit_logs FOR EACH ROW SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='test audit rollback'");
    rejects(fn() => $master->branch(['code' => 'ROLLBACK', 'name' => 'Tidak tersimpan', 'active' => '1']), 'Mutasi gagal ketika audit gagal');
    check(!$repo->one("SELECT id FROM branches WHERE code='ROLLBACK'"), 'Rollback master saat audit gagal');
    rejects(fn() => $master->user(['name' => 'Rollback User', 'email' => 'rollback@example.test', 'role_id' => (string)$roles['Owner'], 'password' => $password, 'active' => '1', 'branches' => [(string)$a]]), 'Pembuatan pengguna gagal jika audit gagal');
    check(!$users->byEmail('rollback@example.test'), 'Rollback pengguna dan cabangnya saat audit gagal');
    $repo->run('DROP TRIGGER test_audit_fail');
    // Session timeout is verified without sleeping or changing production configuration.
    Hls\Services\Session::start($config);
    $auth = new Auth($users, $audit, $config); $auth->login('scoped@example.test', $password, 'test-cli');
    check($auth->current() !== null, 'Session login valid');
    check($auth->current(time() + 1801) === null && !isset($_SESSION['user_id']), 'Session idle timeout 30 menit');
    $auth->login('scoped@example.test', $password, 'test-cli');
    $repo->run('UPDATE users SET active=0 WHERE id=?', [$scopedId]);
    check($auth->current() === null, 'Session user nonaktif dibatalkan');
    rejects(fn() => $auth->login('scoped@example.test', $password, 'test-cli'), 'Login user nonaktif ditolak', 401);
    $repo->run('UPDATE users SET active=1 WHERE id=?', [$scopedId]);
    $auth->login('scoped@example.test', $password, 'test-cli');
    $repo->run('UPDATE users SET auth_version=auth_version+1 WHERE id=?', [$scopedId]);
    check($auth->current() === null, 'Perubahan akses mengakhiri sesi lama'); session_write_close();
    Hls\Services\Session::start($config);
    $auth->login('scoped@example.test', $password, 'test-cli');
    $newPassword = 'New!' . bin2hex(random_bytes(16));
    $master->user(['id' => (string)$scopedId, 'name' => 'Admin Cabang Uji', 'email' => 'scoped@example.test', 'role_id' => (string)$roles['Administrator'], 'password' => $newPassword, 'active' => '1', 'branches' => [(string)$a]]);
    check($auth->current() === null, 'Reset password melalui master membatalkan sesi');
    rejects(fn() => $auth->login('scoped@example.test', $password, 'test-cli'), 'Password lama ditolak setelah reset', 401);
    $auth->login('scoped@example.test', $newPassword, 'test-cli');
    check($auth->current() !== null, 'Password baru dapat login');
    $master->user(['id' => (string)$scopedId, 'name' => 'Admin Cabang Uji', 'email' => 'scoped@example.test', 'role_id' => (string)$roles['Administrator'], 'password' => $password, 'active' => '1', 'branches' => [(string)$a]]);
    session_write_close();
    $repo->run('DELETE FROM login_attempts');
    for ($i = 0; $i < 5; $i++) rejects(fn() => $auth->login('absent@example.test', 'incorrect', 'different-ip-' . $i), 'Login gagal dari IP berbeda ' . ($i + 1), 401);
    rejects(fn() => $auth->login('absent@example.test', 'incorrect', 'another-ip'), 'Rate limit per email lintas IP', 429);
    $repo->run('DELETE FROM login_attempts');
    file_put_contents($configPath, '<?php return ' . var_export($config, true) . ';'); $temporary[] = $configPath;
    $socket = stream_socket_server('tcp://127.0.0.1:0', $errno, $error); $address = stream_socket_get_name($socket, false); fclose($socket); $port = (int)substr(strrchr($address, ':'), 1); $base = 'http://127.0.0.1:' . $port;
    $env = getenv(); $env['HLS_V2_CONFIG'] = $configPath;
    $server = proc_open([PHP_BINARY, '-S', '127.0.0.1:' . $port, '-t', $root . '/public', $root . '/public/router.php'], [['pipe','r'], ['file', __DIR__ . '/results/server.log','a'], ['file', __DIR__ . '/results/server.log','a']], $pipes, $root, $env);
    if (!is_resource($server)) throw new RuntimeException('Tidak dapat menjalankan server uji.'); fclose($pipes[0]);
    $jar = __DIR__ . '/tmp/admin-' . $suffix . '.cookies'; $scopeJar = __DIR__ . '/tmp/scope-' . $suffix . '.cookies'; $ownerJar = __DIR__ . '/tmp/owner-' . $suffix . '.cookies'; $anonJar = __DIR__ . '/tmp/anon-' . $suffix . '.cookies'; array_push($temporary, $jar, $scopeJar, $ownerJar, $anonJar);
    $ready = false; for ($i = 0; $i < 40; $i++) { $s = @fsockopen('127.0.0.1', $port); if ($s) { fclose($s); $ready = true; break; } usleep(100000); }
    check($ready, 'Server HTTP uji tersedia');
    check(http('/users', $anonJar)['status'] === 303, 'Anonim dialihkan ke login');
    check(http('/login', $anonJar, ['email' => 'admin@example.test', 'password' => $password])['status'] === 403, 'Login tanpa CSRF ditolak');
    check(http('/login', $anonJar, ['csrf' => 'wrong', 'email' => 'admin@example.test', 'password' => $password])['status'] === 403, 'Login CSRF salah ditolak');
    check(login('admin@example.test', 'incorrect', $anonJar)['status'] === 401, 'Login password salah ditolak');
    $beforeCookies = file_get_contents($anonJar);
    $response = login('admin@example.test', $password, $anonJar);
    check($response['status'] === 303, 'Login HTTP berhasil');
    check(file_get_contents($anonJar) !== $beforeCookies, 'ID sesi diregenerasi saat login');
    check(str_contains(strtolower($response['headers']), 'httponly') && str_contains(strtolower($response['headers']), 'samesite=lax'), 'Cookie HttpOnly dan SameSite');
    check(str_contains(strtolower(http('/', $anonJar)['headers']), 'cache-control: no-store'), 'Halaman privat no-store');
    check(login('admin@example.test', $password, $jar)['status'] === 303, 'Administrator login');
    check(login('scoped@example.test', $password, $scopeJar)['status'] === 303, 'Admin scoped login');
    check(login('owner@example.test', $password, $ownerJar)['status'] === 303, 'Owner login');
    foreach (['/users', '/branches', '/roles', '/audit'] as $route) check(http($route, $jar)['status'] === 200, 'Route administrator ' . $route);
    foreach (['/users', '/roles', '/audit'] as $route) check(http($route, $scopeJar)['status'] === 403, 'Admin scoped dilarang ' . $route);
    foreach (['/users', '/roles', '/audit'] as $route) check(http($route, $ownerJar)['status'] === 403, 'Owner tanpa permission dilarang ' . $route);
    $page = http('/branches', $scopeJar); check(str_contains($page['body'], 'Cabang A Uji') && !str_contains($page['body'], 'Cabang B Privat'), 'Daftar cabang tidak bocor lintas cakupan');
    check(http('/branches?edit=' . $b, $scopeJar)['status'] === 403, 'ID cabang lain ditolak melalui URL');
    $scopeToken = token($page);
    check(http('/branches', $scopeJar, ['csrf' => $scopeToken, 'id' => (string)$b, 'code' => 'TESTB', 'name' => 'Ubah tanpa izin', 'active' => '1'])['status'] === 403, 'POST cabang lain ditolak');
    check(http('/users', $scopeJar, ['csrf' => $scopeToken])['status'] === 403, 'POST pengguna oleh admin scoped ditolak');
    check(http('/users', $ownerJar, ['csrf' => token(http('/', $ownerJar))])['status'] === 403, 'POST pengguna oleh pembaca ditolak');
    check(http('/branches', $jar, ['code' => 'BAD', 'name' => 'Tanpa CSRF'])['status'] === 403, 'Mutasi master tanpa CSRF ditolak');
    $t = token(http('/branches', $jar));
    check(http('/branches', $jar, ['csrf' => $t, 'code' => 'HTTP', 'name' => '<script>alert(1)</script>', 'active' => '1'])['status'] === 303, 'Create cabang HTTP berhasil');
    $page = http('/branches', $jar); check(str_contains($page['body'], '&lt;script&gt;') && !str_contains($page['body'], '<script>alert'), 'Output disimpan di-escape');
    check(http('/branches', $jar, ['csrf' => $t, 'code' => 'HTTP', 'name' => 'Duplikat', 'active' => '1'])['status'] === 409, 'Duplikasi cabang ditolak tanpa error SQL bocor');
    check(http('/branches', $jar, ['csrf' => $t, 'code' => ['array'], 'name' => 'Invalid'])['status'] === 422, 'Input array tidak valid ditolak');
    check(http('/branches', $jar, ['csrf' => $t, 'code' => "X';DROP", 'name' => 'SQL'])['status'] === 422, 'Payload SQL tidak lolos validasi');
    check(http('/logout', $jar)['status'] === 405, 'Logout GET ditolak');
    check(http('/logout', $jar, [])['status'] === 403, 'Logout tanpa CSRF ditolak');
    $oldToken = token(http('/', $jar)); $replayJar = __DIR__ . '/tmp/replay-' . $suffix . '.cookies'; copy($jar, $replayJar); $temporary[] = $replayJar;
    check(http('/logout', $jar, ['csrf' => $oldToken])['status'] === 303, 'Logout POST berhasil');
    check(http('/', $jar)['status'] === 303, 'Sesi logout tidak dapat mengakses halaman');
    check(http('/', $replayJar)['status'] === 303, 'Cookie lama tidak menghidupkan sesi logout');
    check(http('/login', $jar, ['csrf' => $oldToken, 'email' => 'admin@example.test', 'password' => $password])['status'] === 403, 'CSRF lama tidak dapat dipakai setelah logout');
    check(http('/does-not-exist', $anonJar)['status'] === 404, 'Route tak dikenal 404');
    check(http('/login', $anonJar, null, 'PUT')['status'] === 405, 'Metode route tidak tersedia 405');
    foreach (['/config/local.php', '/app/bootstrap.php', '/database/migrations/001_foundation.sql', '/storage/error.log', '/tests/run.php', '/bin/bootstrap-admin.php'] as $path) check(http($path, $anonJar)['status'] === 404, 'Server public root menutup ' . $path);
    $repo->run('DELETE FROM login_attempts');
    for ($i = 0; $i < 5; $i++) check(login('absent@example.test', 'wrong-password', $jar)['status'] === 401, 'Percobaan gagal tercatat ' . ($i + 1));
    check(login('admin@example.test', $password, $jar)['status'] === 429, 'Rate limit IP melindungi akun lain');
    check((int)$repo->one('SELECT COUNT(*) AS n FROM login_attempts')['n'] === 5, 'Lima kegagalan tersimpan');
    $repo->run('DELETE FROM login_attempts');
    $actions = array_column($repo->all('SELECT DISTINCT action FROM audit_logs'), 'action');
    foreach (['administrator_bootstrapped', 'master_created', 'user_created', 'login_failed', 'login_succeeded', 'login_limited', 'logout', 'session_invalidated'] as $action) check(in_array($action, $actions, true), 'Audit event ' . $action);
    $auditText = json_encode($repo->all('SELECT detail FROM audit_logs'));
    check(!str_contains($auditText, $password) && !str_contains($auditText, $oldToken) && !str_contains($auditText, 'password_hash'), 'Audit tanpa password/hash/token');
    $roleAccounts = [];
    foreach ($roles as $roleName => $roleId) {
        $email = $roleName === 'Administrator' ? 'admin@example.test' : ($roleName === 'Owner' ? 'owner@example.test' : 'role-' . $roleId . '@example.test');
        if (!in_array($roleName, ['Administrator','Owner'], true)) $master->user(['name' => 'Pengguna Uji ' . $roleName, 'email' => $email, 'role_id' => (string)$roleId, 'password' => $password, 'active' => '1', 'branches' => [(string)$a]]);
        $roleAccounts[] = ['role' => $roleName, 'email' => $email];
    }
    require __DIR__ . '/dashboard.php';
    require __DIR__ . '/master-data.php';
    require __DIR__ . '/expedition-access.php';
    require __DIR__ . '/concurrency.php';
    require __DIR__ . '/expedition.php';
    require __DIR__ . '/trucking-operations.php';
    require __DIR__ . '/phase5-audit-repairs.php';
    require __DIR__ . '/trucking-upgrade.php';
    require __DIR__ . '/equipment-contracts.php';
    require __DIR__ . '/equipment-handover-drafts.php';
    require __DIR__ . '/equipment-handovers.php';
    require __DIR__ . '/equipment-timesheets.php';
    $fixture = ['base' => $base, 'email' => 'admin@example.test', 'scopedEmail' => 'scoped@example.test', 'ownerEmail' => 'owner@example.test', 'password' => $password, 'branchA' => $a, 'branchB' => $b, 'roleAccounts' => $roleAccounts,'masterGroups'=>$catalog['groups'],'masterEntities'=>$catalog['entities'],'masterFixtures'=>$masterFixtures];
    $fixture['expedition']=$expeditionFixtures;
    $fixture['operations']=$operationFixtures;
    $fixture['equipment']=$equipmentFixtures;
    file_put_contents($fixturePath, json_encode($fixture)); $temporary[] = $fixturePath;
    $browser = proc_open(['node', __DIR__ . '/browser.cjs', $fixturePath], [['pipe','r'], ['file', __DIR__ . '/results/browser-run.log','w'], ['file', __DIR__ . '/results/browser-run.log','a']], $browserPipes, $root);
    if (!is_resource($browser)) throw new RuntimeException('Browser runner tidak dapat dijalankan.'); fclose($browserPipes[0]);
    check(proc_close($browser) === 0, 'Browser desktop/mobile fondasi lulus');
} catch (Throwable $e) { $failure = $e->getMessage(); }
finally {
    if (is_resource($server)) { proc_terminate($server); proc_close($server); }
    $repo = null; $users = null; $db = null;
    if ($adminDb) {
        try { Hls\Config::databaseName($database); $adminDb->exec("DROP DATABASE IF EXISTS `$database`"); $adminDb->exec("DROP USER IF EXISTS '$account'@'127.0.0.1'"); } catch (Throwable $cleanup) { $failure = ($failure ? $failure . '; ' : '') . 'Cleanup gagal: ' . $cleanup->getMessage(); }
    }
    foreach ($temporary as $path) if (is_file($path)) unlink($path);
    if (isset($sessionDirectory) && is_dir($sessionDirectory . '/claims')) { foreach (glob($sessionDirectory . '/claims/*') as $proof) unlink($proof); rmdir($sessionDirectory . '/claims'); }
    if (isset($sessionDirectory) && is_dir($sessionDirectory . '/equipment')) { foreach (glob($sessionDirectory . '/equipment/*') as $proof) unlink($proof); rmdir($sessionDirectory . '/equipment'); }
    if (isset($sessionDirectory) && is_dir($sessionDirectory)) { foreach (glob($sessionDirectory . '/sess_*') as $file) unlink($file); rmdir($sessionDirectory); }
}
$report = ['date' => date(DATE_ATOM), 'database_engine' => 'MariaDB', 'checks' => $checks, 'passed' => count(array_filter($checks, fn($c) => $c['passed'])), 'failure' => $failure, 'temporary_database_removed' => $adminDb ? !(bool)$adminDb->query("SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME=" . $adminDb->quote($database))->fetchColumn() : null];
file_put_contents(__DIR__ . '/results/foundation.json', json_encode($report, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
echo $report['passed'] . " pemeriksaan lulus.\n"; if ($failure) { fwrite(STDERR, $failure . "\n"); exit(1); } echo "Fondasi dan browser lulus; DB/akun/credential uji dibersihkan.\n";

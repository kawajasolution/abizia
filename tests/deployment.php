<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
$results = []; $failed = false;
foreach (['/hls-v2/' => 403, '/hls-v2/public/assets/equipment-timesheets.js'=>200, '/hls-v2/storage/private/claims/example' => 403, '/hls-v2/public/trucking/evidence?id=1' => 303, '/hls-v2/config/local.php' => 403, '/hls-v2/app/bootstrap.php' => 403, '/hls-v2/database/migrations/001_foundation.sql' => 403, '/hls-v2/storage/error.log' => 403, '/hls-v2/tests/run.php' => 403, '/hls-v2/bin/bootstrap-admin.php' => 403, '/hls-v2/public/router.php' => 403, '/hls-v2/public/login' => 200, '/hls-v2/public/assets/foundation.css' => 200, '/hls-v2/public/assets/images/logo.png' => 200, '/hls-v2/public/assets/interface.js' => 200, '/hls-v2/app/navigation.php' => 403] as $path => $expected) {
    $ch = curl_init('http://127.0.0.1' . $path); curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 5]); $body = curl_exec($ch); $status = curl_getinfo($ch, CURLINFO_HTTP_CODE); curl_close($ch);
    $pass = $status === $expected;
    if ($expected === 403) $pass = $pass && !str_contains((string)$body, '<?php') && !str_contains((string)$body, 'CREATE TABLE');
    $results[] = ['path' => $path, 'status' => $status, 'expected' => $expected, 'passed' => $pass]; $failed = $failed || !$pass;
}
$config = Hls\Config::load(); $db = Hls\Database::connect($config);
$counts = ['tables' => count($db->query('SHOW TABLES')->fetchAll()), 'users' => (int)$db->query('SELECT COUNT(*) FROM users')->fetchColumn(), 'roles' => (int)$db->query('SELECT COUNT(*) FROM roles')->fetchColumn(), 'branches' => (int)$db->query('SELECT COUNT(*) FROM branches')->fetchColumn()];
$counts['permissions'] = (int)$db->query('SELECT COUNT(*) FROM permissions')->fetchColumn();
$counts['master_rows'] = [];
$counts['trucking_rows'] = [];
foreach (['exp_dns','exp_manifests','exp_manifest_items','exp_events','exp_trip_legs','exp_sequences','exp_requests','exp_receipts','exp_claims','exp_claim_events','exp_evidence'] as $table) {
    $counts['trucking_rows'][$table] = (int)$db->query('SELECT COUNT(*) FROM ' . $table)->fetchColumn();
}
foreach (['md_customers','md_parties','md_locations','md_routes','md_assets','md_personnel','md_trucking_tariffs','md_equipment_tariffs','md_categories','md_units','md_items','md_suppliers'] as $table) {
    $counts['master_rows'][$table] = (int)$db->query('SELECT COUNT(*) FROM ' . $table)->fetchColumn();
}
$grants = $db->query('SHOW GRANTS')->fetchAll(PDO::FETCH_COLUMN);
$isolated = true;
foreach ($grants as $grant) if (!str_contains($grant, 'GRANT USAGE ON *.*') && !str_contains($grant, 'ON `hls_v2_dev`.*')) $isolated = false;
$results[] = ['name' => 'Akun database hanya memiliki akses hls_v2_dev', 'passed' => $isolated];
$failed = $failed || !$isolated || $counts['tables'] !== 48 || $counts['roles'] !== 10;
file_put_contents(__DIR__ . '/results/deployment.json', json_encode(['date' => date(DATE_ATOM), 'database_version' => $db->query('SELECT VERSION()')->fetchColumn(), 'development' => $counts, 'checks' => $results, 'passed' => !$failed], JSON_PRETTY_PRINT));
foreach ($results as $result) echo ($result['passed'] ? 'PASS ' : 'FAIL ') . ($result['path'] ?? $result['name']) . PHP_EOL;
exit($failed ? 1 : 0);

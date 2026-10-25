<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
use Hls\Http\HttpError;
use Hls\Http\View;
header('Content-Type: text/html; charset=UTF-8');
header('Cache-Control: no-store');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('Referrer-Policy: no-referrer');
header("Content-Security-Policy: default-src 'self'; style-src 'self'; script-src 'self'; img-src 'self'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'");
$view = null;
try {
    $config = Hls\Config::load();
    if ($config['secure_cookie'] && (empty($_SERVER['HTTPS']) || $_SERVER['HTTPS'] === 'off')) throw new HttpError(403, 'Koneksi HTTPS diperlukan.');
    Hls\Services\Session::start($config);
    $repo = new Hls\Repositories\Repository(Hls\Database::connect($config));
    $users = new Hls\Repositories\UserRepository($repo->db); $audit = new Hls\Services\Audit($repo);
    $auth = new Hls\Services\Auth($users, $audit, $config); $user = $auth->current();
    $access = $user ? new Hls\Middleware\Access($repo, $user) : null;
    $view = new View($config, $access);
    $truckingData=$access?new Hls\Repositories\ExpeditionRepository($repo,new Hls\Services\ExpeditionAccess($repo,$access)):null;
    $trucking=$truckingData?new Hls\Services\TruckingOperations($truckingData,$audit):null;
    $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    if (!is_string($path) || ($config['base_path'] !== '' && $path !== $config['base_path'] && !str_starts_with($path, $config['base_path'] . '/'))) throw new HttpError(404, 'Halaman tidak ditemukan.');
    $path = substr($path, strlen($config['base_path'])) ?: '/';
    [$controller, $action, $permission, $required] = (new Hls\Http\Router(require dirname(__DIR__) . '/app/routes.php'))->resolve($_SERVER['REQUEST_METHOD'], $path);
    if ($required && !$user) $view->redirect('/login');
    if ($permission) $access->demand($permission);
    if ($_SERVER['REQUEST_METHOD'] === 'POST') Hls\Services\Csrf::verify($_POST['csrf'] ?? null);
    $handler = match ($controller) {
        'timesheets','my-timesheets' => new Hls\Controllers\EquipmentTimesheetController(new Hls\Services\EquipmentTimesheets(new Hls\Repositories\EquipmentTimesheetRepository(new Hls\Repositories\EquipmentRepository($repo,new Hls\Services\EquipmentAccess($repo,$access)),$controller==='my-timesheets'),$audit),$view),
        'p2h' => new Hls\Controllers\EquipmentP2HController($repo,$view,$access,$audit),
        'work-orders' => new Hls\Controllers\MaintenanceWorkOrderController($repo,$view,$access,$audit),
        'preventive' => new Hls\Controllers\MaintenancePmController($repo,$view,$access,$audit),
        'cost-rates' => new Hls\Controllers\MaintenanceCostController($repo,$view,$access,$audit),
        'handover' => (function()use($repo,$access,$audit,$config,$view){$ba=new Hls\Services\EquipmentHandovers(new Hls\Repositories\EquipmentHandoverRepository(new Hls\Repositories\EquipmentRepository($repo,new Hls\Services\EquipmentAccess($repo,$access))),$audit);return new Hls\Controllers\EquipmentHandoverController($ba,new Hls\Services\EquipmentHandoverEvidence($ba,$audit,$config['equipment_dir']??dirname(__DIR__).'/storage/private/equipment'),$view);})(),
        'equipment' => new Hls\Controllers\EquipmentController(new Hls\Services\EquipmentContracts(new Hls\Repositories\EquipmentRepository($repo,new Hls\Services\EquipmentAccess($repo,$access)),$audit),$view),
        'auth' => new Hls\Controllers\AuthController($auth, $view, $user),
        'operations' => new Hls\Controllers\OperationsController($trucking,new Hls\Services\Claims($trucking->records,$trucking->write,$audit,$config['claim_dir']??dirname(__DIR__).'/storage/private/claims'),$view),
        'expedition' => new Hls\Controllers\ExpeditionController(new Hls\Services\Expedition(new Hls\Repositories\ExpeditionRepository($repo,new Hls\Services\ExpeditionAccess($repo,$access)),$audit),$view),
        'dashboard' => new Hls\Controllers\DashboardController(new Hls\Services\Dashboard(new Hls\Repositories\DashboardRepository($repo,$access),$access,require dirname(__DIR__).'/app/dashboard.php',new Hls\Services\Navigation(require dirname(__DIR__).'/app/navigation.php',require dirname(__DIR__).'/app/routes.php')),$view),
        'foundation' => new Hls\Controllers\FoundationController($repo, $users, $access, new Hls\Services\MasterService($repo, $access, $audit), $view),
        'master' => new Hls\Controllers\MasterDataController(new Hls\Services\MasterData(new Hls\Repositories\MasterDataRepository($repo,$access,require dirname(__DIR__).'/app/master-data.php'),$audit),$view),
        'finance' => new Hls\Controllers\FinanceController($repo,$view,$access,$audit),
        'invoice' => new Hls\Controllers\FinanceInvoiceController($repo,$view,$access,$audit),
        'receivable' => new Hls\Controllers\FinanceReceivableController($repo,$view,$access,$audit),
        'inventory' => new Hls\Controllers\InventoryController($repo,$view,$access,$audit),
        'payables' => new Hls\Controllers\FinancePayableController($repo,$view,$access,$audit),
        'payment-history' => new Hls\Controllers\FinancePaymentHistoryController($repo,$view,$access),
        default => throw new HttpError(404,'Halaman tidak ditemukan.'),
    };
    $handler->$action();
} catch (Throwable $e) {
    $status = $e instanceof HttpError ? $e->status : ($e instanceof PDOException && $e->getCode() === '23000' ? 409 : 500);
    http_response_code($status);
    if ($status === 405) header('Allow: ' . implode(', ', array_keys((require dirname(__DIR__) . '/app/routes.php')[$path] ?? [])));
    if ($status === 429) header('Retry-After: 900');
    if ($status === 500) error_log('HLS v2 request failed: ' . get_class($e) . ' code=' . $e->getCode());
    $message = $e instanceof HttpError ? $e->getMessage() : ($status === 409 ? 'Kode atau email sudah digunakan. Periksa data sebelum mencoba kembali.' : 'Layanan belum tersedia. Hubungi administrator.');
    if ($view) $view->render('error', ['title' => 'Permintaan tidak dapat diproses', 'message' => $message]);
    else echo '<!doctype html><html lang="id"><meta charset="utf-8"><title>Layanan belum tersedia</title><p>' . View::escape($message) . '</p></html>';
}


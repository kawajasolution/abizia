<?php
declare(strict_types=1);
// Router only for the local PHP development server; Apache uses .htaccess.
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
if (is_string($path) && (preg_match('~^/assets/[a-z0-9-]+\.css$~D', $path) || in_array($path, ['/assets/interface.js', '/assets/equipment-timesheets.js', '/assets/images/logo.png'], true)) && is_file(__DIR__ . $path)) return false;
require __DIR__ . '/index.php';

<?php
declare(strict_types=1);
spl_autoload_register(static function (string $name): void {
    if (str_starts_with($name, 'Hls\\')) {
        $file = __DIR__ . '/' . str_replace('\\', '/', substr($name, 4)) . '.php';
        if (is_file($file)) require $file;
    }
});
date_default_timezone_set('Asia/Makassar');
ini_set('display_errors', '0');
ini_set('log_errors', '1');
ini_set('error_log', dirname(__DIR__) . '/storage/error.log');

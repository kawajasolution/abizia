<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
try { $config = Hls\Config::load(); echo Hls\Services\Migrator::install(Hls\Database::connect($config), $config['database']) ? "Migration terpasang.\n" : "Migration sudah terpasang; tidak ada perubahan.\n"; }
catch (Throwable $e) { fwrite(STDERR, $e->getMessage() . "\n"); exit(1); }

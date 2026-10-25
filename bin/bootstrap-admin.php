<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
try {
    if (count($argv) !== 3) throw new RuntimeException('Gunakan: php bin/bootstrap-admin.php "Nama" email. Password dibaca dari STDIN terproteksi, bukan argumen.');
    if (function_exists('stream_isatty') && stream_isatty(STDIN)) throw new RuntimeException('Jangan ketik password pada terminal terbuka. Gunakan bin/bootstrap-admin.ps1 (input tersembunyi).');
    $password = rtrim(stream_get_contents(STDIN), "\r\n");
    $config = Hls\Config::load();
    Hls\Services\BootstrapAdmin::create(new Hls\Repositories\Repository(Hls\Database::connect($config)), $argv[1], $argv[2], $password);
    unset($password); echo "Administrator awal dibuat. Tidak ada password yang ditampilkan.\n";
} catch (Throwable $e) { fwrite(STDERR, $e->getMessage() . "\n"); exit(1); }

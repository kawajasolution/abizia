<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
try {
    $path = dirname(__DIR__) . '/config/local.php';
    if (is_file($path)) throw new RuntimeException('Konfigurasi sudah ada. Gunakan migrate.php, bukan provision ulang.');
    $db = new PDO('mysql:host=127.0.0.1;port=3306;charset=utf8mb4', getenv('HLS_DB_ADMIN_USER') ?: 'root', getenv('HLS_DB_ADMIN_PASSWORD') ?: '', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    if ($db->query("SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='hls_v2_dev'")->fetchColumn()) throw new RuntimeException('Database target sudah ada; provision dihentikan.');
    if ($db->query("SELECT COUNT(*) FROM mysql.user WHERE User='hls_v2_app'")->fetchColumn()) throw new RuntimeException('Akun target sudah ada; provision dihentikan.');
    $password = bin2hex(random_bytes(32));
    $db->exec('CREATE DATABASE hls_v2_dev CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
    $db->exec("CREATE USER 'hls_v2_app'@'127.0.0.1' IDENTIFIED BY " . $db->quote($password));
    $db->exec("GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER,INDEX,REFERENCES ON hls_v2_dev.* TO 'hls_v2_app'@'127.0.0.1'");
    $config = ['host' => '127.0.0.1', 'port' => 3306, 'database' => 'hls_v2_dev', 'username' => 'hls_v2_app', 'password' => $password, 'base_path' => '/hls-v2/public', 'secure_cookie' => false, 'idle_timeout' => 1800];
    Hls\Services\Migrator::install(Hls\Database::connect($config), 'hls_v2_dev');
    if (file_put_contents($path, "<?php\nreturn " . var_export($config, true) . ";\n", LOCK_EX) === false) throw new RuntimeException('Gagal menyimpan konfigurasi privat.');
    echo "Database development baru dan migration fondasi terpasang. Tidak ada akun aplikasi dibuat.\n";
} catch (Throwable $e) { fwrite(STDERR, "Setup gagal: " . $e->getMessage() . "\n"); exit(1); }

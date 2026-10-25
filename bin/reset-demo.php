<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
try {$admin=new PDO('mysql:host=127.0.0.1;port=3306;charset=utf8mb4',getenv('HLS_DB_ADMIN_USER')?:'root',getenv('HLS_DB_ADMIN_PASSWORD')?:'', [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);$db=$admin->query("SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='hls_v2_demo'")->fetchColumn();if($db!=='hls_v2_demo')throw new RuntimeException('Reset hanya boleh hls_v2_demo.');if(($argv[1]??'')!=='RESET-DEMO')throw new RuntimeException('Konfirmasi wajib: php bin/reset-demo.php RESET-DEMO');$admin->exec('DROP DATABASE hls_v2_demo');$admin->exec("DROP USER IF EXISTS 'hls_v2_demo_app'@'127.0.0.1'");echo "Demo database removed; rerun setup-demo.php to recreate.\n";}catch(Throwable $e){fwrite(STDERR,$e->getMessage()."\n");exit(1);}

<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);
$root = dirname(__DIR__); $configPath = $root . '/config/demo.php';
try {
    $admin = new PDO('mysql:host=127.0.0.1;port=3306;charset=utf8mb4', getenv('HLS_DB_ADMIN_USER') ?: 'root', getenv('HLS_DB_ADMIN_PASSWORD') ?: '', [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
    if ((int)$admin->query("SELECT COUNT(*) FROM information_schema.SCHEMATA WHERE SCHEMA_NAME='hls_v2_demo'")->fetchColumn()) throw new RuntimeException('hls_v2_demo sudah ada; gunakan reset-demo.php setelah verifikasi.');
    $dbPassword = bin2hex(random_bytes(32));
    $admin->exec('CREATE DATABASE hls_v2_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
    $admin->exec("CREATE USER 'hls_v2_demo_app'@'127.0.0.1' IDENTIFIED BY " . $admin->quote($dbPassword));
    $admin->exec("GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,ALTER,INDEX,REFERENCES ON hls_v2_demo.* TO 'hls_v2_demo_app'@'127.0.0.1'");
    $config=['host'=>'127.0.0.1','port'=>3306,'database'=>'hls_v2_demo','username'=>'hls_v2_demo_app','password'=>$dbPassword,'base_path'=>'/hls-v2/public','secure_cookie'=>false,'idle_timeout'=>1800];
    Hls\Services\Migrator::install(Hls\Database::connect($config),'hls_v2_demo');
    $repo=new Hls\Repositories\Repository(Hls\Database::connect($config));
    $repo->run("INSERT INTO branches(code,name,address,active) VALUES ('DMO','DEMO HLS','Data simulasi DEMO',1)"); $branch=(int)$repo->db->lastInsertId();
    $roles=$repo->all('SELECT id,name FROM roles'); $passwords=[];
    foreach($roles as $role){$slug=trim((string)preg_replace('/[^a-z0-9]+/','_',strtolower($role['name'])),'_');$email='demo_'.$slug.'@demo.invalid';$plain=$role['name']==='Administrator'?bin2hex(random_bytes(18)):'123456';$hash=password_hash($plain,PASSWORD_DEFAULT);$all=$role['name']==='Administrator'?1:0;$repo->run('INSERT INTO users(name,email,password_hash,role_id,active,all_branches) VALUES (?,?,?,?,1,?)',['Demo '.$role['name'],$email,$hash,$role['id'],$all]);$uid=(int)$repo->db->lastInsertId();$repo->run('INSERT INTO user_branches(user_id,branch_id) VALUES (?,?)',[$uid,$branch]);$passwords[$email]=$plain;}
    if (file_put_contents($configPath,"<?php\nreturn ".var_export($config,true).";\n",LOCK_EX)===false) throw new RuntimeException('Gagal menulis config/demo.php');
    file_put_contents($root.'/storage/private/demo-credentials.txt',"Generated once by setup-demo.php. Remove after secure handoff.\n".json_encode($passwords,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n",LOCK_EX);
    echo "Demo database and accounts created. Credentials are in storage/private/demo-credentials.txt; do not publish.\n";
} catch(Throwable $e){fwrite(STDERR,"Setup demo gagal: ".$e->getMessage()."\n");exit(1);}

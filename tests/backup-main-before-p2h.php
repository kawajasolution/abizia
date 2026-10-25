<?php
declare(strict_types=1);
require dirname(__DIR__).'/app/bootstrap.php';
$c=require dirname(__DIR__).'/config/main.php'; $db=Hls\Database::connect($c);
$out=dirname(__DIR__).'/storage/private/backups/hls_v2_pre_p2h_'.date('Ymd_His').'.sql';
$tables=$db->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN); $sql="-- hls_v2 pre-P2H backup\n";
foreach($tables as $t){$q=$db->query('SHOW CREATE TABLE `'.str_replace('`','``',$t).'`')->fetch(PDO::FETCH_NUM);$sql.="DROP TABLE IF EXISTS `{$t}`;\n{$q[1]};\n";foreach($db->query('SELECT * FROM `'.str_replace('`','``',$t).'`')->fetchAll(PDO::FETCH_ASSOC) as $row){$cols=array_map(fn($v)=>'`'.str_replace('`','``',$v).'`',array_keys($row));$vals=array_map(fn($v)=>$v===null?'NULL':$db->quote((string)$v),array_values($row));$sql.='INSERT INTO `'.$t.'`('.implode(',',$cols).') VALUES ('.implode(',',$vals).');'."\n";}}
if(file_put_contents($out,$sql)===false)throw new RuntimeException('backup gagal'); if(filesize($out)<100)throw new RuntimeException('backup kosong'); echo $out.PHP_EOL.'bytes='.filesize($out).PHP_EOL.'tables='.count($tables).PHP_EOL;

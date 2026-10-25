<?php
declare(strict_types=1);
require dirname(__DIR__).'/app/bootstrap.php';
$config=require dirname(__DIR__).'/config/main.php';
$db=Hls\Database::connect($config);
foreach(['030_equipment_p2h','031_equipment_unit_holds'] as $m){$r=$db->prepare('SELECT version FROM schema_migrations WHERE version=?');$r->execute([$m]);echo $m.':'.($r->fetch()?'APPLIED':'MISSING').PHP_EOL;}
foreach(['eq_p2h_inspections','eq_p2h_items','eq_unit_holds'] as $t){$r=$db->prepare('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?');$r->execute([$t]);echo $t.':'.((int)$r->fetchColumn()===1?'PRESENT':'MISSING').PHP_EOL;}

<?php
declare(strict_types=1);
$root=dirname(__DIR__);$checks=[];
$check=function(string $name,bool $ok)use(&$checks):void{$checks[]=['name'=>$name,'passed'=>$ok];};
$service=file_get_contents($root.'/app/Services/EquipmentTimesheets.php');
$view=file_get_contents($root.'/app/Views/equipment-timesheets.php');
$routes=file_get_contents($root.'/app/routes.php');
$check('advanced fields validated',str_contains($service,'breakdown_note')&&str_contains($service,'billable_hours')&&str_contains($service,'standby_hours'));
$check('snapshot stores advanced fields',str_contains($service,"project_location'" )&&str_contains($service,"billable_reason'"));
$check('UI captures advanced fields',str_contains($view,'Jam Standby')&&str_contains($view,'Jam Breakdown')&&str_contains($view,'Jam Billable Terverifikasi'));
$check('print mode available',str_contains($routes,'/equipment/timesheets')&&str_contains($view,'mode=print'));
$check('existing workflow routes preserved',str_contains($routes,'/equipment/verification')&&str_contains($service,"status']!=='SUBMITTED'"));
$failed=array_filter($checks,fn($c)=>!$c['passed']);foreach($checks as $c)echo ($c['passed']?'PASS: ':'FAIL: ').$c['name'].PHP_EOL;exit($failed?1:0);

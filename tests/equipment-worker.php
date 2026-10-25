<?php
declare(strict_types=1);
require dirname(__DIR__).'/app/bootstrap.php';
if(PHP_SAPI!=='cli')exit(1);
$config=require $argv[1];if(!preg_match('/^hls_v2_test_[a-f0-9]{12}$/D',$config['database']))exit(2);
$p=json_decode(stream_get_contents(STDIN),true,512,JSON_THROW_ON_ERROR);$repo=new Hls\Repositories\Repository(Hls\Database::connect($config));$actor=(new Hls\Repositories\UserRepository($repo->db))->find($p['actor']);
$service=new Hls\Services\EquipmentContracts(new Hls\Repositories\EquipmentRepository($repo,new Hls\Services\EquipmentAccess($repo,new Hls\Middleware\Access($repo,$actor))),new Hls\Services\Audit($repo));
file_put_contents($p['ready'],'ready');$deadline=microtime(true)+15;while(!is_file($p['gate'])&&microtime(true)<$deadline)usleep(10000);if(!is_file($p['gate']))exit(2);
try{if(($p['operation']??'contract')==='decide'){$ts=new Hls\Services\EquipmentTimesheets(new Hls\Repositories\EquipmentTimesheetRepository($service->data),new Hls\Services\Audit($repo));$ts->decide($p['root'],$p['revision'],$p['version'],$p['revision_version'],$p['hash'],$p['decision'],$p['note']??'',$p['key']);}elseif(($p['operation']??'contract')==='handover'){$ba=new Hls\Services\EquipmentHandovers(new Hls\Repositories\EquipmentHandoverRepository($service->data),new Hls\Services\Audit($repo));$ba->confirm($p['handover'],$p['version'],$p['key']);}else $service->confirm($p['contract'],$p['version'],$p['key']);echo 'OK';}catch(Hls\Http\HttpError $e){echo $e->status===409?'CONFLICT':'ERROR:'.$e->status.':'.$e->getMessage();}catch(Throwable $e){echo 'ERROR:'.get_class($e).':'.$e->getMessage();}

<?php
declare(strict_types=1);
require dirname(__DIR__).'/app/bootstrap.php';
if(PHP_SAPI!=='cli')exit(1);
$config=require $argv[1];if(!preg_match('/^hls_v2_test_[a-f0-9]{12}$/D',$config['database']))exit(2);
$payload=json_decode(stream_get_contents(STDIN),true,512,JSON_THROW_ON_ERROR);
$repo=new Hls\Repositories\Repository(Hls\Database::connect($config));$user=(new Hls\Repositories\UserRepository($repo->db))->find($payload['actor']);
$service=new Hls\Services\Expedition(new Hls\Repositories\ExpeditionRepository($repo,new Hls\Services\ExpeditionAccess($repo,new Hls\Middleware\Access($repo,$user))),new Hls\Services\Audit($repo));
if(isset($payload['gate'],$payload['ready'])){file_put_contents($payload['ready'],'ready');$deadline=microtime(true)+15;while(!is_file($payload['gate'])&&microtime(true)<$deadline)usleep(10000);if(!is_file($payload['gate']))exit(2);}
try{if(($payload['operation']??'')==='confirm')(new Hls\Services\TruckingOperations($service->data,new Hls\Services\Audit($repo)))->confirmDn($payload['dn'],$payload['version'],$payload['key']);elseif(($payload['operation']??'')==='receive')(new Hls\Services\TruckingOperations($service->data,new Hls\Services\Audit($repo)))->receive($payload['dn'],$payload['version'],$payload['key'],['recipient_name'=>'Penerima concurrency','condition_note'=>'Utuh','whole_confirm'=>'1']);else $service->attach($payload['manifest'],[(string)$payload['dn']],1);echo 'OK';}
catch(Hls\Http\HttpError $e){echo $e->status===409?'CONFLICT':'ERROR';}
catch(Throwable $e){echo 'ERROR:'.get_class($e).':'.$e->getCode();}

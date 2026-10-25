<?php
declare(strict_types=1);
function expeditionWorkers(array $payloads,string $worker='expedition-worker.php'): array
{
    global $root,$configPath,$temporary;
    $gate=__DIR__.'/tmp/race-'.bin2hex(random_bytes(8));$temporary[]=$gate;$jobs=[];$ready=[];
    try{
        foreach($payloads as $index=>$payload){
            $marker=$gate.'.'.$index.'.ready';$ready[]=$marker;$temporary[]=$marker;$payload+=['gate'=>$gate,'ready'=>$marker];$pipes=[];
            if(!in_array($worker,['expedition-worker.php','equipment-worker.php'],true))throw new RuntimeException('Worker tidak sah.');
            $process=proc_open([PHP_BINARY,__DIR__.'/'.$worker,$configPath],[['pipe','r'],['pipe','w'],['pipe','w']],$pipes,$root);
            if(!is_resource($process))throw new RuntimeException('Worker V2 tidak dapat dibuat.');$jobs[]=[$process,$pipes];
            fwrite($pipes[0],json_encode($payload,JSON_THROW_ON_ERROR));fclose($pipes[0]);
        }
        $deadline=microtime(true)+10;do{$all=true;foreach($ready as $marker)if(!is_file($marker))$all=false;if(!$all)usleep(10000);}while(!$all&&microtime(true)<$deadline);
        if(!$all)throw new RuntimeException('Worker concurrency belum siap.');file_put_contents($gate,'go');$results=[];
        foreach($jobs as [$process,$pipes]){$results[]=stream_get_contents($pipes[1]);$stderr=stream_get_contents($pipes[2]);fclose($pipes[1]);fclose($pipes[2]);check(proc_close($process)===0&&$stderr==='','Worker V2 melewati barrier dan selesai tanpa error');}
        return $results;
    }finally{
        foreach($jobs as [$process,$pipes]){foreach($pipes as $pipe)if(is_resource($pipe))fclose($pipe);if(is_resource($process)){proc_terminate($process);proc_close($process);}}
        foreach([$gate,...$ready] as $path)if(is_file($path))unlink($path);
    }
}

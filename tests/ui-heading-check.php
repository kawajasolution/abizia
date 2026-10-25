<?php
declare(strict_types=1);
$files = array_merge(glob(__DIR__.'/../app/Views/*.php') ?: [], glob(__DIR__.'/../app/Views/components/*.php') ?: []);
$bad=[];
foreach ($files as $file) { $html=file_get_contents($file); preg_match_all('/<h1\b[^>]*>(.*?)<\/h1>/is',$html,$h1); if(count($h1[0])>1)$bad[]=$file.': multiple h1'; }
foreach (['Rekening kas dan bank','Kategori pengeluaran','Daftar Rekening','Daftar Kategori'] as $forbidden) foreach ($files as $file) { $html=(string)file_get_contents($file); if(preg_match('/<(?:h[1-6]|caption|\.panel-heading)[^>]*>[^<]*'.preg_quote($forbidden,'/').'[^<]*<\/(?:h[1-6]|caption)>/i',$html)) $bad[]=$file.': repeated heading text '.$forbidden; }
if($bad){fwrite(STDERR,implode(PHP_EOL,$bad).PHP_EOL);exit(1);} echo 'UI heading check passed: '.count($files).' view files'.PHP_EOL;

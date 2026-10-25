<?php
$c=require 'config/main.php';
$p=new PDO('mysql:host=127.0.0.1;dbname=hls_v2',$c['username'],$c['password']);
foreach(['branches','md_customers','md_suppliers','users'] as $t){echo $t."\n";echo $p->query("SHOW CREATE TABLE $t")->fetch(PDO::FETCH_NUM)[1]."\n";}

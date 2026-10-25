<?php
declare(strict_types=1);
$root=dirname(__DIR__);$s=file_get_contents($root.'/app/Services/EquipmentHandovers.php');$v=file_get_contents($root.'/app/Views/equipment-handovers.php');$r=file_get_contents($root.'/app/routes.php');
$checks=['metadata snapshot'=>str_contains($s,'bast_meta'),'signatory fields'=>str_contains($v,'Pihak Penyerah')&&str_contains($v,'Pihak Penerima'),'condition checklist'=>str_contains($v,'Kondisi Hidrolik')&&str_contains($v,'Kelengkapan Unit'),'existing handover routes'=>str_contains($r,'/equipment/handovers'),'evidence workflow'=>str_contains($s,'EquipmentHandoverEvidence')||str_contains($v,'Bukti Pendukung'),'read-only confirmed'=>str_contains($s,"['status']!=='DRAFT'")];
$failed=0;foreach($checks as $name=>$ok){echo ($ok?'PASS: ':'FAIL: ').$name.PHP_EOL;if(!$ok)$failed++;}exit($failed?1:0);

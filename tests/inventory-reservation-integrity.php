<?php
declare(strict_types=1);
$checks=['app/Controllers/InventoryController.php','app/Services/Migrator.php','app/routes.php','app/navigation.php','app/Views/inventory-reservations.php','app/Views/inventory-reservation-detail.php','database/migrations/029_inventory_reservations.sql'];
foreach($checks as $f){if(!is_file($f))throw new RuntimeException("missing $f");}
$c=file_get_contents('app/Controllers/InventoryController.php');foreach(['reservations','reservationSave','reservationDetail','reservationTransition','FOR UPDATE','quantity_reserved'] as $x)if(strpos($c,$x)===false)throw new RuntimeException("missing $x");
$r=file_get_contents('app/routes.php');if(strpos($r,'/inventory/reservations')===false)throw new RuntimeException('route missing');echo "reservation static checks passed\n";

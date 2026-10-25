<?php
declare(strict_types=1);
// Isolated local demo front controller. It selects demo.php before the shared app front controller.
putenv('HLS_V2_CONFIG=' . dirname(__DIR__, 2) . '/config/demo.php');
require dirname(__DIR__) . '/index.php';

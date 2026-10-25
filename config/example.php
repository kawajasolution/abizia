<?php
// Copy to config/local.php. Never publish the project root as document root.
return [
    'database' => 'hls_v2_dev', 'host' => '127.0.0.1', 'port' => 3306,
    'username' => 'hls_v2_app', 'password' => '',
    'base_path' => '/hls-v2/public', 'secure_cookie' => false,
    'idle_timeout' => 1800,
];

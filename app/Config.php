<?php
declare(strict_types=1);
namespace Hls;
final class Config
{
    public static function load(): array
    {
        $path = getenv('HLS_V2_CONFIG') ?: dirname(__DIR__) . '/config/local.php';
        if (!is_file($path)) throw new \RuntimeException('Konfigurasi lokal belum tersedia.');
        $config = require $path;
        self::databaseName((string)($config['database'] ?? ''));
        if (!is_string($config['base_path'] ?? null) || !preg_match('~^(?:/[a-zA-Z0-9_-]+)*$~D', $config['base_path'])) throw new \RuntimeException('Base path tidak valid.');
        if (($config['username'] ?? '') === 'root' || empty($config['password'])) throw new \RuntimeException('Gunakan akun database khusus dengan password.');
        return $config;
    }
    public static function databaseName(string $name): void
    {
        if (!preg_match('/^(?:hls_v2|hls_v2_(?:dev|demo|test_[a-f0-9]{12}))$/D', $name)) throw new \RuntimeException('Target database harus hls_v2, development, demo, atau test HLS v2.');
    }
}

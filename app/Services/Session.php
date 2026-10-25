<?php
declare(strict_types=1);
namespace Hls\Services;
final class Session
{
    public static function start(array $config): void
    {
        $directory = $config['session_dir'] ?? dirname(__DIR__, 2) . '/storage/sessions';
        if (!is_dir($directory) && !mkdir($directory, 0700, true) && !is_dir($directory)) throw new \RuntimeException('Penyimpanan sesi tidak tersedia.');
        session_save_path($directory);
        ini_set('session.use_strict_mode', '1'); ini_set('session.use_only_cookies', '1');
        session_name('hls_v2_session');
        session_set_cookie_params(['path' => $config['base_path'] ?: '/', 'httponly' => true, 'secure' => (bool)$config['secure_cookie'] || (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'), 'samesite' => 'Lax']);
        if (!session_start()) throw new \RuntimeException('Sesi tidak dapat dimulai.');
    }
}

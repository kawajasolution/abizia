<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Http\HttpError;
final class Csrf
{
    public static function token(): string { return $_SESSION['csrf'] ??= bin2hex(random_bytes(32)); }
    public static function verify(mixed $token): void { if (!is_string($token) || !isset($_SESSION['csrf']) || !hash_equals($_SESSION['csrf'], $token)) throw new HttpError(403, 'Token CSRF tidak valid. Muat ulang formulir.'); }
}

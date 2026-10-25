<?php
declare(strict_types=1);
namespace Hls\Http;
final class Input
{
    public static function text(array $data, string $key, int $max, bool $required = true): string
    {
        $value = $data[$key] ?? '';
        if (!is_string($value)) throw new HttpError(422, 'Format input tidak valid.');
        $value = trim($value);
        if (($required && $value === '') || mb_strlen($value) > $max) throw new HttpError(422, 'Isian ' . $key . ' tidak valid.');
        return $value;
    }
    public static function id(array $data, string $key, bool $optional = false): int
    {
        $value = self::text($data, $key, 10, !$optional);
        if ($optional && $value === '') return 0;
        if (!ctype_digit($value) || (int)$value < 1) throw new HttpError(422, 'ID tidak valid.');
        return (int)$value;
    }
    public static function flag(array $data, string $key): int
    {
        $value = self::text($data, $key, 1, false);
        if (!in_array($value, ['', '0', '1'], true)) throw new HttpError(422, 'Pilihan tidak valid.');
        return (int)$value;
    }
    public static function password(string $password): string
    {
        if (strlen($password) < 12 || strlen($password) > 72 || preg_match('/[\x00-\x1f\x7f]/', $password)) throw new HttpError(422, 'Password harus 12–72 byte tanpa karakter kontrol.');
        return password_hash($password, PASSWORD_DEFAULT);
    }
}

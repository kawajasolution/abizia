<?php
declare(strict_types=1);
namespace Hls;
final class Database
{
    public static function connect(array $config): \PDO
    {
        Config::databaseName($config['database']);
        $db = new \PDO('mysql:host=' . $config['host'] . ';port=' . (int)$config['port'] . ';dbname=' . $config['database'] . ';charset=utf8mb4', $config['username'], $config['password'], [\PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION, \PDO::ATTR_EMULATE_PREPARES => false, \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC]);
        $db->exec("SET time_zone = '+08:00'");
        return $db;
    }
    public static function transaction(\PDO $db, callable $work): mixed
    {
        $db->beginTransaction();
        try { $result = $work(); $db->commit(); return $result; }
        catch (\Throwable $e) { if ($db->inTransaction()) $db->rollBack(); throw $e; }
    }
}

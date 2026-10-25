<?php
declare(strict_types=1);
namespace Hls\Services;

use Hls\Config;
use Hls\Database;
use Hls\Repositories\Repository;

/** DDL recovery infrastructure only. No Equipment business operations. */
final class EquipmentMigration
{
    public const VERSION = '005_equipment_operations';

    public static function install(\PDO $db, string $database, ?callable $afterStep = null): bool
    {
        Config::databaseName($database);
        if ($db->inTransaction() || $db->query('SELECT DATABASE()')->fetchColumn() !== $database) {
            throw new \RuntimeException('Target/transaksi migration Equipment tidak sah.');
        }
        $repo = new Repository($db);
        if (!$repo->one("SELECT version FROM schema_migrations WHERE version='004_trucking_operations'")) {
            throw new \RuntimeException('Migration 004 wajib lengkap sebelum 005.');
        }
        $lock = 'hlsv2:005:' . $database;
        if ((int)$repo->one('SELECT GET_LOCK(?,0) AS acquired', [$lock])['acquired'] !== 1) {
            throw new \RuntimeException('Migration Equipment sedang dijalankan koneksi lain.');
        }
        try {
            $sql = file_get_contents(dirname(__DIR__, 2) . '/database/migrations/' . self::VERSION . '.sql');
            $steps = [];
            foreach (explode(';', $sql) as $statement) {
                $statement = trim($statement);
                if ($statement === '') continue;
                if (!preg_match('/^(CREATE TABLE|ALTER TABLE) (eq_[a-z_]+)\b/D', $statement, $match)) {
                    throw new \RuntimeException('Pernyataan migration Equipment tidak dikenali.');
                }
                $steps[] = ['sql'=>$statement, 'table'=>$match[2], 'create'=>$match[1] === 'CREATE TABLE', 'hash'=>substr(hash('sha256', $statement), 0, 12)];
            }
            $markers = $repo->all("SELECT version FROM schema_migrations WHERE LEFT(version,7)='005_eq/' ORDER BY version");
            $done = []; $started = []; $latest = [];
            foreach ($markers as $row) {
                if (!preg_match('~^005_eq/(start|done)/(\d{2})/([a-f0-9]{12})(?:/([a-f0-9]{32}))?$~D', $row['version'], $m)) {
                    throw new \RuntimeException('Journal migration Equipment tidak sah.');
                }
                $n = (int)$m[2]; $step = $steps[$n - 1] ?? null;
                if (!$step || $step['hash'] !== $m[3]) throw new \RuntimeException('DDL berubah sejak migration dimulai; hentikan dan review.');
                if ($m[1] === 'start') $started[$n] = true;
                else { $done[$n] = true; $latest[$step['table']][$n] = $m[4] ?? ''; }
            }
            // Verify only the latest completed DDL for each table (later ALTER changes its shape).
            foreach ($latest as $table=>$hashes) {
                ksort($hashes); $expected = end($hashes);
                if (self::shape($db, $table) !== $expected) throw new \RuntimeException('Schema drift pada ' . $table . '; tidak meneruskan migration.');
            }
            $installed = (bool)$repo->one('SELECT version FROM schema_migrations WHERE version=?', [self::VERSION]);
            if ($installed) {
                if (count($done) !== count($steps)) throw new \RuntimeException('Journal 005 tidak lengkap.');
                return false;
            }
            foreach ($steps as $i=>$step) {
                $n = $i + 1;
                if (isset($done[$n])) continue;
                if ($n > 1 && !isset($done[$n - 1])) throw new \RuntimeException('Urutan journal migration tidak lengkap.');
                $prefix = sprintf('005_eq/start/%02d/%s', $n, $step['hash']);
                $exists = (bool)$repo->one('SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=?', [$step['table']]);
                // Never silently adopt an unknown table or an ambiguous crash window after DDL.
                if (($step['create'] && $exists) || (!$step['create'] && isset($started[$n]))) {
                    throw new \RuntimeException('Langkah ' . $n . ' ambigu/tabel sudah ada: ' . $step['table'] . '. Review SHOW CREATE TABLE terhadap DDL; jangan DROP/reset atau mengadopsi tanpa verifikasi.');
                }
                if (!isset($started[$n])) $repo->run('INSERT INTO schema_migrations(version) VALUES (?)', [$prefix]);
                $db->exec($step['sql']);
                $fingerprint = self::shape($db, $step['table']);
                $repo->run('INSERT INTO schema_migrations(version) VALUES (?)', [sprintf('005_eq/done/%02d/%s/%s', $n, $step['hash'], $fingerprint)]);
                $done[$n] = true;
                if ($afterStep !== null) $afterStep($n);
            }
            Database::transaction($db, static function () use ($repo): void {
                EquipmentPermissions::seed($repo);
                $repo->run('INSERT INTO schema_migrations(version) VALUES (?)', [self::VERSION]);
            });
            return true;
        } finally {
            $repo->run('SELECT RELEASE_LOCK(?)', [$lock]);
        }
    }

    private static function shape(\PDO $db, string $table): string
    {
        // Table names originate exclusively from checked migration statements.
        $row = $db->query('SHOW CREATE TABLE `' . $table . '`')->fetch(\PDO::FETCH_NUM);
        $ddl = preg_replace('/\bAUTO_INCREMENT=\d+\b/', '', $row[1]);
        return substr(hash('sha256', $ddl), 0, 32);
    }
}

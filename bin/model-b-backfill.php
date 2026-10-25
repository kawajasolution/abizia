<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') { fwrite(STDERR, "CLI only\n"); exit(1); }
if (in_array('--execute', $argv, true)) { fwrite(STDERR, "Backfill Model B belum boleh dieksekusi; gunakan dry-run.\n"); exit(2); }
try {
    $config = Hls\Config::load();
    $db = Hls\Database::connect($config);
    $tables = $db->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
    foreach (['exp_dns','exp_manifests','exp_manifest_items','exp_trip_legs','exp_events','exp_receipts'] as $table) {
        if (!in_array($table, $tables, true)) throw new RuntimeException("Tabel $table tidak tersedia.");
    }
    $q = static function (PDO $db, string $sql): int { return (int)$db->query($sql)->fetchColumn(); };
    echo "MODEL B BACKFILL DRY-RUN\n";
    echo "DN: ".$q($db, 'SELECT COUNT(*) FROM exp_dns')."\n";
    echo "Manifest: ".$q($db, 'SELECT COUNT(*) FROM exp_manifests')."\n";
    echo "Membership aktif: ".$q($db, "SELECT COUNT(*) FROM exp_manifest_items WHERE removed_at IS NULL")."\n";
    echo "Membership historis: ".$q($db, "SELECT COUNT(*) FROM exp_manifest_items WHERE removed_at IS NOT NULL")."\n";
    echo "Manifest belum selesai: ".$q($db, "SELECT COUNT(*) FROM exp_manifests WHERE status NOT IN ('completed','cancelled')")."\n";
    echo "DN diterima: ".$q($db, "SELECT COUNT(*) FROM exp_dns WHERE status IN ('received','completed')")."\n";
    echo "DN transit: ".$q($db, "SELECT COUNT(*) FROM exp_dns WHERE status='transit'")."\n";
    echo "Kandidat backfill yang memerlukan rekonsiliasi: ".$q($db, "SELECT COUNT(*) FROM exp_manifest_items i JOIN exp_dns d ON d.id=i.dn_id WHERE i.removed_at IS NULL AND d.quantity<=0")."\n";
    echo "Tidak ada INSERT, UPDATE, DELETE, atau perubahan schema.\n";
} catch (Throwable $e) { fwrite(STDERR, $e->getMessage()."\n"); exit(1); }

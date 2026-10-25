<?php
declare(strict_types=1);
require dirname(__DIR__) . '/app/bootstrap.php';
if (PHP_SAPI !== 'cli') exit(1);

// Read-only inspection of this application's configured development database.
$config = Hls\Config::load();
if ($config['database'] !== 'hls_v2_dev') throw new RuntimeException('Hanya database development V2.');
$db = Hls\Database::connect($config);
$checks = [];
$check = function (bool $passed, string $name) use (&$checks): void {
    $checks[] = compact('name', 'passed');
};
$quote = fn(string $name): string => '`' . str_replace('`', '``', $name) . '`';
$tables = $db->query('SHOW TABLE STATUS')->fetchAll(PDO::FETCH_ASSOC);
$check(count($tables) === 48, 'Jumlah tabel T1–5 dan Equipment: 48');
foreach ($tables as $table) {
    $check($table['Engine'] === 'InnoDB', 'Engine InnoDB: ' . $table['Name']);
    $rows = $db->query('CHECK TABLE ' . $quote($table['Name']))->fetchAll(PDO::FETCH_ASSOC);
    $check(count($rows) === 1 && $rows[0]['Msg_type'] === 'status' && $rows[0]['Msg_text'] === 'OK', 'CHECK TABLE: ' . $table['Name']);
}
$stmt = $db->prepare('SELECT TABLE_NAME,CONSTRAINT_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA=? AND REFERENCED_TABLE_NAME IS NOT NULL ORDER BY TABLE_NAME,CONSTRAINT_NAME,ORDINAL_POSITION');
$stmt->execute([$config['database']]);
$constraints = [];
foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) $constraints[$row['TABLE_NAME'] . '.' . $row['CONSTRAINT_NAME']][] = $row;
foreach ($constraints as $name => $columns) {
    $join = $nonnull = [];
    foreach ($columns as $column) {
        $join[] = 'c.' . $quote($column['COLUMN_NAME']) . '=p.' . $quote($column['REFERENCED_COLUMN_NAME']);
        $nonnull[] = 'c.' . $quote($column['COLUMN_NAME']) . ' IS NOT NULL';
    }
    $first = $columns[0];
    $sql = 'SELECT COUNT(*) FROM ' . $quote($first['TABLE_NAME']) . ' c LEFT JOIN ' . $quote($first['REFERENCED_TABLE_NAME']) . ' p ON ' . implode(' AND ', $join) . ' WHERE ' . implode(' AND ', $nonnull) . ' AND p.' . $quote($first['REFERENCED_COLUMN_NAME']) . ' IS NULL';
    $check((int)$db->query($sql)->fetchColumn() === 0, 'Tanpa orphan FK: ' . $name);
}
$invariants = [
    'Satu keanggotaan Manifest aktif per DN' => 'SELECT COUNT(*) FROM (SELECT dn_id FROM exp_manifest_items WHERE removed_at IS NULL GROUP BY dn_id HAVING COUNT(*)>1) duplicates',
    'Satu penerimaan aktual per DN' => 'SELECT COUNT(*) FROM (SELECT dn_id FROM exp_receipts GROUP BY dn_id HAVING COUNT(*)>1) duplicates',
    'DN received/completed mempunyai penerimaan aktual' => "SELECT COUNT(*) FROM exp_dns d LEFT JOIN exp_receipts r ON r.dn_id=d.id WHERE d.status IN ('received','completed') AND r.id IS NULL",
    'Penerimaan aktual utuh dan sesuai cabang tujuan' => 'SELECT COUNT(*) FROM exp_receipts r JOIN exp_dns d ON d.id=r.dn_id WHERE r.quantity<>d.quantity OR r.branch_id<>d.destination_branch_id',
    'Manifest completed/cancelled tanpa anggota aktif' => "SELECT COUNT(*) FROM exp_manifests m JOIN exp_manifest_items i ON i.manifest_id=m.id AND i.removed_at IS NULL WHERE m.status IN ('completed','cancelled')",
    'Posisi Manifest berada dalam jumlah leg' => 'SELECT COUNT(*) FROM exp_manifests m WHERE m.current_stop>(SELECT COUNT(*) FROM exp_trip_legs l WHERE l.manifest_id=m.id)',
    'Klaim memiliki ledger awal' => "SELECT COUNT(*) FROM exp_claims c WHERE NOT EXISTS(SELECT 1 FROM exp_claim_events e WHERE e.claim_id=c.id AND e.previous_status IS NULL AND e.next_status='REPORTED')",
    'Status klaim sesuai ledger terakhir' => 'SELECT COUNT(*) FROM exp_claims c WHERE c.status<>(SELECT e.next_status FROM exp_claim_events e WHERE e.claim_id=c.id ORDER BY e.id DESC LIMIT 1)',
    'Tidak ada tabel transaksi Finance' => "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND LEFT(TABLE_NAME,4)='fin_'",
];
foreach ($invariants as $name => $sql) $check((int)$db->query($sql)->fetchColumn() === 0, $name);
$failed = count(array_filter($checks, fn(array $c): bool => !$c['passed']));
$result = ['date'=>date(DATE_ATOM), 'database'=>'hls_v2_dev', 'read_only'=>true, 'passed'=>count($checks)-$failed, 'failed'=>$failed, 'checks'=>$checks];
file_put_contents(__DIR__ . '/results/database-integrity.json', json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
echo $result['passed'] . ' PASS; ' . $failed . ' FAIL pemeriksaan integritas baca-saja.' . PHP_EOL;
exit($failed ? 1 : 0);

<?php
declare(strict_types=1);
// Runs inside tests/run.php's disposable V2 database and real HTTP server.
$repairStart = count($checks);
$repairMasterChange = function (string $entity, int $id, array $changes) use ($md): void {
    $row = $md->data->find($entity, $id);
    $input = [];
    foreach ($md->data->entity($entity)['fields'] as $field => $definition) $input[$field] = (string)($row[$field] ?? '');
    $md->save($entity, array_replace($input, ['id'=>(string)$id, 'version'=>(string)$row['version'], 'active'=>(string)$row['active']], $changes));
};
$repairLedger = fn(): array => [
    $repo->all('SELECT * FROM exp_events ORDER BY id'),
    $repo->all('SELECT * FROM audit_logs ORDER BY id'),
    $repo->all('SELECT * FROM exp_sequences ORDER BY document_type,branch_id,document_year'),
    $repo->all('SELECT * FROM exp_requests ORDER BY request_key'),
];
$originLocation = (int)$repo->one('SELECT origin_location_id FROM md_routes WHERE id=?', [$expRoute])['origin_location_id'];
try {
    // A01: an admin disables the origin after the DN has been created.
    $repairDn = $exp->save('dn', array_replace($dnInput, ['request_key'=>$key()]));
    $repairMasterChange('locations', $originLocation, ['active'=>'0']);
    $beforeDn = $exp->data->find('dn', $repairDn); $beforeLedger = $repairLedger(); $confirmKey = $key();
    rejects(fn()=>$ops->confirmDn($repairDn, $vDn($repairDn), $confirmKey), 'A01 lokasi asal dinonaktifkan setelah DN dibuat ditolak', 422);
    check($exp->data->find('dn', $repairDn) === $beforeDn, 'A01 penolakan mempertahankan DN/snapshot/nomor/versi');
    check($repairLedger() === $beforeLedger, 'A01 penolakan tanpa event/audit/nomor/token parsial');
    $repairMasterChange('locations', $originLocation, ['active'=>'1']);
    $ops->confirmDn($repairDn, (int)$beforeDn['version'], $confirmKey);
    check($exp->data->find('dn', $repairDn)['status'] === 'confirmed', 'A01 lokasi aktif kembali dapat dikonfirmasi dengan token yang sebelumnya gagal');
    check($exp->data->find('dn', $repairDn)['snapshot'] === $beforeDn['snapshot'], 'A01 konfirmasi tidak menulis ulang snapshot');
    $confirmedLedger = $repairLedger(); $ops->confirmDn($repairDn, (int)$beforeDn['version'], $confirmKey);
    check($repairLedger() === $confirmedLedger, 'A01 replay konfirmasi tidak menggandakan histori atau nomor');

    // A02: current eligibility changes, but the document snapshot must not change.
    $roleDn = $exp->save('dn', array_replace($dnInput, ['request_key'=>$key()]));
    $senderId = (int)$dnInput['sender_id']; $originalSender = $md->data->find('parties', $senderId);
    $repairMasterChange('parties', $senderId, ['party_role'=>'receiver', 'name'=>'Nama master terkini untuk A02']);
    $beforeDn = $exp->data->find('dn', $roleDn); $beforeLedger = $repairLedger(); $roleKey = $key();
    rejects(fn()=>$ops->confirmDn($roleDn, $vDn($roleDn), $roleKey), 'A02 peran master pengirim berubah menjadi receiver ditolak', 422);
    check($exp->data->find('dn', $roleDn) === $beforeDn, 'A02 penolakan mempertahankan DN dan snapshot historis');
    check($repairLedger() === $beforeLedger, 'A02 penolakan tanpa event/audit/nomor/token parsial');
    $repairMasterChange('parties', $senderId, ['party_role'=>'both']);
    $ops->confirmDn($roleDn, (int)$beforeDn['version'], $roleKey);
    check($exp->data->find('dn', $roleDn)['status'] === 'confirmed', 'A02 master both memenuhi peran pengirim');
    check($exp->data->find('dn', $roleDn)['snapshot'] === $beforeDn['snapshot'], 'A02 nama/peran master terkini tidak mengganti snapshot lama');
    $repairMasterChange('parties', $senderId, ['party_role'=>'sender']);
    $senderDn = $exp->save('dn', array_replace($dnInput, ['request_key'=>$key()])); $ops->confirmDn($senderDn, $vDn($senderDn), $key());
    check($exp->data->find('dn', $senderDn)['status'] === 'confirmed', 'A02 master sender tetap memenuhi konfirmasi positif');
    $repairMasterChange('parties', $senderId, ['party_role'=>$originalSender['party_role'], 'name'=>$originalSender['name']]);

    // A03: disable the actual loading stop after Manifest confirmation.
    $loadDn = $exp->save('dn', array_replace($dnInput, ['request_key'=>$key()])); $ops->confirmDn($loadDn, $vDn($loadDn), $key());
    $loadTrip = $exp->save('manifest', array_replace($manifestInput, ['request_key'=>$key()]));
    $ops->attach($loadTrip, [(string)$loadDn], $vMf($loadTrip), $key()); $ops->manifest($loadTrip, 'confirm', $vMf($loadTrip), $key());
    $repairMasterChange('locations', $originLocation, ['active'=>'0']);
    $beforeTrip = $exp->data->find('manifest', $loadTrip); $beforeDn = $exp->data->find('dn', $loadDn); $beforeLedger = $repairLedger(); $departKey = $key();
    rejects(fn()=>$ops->manifest($loadTrip, 'depart', $vMf($loadTrip), $departKey), 'A03 lokasi muat nonaktif setelah Manifest dikonfirmasi ditolak', 422);
    check($exp->data->find('manifest', $loadTrip) === $beforeTrip && $exp->data->find('dn', $loadDn) === $beforeDn, 'A03 penolakan tidak mengubah Manifest/DN/snapshot/versi');
    check($repairLedger() === $beforeLedger, 'A03 penolakan tidak meninggalkan event/audit/token parsial');
    $repairMasterChange('locations', $originLocation, ['active'=>'1']); $ops->manifest($loadTrip, 'depart', (int)$beforeTrip['version'], $departKey);
    check($exp->data->find('manifest', $loadTrip)['status'] === 'departed' && $exp->data->find('dn', $loadDn)['status'] === 'departed', 'A03 lokasi aktif kembali mengizinkan keberangkatan aktual');
    $departedLedger = $repairLedger(); $ops->manifest($loadTrip, 'depart', (int)$beforeTrip['version'], $departKey);
    check($repairLedger() === $departedLedger, 'A03 replay keberangkatan tidak menggandakan histori');

    $transitDn = $exp->save('dn', array_replace($dnInput, ['route_id'=>(string)$routeAC, 'receiver_id'=>(string)$receiverC, 'request_key'=>$key()]));
    $ops->confirmDn($transitDn, $vDn($transitDn), $key());
    $transitTrip = $exp->save('manifest', array_replace($manifestInput, ['request_key'=>$key()]));
    $ops->appendLeg($transitTrip, $routeBC, $vMf($transitTrip), $key());
    $ops->attach($transitTrip, [(string)$transitDn], $vMf($transitTrip), $key());
    foreach (['confirm','depart','arrive'] as $action) $ops->manifest($transitTrip, $action, $vMf($transitTrip), $key());
    $ops->manifest($transitTrip, 'record_arrival', $vMf($transitTrip), $key(), ['dn_ids'=>[(string)$transitDn]]);
    $loadingStop = $ops->records->stop($exp->data->find('manifest', $transitTrip));
    $repairMasterChange('locations', $loadingStop['location'], ['active'=>'0']);
    $beforeTrip = $exp->data->find('manifest', $transitTrip); $beforeDn = $exp->data->find('dn', $transitDn); $beforeLedger = $repairLedger();
    rejects(fn()=>$ops->manifest($transitTrip, 'depart', $vMf($transitTrip), $key()), 'A03 lokasi muat stop transit nonaktif juga ditolak', 422);
    check($exp->data->find('manifest', $transitTrip) === $beforeTrip && $exp->data->find('dn', $transitDn) === $beforeDn && $repairLedger() === $beforeLedger, 'A03 penolakan di transit menjaga status/posisi/histori');
    $repairMasterChange('locations', $loadingStop['location'], ['active'=>'1']);
    $ops->manifest($transitTrip, 'depart', $vMf($transitTrip), $key());
    check($exp->data->find('manifest', $transitTrip)['status'] === 'departed', 'A03 keberangkatan lanjutan sah dari stop aktif');

    // A04: read an already recorded cancellation; never create a replacement event.
    $cancellation = $repo->one("SELECT e.*,u.name actor_name FROM exp_events e JOIN users u ON u.id=e.actor_id WHERE e.manifest_id=? AND e.event_type='trip_cancel' ORDER BY e.id LIMIT 1", [$cancelTrip]);
    $cancelReason = json_decode($cancellation['detail'], true, 512, JSON_THROW_ON_ERROR)['note'];
    $beforeHistory = $repairLedger(); $cancelDocument = $exp->data->find('manifest', $cancelTrip);
    $detail = http('/trucking/manifests?mode=detail&id='.$cancelTrip, $anonJar);
    check($detail['status'] === 200 && str_contains($detail['body'], htmlspecialchars($cancelReason, ENT_QUOTES, 'UTF-8')), 'A04 alasan pembatalan historis ditampilkan melalui HTTP');
    preg_match('/<li><strong>Manifest dibatalkan<\/strong>.*?<\/li>/s', $detail['body'], $cancelEventHtml);
    check(str_contains($cancelEventHtml[0] ?? '', htmlspecialchars($cancellation['actor_name'], ENT_QUOTES, 'UTF-8')) && str_contains($cancelEventHtml[0] ?? '', $cancellation['created_at'].' WITA'), 'A04 aktor dan waktu pada event pembatalan yang sama ditampilkan');
    check($repairLedger() === $beforeHistory && $exp->data->find('manifest', $cancelTrip) === $cancelDocument, 'A04 membaca detail tidak menulis histori/audit/snapshot baru');
    check(http('/trucking/manifests?mode=detail&id='.$cancelTrip, $foreignJar)['status'] === 404, 'A04 histori pembatalan tidak bocor lintas cabang');
    $escapedTrip = $exp->save('manifest', array_replace($manifestInput, ['request_key'=>$key()]));
    $unsafeReason = '<script>alert("audit")</script> & alasan aktual';
    $ops->manifest($escapedTrip, 'cancel', $vMf($escapedTrip), $key(), ['note'=>$unsafeReason]);
    $escapedDetail = http('/trucking/manifests?mode=detail&id='.$escapedTrip, $anonJar);
    check(str_contains($escapedDetail['body'], htmlspecialchars($unsafeReason, ENT_QUOTES, 'UTF-8')) && !str_contains($escapedDetail['body'], $unsafeReason), 'A04 alasan historis di-escape tanpa mengubah data tersimpan');
    $storedReason = json_decode($repo->one("SELECT detail FROM exp_events WHERE manifest_id=? AND event_type='trip_cancel'", [$escapedTrip])['detail'], true)['note'];
    check($storedReason === $unsafeReason, 'A04 tampilan aman mempertahankan alasan asli pada histori');
    $operationFixtures['auditCancellation'] = ['id'=>$cancelTrip, 'reason'=>$cancelReason, 'actor'=>$cancellation['actor_name'], 'time'=>$cancellation['created_at']];
} finally {
    $repairChecks = array_slice($checks, $repairStart);
    file_put_contents(__DIR__.'/results/audit-repairs.json', json_encode(['date'=>date(DATE_ATOM), 'passed'=>count(array_filter($repairChecks, fn($r)=>$r['passed'])), 'failed'=>count(array_filter($repairChecks, fn($r)=>!$r['passed'])), 'checks'=>$repairChecks], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
}

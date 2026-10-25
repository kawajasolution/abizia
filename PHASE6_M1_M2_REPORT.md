# Laporan Tahap 6 — M1 dan M2 Equipment Operasional

## Pemeriksaan akhir ulang M1–M2 — 24 Oktober 2026

**Status terbaru: PASS untuk ruang lingkup M1–M2; 0 FAIL akhir, 0 BLOCKED pengujian wajib M1–M2.** Angka bagian pelaksanaan awal di bawah adalah riwayat, bukan hasil run terbaru. Regresi penuh run terbaru selesai **16:38:12 WITA**. M3–M7 tetap belum dimulai.

### Temuan pemeriksaan aktual

1. **Migrator reachable — PASS.** File app/Services/Migrator.php baris 41 memanggil `EquipmentMigration::install($db, $database)` dan menyimpan hasilnya, baru baris 42 melakukan `return $changed || $equipmentChanged`. Tidak ada return sebelum pemanggilan tersebut. Bahkan ketika `$changed=true` pada fresh install, pemanggilan sudah dieksekusi sebelum evaluasi OR. Selain inspeksi kode, test fresh kini secara eksplisit memeriksa marker lengkap 005 serta **set persis nama 16 tabel**. Fresh, populated upgrade dan no-op benar-benar dijalankan; tidak memperbaiki kode yang sudah benar.
2. **Grant sensitif — PASS.** `equipment.verification.decide` hanya Administrator, yaitu **Y pada matriks**, bukan grant C baru. Admin Sewa verification.view/decide/contract.extend/contract.terminate tetap C/deny. handover.correct, handover.fact_correct, cross_branch.approve, recovery.close, meter.correct, timesheet.revise_terminal dan operator.relink hanya definisi; **tidak satu pun mendapat grant, termasuk Administrator**. Diperiksa secara independen pada fresh test dan database development. Tidak menambah/menghapus grant atau membuka bypass self-approval/scope.
3. **16 tabel desain final — PASS.** Daftar persis di bawah dan pada bagian 4, bukan sekadar hitungan 48. eq_meter_corrections konsisten dengan G03: reset/replacement mempunyai alasan, authorizer/waktu dan bukti yang diikat FK ke koreksi yang benar. HM normal tetap pair/nonmenurun. Tidak menambahkan tabel ke-17 atau workflow koreksi.
4. **Development preservation — PASS.** Verifier baca-saja membandingkan seluruh row dan struktur 32 tabel T1–5 terhadap snapshot pra-M2; menambah pemeriksaan nama tabel dan grant sensitif aktual. 48 tabel/106 permission/215 grant/10 role tetap; semua tabel Equipment kosong, user/cabang/master/Trucking development tetap nol sesuai baseline awal. Pelestarian data bisnis **terisi** juga diuji terpisah pada disposable upgrade, tidak membuat data development palsu.

### Eksekusi pengujian terbaru

| Pengujian yang benar-benar dijalankan | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Migration M2: fresh, populated upgrade, constraint, partial/recovery, seed failure, drift, dua koneksi dan idempotensi | **122** | **0** | [equipment-migrations.json](tests/results/equipment-migrations.json) |
| Regresi lengkap integrasi/HTTP Tahap 1–5 | **661** | **0** | [foundation.json](tests/results/foundation.json), failure=null, temporary_database_removed=true |
| A01–A04, subset 661 | **26** | **0** | [audit-repairs.json](tests/results/audit-repairs.json) |
| Browser existing desktop/mobile lima viewport | **1.982** | **0** | browser/navigation/dashboard-browser/master-browser/expedition-browser/trucking-browser JSON |
| Pelestarian development + nama tabel + grant aktual, baca-saja | **86** | **0** | [equipment-development.json](tests/results/equipment-development.json) |
| Integritas database development | **230** | **0** | [database-integrity.json](tests/results/database-integrity.json) |
| Apache lokal/isolasi DB | **16** | **0** | [deployment.json](tests/results/deployment.json) |
| PHP lint | **93 file** | **0** | [lint.json](tests/results/lint.json) |
| JavaScript syntax | **7 file** | **0** | [javascript-lint.json](tests/results/javascript-lint.json) |

Perintah dijalankan: `php tests/run.php`, `php tests/equipment-migrations.php`, `php tests/equipment-development.php verify`, `php tests/database-integrity.php`, `php tests/deployment.php`, `php bin/migrate.php` (no-op), lint semua PHP dan node --check. Browser breakdown: 108 fondasi + 461 navigasi + 724 dashboard + 351 master + 108 dokumen Trucking + 230 operasional = 1.982. Screenshot pembatalan Manifest terbaru 320 dan 1366 ditinjau visual setelah suite selesai; screenshot/suite tersebut milik T1–5, bukan halaman Equipment yang belum dibuat.

Fresh 001–005, upgrade 004 dengan user/master/DN/Manifest/receipt/claim/event/evidence metadata/audit terisi, dan preservation seluruh row lama lulus. Interupsi checkpoint keempat + resume, kegagalan seed + pemulihan transaksi, drift/tabel asing fail-closed dan no-op berulang lulus. Lima database disposable pada suite M2 dibersihkan. Suite T1–5 membersihkan database/account/credential/session/cookie/file fixture. Tidak menghitung ulang subset 26 atau run ulangan sebagai tambahan kasus unik.

### Daftar 16 tabel yang diverifikasi ulang

- eq_contracts
- eq_contract_units
- eq_unit_periods
- eq_operator_assignments
- eq_branch_authorizations
- eq_handover_documents
- eq_handover_units
- eq_timesheets
- eq_timesheet_revisions
- eq_timesheet_work_entries
- eq_timesheet_verifications
- eq_meter_corrections
- eq_events
- eq_requests
- eq_document_sequences
- eq_evidence

60 FK, 55 CHECK, 16 PK, 32 unique constraint dan 114 indeks tetap; dictionary/daftar nama aktual ada pada bagian 4 dan lampiran. Migration 005 dan seluruh kode aplikasi tidak berubah pada pemeriksaan akhir ini.

### Perubahan khusus pemeriksaan akhir ini

| File | Alasan |
|---|---|
| tests/equipment-migrations.php | Tiga regresi eksplisit: exact table set, marker 005 fresh membuktikan call reachable, dan verification.decide hanya Administrator Y |
| tests/equipment-development.php | Empat cek baca-saja: exact table set, decider aktual, seluruh C khusus deny dan C Admin Sewa deny; menyimpan inventory grant Equipment pada JSON tanpa kredensial |
| PHASE6_M1_M2_REPORT.md | Addendum hasil run baru, temuan/risiko/riwayat, hasil implementasi awal ditandai historis |
| PROGRESS.md, CHANGELOG.md | Mencatat hasil pemeriksaan akhir terbaru dan batas M2 |

Tidak ada perubahan app/Services/Migrator.php, EquipmentMigration.php, EquipmentPermissions.php, migration 005, schema/grant/transaksi development, route/view atau state machine. Daftar file bagian 3 di bawah adalah riwayat implementasi M1–M2 sebelumnya.

### Kegagalan awal run pemeriksaan ini dan tindak lanjut

- Penambahan uji exact table set pertama menghasilkan **3 PASS/1 FAIL** karena urutan ORDER BY information_schema mengikuti kolasi database, sedangkan expected disortir PHP. Nama tabel sebenarnya benar (verifier development lulus). Kedua set kini disortir dengan aturan PHP yang sama sebelum dibandingkan persis; tidak melonggarkan daftar nama atau mengubah schema. Bukti [equipment-final-check-initial.json](tests/results/equipment-final-check-initial.json); rerun final 122 PASS/0 FAIL.
- Run regresi pertama menghasilkan **660 PASS/1 FAIL gerbang browser**: Chromium tidak dapat diluncurkan di sandbox (`spawn EPERM`), **0 assertion browser dijalankan** pada percobaan itu. Tidak mengklaim UI PASS dari hasil lama. Bukti [foundation awal](tests/results/equipment-final-sandbox-foundation.json), [browser awal](tests/results/equipment-final-sandbox-browser.json), dan log terkait. Suite diulang dengan izin proses yang sesuai, tanpa perubahan aplikasi/test browser, dan final 661/1.982 lulus.

### Risiko dan batas verifikasi yang tetap berlaku

**NOT TESTED:** power-loss nyata, recovery manual pada jendela DDL sukses tetapi DONE belum tersimpan, MySQL 8, Safari/perangkat fisik dan hosting/TLS. Kasus jendela DDL ambigu harus fail-closed/review DBA, bukan diberi marker lengkap secara spekulatif. Recovery checkpoint/seed yang dijalankan dan lulus tidak membuktikan semua jenis crash bisa dipulihkan otomatis.

**NOT IMPLEMENTED / di luar mandat:** seluruh runtime M3–M7 (reservasi/nomor KS–BA/lock kode cabang Equipment, lifecycle kontrak/BA, timesheet/verification service, audit/replay bisnis, upload/download, own/cross-branch runtime dan lima halaman). Constraint/seed saja bukan bukti workflow selesai. Seluruh C tetap tanpa grant sesuai keputusan pengguna; tidak membuka operasi khusus lewat Administrator. Tidak mengubah keputusan Tahap 5, proyek/database lama atau hosting. **Berhenti setelah laporan untuk pemeriksaan pengguna.**

24 Oktober 2026, WITA. **M1 PASS; M2 selesai dalam batas skema/seed dan lulus pengujian. Tahap 6 keseluruhan belum selesai.** Tidak melanjutkan M3–M7. G01–G12 adalah baseline sementara yang disetujui pengguna, belum SOP resmi perusahaan. Tidak mengubah Q03/Q04/Q09, Finance, proyek/database lama atau hosting; tidak deployment.

## 1. Ruang lingkup dan keputusan

Mandat hanya gate regresi T1–5, finalisasi empat dokumen Equipment, serta migration aditif Equipment dengan pengujian fresh/upgrade terisi/failure/recovery. Tidak ada service bisnis, controller, repository, view, route/menu atau transaksi Equipment baru. Model header-detail multi-unit, operator WITH/WITHOUT, periode berhistori, BA, root/revisi/verification, bukti, event, idempotency dan counter disiapkan sebagai skema.

Keputusan pengguna tentang sel C: **“Jangan seed grant C; definisi permission saja.”** Diterapkan untuk seluruh role, termasuk Administrator. Grant Y/O mengikuti matriks. Tidak ada role/akun Manager atau akun/operator dummy. Kedua approver lintas cabang harus berbeda, reviewer bukan pembuat root maupun revisi; tidak ada bypass global.

## 2. M1 — gate sebelum perubahan aplikasi/migration

Run gate selesai **15:33:17 WITA**. Artefak disalin ke [tests/results/phase6-m1](tests/results/phase6-m1/) sebelum nama hasil generik dipakai run berikutnya.

| Pemeriksaan sebelum M2 | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Integrasi/HTTP/regresi penuh Tahap 1–5 | 661 | 0 | [foundation](tests/results/phase6-m1/foundation.json) |
| A01–A04 permanen, **subset 661** | 26 | 0 | [audit-repairs](tests/results/phase6-m1/audit-repairs.json) |
| Assertion browser existing desktop/mobile | 1.982 | 0 | browser/navigation/dashboard/master/expedition/trucking JSON pada folder gate |
| Integritas development sebelum migration | 138 | 0 | [integritas](tests/results/phase6-m1/database-integrity.json) |
| Apache lokal/isolasi akun DB | 16 | 0 | [deployment](tests/results/phase6-m1/deployment.json) |
| PHP lint existing | 89 file | 0 | [lint](tests/results/phase6-m1/lint.json) |
| JavaScript syntax existing | 7 file | 0 | node --check dijalankan pada M1 |

M1 benar-benar dijalankan dan lulus sebelum kode/migration Equipment dibuat. Artefak empat probe audit asli audit-repair-after.json yang ikut tersalin adalah hasil historis, **tidak dihitung sebagai empat test baru pada run ini**.

| Temuan | Hasil regresi sekarang |
|---|---|
| A01 lokasi asal DN nonaktif | PASS; penolakan setelah master berubah dan kondisi positif/pemulihan, tanpa nomor/event/audit parsial |
| A02 kelayakan pengirim terkini | PASS; sender/both sah, perubahan menjadi receiver ditolak; snapshot tidak ditimpa |
| A03 lokasi muat nonaktif | PASS; saat keberangkatan, termasuk stop transit; validasi transaksi tetap |
| A04 histori alasan pembatalan | PASS; alasan/aktor/waktu historis lewat HTTP/browser dan escaping; tidak membuat histori baru |

## 3. File aplikasi, migration dan pengujian

| File | Perubahan dan alasan |
|---|---|
| database/migrations/005_equipment_operations.sql | Baru; 16 tabel aditif beserta constraint/index, tanpa seed transaksi/master/account |
| app/Services/EquipmentMigration.php | Baru; infrastruktur DDL saja, guard target, lock installer, journal/hash/fingerprint, resume/fail-closed, marker lengkap atomik dengan seed |
| app/Services/EquipmentPermissions.php | Baru; 43 definisi permission dan grant Y/O; seluruh C tidak mendapat grant |
| app/Services/Migrator.php | Menjalankan 005 setelah 004 tanpa mengubah migration/generator Trucking |
| tests/equipment-migrations.php | Baru; fresh/upgrade terisi, constraint positif/negatif, grant, interupsi/seed failure/drift/objek asing/dua koneksi |
| tests/equipment-development.php | Baru; snapshot privat sebelum migration, verifikasi baca-saja row/struktur existing dan kosongnya Equipment |
| tests/run.php | Hitungan tabel fresh 48, pemeriksaan lama tetap dijalankan |
| tests/dashboard.php | Hitungan katalog permission setelah seed aditif; KPI tetap data nyata |
| tests/database-integrity.php | Hitungan schema 48, semua FK/tabel existing dan baru diperiksa baca-saja |
| tests/deployment.php | Hitungan schema development 48, pemeriksaan HTTP/isolation tetap |

Dokumentasi diperbarui: EQUIPMENT_DESIGN.md, EQUIPMENT_STATE_MACHINE.md, EQUIPMENT_PERMISSION_MATRIX.md, PHASE6_IMPLEMENTATION_PLAN.md, DATABASE_DESIGN.md, BUSINESS_RULES.md, DECISIONS.md, PROGRESS.md, CHANGELOG.md, README.md dan laporan ini. Register G01–G12 disalin dari mandat sebagai keputusan disetujui; keputusan grant C dicatat eksplisit. Artefak JSON/screenshot/lint berada di tests/results/. Snapshot DDL/row awal berada di storage/private/backups/phase6-m2-pre-migration.json, tidak dipublikasikan atau ditimpa.

Tidak mengubah code Trucking, layout/navigasi, generator DN/MF, controller/view/route existing atau migration 001–004. Tidak membuat file workflow Equipment M3–M7.

## 4. Database aktual

005 terpasang pada **hls_v2_dev** melalui `php bin/migrate.php` sesudah uji disposable lulus. Pengulangan perintah mengembalikan no-op. Schema menjadi **48 tabel: 32 existing + 16 Equipment**, seluruh InnoDB.

| Tabel baru | Tujuan dan constraint penting |
|---|---|
| eq_contracts | Header, FK customer/cabang dan aktor; internal/ref resmi unik, status/snapshot/version |
| eq_contract_units | Detail multi-unit, FK header/cabang dan asset/owner; nomor baris unik, generated unique detail nonterminal per kontrak/unit |
| eq_unit_periods | Versi periode inklusif, previous milik detail sama, nomor revisi unik; FK current pointer ditambahkan setelah target ada |
| eq_operator_assignments | Personel/owner, account snapshot opsional, interval datetime, previous milik detail sama, indeks konflik |
| eq_branch_authorizations | Sumber unit/operator/periode, cabang kontrak/pemilik, persetujuan dua akun berbeda, waktu/status/revocation berhistori |
| eq_handover_documents | Header BA HANDOVER/RETURN satu kontrak, ALL/SELECTED, official/internal unik, correction-of satu kontrak |
| eq_handover_units | BA dan detail satu kontrak melalui FK komposit; kondisi/HM/snapshot, unique lifecycle_effect per unit agar efek awal tidak ganda |
| eq_timesheets | Root unit/assignment/tanggal, assignment_scope NULL-normalized unique, author dan pending/effective pointer |
| eq_timesheet_revisions | Previous/base/root konsisten, revisi unik, HM pair/normal nonmenurun, unique satu DRAFT/SUBMITTED per root |
| eq_timesheet_work_entries | Beberapa interval datetime lintas hari, nomor baris unik, start<end, break tidak melebihi interval |
| eq_timesheet_verifications | Satu keputusan per revisi; author ID diikat FK root/revisi, CHECK reviewer berbeda dari keduanya, alasan RETURNED/REJECTED |
| eq_meter_corrections | Tambahan teknis terhadap 15 tabel konseptual untuk G03: reset/replacement, alasan, bukti yang tepat dan otorisasi saat AUTHORIZED |
| eq_events | Relasi kontrak/detail/periode/operator/BA/revisi, metadata JSON, aktor/cabang/waktu dan timeline index |
| eq_requests | PK token idempotensi, aktor/aksi/payload hash/scope/result JSON; belum endpoint replay |
| eq_document_sequences | PK KS/BA + cabang + tahun; batas enam digit; terpisah dari exp_sequences, tanpa allocator runtime |
| eq_evidence | Tepat satu target BA-unit/revisi/koreksi meter, private storage key unik, hash per target, FK bukti koreksi sesuai pemilik |

Master existing digunakan ulang, tanpa unit/operator/customer/cabang duplikat. **60 FK RESTRICT, 55 CHECK, 16 primary key, 32 unique constraint; 114 indeks total** termasuk primary/unique/indeks pendukung FK. Daftar nama per tabel di lampiran akhir; kolom/urutan/target lengkap pada [inventory aktual](tests/results/equipment-migrations.json) dan [DDL](database/migrations/005_equipment_operations.sql).

## 5. Permission dan cakupan

43 definisi baru, total **106 permission**, tetap **10 role**. Grant baru 64 Y/O, total **215 role-permission**. Administrator 26, Admin Sewa 22, Operator Alat Berat 10 own, Owner 6 baca. Finance/Gudang/Customer/petugas Trucking tidak diberi grant Equipment. Sel C Admin Sewa contract.terminate/extend/verification.view/decide tetap deny.

Seluruh C khusus hanya definisi: handover.correct, handover.fact_correct, cross_branch.approve, recovery.close, meter.correct, timesheet.revise_terminal, operator.relink (prefix equipment.). Tidak ada account/default password baru. Hasil uji seed juga memeriksa deny C secara independen, scope grant own Operator dan read-only Owner.

Cakupan runtime Equipment **belum diimplementasikan**: active membership/grant saat aksi, sumber/kontrak/periode, own projection/relink, dua approval lintas cabang, no self-approval dan recovery tetap wajib pada M3–M5. CHECK/FK lokal sudah diuji tetapi bukan bukti seluruh service authorization sudah bekerja. Tidak menampilkan menu kosong.

## 6. Hasil pelaksanaan awal M2 — historis

Regresi penuh selesai **15:46:03 WITA**; hasil bukan perkiraan atau pengulangan angka historis.

| Rangkaian | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Migration/constraint/seed/recovery/fresh/upgrade Equipment terisolasi | 119 | 0 | [equipment-migrations.json](tests/results/equipment-migrations.json) |
| Integrasi/HTTP dan regresi lengkap Tahap 1–5 | 661 | 0 | [foundation.json](tests/results/foundation.json), failure=null, DB uji dihapus |
| A01–A04 permanen, **subset 661** | 26 | 0 | [audit-repairs.json](tests/results/audit-repairs.json) |
| Browser fondasi | 108 | 0 | [browser.json](tests/results/browser.json) |
| Browser navigasi | 461 | 0 | [navigation.json](tests/results/navigation.json) |
| Browser dashboard | 724 | 0 | [dashboard-browser.json](tests/results/dashboard-browser.json) |
| Browser master | 351 | 0 | [master-browser.json](tests/results/master-browser.json) |
| Browser dokumen Trucking | 108 | 0 | [expedition-browser.json](tests/results/expedition-browser.json) |
| Browser operasional Trucking | 230 | 0 | [trucking-browser.json](tests/results/trucking-browser.json) |
| Preservation development baca-saja | 82 | 0 | [equipment-development.json](tests/results/equipment-development.json) |
| Integritas development baca-saja | 230 | 0 | [database-integrity.json](tests/results/database-integrity.json) |
| Apache lokal/isolasi akun DB | 16 | 0 | [deployment.json](tests/results/deployment.json) |
| PHP lint | 93 file | 0 | [lint.json](tests/results/lint.json) |
| JavaScript syntax | 7 file | 0 | [javascript-lint.json](tests/results/javascript-lint.json) |

Browser total **1.982 assertion**, lima viewport 320×640, 375×812, 402×874, 768×1024 dan 1366×768. Ini UI existing T1–5, bukan halaman Equipment. Screenshot pembatalan Manifest 320 dan 1366 pascamigration ditinjau secara visual; referensi/alasan/aktor/waktu tetap terlihat dan tidak overflow. Screenshot full-page tidak membuktikan semua posisi scroll pada perangkat fisik.

Tidak menjumlahkan subset A01–A04 sebagai suite tambahan; M1 dan regresi M2 adalah dua run baseline yang sama, bukan dua kali jumlah kasus unik. Tes M2 memakai **lima database disposable**, semuanya dibersihkan. Fixture/akun/sesi/file suite T1–5 juga dibersihkan.

### Fresh, upgrade dan preservation

Fresh installation 001–005 dan replay no-op lulus, tanpa akun/cabang/transaksi bawaan. Upgrade dari schema 004 terisi user/membership/master, DN/Manifest/nomor resmi/keanggotaan/leg/event/sequence/request, receipt, claim/claim-event/evidence metadata dan audit lulus. Seluruh row lama pada 32 tabel dibandingkan hash seluruh kolom dan tetap identik; seed hanya menambahkan permission/grant/marker. Bukti lampiran upgrade adalah metadata, bukan uji salin byte file historis.

Development sebelum pemasangan memiliki 32 tabel, 63 permission, 10 role dan nol user/cabang/master/Trucking. Sesudahnya 48 tabel/106 permission/215 grant; **seluruh 16 tabel Equipment, termasuk sequence/event/request, tetap 0 row**, user/cabang/master/Trucking tetap 0. Seluruh row awal dan struktur 32 tabel terjaga; hanya nilai opsi AUTO_INCREMENT permissions bertambah sesuai seed sah. schema_migrations memiliki lima marker lengkap dan 38 START/DONE, total 43 row; bukan transaksi atau nomor resmi.

### Kegagalan migration dan recovery

- Interupsi benar-benar diinjeksi setelah checkpoint DDL keempat. Marker lengkap/permission belum ada; rerun memverifikasi langkah terdahulu lalu melanjutkan tanpa DROP/reset. Replay no-op lulus.
- Trigger uji menggagalkan seed setelah DDL selesai. Seluruh permission/grant/marker transaksi rollback. Setelah trigger uji dihapus pada database disposable, rerun menggunakan DDL yang sudah terverifikasi dan berhasil; replay no-op.
- Schema drift dan tabel asing tanpa journal diuji: ditolak, tidak diadopsi diam-diam atau dihapus.
- Dua koneksi nyata memperebutkan advisory lock installer: koneksi kedua ditolak. Ini **bukan** uji reservasi/penomoran kontrak dua proses; workflow tersebut belum dibuat.
- Crash pada jendela DDL sukses tetapi DONE belum tercatat ditangani fail-closed/ambigu; bukan resume otomatis. Perlu review struktur/journal/backup oleh DBA, tidak diberi marker lengkap secara spekulatif. Power-loss nyata dan recovery manual jendela ini **NOT TESTED**. Prosedur batas/recovery ada di PHASE6_IMPLEMENTATION_PLAN.md.

### Riwayat kegagalan selama pengerjaan

Run migration pertama berhenti sebelum assertion pertama karena MariaDB 10.4 menolak CHECK yang merujuk primary key AUTO_INCREMENT pada row yang sama. Ini **suite gagal**, bukan 0 FAIL berarti lulus; exception tersimpan di [equipment-migrations-initial.json](tests/results/equipment-migrations-initial.json). CHECK self-reference tersebut dihapus sebelum migration development; FK komposit parent tetap, self-reference/cycle dicegah service M3–M5 kelak. SQL target MariaDB kemudian fresh/upgrade diuji ulang dan lulus.

Verifier development pertama **81 PASS/1 FAIL** karena membandingkan SHOW CREATE TABLE permissions termasuk nilai AUTO_INCREMENT yang sah berubah akibat seed. Seluruh row sudah identik. Verifier diperbaiki hanya untuk menormalisasi opsi counter tabel permissions, tetap membandingkan seluruh struktur; final **82 PASS/0 FAIL**. Bukti awal [equipment-development-initial.json](tests/results/equipment-development-initial.json). Tidak mengubah database atau aplikasi demi melewati pemeriksaan tersebut.

## 7. Kategori status dan risiko

| Kategori | Status |
|---|---|
| PASS | M1; M2 schema/seed/fresh/upgrade/constraint/checkpoint recovery; regresi T1–5/A01–A04/browser; preservation/integritas/lint/isolation |
| FAIL akhir | 0 pada seluruh suite akhir yang dijalankan; kegagalan awal tetap dicatat di atas |
| BLOCKED M1–M2 | 0; keputusan grant C sudah diberikan, tidak ada grant C yang ditunggu atau disemai |
| NOT IMPLEMENTED | Seluruh M3–M7: reservasi/contract workflow, actual BA, timesheet approval/revision service, audit/replay bisnis, upload/download, lima halaman dan allocator KS/BA/lock kode cabang Equipment |
| NOT TESTED | Runtime Equipment di atas; MySQL 8, Safari/perangkat fisik, power-loss nyata/jendela DDL ambigu/recovery manual, hosting/TLS/deployment |

Constraint tidak menggantikan validasi lintas row: master kind/aktif, cakupan/owner branch, interval overlap, eligible pointer (approved hanya menunjuk APPROVED), acyclic history, immutable BA/approved, aggregate close dan atomic audit harus ditegakkan pada M3–M5. Role C yang tidak diberi grant berarti operasi khusus masih tidak dapat dipakai kelak tanpa mandat delegasi baru. Tidak mengatasi hal itu dengan bypass Administrator.

Format/batas/retensi file dan tanda tangan Equipment, otoritas koreksi/recovery/delegasi khusus, serta detail pemanfaatan sisa hari sesudah actual return perlu diputuskan sebelum workflow terkait; tidak mengarang aturan saat M2. Belum menguji backup restore ke database development; snapshot disimpan untuk review/pemulihan, tidak dipakai mereset development.

**Berhenti setelah M2. Tidak memulai M3 atau deployment.**

## Lampiran — inventory constraint dan indeks aktual M2

Sumber metadata hasil eksekusi fresh installation yang juga dipakai upgrade M2: equipment-migrations.json. Indeks di bawah termasuk primary/unique dan indeks yang dibentuk InnoDB untuk FK; bukan klaim EXPLAIN/performa dengan beban produksi. Seluruh field/urutan referensi tersedia dalam JSON dan DDL.

### eq_branch_authorizations

- PRIMARY KEY: PRIMARY.
- UNIQUE: .
- FOREIGN KEY: fk_eq_authorization_assignment, fk_eq_authorization_period, fk_eq_authorization_owner_actor, fk_eq_authorization_owner, fk_eq_authorization_unit, fk_eq_authorization_contract_actor, fk_eq_authorization_revoker, fk_eq_authorization_branch, fk_eq_authorization_requester.
- CHECK: ck_eq_authorization_interval, ck_eq_authorization_reason, ck_eq_authorization_resource, ck_eq_authorization_revoke, ck_eq_authorization_approval, ck_eq_authorization_two_accounts, ck_eq_authorization_state.
- Indeks: fk_eq_authorization_unit, fk_eq_authorization_assignment, fk_eq_authorization_period, ix_eq_authorization_unit, fk_eq_authorization_requester, ix_eq_authorization_owner, fk_eq_authorization_contract_actor, ix_eq_authorization_contract, PRIMARY, fk_eq_authorization_owner_actor, fk_eq_authorization_revoker.

### eq_contracts

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_contract_ref, uq_eq_contract_number, uq_eq_contract_branch.
- FOREIGN KEY: fk_eq_contract_customer, fk_eq_contract_creator, fk_eq_contract_branch.
- CHECK: ck_eq_contract_version, ck_eq_contract_snapshot, ck_eq_contract_closure, ck_eq_contract_status.
- Indeks: PRIMARY, fk_eq_contract_creator, uq_eq_contract_branch, uq_eq_contract_number, ix_eq_contract_scope, ix_eq_contract_customer, fk_eq_contract_customer, uq_eq_contract_ref.

### eq_contract_units

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_unit_line, uq_eq_unit_active_asset, uq_eq_unit_branch, uq_eq_unit_contract.
- FOREIGN KEY: fk_eq_unit_current_period, fk_eq_unit_contract, fk_eq_unit_asset.
- CHECK: ck_eq_unit_state, ck_eq_unit_mode, ck_eq_unit_version, ck_eq_unit_snapshot, ck_eq_unit_actual.
- Indeks: ix_eq_unit_state, uq_eq_unit_line, fk_eq_unit_contract, uq_eq_unit_contract, uq_eq_unit_branch, uq_eq_unit_active_asset, ix_eq_unit_asset, fk_eq_unit_asset, fk_eq_unit_current_period, PRIMARY.

### eq_document_sequences

- PRIMARY KEY: PRIMARY.
- UNIQUE: .
- FOREIGN KEY: fk_eq_sequence_branch.
- CHECK: ck_eq_sequence_value, ck_eq_sequence_type.
- Indeks: PRIMARY, fk_eq_sequence_branch.

### eq_events

- PRIMARY KEY: PRIMARY.
- UNIQUE: .
- FOREIGN KEY: fk_eq_event_contract, fk_eq_event_unit, fk_eq_event_ba, fk_eq_event_timesheet, fk_eq_event_actor, fk_eq_event_revision, fk_eq_event_period, fk_eq_event_operator.
- CHECK: ck_eq_event_context, ck_eq_event_detail.
- Indeks: fk_eq_event_contract, fk_eq_event_revision, PRIMARY, fk_eq_event_unit, fk_eq_event_actor, ix_eq_event_contract, fk_eq_event_period, ix_eq_event_unit, fk_eq_event_operator, ix_eq_event_ba, fk_eq_event_ba, ix_eq_event_revision, fk_eq_event_timesheet, ix_eq_event_request.

### eq_evidence

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_evidence_meter, uq_eq_evidence_meter_hash, uq_eq_evidence_revision_hash, uq_eq_evidence_ba_hash, uq_eq_evidence_key.
- FOREIGN KEY: fk_eq_evidence_meter, fk_eq_evidence_ba, fk_eq_evidence_actor, fk_eq_evidence_revision.
- CHECK: ck_eq_evidence_size, ck_eq_evidence_target.
- Indeks: uq_eq_evidence_meter, uq_eq_evidence_key, uq_eq_evidence_ba_hash, uq_eq_evidence_revision_hash, uq_eq_evidence_meter_hash, fk_eq_evidence_actor, PRIMARY.

### eq_handover_documents

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_ba_number, uq_eq_ba_contract, uq_eq_ba_ref.
- FOREIGN KEY: fk_eq_ba_contract, fk_eq_ba_creator, fk_eq_ba_correction.
- CHECK: ck_eq_ba_type, ck_eq_ba_version, ck_eq_ba_correction, ck_eq_ba_state, ck_eq_ba_scope.
- Indeks: uq_eq_ba_ref, uq_eq_ba_contract, ix_eq_ba_list, fk_eq_ba_correction, fk_eq_ba_creator, PRIMARY, uq_eq_ba_number.

### eq_handover_units

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_ba_lifecycle, uq_eq_ba_unit.
- FOREIGN KEY: fk_eq_ba_unit_header, fk_eq_ba_unit_detail.
- CHECK: ck_eq_ba_unit_effect, ck_eq_ba_unit_snapshot, ck_eq_ba_unit_hm, ck_eq_ba_unit_condition.
- Indeks: uq_eq_ba_unit, uq_eq_ba_lifecycle, fk_eq_ba_unit_header, fk_eq_ba_unit_detail, PRIMARY.

### eq_meter_corrections

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_meter_target, uq_eq_meter_revision.
- FOREIGN KEY: fk_eq_meter_requester, fk_eq_meter_evidence, fk_eq_meter_authorizer, fk_eq_meter_revision.
- CHECK: ck_eq_meter_state, ck_eq_meter_type, ck_eq_meter_authorized, ck_eq_meter_values.
- Indeks: fk_eq_meter_requester, fk_eq_meter_evidence, PRIMARY, uq_eq_meter_target, fk_eq_meter_authorizer, uq_eq_meter_revision.

### eq_operator_assignments

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_operator_unit.
- FOREIGN KEY: fk_eq_operator_unit, fk_eq_operator_previous, fk_eq_operator_personnel, fk_eq_operator_account.
- CHECK: ck_eq_operator_version, ck_eq_operator_actual, ck_eq_operator_interval, ck_eq_operator_state.
- Indeks: ix_eq_operator_schedule, ix_eq_unit_operator_schedule, PRIMARY, fk_eq_operator_personnel, uq_eq_operator_unit, fk_eq_operator_previous, fk_eq_operator_account.

### eq_requests

- PRIMARY KEY: PRIMARY.
- UNIQUE: .
- FOREIGN KEY: fk_eq_request_branch, fk_eq_request_actor.
- CHECK: ck_eq_request_result.
- Indeks: ix_eq_request_actor, fk_eq_request_branch, PRIMARY.

### eq_timesheets

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_timesheet_unit, uq_eq_timesheet_creator, uq_eq_timesheet_root.
- FOREIGN KEY: fk_eq_timesheet_effective, fk_eq_timesheet_creator, fk_eq_timesheet_assignment, fk_eq_timesheet_unit, fk_eq_timesheet_pending.
- CHECK: ck_eq_timesheet_version.
- Indeks: uq_eq_timesheet_root, ix_eq_timesheet_date, fk_eq_timesheet_assignment, uq_eq_timesheet_creator, fk_eq_timesheet_effective, uq_eq_timesheet_unit, fk_eq_timesheet_pending, PRIMARY, fk_eq_timesheet_creator.

### eq_timesheet_revisions

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_revision_root, uq_eq_revision_number, uq_eq_revision_pending, uq_eq_revision_author.
- FOREIGN KEY: fk_eq_revision_previous, fk_eq_revision_creator, fk_eq_revision_base, fk_eq_revision_submitter, fk_eq_revision_root.
- CHECK: ck_eq_revision_snapshot, ck_eq_revision_submission, ck_eq_revision_hm, ck_eq_revision_status, ck_eq_revision_reason, ck_eq_revision_version.
- Indeks: uq_eq_revision_number, fk_eq_revision_base, uq_eq_revision_root, fk_eq_revision_creator, uq_eq_revision_author, uq_eq_revision_pending, ix_eq_revision_queue, PRIMARY, fk_eq_revision_previous, fk_eq_revision_submitter.

### eq_timesheet_verifications

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_verification_request, uq_eq_verification_revision.
- FOREIGN KEY: fk_eq_verification_root, fk_eq_verification_revision, fk_eq_verification_reviewer.
- CHECK: ck_eq_verification_note, ck_eq_verification_self, ck_eq_verification_decision.
- Indeks: PRIMARY, uq_eq_verification_request, ix_eq_verification_actor, fk_eq_verification_root, fk_eq_verification_revision, uq_eq_verification_revision.

### eq_timesheet_work_entries

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_work_line.
- FOREIGN KEY: fk_eq_work_revision.
- CHECK: ck_eq_work_break, ck_eq_work_interval.
- Indeks: PRIMARY, uq_eq_work_line, ix_eq_work_interval.

### eq_unit_periods

- PRIMARY KEY: PRIMARY.
- UNIQUE: uq_eq_period_unit, uq_eq_period_revision.
- FOREIGN KEY: fk_eq_period_unit, fk_eq_period_previous, fk_eq_period_actor.
- CHECK: ck_eq_period_kind, ck_eq_period_dates, ck_eq_period_reason.
- Indeks: uq_eq_period_revision, uq_eq_period_unit, ix_eq_period_dates, fk_eq_period_previous, fk_eq_period_actor, PRIMARY.

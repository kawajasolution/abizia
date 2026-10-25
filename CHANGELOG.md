# Changelog

## 24 Oktober 2026 — M5 Timesheet dan Verifikasi Equipment

- Tambah root/revisi WITH/WITHOUT dan scope own/scoped/reviewer, interval lintas malam/break/detik bersih/HM normal terpisah, immutable submission/hash dan no-self verifikasi.
- Tambah pending tunggal/approved efektif atomik, revisi terminal terotorisasi, pengolahan snapshot assignment sah setelah RETURN tanpa mengubah M4, serta histori/audit/idempotensi/locking.
- Tambah halaman list/form/detail/revisi/antrean/pemeriksaan responsif dan script interval; menu/shortcut route nyata. Router PHP lokal menyajikan asset M5 eksplisit.
- Run akhir 906 integrasi/HTTP dan 2.305 browser assertions, 0 FAIL; migration/preservation/integritas/Apache/lint lulus. Detail: PHASE6_M5_REPORT.md. Reset HM/fakta BA tetap BLOCKED; tidak memulai M6/M7, Finance atau deployment.

## 24 Oktober 2026 — M4 BA Equipment

- Tambah BA draft/edit/cancel, HANDOVER/RETURN subset/ALL, penomoran BA dan lifecycle/aggregate atomik, replay/locking/audit berhistori.
- Tambah addendum administratif terhubung tanpa lifecycle ulang, evidence privat JPEG/PNG/PDF <=5 MB, route/menu BA nyata dan halaman responsif/cetak. Koreksi fakta/reset HM BLOCKED; tanpa grant C otomatis.
- Integrasikan guard sumber/approval M3 pada HANDOVER dan aggregate penutupan setelah pembatalan detail terakhir yang belum diserahkan pasca-return. Schema/migration dan keputusan Trucking/Finance tetap.
- Regresi akhir: 834 integrasi/HTTP, 2.185 browser assertions, 122 migration, 86 preservation, 230 integritas, 16 Apache/isolasi, lint 108 PHP/9 JS; 0 FAIL. Detail file/kasus/risiko: PHASE6_M4_REPORT.md. Tidak melanjutkan M5.

## 24 Oktober 2026 — M3 Kontrak Sewa multi-unit/reservasi

M3 backend/UI tersedia: DRAFT header/customer/unit/operator, CONFIRMED dan reservasi atomik, KS saat confirm header, cancel sebelum ACTIVE, tambahan unit/extension/pengganti jadwal berhistori dan cross-approval dua pihak tanpa self-approval. Kode cabang juga terkunci sesudah KS pertama; DN/MF tidak diubah. Hanya menu Kontrak Sewa dan subproses approval yang aktif; tidak membangun BA/timesheet/halaman Equipment lain.

Run final 17:34:45 WITA: 735 integrasi/HTTP PASS (74 M3 dan 26 A01–A04 adalah subset), 2.059 assertion browser PASS (62 M3), 122 regresi migration M2, 86 preservation development, 230 integritas, 16 Apache/isolasi, lint 101 PHP/8 JS; semuanya 0 FAIL akhir. Database tetap 48 tabel tanpa migration/reset/fixture/grant tambahan pada development. Seluruh C tetap deny; penggunaan approval lintas cabang menunggu penugasan eksplisit. Snapshot/histori T1–5 terjaga. Rincian file, koreksi jalur pengganti operator DRAFT, bukti dan risiko: PHASE6_M3_REPORT.md. **Berhenti M3; M4–M7/Finance/deployment belum dimulai.**

## 24 Oktober 2026 — pemeriksaan akhir ulang M1–M2

Migrator baris 41 menjalankan EquipmentMigration sebelum return baris 42; fresh install membuktikan marker 005 dan 16 nama tabel tepat, termasuk eq_meter_corrections. verification.decide hanya Administrator Y; seluruh C khusus/Admin Sewa tetap deny sesuai keputusan pengguna. Tidak mengubah aplikasi, migration, grant atau data development.

Final run terbaru: 122 PASS/0 FAIL migration/recovery/constraint/fresh/populated upgrade/idempotensi; 661 integrasi/HTTP dan 1.982 assertion browser lulus, termasuk 26 regresi A01–A04; 86 preservation development, 230 integritas, 16 Apache/isolasi; lint 93 PHP/7 JavaScript lulus. Dua tes diperkuat, laporan diperbarui. Kegagalan awal urutan kolasi tabel (3 PASS/1 FAIL) diperbaiki pada harness; peluncuran Chromium spawn EPERM (660 PASS/1 FAIL gerbang, 0 assertion browser) diulang dengan izin proses yang sesuai lalu lulus. Riwayat/bukti dan risiko recovery jendela DDL/power-loss tetap dicatat pada PHASE6_M1_M2_REPORT.md. M3–M7 dan deployment belum dimulai; berhenti untuk pemeriksaan pengguna.

## 24 Oktober 2026 — M1–M2 Equipment, skema saja

Menambahkan 005_equipment_operations.sql (16 tabel, 60 FK/55 CHECK/32 unique/114 indeks), EquipmentMigration (advisory lock, journal hash/fingerprint, fail-closed/resume), EquipmentPermissions (43 definisi; C tanpa grant) serta integrasi Migrator. Tidak ada workflow/controller/view/route Equipment atau perubahan Trucking.

Menambahkan pengujian migration/recovery/upgrade dan preservation development; memperbarui hitungan schema/permission pada regresi existing. Final: 119 uji migration, 82 preservation, 661 regresi/HTTP, 1.982 browser, 230 integritas, 16 Apache/isolasi, 93 PHP lint/7 JS lulus. Kegagalan awal kompatibilitas CHECK AUTO_INCREMENT dan pembandingan counter AUTO_INCREMENT permissions disimpan sebagai riwayat dan dikoreksi; tidak ada kegagalan final. Empat dokumen Equipment, database/keputusan/aturan/progres/README dan laporan M1–M2 diperbarui. Scope M3–M7 belum diizinkan, tanpa reset/data palsu/deployment atau akses proyek/database lama.

## 24 Oktober 2026 — Perbaikan terbatas Tahap 5 A01–A04

Pengguna mengotorisasi empat temuan saja. Validasi transaksi kini memeriksa lokasi asal DN aktif, peran sender/both master terkini dan lokasi muat aktif termasuk stop transit. Snapshot/histori dipertahankan; detail Manifest membaca alasan pembatalan historis beserta aktor/waktu dan membungkus referensi panjang. Dua kegagalan browser selama pengerjaan (overflow 320px dan selector heading ambigu) ditangani dan bukti awal tetap disimpan. Run final 24 Oktober 2026 selesai pukul 14:01:53 WITA: **661 PASS/0 FAIL integrasi/HTTP**, termasuk **26 regresi permanen A01–A04**; **1.982 assertion browser PASS/0 FAIL** (fondasi 108, navigasi 461, dashboard 724, master 351, dokumen Trucking 108, operasional 230). Empat probe audit asli berubah dari 0 PASS/4 FAIL sebelum perbaikan menjadi **4 PASS/0 FAIL** sesudah perbaikan. Integritas development baca-saja **138 PASS/0 FAIL**, Apache lokal/isolasi DB **16 PASS/0 FAIL**, PHP lint **89 file lulus**, sintaks JavaScript **7 file lulus**. Fixture DB/akun/credential/cookie/sesi/file uji dibersihkan; failure=null dan temporary_database_removed=true pada run final.

File aplikasi berubah hanya app/Services/TruckingOperations.php dan app/Views/expedition.php; regresi permanen baru tests/phase5-audit-repairs.php, pengikatan tests/run.php dan perluasan tests/trucking-operations.cjs. PHASE5_FINAL_AUDIT.md, PHASE5_REPORT.md dan laporan baru PHASE5_AUDIT_REPAIR_REPORT.md memuat rincian/status. Tidak ada perubahan migration/tabel/grant/aturan operasional, database/proyek lama atau hosting. Tahap 6 belum dimulai; berhenti untuk pemeriksaan pengguna.

## 24 Oktober 2026 — Verifikasi ulang Tahap 5

Verifikasi ulang mandat lanjutan 24 Oktober 2026 selesai pukul 12:57 WITA: 635 integrasi/HTTP dan 1.952 assertion browser PASS, 0 FAIL; regresi Tahap 1–4, state machine, cakupan cabang, konkurensi dan idempotensi dijalankan kembali. Integritas development baca-saja 138 PASS/0 FAIL, Apache lokal 16 PASS/0 FAIL, lint PHP 88 file dan sintaks JavaScript 7 file lulus. Menambah tests/database-integrity.php dan memperjelas penandaan catatan keputusan historis; kode operasional serta migration terpasang tidak diulang/diubah. Fixture DB/akun/file uji dibersihkan. Laporan PHASE5_REPORT.md diperbarui. Tetap baseline sementara untuk validasi Manager; berhenti sebelum Tahap 6/deployment.

## 24 Oktober 2026 — Penutupan Tahap 5

Verifikasi akhir Tahap 5: 635 integrasi/HTTP; browser fondasi 108, navigasi 461, dashboard 724, master 351, dokumen Trucking 108 dan operasional 200; Apache/isolasi DB 16; lint PHP 88 file dan sintaks JavaScript 7 file lulus. Nol gagal. Migration aditif 004 terpasang pada hls_v2_dev dan rerun no-op: 32 tabel, 10 role, 63 permission, tanpa akun/cabang/master/transaksi bawaan. Regresi Tahap 1–4 serta upgrade 003 berisi transaksi, konkurensi dan idempotensi dijalankan. Lihat PHASE5_REPORT.md untuk rincian, screenshot dan batas verifikasi. Baseline masih sementara untuk validasi Manager. Berhenti setelah Tahap 5; Tahap 6 belum dimulai.

## 2026-10-24

- Tahap 3: direct dashboard per role dari akun DB, controller/service/repository terpisah, snapshot pembacaan dan pemeriksaan permission setiap dataset.
- Menambahkan KPI administrasi, distribusi role, aktivitas/tindak lanjut nyata, filter cabang dan periode audit; widget bisnis yang belum memiliki sumber ditandai Belum tersedia tanpa angka palsu.
- Mempertahankan navigasi Tahap 2, memakai komponen/grid HLS dan mengganti handler/view home lama. Tidak menambah migration, grant, modul transaksi atau aturan bisnis.
- Menambahkan definisi widget dan PHASE3_REPORT; regresi aktual lulus 196 integrasi/HTTP (87 dashboard), 107 browser fondasi, 236 navigasi, 724 dashboard, 14 Apache/DB dan 62 lint PHP. Tahap 4 belum dimulai.

## 2026-10-23

- Tahap 2: satu registry menu dengan lima route tersedia dan 38 item backlog; sidebar desktop/drawer mobile, header profil nyata dan bottom nav berbasis permission.
- Menambahkan 13 partial komponen, SVG, token/layout responsif, fokus drawer, validasi, konfirmasi edit, pagination fondasi, alert/empty/loading state dan retensi input aman.
- Menambahkan suite navigasi semua viewport/role, screenshot aktual dan PHASE2_REPORT.md/NAVIGATION_BACKLOG.md. Hasil akhir: 109 fondasi, 107 browser fondasi, 236 browser navigasi, 14 Apache/DB dan 54 lint PHP lulus. Tahap 3 belum dimulai.

- Tindak lanjut Tahap 1: memasang logo PNG resmi identik pada header fondasi, menguji proporsi/login lima viewport, serta mendokumentasikan persiapan cPanel tanpa akses hosting. Regresi akhir: 101 fondasi, 107 browser, 12 Apache/DB dan 37 lint PHP lulus.

- Tahap 1: menambahkan aplikasi PHP Native berlapis, route eksplisit, konfigurasi privat dan database development terisolasi.
- Menambahkan migration 001 dengan sembilan tabel, role/permission fondasi tanpa akun bawaan, serta bootstrap admin CLI aman.
- Menambahkan autentikasi, session timeout/revocation, CSRF, rate limit, RBAC/cabang dan audit atomik, master pengguna/cabang dan tampilan minimum.
- Menambahkan tes service/HTTP/browser/Apache, fixture DB disposable dan laporan hasil aktual pada Tahap 1; navigasi global kemudian dikerjakan pada Tahap 2 setelah persetujuan.

- Menambahkan audit statis baca-saja proyek lama, aturan bisnis beserta status keputusan, inventaris/rancangan database, design system/navigasi dan rencana implementasi bertahap.
- Menambahkan dokumentasi status/keputusan/progres v2.
- Pada Tahap 0 belum ada implementasi aplikasi. Sepanjang Tahap 0–1 proyek/database lama dan hosting tidak diubah.
# 2026-10-24 — Tahap 4

- Menambahkan 10 submenu/15 entity master nyata, halaman daftar/tambah/detail/edit terpisah, status, search/filter/pagination; tanpa hard delete atau transaksi bisnis.
- Migration 002 aditif: 12 tabel md_* dan perluasan branches, FK/composite FK/index/unik, optimistic version dan audit atomik; total 21 tabel. Upgrade mempertahankan cabang/histori.
- RBAC per entity/aksi/tab, scope kedua endpoint rute, katalog global terproteksi dan akun personel opsional; total 53 permission. Mempertahankan layout Tahap 2 dan widget berbasis sumber nyata.
- Regresi aktual: 481 integrasi/HTTP, 108 browser fondasi, 371 navigasi, 724 dashboard, 351 master browser, 14 Apache/DB, 68 lint PHP; semua lulus. Screenshot lima viewport dan PHASE4_REPORT.md ditambahkan. Berhenti sebelum Tahap 5.


## Tahap 5 — implementasi parsial, 24 Oktober 2026

- DN created dan Manifest draft terintegrasi master, snapshot, version, token create idempoten, audit/event atomik, batch membership/unique active DN dan Tracking internal.
- Migration 003 aditif empat tabel, empat permission tambahan; total 25 tabel/57 permission. Navigasi mengaktifkan hanya DN, Manifest dan Tracking.
- Guard operasional memeriksa akun/cabang/penetapan/grant terkini. Uji dua proses menemukan kebutuhan current locking read untuk active membership; diperbaiki dan diuji ulang.
- Pengguna menolak pengesahan Q03 saat ini: keberangkatan/transit/penerimaan/penyelesaian tetap blocked. Q04 nomor resmi dan Q09 penanganan klaim tetap terbuka. Tahap 5 belum selesai; lihat PHASE5_REPORT.md.

Hasil akhir aktual bagian independen Tahap 5: 544 integrasi/HTTP (10 guard operasional + 53 Trucking termasuk di dalamnya), 108 browser fondasi, 416 navigasi, 724 dashboard, 351 master, 108 browser Trucking, 14 Apache/DB dan 77 lint PHP lulus. Migration 003 terpasang pada development dan idempoten; 25 tabel/57 permission, seluruh master/dokumen tetap kosong. Transit/penerimaan/klaim positif belum diuji karena blocked Q03/Q09. Tahap 5 belum selesai karena dependensi; lihat PHASE5_REPORT.md.

## 2026-10-24 — penyelesaian baseline operasional Tahap 5

- Q03/Q04/alur operasional Q09 disetujui sementara oleh pengguna untuk validasi Manager; blokir sebelumnya digantikan. State machine didokumentasikan sebelum implementasi.
- Migration 004 aditif menambah tujuh tabel (total 32), posisi/histori/official_number, dan enam permission (total 63). Snapshot/timestamp/identifier dokumen lama dipertahankan.
- Trip eksplisit multi-tujuan, konfirmasi/sequence, pencatatan kendaraan dan DN terpisah, pindah Manifest, CANCELLED tanpa reuse nomor, penerimaan utuh aktual, klaim stateful dan bukti privat.
- Penguncian kode cabang pascapenomoran disetujui untuk menjaga namespace. Idempotensi, current read, barrier concurrency, rollback nomor/file dan regresi desktop/mobile ditambahkan. Hasil akhir ada di PHASE5_REPORT.md. Tidak ada transaksi Finance/deployment/Tahap 6.

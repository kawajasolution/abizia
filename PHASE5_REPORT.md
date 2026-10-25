# Laporan Tahap 5 — Trucking / Ekspedisi V2

## Addendum terbaru — perbaikan audit A01–A04

**Perbaikan terbatas selesai dan lulus verifikasi akhir, 24 Oktober 2026.** Run final 24 Oktober 2026 selesai pukul 14:01:53 WITA: **661 PASS/0 FAIL integrasi/HTTP**, termasuk **26 regresi permanen A01–A04**; **1.982 assertion browser PASS/0 FAIL** (fondasi 108, navigasi 461, dashboard 724, master 351, dokumen Trucking 108, operasional 230). Empat probe audit asli berubah dari 0 PASS/4 FAIL sebelum perbaikan menjadi **4 PASS/0 FAIL** sesudah perbaikan. Integritas development baca-saja **138 PASS/0 FAIL**, Apache lokal/isolasi DB **16 PASS/0 FAIL**, PHP lint **89 file lulus**, sintaks JavaScript **7 file lulus**. Fixture DB/akun/credential/cookie/sesi/file uji dibersihkan; failure=null dan temporary_database_removed=true pada run final.

Penyebab diperbaiki pada app/Services/TruckingOperations.php (referensi lokasi aktif/peran pengirim terkini dalam transaksi) dan app/Views/expedition.php (alasan pembatalan historis dengan escaping dan pembungkusan referensi panjang). Regresi permanen ditambahkan lewat tests/phase5-audit-repairs.php, tests/run.php dan tests/trucking-operations.cjs. Tidak mengubah snapshot/histori lama, state machine, Q03/Q04/Q09, penerimaan/klaim/nomor/pergantian kendaraan, migration atau database development. Tidak ada Equipment/Tahap 6/deployment.

[Laporan perbaikan dan daftar file lengkap](PHASE5_AUDIT_REPAIR_REPORT.md), [status audit terbaru](PHASE5_FINAL_AUDIT.md). Angka dan narasi implementasi di bawah merupakan riwayat sebelum addendum ini; hasil final terbaru berada pada addendum. NOT TESTED di luar mandat tetap berlaku. Berhenti untuk pemeriksaan pengguna.

## Riwayat laporan implementasi sebelum perbaikan audit

24 Oktober 2026 — PT Hanqia Lintas Sarana.

**Status: Tahap 5 selesai dan lulus pengujian dalam baseline sementara yang disetujui pengguna.** Q03, Q04 dan alur operasional Q09 disetujui pengguna sebagai **baseline sementara implementasi V2, bukan SOP resmi perusahaan**. Manager masih perlu memvalidasinya. Laporan ini menggantikan status parsial/blocked sebelumnya. Tidak ada Tahap 6, deployment, perubahan Finance atau akses database/proyek lama.

## Keputusan dan state machine

[Tabel transisi sebelum implementasi](TRUCKING_STATE_MACHINE.md) memisahkan dokumen DN, perjalanan kendaraan, transit DN, penerimaan aktual dan klaim. Klarifikasi yang disetujui pengguna:

- Penerimaan hanya utuh/sesuai; selisih tidak dikonfirmasi sebagai penerimaan dan dicatat sebagai klaim.
- Bukti klaim boleh menyusul; kondisi belum dilampirkan ditampilkan.
- Manifest boleh CANCELLED sebelum berangkat setelah kosong, wajib alasan, histori dan nomor tetap.
- Kode cabang dikunci setelah nomor resmi pertama; nama, alamat dan kontak tetap dapat diedit agar namespace nomor tidak digunakan ulang.

DN: created → confirmed → departed → transit berulang atau arrived → received → completed. Manifest: draft → confirmed → departed → transit, berulang per leg, lalu completed di stop terakhir setelah semua DN diturunkan/dipindah. cancelled hanya sebelum berangkat. Klaim: REPORTED → REVIEWING → APPROVED/REJECTED → CLOSED.

## Modul yang berfungsi

| Modul | Perilaku aktual |
|---|---|
| Delivery Note | Satu deskripsi barang, jumlah/satuan dan berat/volume opsional; master kontekstual; daftar/search/filter/pagination, tambah/edit awal/detail, konfirmasi dan nomor resmi; data penting dibekukan setelah konfirmasi |
| Manifest | Trip kendaraan dengan banyak DN dan tujuan berbeda pada lintasan eksplisit; draf, penetapan armada, tambah leg berkesinambungan, konfirmasi/nomor resmi, batch anggota aktif, pergantian kendaraan melalui Manifest baru dan histori perpindahan |
| Transit | Daftar perjalanan aktif, detail leg/posisi, keberangkatan, kedatangan kendaraan, pencatatan DN terpilih yang benar-benar tiba, penurunan dan perjalanan berikutnya |
| Penerimaan | Daftar yang memenuhi syarat, penerimaan utuh aktual di tujuan, nama penerima/petugas/kondisi/waktu, pencegahan penerimaan ganda dan penyelesaian DN setelah penerimaan |
| Klaim | Jenis masalah, deskripsi/pelapor/cabang/aktor/waktu, status dan histori penanganan, pencarian/filter/pagination, lampiran privat dan unduhan terotorisasi |
| Tracking internal | Referensi/status/posisi dan timeline event aktual; penerimaan hanya muncul setelah record penerimaan; autentikasi/RBAC/cakupan cabang, tanpa tracking publik |

Lintasan terdiri dari leg master md_routes dan lokasi yang berkesinambungan. Tujuan DN harus ada pada stop mendatang; kesamaan cabang saja tidak cukup. Tidak membuat jaringan rute atau menyimpulkan semua tujuan berada pada lintasan. Satu DN hanya satu anggota aktif, dilindungi generated unique key dan current locking read. Batch seluruhnya valid atau rollback.

Kedatangan kendaraan tidak mengubah DN menjadi tiba. Petugas memilih DN aktual; hanya DN terpilih memperoleh posisi/status arrival. DN pada tujuan harus diturunkan sebelum kendaraan melanjutkan. Trip boleh melanjutkan leg tersisa tanpa muatan setelah seluruh DN diturunkan/dipindah. Manifest selesai tidak membuat received/completed pada DN atau record penerimaan. Pergantian kendaraan setelah konfirmasi menggunakan Manifest baru dengan sumber/tujuan/alasan/aktor/waktu, tanpa menghapus anggota lama.

## Penomoran Q04

- `DN/{KODE_CABANG}/{TAHUN}/{000001}` saat konfirmasi DN.
- `MF/{KODE_CABANG}/{TAHUN}/{000001}` saat konfirmasi Manifest.
- `INV/{KODE_CABANG}/{TAHUN}/{000001}` hanya saat ISSUED: keputusan tercatat untuk Finance berikutnya, **tidak diimplementasikan sebagai transaksi/issuance invoice Tahap 5**.

Counter terpisah jenis/cabang/tahun, tahun waktu konfirmasi WITA, row lock dan unique index. Nomor committed tidak dipakai ulang, termasuk Manifest dibatalkan. Tanggal dokumen mundur tidak mengubah nomor. Identifier internal INT-DN/INT-MF tetap tersimpan terpisah dari official_number. Batas enam digit habis ditolak, tanpa wrap/reset. Rollback sebelum commit tidak mempublikasikan nomor. Penguncian kode cabang pascapenomoran diperiksa backend dan diserialisasi dengan penerbitan nomor.

## Database dan migration

Migration aditif [004_trucking_operations.sql](database/migrations/004_trucking_operations.sql), mempertahankan 001–003. Total 32 tabel dan 63 permission, sepuluh role. Tidak reset development atau seed transaksi.

| Tabel baru | Relasi/constraint/index |
|---|---|
| exp_trip_legs | Manifest, posisi unik, FK komposit route/cabang dan lokasi/cabang; snapshot, waktu kendaraan tiba; index cabang/manifest |
| exp_sequences | PK jenis/cabang/tahun, FK cabang dan CHECK tipe DN/MF serta batas counter |
| exp_requests | Token unik, FK aktor/cabang, aksi/hash payload/hasil untuk idempotensi |
| exp_receipts | DN unik, FK cabang/aktor, kuantitas utuh dan waktu penerimaan |
| exp_claims | FK DN/cabang/aktor, state/version, index cabang/status/tanggal dan DN |
| exp_claim_events | Ledger sebelum/sesudah/catatan/aktor/waktu, index klaim/id |
| exp_evidence | FK klaim/aktor; storage_key unik, MIME/ukuran/SHA-256, unique klaim/hash |

Kolom aditif pada DN/Manifest: official_number/confirmed_at, posisi DN, current_stop Manifest. Membership menambah removed_by/removal_reason/moved_to_manifest_id. CHECK status diperluas sesuai baseline. Semua relasi RESTRICT; tidak ada hard delete/cascade histori.

Upgrade dokumen 003 dibackfill dari referensi dan snapshot historis, mempertahankan timestamp asli. Tidak mengambil nama master terbaru untuk mengganti histori, menerbitkan nomor secara otomatis, atau membuat event kedatangan/penerimaan rekaan. Fresh install, upgrade fondasi dan upgrade 003 berisi DN/Manifest/membership/event diuji pada DB disposable V2.

## Hak akses dan keamanan

Enam permission aditif: expedition.confirm, expedition.transit, expedition.receive, expedition.claim.view, expedition.claim.report, expedition.claim.review. Empat permission parsial tetap: expedition.view, expedition.ship, expedition.manifest.view, expedition.manifest.

| Role | Akses operasional |
|---|---|
| Administrator | Semua aksi Trucking, tetap sesuai cakupan akun dan cabang aktif |
| Owner | Baca DN/Manifest/Tracking/klaim; tanpa mutasi |
| Admin Pengirim | Buat/edit/konfirmasi DN, baca perjalanan dan lapor klaim dalam cakupan |
| Admin Transit | Kelola trip, catat transit/perpindahan dan lapor klaim pada cabang berwenang |
| Admin Penerima | Penerimaan/penyelesaian aktual dan pelaporan klaim pada cabang tujuan |
| Role lain/Customer | Tanpa grant Trucking; tidak ada portal publik |

Review/keputusan/penutupan klaim awal hanya Administrator; delegasi Manager dapat ditinjau setelah validasi. Permission disimpan di DB, tanpa bypass nama role runtime. Read dibatasi cabang asal/tujuan/posisi atau keterlibatan trip historis yang sah dengan penetapan efektif. Write memerlukan cabang peristiwa aktif, aktor/role/auth_version/cakupan/grant terkini dan penetapan yang masih berlaku. all_branches tidak melewati cabang nonaktif.

Routing/group permission, controller HTTP, service aturan/transaksi dan repository query terpisah. Semua POST CSRF, prepared PDO, escaping output, version/row lock, token idempotensi terikat aktor/aksi/payload/cabang, audit/event atomik. Replay identik tidak menggandakan record/event/nomor/file; token berbeda tidak melewati unique membership/receipt/state/version. Konflik menghasilkan penolakan, tidak data parsial.

Bukti JPEG/PNG/PDF maksimal 5 MB, MIME dari isi dan ekstensi sesuai, nama storage acak di luar public, SHA-256 dan attachment download berizin. Berkas identik per klaim tidak digandakan; kegagalan audit membersihkan file baru. Download tidak menerima path dari pengguna. Bukti boleh menyusul, termasuk sebagai tambahan histori, tanpa menulis ulang file lama. Klaim tidak mengubah status/posisi DN atau sumber Finance.

## Route

Prefix Apache `/hls-v2/public`.

| Route | Metode |
|---|---|
| /trucking/dns | GET/POST |
| /trucking/manifests | GET/POST |
| /trucking/transit | GET |
| /trucking/receipts | GET/POST |
| /trucking/claims | GET/POST |
| /trucking/tracking | GET |
| /trucking/evidence?id=... | GET, download privat |

Aksi berada di halaman detail, bukan submenu tambahan. Trip actions melalui POST Manifest; penerimaan melalui POST Penerimaan. Mode daftar/create/edit-awal/detail sesuai modul; query q/status/branch/from/until/page. Registry tunggal kini mengaktifkan enam submenu Trucking; tidak ada route dummy. Dashboard fondasi dan layout Tahap 2 dipertahankan; tautan/shortcut mengikuti route/permission aktual. Tidak mengaktifkan agregasi Finance atau angka bisnis simulasi.

## File

Baru: TRUCKING_STATE_MACHINE.md, migration 004, app/Services/DocumentNumbers.php, app/Services/OperationalWrite.php, app/Services/TruckingOperations.php, app/Services/Claims.php; app/Repositories/TruckingRepository.php; app/Controllers/OperationsController.php; app/Views/claims.php dan app/Views/components/trucking-actions.php; tests/trucking-operations.php, trucking-upgrade.php, concurrency.php, trucking-operations.cjs, database-integrity.php; screenshot/JSON baru.

Dimodifikasi: app/Services/Migrator.php, app/Services/ExpeditionPermissions.php, app/Services/Expedition.php, app/Services/MasterData.php; app/Repositories/ExpeditionRepository.php dan app/Repositories/MasterDataRepository.php; app/Controllers/ExpeditionController.php; app/Views/expedition.php; app/routes.php/navigation.php, public/index.php. Tests run.php, expedition.php/worker, browser.cjs, navigation.cjs, dashboard.php, deployment.php. Dokumen BUSINESS_RULES, DECISIONS, DATABASE_DESIGN, PHASE5_REPORT, README, PROGRESS, CHANGELOG, IMPLEMENTATION_PLAN, NAVIGATION_BACKLOG, TRUCKING_DESIGN dan DASHBOARD_WIDGETS diperbarui. Konfigurasi privat/credential lama tidak ditampilkan atau disalin.

## Pengujian aktual

Eksekusi akhir 24 Oktober 2026 pada PHP 8.2.12/MariaDB 10.4.32 dan Chromium lokal: seluruh pemeriksaan berikut lulus, nol gagal.

| Rangkaian | Lulus | Bukti |
|---|---:|---|
| Integrasi/HTTP gabungan, termasuk regresi Tahap 1–4 | 635 | [foundation.json](tests/results/foundation.json) |
| Browser fondasi | 108 | [browser.json](tests/results/browser.json) |
| Browser navigasi/komponen | 461 | [navigation.json](tests/results/navigation.json) |
| Browser dashboard | 724 | [dashboard-browser.json](tests/results/dashboard-browser.json) |
| Browser master data | 351 | [master-browser.json](tests/results/master-browser.json) |
| Browser regresi dokumen Trucking awal | 108 | [expedition-browser.json](tests/results/expedition-browser.json) |
| Browser operasional enam modul | 200 | [trucking-browser.json](tests/results/trucking-browser.json) |
| Apache lokal/isolasi database | 16 | [deployment.json](tests/results/deployment.json) |
| Integritas development baca-saja | 138 | [database-integrity.json](tests/results/database-integrity.json) |
| Lint PHP | 88 file | [lint.json](tests/results/lint.json) |
| Sintaks JavaScript | 7 file | node --check |

Jumlah browser: 1.952 assertion. Sebanyak 78 pengujian operasional, 13 upgrade berisi transaksi lama 003, 53 dokumen awal dan 10 active-membership guard merupakan bagian dari 635 integrasi/HTTP, bukan tambahan yang dihitung ulang. Bukti khusus: [operasional](tests/results/trucking-operations.json), [upgrade](tests/results/trucking-upgrade.json), [guard](tests/results/expedition-access.json).

Migration 004 sudah dipasang secara aditif pada hls_v2_dev; eksekusi ulang tidak mengubah apa pun. Verifikasi setelah pemasangan: 32 tabel, 10 role, 63 permission; nol pengguna, cabang, baris master dan transaksi Trucking. Tidak membuat akun/password bawaan. Bootstrap administrator aman yang sudah tersedia tetap diperlukan untuk penggunaan lokal. Seluruh fixture pengujian hanya pada DB disposable dan telah dibersihkan.

Materi backend: multi-tujuan sah dan penolakan lintasan tak berkesinambungan/tujuan di luar trip; konfirmasi/nomor/backdate/immutability kode cabang; status ilegal, versi usang, active membership dan branch scope; kedatangan kendaraan terpisah dari DN/penerimaan; penggantian kendaraan/histori/CANCELLED; penerimaan utuh/ganda; semua cabang state machine klaim; bukti privat/MIME/ekstensi/download dan lintas cabang; CSRF; rollback audit/nomor/file. Dua proses dan dua aktor dilepas melalui barrier untuk persaingan active membership, nomor resmi dan penerimaan.

Browser Chromium: semua enam menu pada 320×640, 375×812, 402×874, 768×1024, 1366×768. Alur aktual DN → nomor resmi → Manifest → keberangkatan → kendaraan tiba → DN tiba → turun → Manifest selesai → penerimaan → DN selesai; klaim tanpa bukti → bukti menyusul → REVIEWING → APPROVED → CLOSED, timeline dan ruang bottom navigation. Regresi Tahap 1–4 dijalankan kembali. File fixture/cookie/credential/sesi/DB/akun uji dibersihkan.

| Viewport | Form penerimaan | Detail klaim |
|---|---|---|
| 320×640 | [penerimaan](tests/results/phase5-receipt-320.png) | [klaim](tests/results/phase5-claim-320.png) |
| 375×812 | [penerimaan](tests/results/phase5-receipt-375.png) | [klaim](tests/results/phase5-claim-375.png) |
| 402×874 | [penerimaan](tests/results/phase5-receipt-402.png) | [klaim](tests/results/phase5-claim-402.png) |
| 768×1024 | [penerimaan](tests/results/phase5-receipt-768.png) | [klaim](tests/results/phase5-claim-768.png) |
| 1366×768 | [penerimaan](tests/results/phase5-receipt-1366.png) | [klaim](tests/results/phase5-claim-1366.png) |

## Batas verifikasi dan keputusan lanjutan

Baseline masih menunggu validasi Manager sebagai SOP perusahaan: matriks delegasi/review, satu deskripsi per DN, penerimaan utuh, batas trip tanpa lokasi berulang, kondisi klaim dan prosedur koreksi/retur/pembatalan DN. Driver opsional; konflik jadwal kendaraan/driver lintas trip belum diberi kebijakan dan tidak dihitung sebagai fitur penjadwalan. Angka kompensasi, refund, pajak/tarif/invoice/pembayaran dan penyelesaian finansial klaim tetap di luar Tahap 5.

MySQL 8, Safari/perangkat fisik, HTTPS dan cPanel belum diuji. Migration DDL parsial tetap memerlukan pemeriksaan manual, tanpa reset otomatis. Tidak migrasi data proyek lama atau mengakses hosting. Tidak membuat atau menguji issuance invoice baru; format INV adalah keputusan untuk tahap Finance berikutnya.

**Status akhir: selesai dan lulus pengujian Tahap 5 pada baseline sementara.** Tidak ada pengujian kritis dalam lingkup ini yang gagal atau belum dijalankan. Validasi Manager dan batas platform di atas tetap berlaku. Pekerjaan berhenti setelah Tahap 5; Tahap 6 dan deployment menunggu mandat terpisah.
## Verifikasi ulang atas mandat lanjutan — 24 Oktober 2026

Enam dokumen mandat dibaca kembali dan implementasi terakhir diperiksa; tidak mengulang modul atau mengubah aturan bisnis. Ditambahkan tests/database-integrity.php yang hanya membaca hls_v2_dev: engine seluruh tabel, CHECK TABLE, setiap FK termasuk komposit, dan sembilan invariant operasional. Hasil 138 PASS/0 FAIL. Database development belum berisi transaksi; pemeriksaan data operasional berisi fixture dilakukan pada suite integrasi/HTTP disposable, bukan dianggap teruji hanya dari database kosong. Pemeriksaan Apache lokal tetap 16 PASS/0 FAIL; ini pengujian instalasi lokal, tanpa deployment hosting. Judul gerbang historis pada dokumen diperjelas agar tidak disalahartikan sebagai blokir yang masih berlaku.

Eksekusi ulang selesai 24 Oktober 2026 pukul 12:57:38 WITA: 635 PASS/0 FAIL integrasi/HTTP, failure=null, cleanup database uji terverifikasi. Browser: fondasi 108, navigasi 461, dashboard 724, master 351, regresi dokumen Trucking 108 dan operasional 200 PASS (total 1.952), seluruhnya 0 FAIL. PHP lint 88 file dan JavaScript 7 file lulus. Keamanan, cakupan cabang, state machine, konkurensi, idempotensi, rollback audit dan regresi Tahap 1–4 termasuk dalam suite tersebut; bukan hitungan tambahan. Screenshot lima viewport diperbarui dari eksekusi ini; form penerimaan mobile diperiksa ulang secara visual. Tidak ditemukan kebutuhan memperbaiki kode operasional atau menambah migration. Tidak ada pengujian kritis dalam lingkup Tahap 5 yang gagal atau tertinggal.

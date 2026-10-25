# HLS Transport Management System v2

Status terbaru: **Tahap 6 M5 Timesheet dan Verifikasi selesai dengan catatan; reset/penggantian HM khusus dan koreksi fakta BA tetap BLOCKED.** Run akhir 24 Oktober 2026 19:01:26 WITA: **906 integrasi/HTTP + 2.305 assertion browser, 0 FAIL**. WITH/WITHOUT, scoped/own, interval/break/HM, revisi immutable dan verifikasi no-self tersedia tanpa migration/reset atau seed C. Laporan: [PHASE6_M5_REPORT.md](PHASE6_M5_REPORT.md). M6/M7 dan deployment belum dimulai; status milestone terdahulu di bawah adalah riwayat.

Status terbaru: **Tahap 6 M4 BA Equipment selesai dengan catatan; koreksi fakta operasional tetap BLOCKED menunggu SOP khusus.** BA HANDOVER/RETURN per unit/ALL, lifecycle, nomor BA, histori, bukti privat dan cetak terintegrasi. Run akhir 24 Oktober 2026 18:18:25 WITA: 834 integrasi/HTTP + 2.185 assertion browser, 0 FAIL. Tidak ada grant C otomatis, schema/reset development atau implementasi M5. Laporan lengkap: [PHASE6_M4_REPORT.md](PHASE6_M4_REPORT.md). Catatan status M1–M3 di bawah merupakan riwayat milestone.

PT Hanqia Lintas Sarana — Trucking / Ekspedisi dan Equipment / Penyewaan Alat Berat.

Status: **Tahap 6 mencakup M3 Kontrak Sewa multi-unit/reservasi dan antarmuka kontrak.** M4–M7, Finance dan deployment belum dimulai. Baseline sementara, belum SOP perusahaan. Hasil pengujian: [PHASE6_M3_REPORT.md](PHASE6_M3_REPORT.md).

Dokumentasi:

- [Audit dan temuan](PROJECT_AUDIT.md)
- [Aturan bisnis dan keputusan terbuka](BUSINESS_RULES.md)
- [Rancangan database](DATABASE_DESIGN.md)
- [Design system dan navigasi](UI_DESIGN_SYSTEM.md)
- [Rencana implementasi](IMPLEMENTATION_PLAN.md)
- [Keputusan](DECISIONS.md), [progres](PROGRESS.md), [riwayat perubahan](CHANGELOG.md)
- [Laporan Tahap 2 dan screenshot](PHASE2_REPORT.md), [backlog navigasi](NAVIGATION_BACKLOG.md)
- [Laporan Tahap 4, route, permission dan screenshot](PHASE4_REPORT.md), [desain master](MASTER_DATA_DESIGN.md)
- [Laporan Tahap 3 dan screenshot](PHASE3_REPORT.md), [sumber/definisi widget](DASHBOARD_WIDGETS.md)

Proyek lama `D:/xampp/htdocs/hlstransport` tetap baca-saja. Tidak mengubah database lama atau mengakses hosting. Lihat [laporan Tahap 1](PHASE1_REPORT.md) untuk hasil aktual dan batas verifikasi.

## Menjalankan fondasi lokal

Apache XAMPP: [halaman login](http://localhost/hls-v2/public/login). Document root aplikasi adalah `public/`; root proyek sengaja membalas 403. File `.htaccess` wajib aktif. Tidak ada password/akun administrator default dan database development saat ini tidak berisi pengguna atau cabang.

Buat administrator awal dengan password pilihan Anda di PowerShell lokal:

```powershell
.\bin\bootstrap-admin.ps1 -Name "Nama Administrator" -Email "alamat-email-anda"
```

Script meminta password tersembunyi dua kali (12–72 byte, tanpa karakter kontrol), meneruskannya lewat STDIN UTF-8 ke PHP, dan tidak mencetak/menyimpan password plaintext. Bootstrap hanya CLI, hanya saat tabel users kosong, memakai lock/transaction dan audit; tidak dapat dipakai untuk mereset akun. Jangan menaruh password di argumen command, history atau dokumen. Setelah bootstrap, masuk dan buat cabang lalu pengguna melalui UI. Akun sendiri tidak dapat diubah melalui master; perubahan akun lain membatalkan sesi lamanya. Tidak ada layanan lupa password/email/remember-me pada fondasi ini.

Konfigurasi privat ada di `config/local.php` (diabaikan Git). Akun DB `hls_v2_app` hanya diberi hak pada `hls_v2_dev`; password acak dibuat saat provision dan tidak perlu ditampilkan. Konfigurasi HTTP lokal memakai cookie Secure=false; HTTPS harus memakai Secure=true. Sesi disimpan di `storage/sessions`, terpisah dari proyek lain, dengan timeout 30 menit.

Untuk instalasi kosong baru (jangan menjalankan provision pada database yang sudah ada):

```powershell
php bin/setup-dev.php
php bin/migrate.php
```

Setup memakai akun administrasi MySQL lokal dari `HLS_DB_ADMIN_USER`/`HLS_DB_ADMIN_PASSWORD` atau root lokal tanpa password bila memang dikonfigurasi demikian oleh XAMPP. Credential administratif tidak disimpan sebagai akun aplikasi. Provision menolak jika database/akun target sudah ada, tidak melakukan reset. Migration dapat pula dipasang pada database kosong yang disediakan sendiri menggunakan konfigurasi contoh, dengan akun khusus; target di luar allowlist `hls_v2_dev` atau `hls_v2_test_<12 hex>` ditolak. DDL tidak atomik: kegagalan instalasi parsial harus diperiksa manual, tidak diatasi dengan penghapusan otomatis.

## Route dan hak akses

`GET /` langsung menampilkan dashboard sesuai role dari akun DB melalui DashboardController/Service/Repository. Administrator memperoleh KPI dan aktivitas administrasi nyata sesuai permission; role bisnis mendapat fokus kerja masing-masing dengan status Belum tersedia untuk sumber yang belum ada. Tidak ada angka 0 pengganti DN/invoice/stok. Identitas dan cabang sendiri tetap nyata. `GET/POST /login`, `POST /logout`, `GET/POST /users`, `GET/POST /branches`, `GET /roles`, `GET /audit` tetap berfungsi. Seluruh URL memakai prefix `/hls-v2/public` pada Apache. Role/permission masih baca-saja; tidak ada editor grant dinamis. Sidebar desktop/drawer mobile dan bottom nav memakai satu registry app/navigation.php tanpa perubahan posisi Tahap 2. Menu bisnis yang belum memiliki route tidak ditampilkan.

Database memiliki 53 permission (tujuh fondasi + 46 master). Administrator mengelola master sesuai cakupan; katalog global dan pembuatan cabang memerlukan all_branches. Owner membaca master tanpa mutasi; role operasional membaca referensi tertentu. Customer tidak memperoleh master. Users/roles/audit tetap mensyaratkan cakupan global. Matriks lengkap berada di PHASE4_REPORT.md; pemeriksaan izin/cabang dijalankan backend.

## Pengujian

```powershell
php tests/run.php
php tests/deployment.php
php tests/database-integrity.php
```

Runner membuat DB/akun uji acak `hls_v2_test_*`, memakai credential uji acak, menyalakan server loopback dan Chromium, lalu membersihkan DB/akun/file credential/cookie/sesi uji. Tidak memakai database development untuk fixture. Akun administrasi MySQL diperlukan untuk CREATE/DROP database uji saja. Jangan menjalankan suite proyek lama.

Browser runner memakai library Playwright yang sudah terpasang pada node_modules proyek lama secara baca-saja, bukan source/tes lamanya. Dapat diganti lewat `HLS_PLAYWRIGHT_MODULE` ke instalasi Playwright lokal lain. Chromium perlu dapat diluncurkan; sandbox yang memblokir spawn harus memberi izin proses. Kegagalan browser membuat suite gagal, tidak ditandai skip/lulus.

Hasil akhir Tahap 4: 481 pemeriksaan integrasi/HTTP (termasuk 286 khusus master), 108 browser fondasi, 371 navigasi/komponen, 724 dashboard, 351 browser master, 14 Apache/isolasi DB, serta 68 PHP lint lulus. Lima viewport: 320×640, 375×812, 402×874, 768×1024, 1366×768. Bukti run aktual di tests/results/. MySQL 8, TLS nyata, perangkat fisik dan hosting belum diuji.

Logo PNG resmi digunakan utuh pada header login/halaman fondasi; salinan identik SHA-256 dengan aset sumber, tanpa bidang putih tambahan dari CSS dan tanpa perubahan proporsi. Regresi browser memeriksa pemuatan/rasio logo serta overflow halaman login pada lima viewport.

Desktop memakai sidebar pada lebar ≥1024px. Di bawahnya, hamburger kiri membuka drawer dengan X/overlay/Escape dan pengelolaan fokus; shortcut mobile berukuran 64px + safe-area. Profil menampilkan identitas akun dan logout nyata. Notifikasi belum tersedia dan tidak diberi tombol/dot palsu. Form/tabel/pagination/modal/alert/loading digunakan pada Pengguna/Cabang/Audit, tanpa halaman bisnis dummy. Layout ini dipertahankan pada dashboard Tahap 3. Berhenti setelah Tahap 4; Tahap 5 menunggu persetujuan.

Filter cabang dashboard hanya menawarkan ID yang diizinkan dan memengaruhi daftar/jumlah cabang serta pengguna dengan akses cabang tersebut. KPI adalah kondisi saat ini; role/permission global. Periode hanya berlaku pada audit global (batas tanggal inklusif WITA). Jika cabang tertentu dipilih, audit tidak ditampilkan sebagai audit cabang karena belum ada metadata cabang transaksi. Rincian definisi dan widget menunggu modul ada di DASHBOARD_WIDGETS.md; tidak ada perubahan aturan akuntansi atau migration bisnis.

Lihat [persiapan cPanel](CPANEL_PREPARATION.md) untuk layout public/private, persyaratan hosting dan gerbang staging yang belum dijalankan. Allowlist database saat ini memang hanya development/test; ini belum paket deployment produksi.

## Master Data Tahap 4

Cabang, Customer, Pengirim & Penerima, Lokasi & Rute, Tarif Trucking, Tarif Equipment, Kendaraan & Unit, Driver & Operator, Barang & Kategori/Satuan, Supplier tersedia sebagai 10 submenu/15 entity. Daftar, pencarian/filter/pagination, tambah, detail, edit, nonaktif dan aktif kembali menggunakan halaman nyata. Lihat PHASE4_REPORT.md untuk path dan query mode. Tidak ada hard delete.

Migration 002_master_data.sql menambah 12 tabel md_* dan memperluas branches, total 21 tabel. Untuk instalasi fondasi existing jalankan hanya `php bin/migrate.php`; jangan menjalankan setup-dev atau reset. Development tetap tanpa data contoh dan akun bawaan. Relasi FK, kode unik, scope kedua endpoint rute, version dan audit atomik melindungi perubahan. Katalog barang global tidak menyimpan stok. Tarif hanya referensi manual; kosong berbeda dari nol; paket Equipment jam/shift/bulan tanpa rumus tagihan. Tarif harian menunggu keputusan.

## Riwayat Tahap 5 parsial — sebelum persetujuan baseline operasional

DN awal, Manifest draf dan Tracking internal tersedia pada /trucking/dns, /trucking/manifests, /trucking/tracking. Lihat [laporan Tahap 5](PHASE5_REPORT.md) dan [desain](TRUCKING_DESIGN.md). Mandat mencakup DN/Manifest, tetapi pengguna belum mengesahkan SOP Q03 dan secara eksplisit meminta transisi terkait diblokir. Tidak ada keberangkatan/transit/penerimaan/klaim yang diaktifkan berdasarkan alur demo. Tahap 5 belum selesai; tahap berikutnya belum dimulai.

Migration 003_trucking aditif menambah empat tabel dokumen/histori; total 25 tabel dan 57 permission. Nomor INT-DN/INT-MF adalah identifier internal, bukan format resmi Q04. Semua data development tetap tanpa fixture/akun bawaan. Operasi mutasi memakai akun/cabang/penetapan aktif, permission backend, CSRF, transaksi, version, audit dan unique active membership. Tracking memerlukan autentikasi; tidak ada portal publik.

Hasil akhir aktual bagian independen Tahap 5: 544 integrasi/HTTP (10 guard operasional + 53 Trucking termasuk di dalamnya), 108 browser fondasi, 416 navigasi, 724 dashboard, 351 master, 108 browser Trucking, 14 Apache/DB dan 77 lint PHP lulus. Migration 003 terpasang pada development dan idempoten; 25 tabel/57 permission, seluruh master/dokumen tetap kosong. Transit/penerimaan/klaim positif belum diuji karena blocked Q03/Q09. Tahap 5 belum selesai karena dependensi; lihat PHASE5_REPORT.md.

## Pembaruan Tahap 5 — baseline sementara disetujui

Keputusan terbaru menggantikan blokir Q03/Q04/alur klaim Q09 sebelumnya. DN, Manifest trip-based, Transit, Penerimaan, Klaim dan Tracking internal tersedia; tabel transisi ditulis di TRUCKING_STATE_MACHINE.md sebelum implementasi. Lihat PHASE5_REPORT.md untuk hasil akhir, route, permission, file dan screenshot.

Migration 004_trucking_operations aditif: total 32 tabel/63 permission/10 role, tanpa reset atau akun/data contoh. Jalankan hanya `php bin/migrate.php` pada development existing. Konfirmasi menerbitkan nomor DN/MF per jenis/cabang/tahun WITA dan mempertahankan identifier internal. Nomor invoice saat ISSUED hanya ketentuan untuk tahap Finance berikutnya, tanpa implementasi invoice baru. Kode cabang terkunci setelah nomor resmi pertama; nama/alamat/kontak tetap dapat diedit.

Kedatangan kendaraan, kedatangan DN terpilih, penurunan dan penerimaan aktual adalah operasi terpisah. Penerimaan hanya utuh; selisih menjadi klaim. Bukti boleh menyusul, JPEG/PNG/PDF maksimal 5 MB disimpan privat di storage/private/claims (atau claim_dir privat yang dikonfigurasi). Download hanya lewat endpoint berizin. Status klaim REPORTED → REVIEWING → APPROVED/REJECTED → CLOSED tanpa perubahan Finance. Manager masih perlu memvalidasi baseline sebagai SOP resmi.

## Equipment — batas M1–M2

Migration 005 menambah 16 tabel kosong (total 48), katalog 43 permission baru (total 106) dan grant Y/O sesuai matriks. Semua C hanya definisi/tanpa grant sesuai keputusan pengguna. Database development tidak direset atau diisi akun/operator/transaksi/nomor palsu. Untuk upgrade existing gunakan `php bin/migrate.php`; journal diverifikasi saat retry. Recovery dan kasus ambigu: PHASE6_IMPLEMENTATION_PLAN.md; jangan DROP/reset atau memakai CREATE IF NOT EXISTS untuk menyembunyikan schema drift.

Tes: `php tests/equipment-migrations.php` memakai database disposable untuk fresh/upgrade/constraint/recovery; `php tests/equipment-development.php verify` memeriksa snapshot privat development secara baca-saja. Jalankan `php tests/run.php` untuk regresi lengkap existing. Hasil aktual M1–M2 tercatat dalam laporan. Belum ada route/menu Equipment, kontrak/reservasi aktif, BA/timesheet workflow, upload, allocator KS/BA atau branch-code lock Equipment. M3 memerlukan instruksi baru.
## M3 — Kontrak Sewa dan reservasi

GET/POST `/equipment/contracts`: daftar/filter/pagination, draft header/detail multi-unit, WITH/WITHOUT operator, konfirmasi/KS, cancel sebelum ACTIVE, histori, usulan/penerapan extension dan pengganti operator. Menu Kontrak Sewa memakai registry/permission existing. `/equipment/authorizations` hanya untuk petugas yang telah diberi permission approval secara eksplisit; seluruh C tetap tanpa grant default, tidak ada bypass Administrator. M3 tidak menyediakan BA, ACTIVE/return operasional, timesheet atau verifikasi.

Tidak ada migration baru atau reset development. Jalankan `php tests/run.php` untuk regresi T1–5 sekaligus backend/HTTP/concurrency/browser M3; `php tests/equipment-migrations.php` untuk regresi M2. Bukti tersimpan pada tests/results/equipment-contracts.json dan equipment-browser.json. Laporan lengkap dan batas: PHASE6_M3_REPORT.md. Berhenti setelah M3.

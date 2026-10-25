# Demo Hosting Readiness Report

Tanggal audit: 24 Oktober 2026 (WITA)

## Status dan batas audit

Audit ini menilai kesiapan aplikasi untuk lingkungan demo terisolasi. Tidak ada deployment, perubahan hosting, perubahan database lama, atau pembuatan akun pada `hls_v2_dev`. Pengembangan fitur M6/M7 juga tidak dimulai.

Kesimpulan: **BELUM SIAP DEPLOY DEMO**. Fondasi aplikasi, RBAC, navigasi, dan modul yang telah diuji cukup untuk dijadikan kandidat demo setelah database demo terpisah, seed data sintetis, akun demo, dan prosedur reset disiapkan serta diuji.

## Role yang tersedia

Database menyediakan sepuluh role: Administrator, Owner, Admin Pengirim, Admin Transit, Admin Penerima, Admin Sewa, Operator Alat Berat, Finance, Gudang, dan Customer. Katalog permission Equipment mendefinisikan permission C sensitif, tetapi grant C tidak diberikan otomatis. Administrator tidak menjadi bypass untuk permission C.

## Akun demo

Status akun demo: **NOT IMPLEMENTED**.

Database development saat audit tidak boleh dipakai sebagai database demo dan tidak diisi akun contoh. Bootstrap administrator yang ada hanya CLI lokal, meminta password interaktif, dan tidak menyediakan endpoint bootstrap web. Tidak ada akun default atau password yang dapat dilaporkan.

Rancangan akun yang perlu dibuat pada database demo terpisah, setelah persetujuan deployment:

| Role | Username usulan | Scope demo | Catatan |
|---|---|---|---|
| Administrator | `demo_administrator` | Global | Akun demo tanpa grant C; tidak memakai password Administrator operasional |
| Owner | `demo_owner` | Cabang demo | Baca dan monitoring sesuai grant |
| Admin Pengirim | `demo_pengirim` | Cabang demo | DN dan tracking yang tersedia |
| Admin Transit | `demo_transit` | Cabang demo | Manifest/transit yang tersedia |
| Admin Penerima | `demo_penerima` | Cabang demo | Penerimaan/klaim yang tersedia |
| Admin Sewa | `demo_sewa` | Cabang demo | Kontrak, BA, timesheet scoped |
| Operator Alat Berat | `demo_operator` | Projection penugasan sendiri | Timesheet sendiri saja |
| Finance | `demo_finance` | Cabang demo | Hanya menu/status yang benar-benar ber-route; Finance belum dibangun |
| Gudang | `demo_gudang` | Cabang demo | Hanya menu/status yang benar-benar ber-route; Inventory belum dibangun |
| Customer | `demo_customer` | Data pelanggan demo | Tracking sesuai grant dan data sintetis |

Password sederhana seperti `123456` hanya boleh digunakan pada database demo yang terisolasi, dengan rate limiting, tanpa akses Administrator operasional, dan tidak boleh ditulis ke repository atau laporan publik. Mekanisme satu klik juga harus menghasilkan sesi demo terbatas dan tidak boleh melewati autentikasi/RBAC.

## Matriks menu dan backend

Menu berasal dari satu registry `app/navigation.php`; item tanpa route tidak ditampilkan sebagai menu yang dapat diklik. Backend tetap memeriksa permission dan branch scope.

| Role | Menu/route yang tersedia untuk demo | Area yang tidak tersedia / dibatasi |
|---|---|---|
| Administrator | Dashboard, Users, Branches, Roles, Audit; seluruh route yang grant-nya tersedia | Tidak ada grant C otomatis; modul Finance/Inventory belum dibangun |
| Owner | Dashboard, master data baca sesuai grant, DN/Manifest/Tracking, Equipment baca yang sesuai scope | Tidak dapat mutasi users/roles/audit; tidak dapat aksi tulis |
| Admin Pengirim | Dashboard, DN, Tracking, master referensi sesuai grant | Transit, penerimaan, verifikasi dan route tanpa permission ditolak |
| Admin Transit | Dashboard, Manifest, Transit, Tracking, master referensi sesuai grant | Users/roles/audit dan route di luar scope ditolak |
| Admin Penerima | Dashboard, Penerimaan, Klaim, Tracking, master referensi sesuai grant | Route tanpa permission dan cabang lain ditolak |
| Admin Sewa | Dashboard, Kontrak, BA, Timesheet scoped, route Equipment yang diizinkan | Permission C dan fungsi Finance/Inventory belum tersedia |
| Operator Alat Berat | Dashboard, Timesheet Saya, proyeksi penugasan sendiri | Tidak dapat melihat data scoped penuh, reviewer, atau data cabang lain |
| Finance | Dashboard dan menu Finance hanya jika route nyata/grant tersedia | Invoice, pembayaran, dan Petty Cash belum dibangun |
| Gudang | Dashboard dan menu Inventory hanya jika route nyata/grant tersedia | Inventory belum dibangun |
| Customer | Dashboard dan akses tracking yang benar-benar diberikan | Tidak mendapat master, pengaturan, atau data lintas pelanggan |

Pengujian baseline yang tersedia membuktikan login, dashboard berbasis role, menu permission-aware, URL langsung, backend denial, branch scope, logout, CSRF, dan responsivitas pada lima viewport untuk suite yang telah dijalankan. Angka dan tanggal harus diambil dari laporan milestone terbaru saat gate deployment dijalankan ulang; laporan ini tidak mengklaim pengujian hosting nyata.

## Status keamanan demo

| Area | Status | Temuan |
|---|---|---|
| Database terpisah | BLOCKED | Konfigurasi saat ini menunjuk development; belum ada database demo/seed/reset |
| Data sintetis | NOT IMPLEMENTED | Belum ada paket fixture demo resmi |
| Password/default account | PASS untuk baseline | Tidak ada password Administrator bawaan; jangan menyalin credential lokal |
| Rate limiting/session timeout | PASS pada baseline lokal | Harus diuji ulang pada domain HTTPS demo |
| RBAC/branch scope | PASS pada baseline | Permission backend tetap wajib diuji per akun demo |
| Permission sensitif | PASS | Grant C tetap kosong; jangan memberi grant saat seed demo |
| Upload privat | PASS pada baseline | Evidence disimpan di luar public dan endpoint berizin; uji ukuran/MIME pada hosting |
| Source/config/log protection | PASS pada local Apache checks | Document root harus `public`; config, backup, log, dan storage privat tidak boleh web-accessible |
| HTTPS/cookie | BLOCKED | `secure_cookie` lokal false; demo wajib HTTPS dan konfigurasi secure cookie |
| Backup/reset | NOT IMPLEMENTED | Perlu prosedur restore/reset terpisah dan verifikasi sebelum demo |

## Fitur yang layak didemonstrasikan setelah seed

Login/logout, dashboard role, sidebar/drawer/bottom shortcut, pembatasan URL dan cabang, master data yang telah memiliki route, DN/Manifest/Tracking dan operasi Trucking yang sudah lulus, kontrak Equipment multi-unit, BA HANDOVER/RETURN, timesheet WITH/WITHOUT, revisi dan verifikasi tanpa grant C.

## Fitur yang belum selesai atau tidak boleh dipresentasikan sebagai tersedia

Finance, invoice, pembayaran, Petty Cash, Inventory, tarif otomatis, grant permission dinamis, koreksi fakta BA, reset/penggantian HM khusus, serta prosedur deployment hosting nyata. Status yang belum memiliki sumber data tidak boleh ditampilkan sebagai angka operasional.

## Kesiapan hosting

Dokumen cPanel saat ini hanya persiapan. Domain demo perlu document root ke `public`, PHP 8.2+ dengan PDO MySQL/mbstring/OpenSSL, database dan user runtime terpisah dengan privilege minimum, HTTPS aktif, `secure_cookie=true`, session dan storage privat writable, error log privat, serta rewrite Apache yang diuji. Allowlist konfigurasi database saat ini dibatasi development/test; jangan melemahkannya untuk deployment tanpa paket staging/deployment yang disetujui.

## Risiko tersisa

1. Belum ada fixture dan akun demo yang reproducible.
2. Belum ada reset data demo atau backup/restore yang diuji.
3. Belum ada verifikasi domain HTTPS, cookie Secure, dan perilaku hosting cPanel nyata.
4. Password sederhana atau tautan satu klik berisiko disalahgunakan jika tidak dibatasi isolasi, masa berlaku, rate limit, dan scope.
5. Menu role Finance/Gudang dapat terlihat sebagai status belum tersedia, tetapi tidak boleh diperlakukan sebagai modul selesai.

## Langkah deployment yang diusulkan (belum dijalankan)

1. Setujui domain demo, masa hidup, daftar akun, dan apakah password sederhana atau login satu klik digunakan.
2. Buat database demo baru dan user runtime minimum; jangan memakai `hls_v2_dev` atau database lama.
3. Jalankan migration pada database kosong, lalu seed cabang, master, dan transaksi sintetis melalui script yang dapat diulang.
4. Seed akun demo tanpa grant C dan simpan secret melalui kanal privat, bukan repository.
5. Siapkan reset atomik dari snapshot bersih dan uji restore.
6. Konfigurasikan HTTPS, `secure_cookie`, session/storage privat, log privat, dan document root `public`.
7. Jalankan ulang suite login/RBAC/branch/CSRF/route serta smoke test lima viewport pada URL demo.
8. Lakukan review manual calon pengguna, lalu hapus/reset data demo setelah sesi.

Persetujuan eksplisit masih diperlukan sebelum pembuatan fixture/akun demo, perubahan allowlist deployment, atau deployment ke hosting.

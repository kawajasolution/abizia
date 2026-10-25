# Laporan Tahap 1 — Fondasi HLS Transport V2

Tanggal: 23 Oktober 2026, WITA. Status: **selesai dalam lingkup fondasi; seluruh pengujian kritis akhir lulus**. Tahap 2 belum dimulai.

Tindak lanjut instruksi Tahap 1: logo PNG resmi sudah dipasang pada header login/halaman fondasi, identik SHA-256 dengan sumber baca-saja. Browser membuktikan logo termuat dan proporsional, serta halaman login tanpa overflow pada lima viewport. Tidak ada kotak background tambahan pada logo. Panduan CPANEL_PREPARATION.md menjelaskan penempatan privat/publik dan batas staging/deployment; hosting tidak diakses dan kompatibilitas provider belum diklaim.

## Struktur baru

```text
hls-v2/
  app/
    Controllers/       AuthController, FoundationController
    Http/              Router, View, Input, HttpError
    Middleware/        Access (permission + cabang)
    Repositories/      Repository, UserRepository
    Services/          Auth, Session, Csrf, Audit, MasterService,
                       Migrator, BootstrapAdmin
    Views/             login, home, users, branches, roles, audit, error, layout
    bootstrap.php      autoload/config runtime dasar
    routes.php         registry route eksplisit
  bin/                 setup-dev, migrate, bootstrap-admin PHP/PowerShell
  config/              example.php dan local.php privat/diabaikan Git
  database/migrations/ 001_foundation.sql
  public/              index.php, router server lokal, assets/foundation.css
  storage/             log dan sesi privat (ditolak HTTP)
  tests/               run.php, browser.cjs, deployment.php, results/, tmp/
```

Source, konfigurasi, SQL dan alat CLI berada di luar public document root. `.htaccess` akar menolak HTTP; `public/` hanya membuka front controller/aset. Route tidak bergantung pada daftar menu di view; controller menangani HTTP, service memvalidasi izin/mutasi/transaksi, repository menjalankan prepared PDO.

## Database dan akun

Database baru `hls_v2_dev`; PHP 8.2.12, MariaDB 10.4.32. Akun DB khusus `hls_v2_app` dengan password acak privat, grant hanya pada DB ini. Tidak ada akses database lama dalam implementasi/test. Development hanya memiliki:

| Tabel | Fungsi |
|---|---|
| schema_migrations | Versi migration |
| roles | Sepuluh role |
| permissions | Tujuh izin fondasi |
| role_permissions | Grant role-permission |
| branches | Cabang dan status aktif |
| users | Identitas/hash password/role/cakupan/auth_version |
| user_branches | Cakupan cabang eksplisit |
| audit_logs | Aktor, aksi, entitas, metadata dan waktu |
| login_attempts | Hash email/IP dan waktu kegagalan |

Role: Administrator, Owner, Admin Pengirim, Admin Transit, Admin Penerima, Admin Sewa, Operator Alat Berat, Finance, Gudang, Customer. Seluruh role mendapat foundation.view; hanya Administrator memiliki users.view/manage, branches.view/manage, roles.view, audit.view. Tidak ada permission bisnis. Cakupan global bukan izin aksi dan nama role tidak menjadi bypass middleware.

**Pengguna development: 0; cabang: 0.** Tidak membuat akun administrator dengan password pilihan agen atau password default. Pemilik menjalankan `bin/bootstrap-admin.ps1` untuk memilih nama/email/password sendiri. Proses bootstrap sudah dibuktikan pada DB test: hashing, penolakan password pendek, penolakan bootstrap ulang dan audit. Akun admin global/scoped/Owner/akun formulir yang dipakai tes bersifat sementara dan telah dihapus bersama DB test. Tidak ada password dalam laporan/artefak akhir.

## Route dan fitur aktual

| Method/path relatif | Perilaku |
|---|---|
| GET /login | Form login + token CSRF |
| POST /login | Password verify, rate limit, audit dan regenerasi sesi |
| POST /logout | CSRF, audit, destroy sesi dan cookie |
| GET / | Identitas, role, cakupan/cabang sendiri dari DB; bukan dashboard bisnis |
| GET/POST /users | Daftar/buat/ubah/nonaktif/reset password akun lain; izin + global |
| GET/POST /branches | Daftar/buat/ubah/nonaktif; scope cabang, pembuatan hanya global |
| GET /roles | Matriks permission baca-saja, izin + global |
| GET /audit | 100 aktivitas terbaru, izin + global |

URL lokal terverifikasi: `http://localhost/hls-v2/public/login`. Penolakan route tidak dikenal 404, metode salah 405, input salah 422, CSRF/izin/cabang 403, kredensial salah 401, duplikasi 409, rate limit 429. Anonim diarahkan ke login. Error internal generik, tidak menampilkan konfigurasi/SQL. Password tidak dirender kembali. Seluruh output HTML di-escape.

Idle timeout 30 menit, cookie HttpOnly/SameSite=Lax, strict mode, storage sesi khusus. Secure aktif ketika memakai HTTPS/konfigurasi secure; konfigurasi development lokal HTTP tidak memakainya. Akun nonaktif/reset password/perubahan hak membatalkan sesi lama pada permintaan berikutnya. POST adalah satu-satunya cara logout. Tidak ada reset password publik, email, remember-me, upload, role editor atau modul bisnis pada tahap ini.

## Pengujian aktual akhir

| Pemeriksaan | Hasil | Bukti |
|---|---|---|
| Lint seluruh PHP aplikasi/CLI/config/test | 37 berkas, 0 gagal | tests/results/lint.json |
| Sintaks browser runner | node --check lulus | Perintah verifikasi akhir |
| Service/HTTP + gerbang suite browser | 101 lulus, failure=null | tests/results/foundation.json |
| Browser Chromium | 107 lulus | tests/results/browser.json, browser-run.log |
| Apache + isolasi akun DB | 12 lulus | tests/results/deployment.json |
| Cleanup DB test | Terhapus | foundation.json temporary_database_removed=true |

101 adalah jumlah assertion runner PHP yang mencakup satu gerbang hasil browser; 107 adalah assertion di dalam suite browser, bukan 107 skenario bisnis berbeda. Lima viewport benar-benar dijalankan: 320×640, 375×812, 402×874, 768×1024, 1366×768. Screenshot foundation-320/375/402/768/1366.png berada di tests/results. Browser menguji login/logout, route, tidak ada overflow halaman, tidak ada menu bisnis, pembuatan cabang/pengguna mobile dan pembatasan akses scoped/Owner.

Tes kritis mencakup migration kosong/idempoten tanpa akun, target DB lama/sistem ditolak, bootstrap/password hashing, login salah/nonaktif, rate limit per IP dan email lintas IP, regenerasi sesi, idle timeout/revocation/reset password, CSRF hilang/salah/usang, logout dan replay cookie lama, deny-by-default/URL langsung/POST terlarang, cabang di luar scope, duplikasi/input array/payload SQL, escaping, audit event tanpa credential dan rollback master/pengguna ketika audit gagal. Browser berjalan dengan izin launch proses setelah sandbox awal mengembalikan spawn EPERM. Suite akhir tidak skip.

Tes Apache benar-benar meminta root proyek, config/local.php, source app, SQL migration, log, runner tes, bootstrap CLI dan public/router.php: semua 403. Login/aset 200. SHOW GRANTS diperiksa tanpa menampilkan credential. Semua fixture berada pada database baru hls_v2_test_* dan dibersihkan; database development tidak diisi data uji.

## Masalah dan batas yang tersisa

Tidak ada pengujian kritis fondasi yang masih gagal/belum dijalankan. Pemilik perlu memilih credential admin lewat bootstrap sebelum penggunaan development interaktif; ini langkah pengisian credential, bukan password bawaan yang disembunyikan.

MySQL 8, TLS/sertifikat nyata, OS/perangkat fisik, browser selain Chromium dan hosting belum diuji. Windows perlu memberikan hak tulis folder storage kepada akun Apache; uji lokal saat ini berhasil. Audit log/rate limit belum mempunyai kebijakan retensi otomatis karena keputusan retensi belum final. Provision DDL yang gagal sebagian tidak di-reset otomatis. Hak DDL akun development dibatasi hanya skemanya, bukan rancangan privilege produksi.

Desain navigasi lengkap, PWA dan seluruh modul bisnis belum dibangun. Pertanyaan Q01–Q11 tetap untuk tahap terkait. Proyek lama tetap baca-saja; library Playwright terpasang hanya dipakai baca-saja untuk pengujian, tidak menjalankan suite lama. Tidak mengubah database lama atau hosting. **Berhenti setelah Tahap 1; tunggu persetujuan untuk Tahap 2.**

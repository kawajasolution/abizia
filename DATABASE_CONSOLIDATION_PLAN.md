# Database Consolidation Plan

Status: **Rencana saja — belum dijalankan**  
Tanggal: 24 Oktober 2026 (WITA)

## 1. Hasil audit read-only

| Aspek | `hls_v2_dev` | `hls_v2_demo` |
|---|---|---|
| Konfigurasi aktif | `config/local.php`, base path `/hls-v2/public` | `config/demo.php`, base path `/hls-v2/public/demo` |
| Schema | Migration 001–005, 48 tabel Equipment/Trucking/master/fondasi | Migration existing yang sama |
| Akun/cabang | Baseline development dilaporkan kosong; verifier M1–M5 memeriksa 0 users/branches | 10 akun role, cabang kode `DMO` bernama `Kantor Pusat` |
| Permission | Katalog role/permission hasil migration | Katalog sama; tidak ada grant C otomatis |
| Master | Tidak diisi fixture | Fixture sintetis idempoten: customer1, parties2, locations2, route1, truck1, equipment1, driver1, operator1, category/unit/item |
| Transaksi | Tidak ada fixture bisnis | Tabel transaksi masih kosong; tidak ada histori operasional yang harus dipertahankan |
| Audit | Schema tersedia; tidak ada data bisnis development | Audit akun/setup dapat ada sesuai proses pembuatan akun |
| Reset | Tidak ada reset development | `bin/reset-demo.php` hanya menargetkan nama demo |

Sumber fakta: `tests/results/equipment-development*.json`, `PHASE6_M5_REPORT.md`, `DEMO_ENVIRONMENT_REPORT.md`, `DEMO_UAT_READY_REPORT.md`, migration 001–005, serta konfigurasi privat lokal. Password dan isi credential privat tidak disalin ke dokumen ini.

Konsolidasi **belum boleh** dianggap aman hanya dari perbandingan jumlah tabel. Sebelum eksekusi wajib dibuat dump struktural dan data dari kedua database, checksum dump, daftar row per tabel, `SHOW CREATE TABLE`, foreign key, trigger, event, view, dan daftar grant aplikasi.

## 2. Database sumber yang direkomendasikan

`hls_v2_demo` adalah kandidat sumber untuk akun dan master karena sudah memiliki sepuluh role, akun profesional, cabang Kantor Pusat, dan fixture sintetis. Sumber ini belum berisi transaksi sehingga tidak dapat menjadi sumber histori operasional. `hls_v2_dev` tetap dipertahankan sebagai arsip development sampai migrasi selesai dan diverifikasi.

Tidak ada merge otomatis dari dua database. Jika audit menemukan row non-kosong pada development atau konflik identifier, migrasi harus berhenti dan memerlukan keputusan pengguna.

## 3. Target permanen

Target: `hls_v2`.

Nama ini belum diizinkan oleh `Hls\Config::databaseName()` dan belum dibuat. Perubahan allowlist, konfigurasi runtime, akun database, dan URL utama hanya boleh dilakukan setelah rencana disetujui dan backup terverifikasi. URL normal yang diusulkan adalah `/hls-v2/public`; jalur `/demo/` menjadi jalur sementara dan kemudian dapat ditutup setelah cutover.

## 4. Data yang dipertahankan

- Sepuluh role existing dan seluruh permission.
- Akun demo sebagai akun awal yang wajib diganti nama/email/password atau dinonaktifkan saat handover perusahaan.
- Cabang `DMO` dengan nama tampilan `Kantor Pusat`, tanpa mengganti kode yang mungkin sudah menjadi bagian nomor dokumen.
- Seluruh master fixture sintetis yang lolos foreign key.
- Seluruh tabel, migration marker, constraint, index, trigger, audit, dan histori jika pada audit lanjutan ditemukan row non-kosong.
- Tidak ada grant permission C baru.

## 5. Perubahan konfigurasi yang diperlukan setelah persetujuan

1. Tambahkan `hls_v2` ke allowlist hanya pada tahap cutover.
2. Buat `config/application.php` privat dengan database `hls_v2`, user runtime minimum, base path `/hls-v2/public`, `secure_cookie=true` saat HTTPS, dan session directory privat.
3. Ubah Apache/demo entrypoint agar URL utama memuat konfigurasi tunggal; jangan membuat URL memilih database berdasarkan query atau input pengguna.
4. Pertahankan `config/local.php` sebagai backup konfigurasi development sampai rollback window berakhir.
5. Hapus/disable script reset demo pada environment utama; script reset tidak boleh menerima `hls_v2`.

## 6. Strategi backup dan cutover

1. Hentikan akses tulis sementara.
2. Verifikasi target `hls_v2` belum ada dan bukan database lama.
3. Buat dump struktur dan data `hls_v2_dev` serta `hls_v2_demo` dengan timestamp WITA, checksum SHA-256, dan lokasi privat.
4. Restore sumber yang disetujui ke database staging bernama acak `hls_v2_test_<12hex>` dan jalankan integrity checks.
5. Buat database `hls_v2` hanya setelah restore staging, perbandingan row, FK, index, trigger, dan permission lulus.
6. Migrasikan dengan transaksi per kelompok tabel dan validasi FK setelah setiap kelompok; jangan memakai `DROP`, `TRUNCATE`, atau reset otomatis.
7. Ubah konfigurasi runtime secara atomik, restart session, lalu jalankan smoke test login/RBAC/CSRF/branch scope.
8. Simpan database sumber read-only selama rollback window yang disepakati.

## 7. Pengujian pascamigrasi

- `php -l` seluruh source dan `node --check` seluruh JavaScript.
- Fresh/upgrade migration dan idempotensi pada staging.
- Jumlah dan checksum row setiap tabel sumber/target.
- FK, unique, check constraint, index, trigger, migration marker, dan engine InnoDB.
- Login seluruh role, password salah, logout, timeout, CSRF, akun nonaktif.
- Dashboard, sidebar, URL direct, permission backend, dan branch scope.
- Nomor dokumen, audit, state machine, idempotensi, dan konkurensi bila transaksi ditemukan.
- Browser desktop/tablet/mobile pada URL utama, termasuk asset CSS/JS/content-type.
- Backup restore kedua untuk membuktikan rollback.

Tidak boleh menyatakan cutover PASS bila salah satu pemeriksaan kritis belum dijalankan.

## 8. Risiko dan rollback

Risiko utama adalah konfigurasi salah menunjuk database, hilangnya audit/foreign key, konflik identifier, akun password sederhana terbawa ke aplikasi utama, serta script reset demo aktif pada target permanen. Risiko lain adalah perbedaan konfigurasi session/base path dan asset URL.

Rollback dilakukan dengan mengembalikan konfigurasi privat ke database sebelumnya, menutup URL target, dan memulihkan dari dump terverifikasi. Database sumber tidak dihapus selama rollback window. Penghapusan `hls_v2_demo` atau `hls_v2_dev` memerlukan persetujuan eksplisit terpisah.

## 9. Keputusan yang masih diperlukan

1. Persetujuan eksplisit untuk membuat `hls_v2` dan mengubah allowlist konfigurasi.
2. Pilihan sumber final jika audit menemukan data non-kosong pada development.
3. Masa rollback window dan lokasi backup privat.
4. Daftar akun yang dipertahankan, dinonaktifkan, atau diubah sebelum akses perusahaan.
5. Konfirmasi bahwa seluruh fixture sintetis boleh dipertahankan sebagai data awal.

Tidak ada konsolidasi, pembuatan database `hls_v2`, perubahan konfigurasi aktif, atau penghapusan database yang dilakukan pada tahap ini.

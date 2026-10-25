# Demo Environment Report

Tanggal: 24 Oktober 2026 (WITA)

## Status akhir

**SELESAI SEBAGIAN — BELUM SIAP UAT ROLE PENUH.**

Database demo terpisah berhasil dibuat secara lokal dan migration existing berhasil dipasang. Akun demo seluruh role berhasil dibuat. Seed data bisnis sintetis lengkap (customer, unit, kendaraan, lokasi, kontrak, DN, Manifest, BA, dan timesheet) belum dibuat pada eksekusi ini, sehingga demo belum boleh dipresentasikan sebagai lingkungan UAT lengkap.

## Database dan konfigurasi

- Database: `hls_v2_demo`.
- Akun runtime: `hls_v2_demo_app`.
- Konfigurasi privat: `config/demo.php` (tidak boleh masuk repository).
- Database development `hls_v2_dev` tidak digunakan atau diubah.
- Database proyek lama dan hosting tidak diakses.
- Guard `Config::databaseName()` sekarang menerima `hls_v2_demo`, selain development dan test.
- Migration dipasang melalui `Hls\\Services\\Migrator::install()`; setup menolak jika database demo sudah ada.

## Akun demo

Sepuluh akun dibuat dengan pola `demo_<role>@demo.invalid`: Administrator, Owner, Admin Pengirim, Admin Transit, Admin Penerima, Admin Sewa, Operator Alat Berat, Finance, Gudang, dan Customer.

Password role selain Administrator adalah `123456` dan hanya tersimpan pada file privat satu kali `storage/private/demo-credentials.txt`. Password Administrator dibuat acak kuat dan tidak ditulis di laporan. File credential tidak dapat diakses dari document root dan tidak boleh dibagikan ke publik.

Semua akun aktif dan terhubung ke cabang `DMO` / `DEMO HLS`. Administrator mendapat cakupan global sesuai model fondasi; akun lain hanya cabang demo. Tidak ada grant permission C atau bypass autentikasi yang ditambahkan.

## Reset demo

`bin/reset-demo.php` hanya menerima target tetap `hls_v2_demo` dan membutuhkan token konfirmasi literal:

```powershell
php bin/reset-demo.php RESET-DEMO
```

Reset menghapus database demo dan akun database runtime, lalu setup dapat dijalankan kembali. Mekanisme ini hanya CLI lokal, tidak dapat dipanggil akun demo publik, dan tidak menyentuh development/produksi. Hasil reset dicetak ke output CLI; audit log aplikasi tidak dapat dipertahankan karena seluruh database demo dihapus.

## Menu dan role

Registry menu tetap `app/navigation.php`. Route yang memiliki implementasi mengikuti permission dan branch scope backend. Item Finance, Inventory, laporan, atau menu lain tanpa route tidak dianggap tersedia. Matriks role lengkap dan status route tercantum pada [DEMO_HOSTING_READINESS_REPORT.md](DEMO_HOSTING_READINESS_REPORT.md).

## Pengujian aktual

| Pemeriksaan | Hasil |
|---|---|
| Fresh creation `hls_v2_demo` | PASS |
| Migration existing pada database demo | PASS |
| Akun 10 role dan branch demo | PASS |
| Reset `RESET-DEMO` lalu recreate | PASS (dijalankan 24 Oktober 2026) |
| Password Administrator tidak default | PASS |
| Grant C tidak ditambahkan | PASS berdasarkan seed permission existing |
| Isolasi dari `hls_v2_dev` | PASS secara target konfigurasi; belum dilakukan destructive comparison |
| Login HTTP seluruh akun | NOT TESTED |
| Dashboard/sidebar/URL direct seluruh akun | NOT TESTED |
| Branch scope seluruh akun | NOT TESTED |
| Seed data bisnis relasional | NOT IMPLEMENTED |
| Reset lalu recreate dan restore fixture | NOT TESTED |
| Hosting HTTPS/cPanel | NOT TESTED |

Hasil lint setup/reset: **2 PASS, 0 FAIL**. Reset dan recreate dilakukan hanya terhadap `hls_v2_demo`; database development tidak dijadikan target.

Tidak ada pengujian yang dinyatakan PASS hanya karena route tersedia. Regression suite existing tetap merupakan baseline lokal milestone, bukan bukti bahwa akun demo baru telah diuji.

## File berubah

- `app/Config.php`: allowlist database demo.
- `bin/setup-demo.php`: membuat database runtime, migration, cabang, dan akun demo.
- `bin/reset-demo.php`: reset eksplisit database demo saja.
- `bin/seed-demo.php`: fixture master sintetis idempoten untuk database demo.
- `public/demo/index.php` dan `public/demo/.htaccess`: front controller demo dengan base path dan konfigurasi terisolasi.
- `config/demo.php`: base path/session directory demo lokal.
- `DEMO_ENVIRONMENT_REPORT.md`: laporan ini.
- `DEMO_UAT_READY_REPORT.md`: status UAT aktual.

## Risiko dan pekerjaan tersisa

1. Seed bisnis transaksi harus ditambahkan melalui workflow service idempoten yang membangun relasi valid dan menandai seluruh data `DEMO`; saat ini tabel transaksi masih kosong.
2. Branch scope cabang kedua, akun nonaktif, dan browser desktop/tablet/mobile belum diuji pada URL demo.
3. Password sederhana hanya aman dalam lingkungan lokal/demo terisolasi; jangan gunakan pada produksi atau akun Administrator operasional.
4. `secure_cookie` masih mengikuti konfigurasi lokal; hosting demo wajib HTTPS dan `secure_cookie=true`.
5. Reset saat ini bersifat drop/recreate database demo, sehingga memerlukan backup/snapshot terpisah bila data hasil UAT perlu dipertahankan.

Persetujuan diperlukan sebelum menambahkan fixture transaksi bisnis, membuka URL demo ke publik, atau melakukan deployment.

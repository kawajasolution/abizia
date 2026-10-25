# Demo UAT Readiness Report

Tanggal: 24 Oktober 2026 (WITA)

## Status

**BELUM SIAP UAT PENUH.** Database, akun demo, master fixture, dan URL Apache lokal tersedia. Fixture transaksi Trucking/Equipment belum dibuat karena harus melalui workflow service/state machine yang membutuhkan actor, snapshot, dan urutan konfirmasi yang belum tersedia pada seed demo. Tidak ada transaksi fiktif yang disisipkan langsung untuk mengakali state machine.

## URL dan akun

URL Apache lokal demo yang berhasil dibuka: `http://localhost/hls-v2/public/demo/login`.

| Username | Role | Cabang |
|---|---|---|
| `demo_administrator@demo.invalid` | Administrator | Global + DMO |
| `demo_owner@demo.invalid` | Owner | DMO |
| `demo_admin_pengirim@demo.invalid` | Admin Pengirim | DMO |
| `demo_admin_transit@demo.invalid` | Admin Transit | DMO |
| `demo_admin_penerima@demo.invalid` | Admin Penerima | DMO |
| `demo_admin_sewa@demo.invalid` | Admin Sewa | DMO |
| `demo_operator_alat_berat@demo.invalid` | Operator Alat Berat | DMO |
| `demo_finance@demo.invalid` | Finance | DMO |
| `demo_gudang@demo.invalid` | Gudang | DMO |
| `demo_customer@demo.invalid` | Customer | DMO |

Password non-Administrator mengikuti file privat `storage/private/demo-credentials.txt`. Password Administrator acak dan tidak dicantumkan di laporan; ambil melalui akses lokal privat sebelum sesi demo, lalu hapus/rotasi setelahnya. Tidak ada bypass login dan tidak ada grant C.

## Fixture aktual

Script idempoten: `php bin/seed-demo.php`.

| Data | Jumlah |
|---|---:|
| Cabang DEMO | 1 |
| Customer | 1 |
| Party pengirim/penerima | 2 |
| Lokasi | 2 |
| Rute | 1 |
| Kendaraan | 1 |
| Unit alat berat | 1 |
| Sopir | 1 |
| Operator | 1 |
| Kategori/unit/item pendukung | 3 |
| Delivery Note | 0 |
| Manifest/Transit/Penerimaan/Klaim | 0 |
| Kontrak/Reservasi/BA/Timesheet | 0 |

Seed dijalankan dua kali dengan hasil konsisten tanpa duplikasi. Semua data yang dibuat memiliki prefix `DEMO`.

## Uji aktual

| Pemeriksaan | Status |
|---|---|
| Fresh migration demo | PASS (baseline sebelumnya) |
| Seed master pertama | PASS |
| Seed master kedua/idempotensi | PASS |
| Reset demo lalu setup lalu seed | PASS untuk database/akun/master |
| PHP lint setup/reset/seed | PASS, 3/3 |
| Apache demo URL dan koneksi DB demo | PASS, HTTP 200 |
| Login HTTP 10 akun | PASS, 10/10 HTTP 303 |
| Dashboard 10 akun | PASS, 10/10 HTTP 200 |
| Sidebar/menu rendering 10 akun | PASS, menu registry ter-render (2–28 item sesuai role) |
| Password salah ditolak | PASS, HTTP 401 |
| Logout/session invalidation | PASS, HTTP 303 diuji pada Owner |
| URL direct/RBAC | PASS parsial, Owner `/users` HTTP 403 |
| Branch scope cabang kedua | NOT TESTED; belum membuat cabang kedua |
| Akun nonaktif ditolak | NOT TESTED |
| Browser desktop/tablet/mobile | NOT TESTED; belum menjalankan browser automation pada URL demo |
| Reset restore transaksi | BLOCKED karena fixture transaksi belum ada |
| Hosting/HTTPS | NOT TESTED |

## Matriks menu ringkas

Registry `app/navigation.php` tetap menjadi sumber menu. Administrator mendapat menu pengaturan yang ber-route; Owner hanya menu baca sesuai permission; Admin Pengirim/Transit/Penerima/Sewa mendapat route operasional masing-masing; Operator hanya Timesheet Saya; Finance, Gudang, dan Customer hanya melihat route yang benar-benar tersedia dan permission-nya. Item tanpa route tidak boleh dipresentasikan sebagai fitur selesai. Backend tetap menjadi pemeriksa akhir permission dan branch scope.

## Masalah tersisa

1. Fixture transaksi belum tersedia.
2. HTTP/browser UAT pada konfigurasi demo belum dapat dijalankan karena base path aplikasi dirancang untuk Apache `/hls-v2/public`; server built-in yang dicoba mengembalikan 404.
3. Akun non-Administrator menggunakan password sederhana dan harus tetap berada di lingkungan demo terisolasi.
4. Reset menghapus database demo dan belum memulihkan transaksi karena transaksi belum difixture.

Base path diperbaiki secara minimal melalui `public/demo/` dan `config/demo.php`; URL development `/hls-v2/public` tidak dialihkan ke database demo. Pekerjaan berhenti pada lingkungan demo lokal. Tidak ada M6/M7, deployment, perubahan hosting global, perubahan `hls_v2_dev`, atau perubahan proyek lama.

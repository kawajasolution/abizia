# HLS Main Application Consolidation Report

Tanggal: 24 Oktober 2026 (WITA)

## Status

**KONSOLIDASI SELESAI DENGAN CATATAN.** Database `hls_v2` dibuat tanpa menghapus `hls_v2_dev` atau `hls_v2_demo`. Konfigurasi utama sekarang menunjuk `hls_v2`; URL utama Apache adalah `http://localhost/hls-v2/public/login`.

Target berisi schema 48 tabel, 10 role, 106 permission, 215 grant, 10 akun, 1 cabang, dan 13 row master sintetis. Transaksi Trucking/Equipment tetap 0 karena sumber demo memang belum memiliki fixture transaksi.

## Sumber dan backup

Backup dibuat sebelum penyalinan pada `storage/private/backups/`:

| Sumber | File | Ukuran | SHA-256 | Tabel | Row |
|---|---|---:|---|---:|---:|
| `hls_v2_dev` | `20261024_200808_dev.sql` | 100555 byte | `d13207ba8cfbeb9412cbb11ed38388c2e9e94bd9c29d730f0524fd0df930f92c` | 48 | Row count per tabel tercatat di metadata; users/branches/master/transaksi = 0 |
| `hls_v2_demo` | `20261024_200808_demo.sql` | 114770 byte | `e81242dfd4640f914ba5fa2a1a39fe2d067c7f0fe7e8743fef329393ea497a19` | 48 | 10 akun, 1 cabang, 13 master, 36 audit/login lainnya |

Backup diverifikasi dapat dibaca, memiliki 48 `CREATE TABLE`, dan checksum dicatat pada `20261024_200808_consolidation.json`. Sumber tidak dihapus.

## Data yang dipertahankan

- Struktur dan migration marker dari sumber lengkap.
- Role, permission, dan grant existing.
- Sepuluh akun role dari `hls_v2_demo`.
- Cabang kode `DMO` dengan nama tampilan `Kantor Pusat`.
- Customer, parties, lokasi, rute, kendaraan, unit alat berat, sopir, operator, kategori, unit, dan item sintetis.
- Audit log yang ada pada sumber demo.
- Tidak ada grant permission C baru.

`hls_v2_dev` tidak memiliki akun/cabang/master/transaksi menurut backup aktual. Tidak ada konflik row yang harus diselesaikan.

## Perubahan konfigurasi

- `app/Config.php` menerima target permanen `hls_v2` selain dev/demo/test.
- `config/local.php` sekarang menunjuk database `hls_v2` dengan URL utama `/hls-v2/public`.
- `config/main.php` dibuat privat sebagai salinan koneksi target.
- `public/demo/` dan konfigurasi demo tetap ada sebagai artefak teknis, tetapi bukan URL penggunaan utama.
- Username database runtime existing `hls_v2_app` dipertahankan; password tidak diubah.
- Tidak ada perubahan proyek lama atau hosting.

## Pengujian aktual

| Pemeriksaan | Hasil |
|---|---|
| Backup dev/demo dan checksum | PASS |
| Target `hls_v2` dibuat tanpa overwrite database berisi | PASS |
| Struktur target 48 tabel | PASS |
| Role/permission/grant target | PASS, 10/106/215 |
| Akun target | PASS, 10 |
| Master target | PASS, 13 row |
| Grant C sensitif | PASS, 0 |
| Verifikasi target `verify-main.php` | PASS |
| Login HTTP 10 role URL utama | PASS, 10/10 HTTP 303 |
| Dashboard 10 role URL utama | PASS, 10/10 HTTP 200 |
| Browser visual main URL | PASS, 6/6 (Owner/Administrator; 320/768/1366) |
| Regresi penuh Trucking/Equipment | NOT TESTED terhadap target baru |
| Branch scope cabang kedua | NOT TESTED |
| HTTPS/hosting | NOT TESTED |

Screenshot visual tersimpan sebagai `tests/results/demo-owner-*.png` dan `demo-administrator-*.png`; pengujian browser memeriksa CSS, ikon, sidebar, overflow, console error, dan asset response.

## Risiko tersisa

1. Nama database target sudah utama, tetapi transaksi operasional belum tersedia sehingga dashboard bisnis tetap menunjukkan sumber belum tersedia.
2. Password sederhana akun non-Administrator masih harus diganti sebelum akses perusahaan.
3. `secure_cookie` masih false untuk lokal; HTTPS wajib sebelum hosting.
4. Branch scope cabang kedua dan regresi penuh terhadap target belum dijalankan.
5. Script reset demo tetap ada dan harus dicegah agar tidak pernah menerima target `hls_v2`.

Tidak ada database yang dihapus, tidak ada aturan bisnis/permission sensitif yang diubah, dan tidak ada deployment. Konsolidasi berhenti menunggu pemeriksaan pengguna.

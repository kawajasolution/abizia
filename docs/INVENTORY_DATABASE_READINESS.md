# Inventory Database Readiness

Tanggal pemeriksaan: 25 Oktober 2026

## Database aktif

Aplikasi menggunakan database `hls_v2` melalui driver MySQL/MariaDB pada host lokal dan port konfigurasi aplikasi. Kredensial tidak dicatat dalam dokumen ini.

## Audit awal

Sebelum migrasi, database memiliki 60 tabel. Migration Inventory 019 sampai 023 belum tercatat dan tabel `inv_stock_ledger`, `inv_receipts`, `inv_receipt_lines`, `inv_issues`, `inv_issue_lines`, serta `inv_warehouses` belum tersedia. Fondasi master `branches` dan `md_items` tersedia.

## Backup

Utilitas yang tersedia: `D:\xampp\mysql\bin\mysqldump.exe`.

Backup berhasil dibuat dengan mode transaksi konsisten pada:

`storage/backups/hls_v2_20261025_041117.sql`

Verifikasi backup: file dapat dibaca, ukuran 145539 byte, berisi 60 definisi tabel dan definisi `schema_migrations`. Opsi `--events` tidak digunakan karena akun aplikasi tidak memiliki privilege events; struktur dan data tabel tetap berhasil didump dengan `--routines --triggers`.

Folder `storage/` dikecualikan dari Git.

## Migration

Migration dijalankan melalui `Hls\Services\Migrator::install`, bukan SQL manual. Semua migration berikut berhasil tercatat:

- `019_inventory_stock_ledger`
- `020_inventory_receipts`
- `021_inventory_issues`
- `022_inventory_multi_warehouse`
- `023_inventory_warehouse_permissions`

Struktur terverifikasi setelah migrasi:

- `inv_stock_ledger` tersedia dengan `warehouse_id` nullable.
- `inv_receipts` tersedia dengan `warehouse_id` nullable.
- `inv_issues` tersedia dengan `warehouse_id` nullable.
- `inv_receipt_lines`, `inv_issue_lines`, dan `inv_warehouses` tersedia.

Tidak ada data transaksi lama yang dipetakan atau diubah.

## Prosedur pemulihan

Jika migrasi gagal, hentikan proses dan simpan pesan error. Pulihkan backup hanya ke lingkungan terisolasi setelah memeriksa integritas dump; jangan melakukan restore pengujian ke database operasional.

## Pemeriksaan aplikasi

Kode Barang Masuk kini mewajibkan gudang aktif yang berada pada cabang dan branch scope transaksi, menyimpan `warehouse_id` pada DRAFT, dan menulis ledger penerimaan dengan gudang yang sama saat posting. Transaksi lama dengan `warehouse_id` NULL tetap didukung dan ditampilkan sebagai belum dialokasikan.

Pengujian browser terautentikasi dan transaksi Barang Masuk nyata masih perlu dijalankan dengan fixture resmi.

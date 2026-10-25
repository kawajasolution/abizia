# Navigasi — ketersediaan dan backlog

Status Tahap 5: 20 item nyata, 23 backlog; enam submenu Trucking aktif. Rincian pembaruan terkini di bagian akhir. Catatan Tahap 2–4 di bawah dipertahankan sebagai riwayat.

Registry tunggal: `app/navigation.php`. Seluruh item memiliki ID, label, route, ikon, kelompok, permission, status available, ketentuan cakupan dan peringkat shortcut. Route backlog bernilai null dan available=false; tidak menghasilkan href, placeholder atau halaman kosong. Service Navigation juga memverifikasi route GET dan permission-nya terhadap app/routes.php sebelum menampilkan item.

| Kelompok | Route tersedia di v2 | Backlog (tidak ditampilkan) |
|---|---|---|
| Dashboard | `/` langsung | Sumber transaksi bisnis belum tersedia |
| Trucking | Delivery Note (DN), Manifest, Transit, Penerimaan, Klaim, Tracking — enam route nyata | — |
| Equipment | — | Unit Alat Berat, Kontrak Sewa, Berita Acara, Timesheet, Verifikasi Timesheet |
| Keuangan | — | Invoice Trucking, Invoice Equipment, Pembayaran, Piutang, Pengeluaran, Petty Cash |
| Gudang & Inventori | — | Barang Masuk, Barang Keluar, Stok Barang, Transfer Stok, Pemakaian Barang, Stock Opname |
| Master Data | Sepuluh submenu nyata: Cabang, Customer, Pengirim & Penerima, Lokasi & Rute, Tarif Trucking, Tarif Equipment, Kendaraan & Unit, Driver & Operator, Barang & Kategori/Satuan, Supplier | — |
| Laporan | — | Trucking, Equipment, Keuangan, Gudang, Petty Cash, Laba Rugi |
| Pengaturan | Pengguna `/users`, Role & Hak Akses `/roles`, Audit Log `/audit` | Editor role/permission dinamis tidak termasuk fondasi |

Total 43 item informasi: 14 tersedia dan 29 belum tersedia. Tahap 4 menambahkan permission/grant dan migration master untuk route yang benar-benar berfungsi. Permission pada item backlog merupakan identifier rencana, bukan grant baru yang telah disetujui.

## Shortcut yang benar-benar tampil sekarang

- Administrator global: Dashboard, Pengguna, Cabang, Pengaturan (menuju route Role & Hak Akses yang sudah nyata).
- Administrator scoped: Dashboard, Cabang. Pengguna/role/audit memerlukan cakupan global, walaupun role memiliki permission-nya.
- Owner, Admin Pengirim, Admin Transit, Admin Penerima, Admin Sewa, Operator Alat Berat, Finance, Gudang, Customer: Dashboard saja, mengikuti permission fondasi yang ada. Shortcut bisnis muncul hanya setelah route dan izin sah tersedia pada tahap terkait.

Peringkat per role disimpan pada item registry yang sama; tidak ada daftar terpisah di template sidebar/drawer/bottom navigation. Shortcut agregat Owner (Trucking/Equipment/Keuangan/Laporan) membutuhkan keputusan route agregat nyata pada tahap dashboard/modul, bukan alias ke halaman yang belum ada.

## Header dan batas tahap

Notifikasi ditunda: belum ada event/penerima/status baca, jadi tidak dirender tombol, badge atau dot palsu. Profil menggunakan identitas akun dari DB, tautan ke bagian akun pada `/`, serta POST logout ber-CSRF. Tidak ada tautan `/profile` yang belum diimplementasikan.

Dashboard mengarah langsung ke route `/`. Pada Tahap 3, route ini memilih fokus role dari principal DB, memakai KPI administrasi nyata sesuai izin serta status Belum tersedia untuk sumber bisnis. Identitas/cakupan/cabang sendiri tetap nyata; tidak ada halaman perantara atau KPI dummy. PWA dan modul bisnis belum dibuat. Tahap 4 selesai; Tahap 5 menunggu persetujuan.

## Pembaruan Tahap 4

Path/tab/per-aksi dan matriks grant tercatat di PHASE4_REPORT.md. Administrator global melihat 14 item, Owner 11, role operasional hanya master yang diizinkan. Daftar shortcut di atas tetap berlaku sebagai bottom navigation, bukan daftar seluruh sidebar. Owner tetap memakai shortcut Dashboard walaupun kini dapat membaca sepuluh submenu master melalui drawer/sidebar. Tidak mengubah posisi/header/sidebar/drawer atau menambah shortcut transaksi palsu. Menu Equipment Unit Alat Berat transaksi tetap backlog; master unit berada pada Kendaraan & Unit.

## Pembaruan Tahap 5 parsial

17 item tersedia, 26 backlog. DN /trucking/dns, Manifest /trucking/manifests dan Tracking /trucking/tracking sudah nyata. Transit, Penerimaan dan Klaim tetap unavailable/null; tidak membuat halaman dummy ketika Q03/Q09 diblokir. Shortcut Pengirim: Dashboard/DN/Tracking; Transit: Dashboard/Manifest. Owner tetap Dashboard. Permission dan cakupan diperiksa di route/service. Detail PHASE5_REPORT.md.

## Baseline operasional Tahap 5 terkini

Total 43 item: 20 tersedia, 23 backlog. Enam submenu Trucking aktif, tanpa submenu aksi atau tracking publik. Global Administrator melihat 20, Administrator scoped 17, Owner 15 sesuai grant. Bottom shortcut: Pengirim Dashboard/DN/Tracking; Transit Dashboard/Manifest/Transit; Penerima Dashboard/Penerimaan/Klaim; Administrator tetap empat atau dua sesuai scope; role lain mengikuti grant registry tanpa perubahan layout. Ketentuan ketersediaan/blocked pada bagian historis sebelumnya sudah digantikan baseline ini.

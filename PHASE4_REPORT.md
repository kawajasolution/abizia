# Laporan Tahap 4 — Master Data Management

24 Oktober 2026. Implementasi lokal PHP 8.2.12 / MariaDB 10.4.32 / Chromium. Tahap ini hanya master referensi. Tidak ada transaksi Trucking/Equipment/Inventory, invoice, pembayaran, stok, deployment, atau akses database lama. Tahap 5 belum dimulai.

## Master dan route yang berfungsi

Semua path memakai prefix Apache `/hls-v2/public`. Setiap kelompok mendukung GET daftar, pencarian, filter status/cabang yang relevan, pagination 10 baris, halaman tambah, detail, edit, serta POST simpan dan nonaktif/aktif kembali. Aksi mutasi memerlukan CSRF dan permission backend. Tidak ada hard delete.

| Submenu | Route GET/POST | Tab/entity |
|---|---|---|
| Cabang | `/branches` | `branches` |
| Customer | `/master/customers` | `customers` |
| Pengirim & Penerima | `/master/parties` | `parties` |
| Lokasi & Rute | `/master/routes` | `locations`, `routes` |
| Tarif Trucking | `/master/trucking-tariffs` | `trucking-tariffs` |
| Tarif Equipment | `/master/equipment-tariffs` | `equipment-tariffs` |
| Kendaraan & Unit | `/master/assets` | `vehicles`, `units` |
| Driver & Operator | `/master/personnel` | `drivers`, `operators` |
| Barang & Kategori | `/master/items` | `items`, `categories`, `uoms` |
| Supplier | `/master/suppliers` | `suppliers` |

Mode halaman: `?tab=<entity>&mode=create`, `mode=detail&id=<id>`, `mode=edit&id=<id>`; mode bawaan daftar. Query daftar: `q`, `status`, `branch`, `page`. Tab yang tidak diizinkan juga ditolak saat URL/POST diakses langsung. Login/logout, dashboard langsung per role, pengguna, role dan audit tetap berfungsi.

## Database dan migration

`database/migrations/002_master_data.sql` aditif: 12 tabel baru, total 21 dengan sembilan tabel fondasi. Migration dipasang pada `hls_v2_dev` tanpa reset; pengulangan tidak mengubah data. Fresh install dan upgrade dari fondasi diuji pada DB disposable. Data/ID cabang lama dan audit tetap dipertahankan; tanggal pembuatan cabang historis tetap NULL.

| Tabel baru | Relasi/tujuan |
|---|---|
| `md_customers` | Customer bersama Trucking/Equipment, FK cabang |
| `md_parties` | Satu identitas pengirim/penerima/keduanya, FK cabang, fingerprint unik per cabang |
| `md_locations` | Lokasi, FK cabang |
| `md_routes` | Dua cabang dan dua lokasi; composite FK memastikan kecocokan lokasi/cabang |
| `md_assets` | Kendaraan/unit dalam satu identitas berjenis, FK cabang; identitas unik per jenis |
| `md_personnel` | Driver/operator, FK cabang dan akun login opsional unik |
| `md_trucking_tariffs` | Referensi reguler/carter/pickup; FK cabang/rute yang sesuai |
| `md_equipment_tariffs` | Referensi jam/shift/bulan; composite FK unit/cabang |
| `md_categories` | Kategori katalog global |
| `md_units` | Satuan katalog global |
| `md_items` | Barang global, FK kategori/satuan; tanpa jumlah stok |
| `md_suppliers` | Supplier barang/jasa, FK cabang |

`branches` dipakai kembali dengan kota, provinsi, telepon, version dan timestamps. Seluruh master memiliki kode unik, status aktif, version, timestamps dan index relevan. FK bernama eksplisit memakai RESTRICT. Penulisan memakai prepared PDO, transaksi/lock, optimistic version (konflik 409) dan audit atomik. Kegagalan audit membatalkan mutasi. Perubahan cabang pemilik tidak tersedia; relasi/identitas tertentu yang sudah direferensikan dilindungi. Parent nonaktif tidak dapat dipilih untuk relasi baru, tetapi relasi historis dapat dipertahankan.

Verifikasi development setelah migration: 21 tabel, 10 role, 53 permission, 0 pengguna, 0 cabang, dan 0 baris pada seluruh 12 tabel md_*. Tidak diisi fixture/akun/password bawaan. Bootstrap administrator tetap melalui CLI dengan password pilihan pemilik. Fixture dan screenshot berasal dari database uji terpisah; hitungan aktual ada di tests/results/deployment.json.

## Permission dan cakupan

Total 53 permission: tujuh fondasi dan 46 tambahan. Cabang tetap memakai `branches.view`/`branches.manage`. Empat belas prefix berikut masing-masing mempunyai `.view`, `.create`, `.update`:

`master.customer`, `master.party`, `master.location`, `master.route`, `master.trucking_tariff`, `master.equipment_tariff`, `master.vehicle`, `master.unit`, `master.driver`, `master.operator`, `master.item`, `master.category`, `master.uom`, `master.supplier`.

Empat izin kelompok tab: `master.routes.view`, `master.assets.view`, `master.personnel.view`, `master.catalog.view`. Backend memeriksa izin kelompok dan entity/aksi; status memakai update. Nama role hanya menentukan seed, tidak menjadi bypass runtime.

| Role | Grant master bawaan |
|---|---|
| Administrator | Baca/tambah/ubah, tetap dibatasi cabang akun; katalog global dan tambah cabang perlu all_branches |
| Owner | Baca semua master sesuai cakupan, termasuk cabang; tanpa mutasi |
| Admin Pengirim | Baca customer, pihak, lokasi, rute, tarif Trucking, kendaraan, driver |
| Admin Transit | Baca pihak, lokasi, rute, kendaraan, driver |
| Admin Penerima | Baca customer, pihak, lokasi, rute |
| Admin Sewa | Baca customer, unit, operator, tarif Equipment |
| Operator Alat Berat | Baca unit |
| Finance | Baca customer/supplier |
| Gudang | Baca barang/kategori/satuan, supplier, unit |
| Customer | Tanpa grant master |

Rute hanya terlihat bila kedua endpoint diizinkan. Katalog global dibagikan sebagai referensi, tanpa saldo cabang. Pemilihan akun personel memerlukan users.view dan cakupan global, akun aktif dengan akses cabang yang sesuai. Nama personel tertaut berasal dari users; tidak membuat akun, menyalin password, atau memberi role. Riwayat/referensi sensitif pada detail membutuhkan audit.view dan cakupan global.

## File dan struktur

```text
app/
  master-data.php                 # registry field/entity/tab, terpisah dari route
  routes.php                     # route HTTP dan izin kelompok
  navigation.php                 # sepuluh submenu nyata, layout tetap
  Controllers/MasterDataController.php
  Services/MasterData.php         # validasi, transaksi, audit
  Services/MasterPermissions.php  # seed grant eksplisit
  Repositories/MasterDataRepository.php
  Views/master-data.php
database/migrations/002_master_data.sql
tests/master-data.php
tests/master-data.cjs
tests/results/phase4-*.png
```

File existing diperbarui: `public/index.php`, `public/assets/foundation.css`, `app/Services/Migrator.php`, `app/Services/MasterService.php`, `app/Controllers/FoundationController.php`, `tests/run.php`, `tests/browser.cjs`, `tests/navigation.cjs`, `tests/dashboard.php`, `tests/dashboard.cjs`, `tests/deployment.php`. View cabang lama `app/Views/branches.php` dihapus agar hanya ada satu implementasi master. CSS tambahan terbatas halaman master; header/sidebar/drawer/bottom navigation Tahap 2 dipertahankan. Owner mendapat KPI cabang nyata melalui permission branches.view yang kini disetujui; widget transaksi tetap Belum tersedia.

Dokumen diperbarui: README, DECISIONS, PROGRESS, CHANGELOG, IMPLEMENTATION_PLAN, DATABASE_DESIGN, BUSINESS_RULES, UI_DESIGN_SYSTEM, NAVIGATION_BACKLOG, DASHBOARD_WIDGETS. Desain sebelum migration tercatat di [MASTER_DATA_DESIGN.md](MASTER_DATA_DESIGN.md).

## Pengujian aktual

Run akhir `php tests/run.php` selesai dengan exit 0: **481 pemeriksaan integrasi/HTTP** (286 khusus master), **108 browser fondasi**, **371 navigasi/komponen**, **724 browser dashboard**, dan **351 browser master** semuanya lulus. `php tests/deployment.php`: **14 pemeriksaan Apache/isolasi DB lulus**. Seluruh **68 file PHP lulus lint**; `node --check` untuk kelima file suite browser lulus. Artefak JSON di `tests/results/` menyimpan pemeriksaan individual. Failure fondasi null; database/akun/credential/cookie/sesi uji dibersihkan. Tidak ada pengujian kritis gagal atau belum dijalankan dalam lingkup Tahap 4.

Master browser: viewport 320/375/402/768/1366 masing-masing 60/60/60/60/59 pemeriksaan, ditambah 52 pemeriksaan lintas entity/role/pagination, total 351. Regresi sebelum perubahan juga dijalankan: 196 integrasi/HTTP, 107 browser fondasi, 236 navigasi dan 724 dashboard lulus.

Materi uji: fresh install, upgrade tanpa kehilangan histori, migration idempoten; tambah/edit/detail/status seluruh entity; validasi, duplikasi, FK aktual dan penolakan hard delete; cabang terlarang, kedua endpoint rute, akses tanpa grant, Owner read-only; CSRF; rollback audit; konflik version; referensi parent nonaktif; identitas pihak/personel; nominal kosong versus nol dan presisi; pencarian literal wildcard, filter dan pagination. Suite fondasi mengulang login benar/salah, rate limit, session timeout/revocation, logout serta perlindungan source/config.

Browser menguji sepuluh submenu pada lima viewport, seluruh 15 form edit, alur customer nyata, pagination, role/cabang, overflow, serta tombol simpan pada scroll paling bawah agar tidak tertutup bottom navigation. Screenshot desktop/mobile ditinjau langsung.

| Viewport | Screenshot daftar | Screenshot form |
|---|---|---|
| 320 × 640 | [daftar](tests/results/phase4-list-320.png) | [form](tests/results/phase4-form-320.png) |
| 375 × 812 | [daftar](tests/results/phase4-list-375.png) | [form](tests/results/phase4-form-375.png) |
| 402 × 874 | [daftar](tests/results/phase4-list-402.png) | [form](tests/results/phase4-form-402.png) |
| 768 × 1024 | [daftar](tests/results/phase4-list-768.png) | [form](tests/results/phase4-form-768.png) |
| 1366 × 768 | [daftar](tests/results/phase4-list-1366.png) | [form](tests/results/phase4-form-1366.png) |

## Keputusan tertunda dan batas verifikasi

Tarif adalah referensi manual nullable, tanpa kalkulasi otomatis. Tarif Equipment per hari, definisi durasi shift, prorata/overtime, tier berat/volume, pajak, bahan bakar/operator/mobilisasi, mutasi master antar cabang, konflik jadwal/personel dan delegasi write role operasional memerlukan keputusan berikutnya. Tidak membuat aturan finansial berdasarkan asumsi. Kondisi unit tidak menyatakan sedang disewa; katalog barang tidak menyatakan saldo stok.

MySQL 8, Safari/perangkat fisik, HTTPS nyata dan hosting cPanel belum diuji. Migration DDL parsial tetap memerlukan pemeriksaan manual, tanpa reset otomatis. Tidak ada migrasi data proyek lama. Berhenti setelah Tahap 4; Tahap 5 memerlukan persetujuan pengguna.

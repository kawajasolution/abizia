# HLS Operational Navigation Verification

Tanggal: 24 Oktober 2026 (WITA)

URL diuji: `http://localhost/hls-v2/public/` dengan database `hls_v2`.

## Ringkasan

Verifikasi browser Owner dijalankan terhadap Dashboard, Trucking, Equipment, dan Master Data. Sebanyak 21 route diperiksa pada browser desktop 1366 px. Route yang tidak dimiliki Owner mengembalikan `403` dan dicatat sebagai hasil keamanan yang benar, bukan sebagai halaman berhasil.

## Matriks route Owner

| Kelompok | Menu | Route | Permission | Hasil |
|---|---|---|---|---|
| Dashboard | Dashboard | `/` | `foundation.view` | PASS — HTTP 200, heading Dashboard, KPI tampil |
| Trucking | Delivery Note (DN) | `/trucking/dns` | `expedition.view` | PASS — HTTP 200, halaman daftar tampil |
| Trucking | Manifest | `/trucking/manifests` | `expedition.manifest.view` | PASS — HTTP 200, halaman daftar tampil |
| Trucking | Transit | `/trucking/transit` | `expedition.transit` | PASS keamanan — Owner ditolak HTTP 403 sesuai permission |
| Trucking | Penerimaan | `/trucking/receipts` | `expedition.receive` | PASS keamanan — Owner ditolak HTTP 403 sesuai permission |
| Trucking | Klaim | `/trucking/claims` | `expedition.claim.view` | PASS — HTTP 200, daftar klaim tampil |
| Trucking | Tracking | `/trucking/tracking` | `expedition.view` | PASS — HTTP 200, halaman tracking tampil |
| Equipment | Kontrak Sewa | `/equipment/contracts` | `equipment.contract.view` | PASS — HTTP 200 |
| Equipment | Berita Acara | `/equipment/handovers` | `equipment.handover.view` | PASS — HTTP 200 |
| Equipment | Timesheet | `/equipment/timesheets` | `equipment.timesheet.view_scoped` | PASS — HTTP 200 |
| Equipment | Verifikasi Timesheet | `/equipment/verification` | `equipment.verification.view` | PASS — HTTP 200 |
| Master Data | Customer | `/master/customers` | `master.customer.view` | PASS — HTTP 200, data/listing tampil |
| Master Data | Pengirim & Penerima | `/master/parties` | `master.party.view` | PASS — HTTP 200 |
| Master Data | Lokasi & Rute | `/master/routes` | `master.routes.view` | PASS — HTTP 200 |
| Master Data | Tarif Trucking | `/master/trucking-tariffs` | `master.trucking_tariff.view` | PASS — HTTP 200 |
| Master Data | Tarif Equipment | `/master/equipment-tariffs` | `master.equipment_tariff.view` | PASS — HTTP 200 |
| Master Data | Kendaraan & Unit | `/master/assets` | `master.assets.view` | PASS — HTTP 200 |
| Master Data | Driver & Operator | `/master/personnel` | `master.personnel.view` | PASS — HTTP 200 |
| Master Data | Barang & Kategori | `/master/items` | `master.catalog.view` | PASS — HTTP 200 |
| Master Data | Supplier | `/master/suppliers` | `master.supplier.view` | PASS — HTTP 200 |
| Master Data | Cabang | `/branches` | `branches.view` | PASS — HTTP 200 |

Finance, Inventory, Laporan, serta Unit Alat Berat belum memiliki route implementasi dan tetap tersembunyi. Tidak ada permission baru yang diberikan.

## Dashboard Owner

Hasil inspeksi browser:

- 11 kartu KPI operasional ter-render dari query repository, tanpa angka hardcoded.
- Filter periode: 2 input tanggal tersedia.
- Filter cabang: 1 selector tersedia dan mengikuti branch scope.
- Drill-down KPI: 10 tautan kartu terdeteksi.
- Shortcut dashboard lama: 0 elemen `.dashboard-actions`; shortcut tidak lagi menumpuk di halaman.
- Tidak ada error JavaScript pada inspeksi desktop maupun mobile.

## Responsivitas

| Viewport | Hasil |
|---|---|
| Desktop 1366 px | PASS — route dan layout diperiksa |
| Tablet 768 px | PASS — regresi visual sebelumnya 6/6 |
| Mobile 320 px | PASS — hamburger, bottom navigation, dan tidak ada overflow |

Pengujian visual sebelumnya (`tests/demo-visual.cjs`) menghasilkan 6/6 PASS untuk Owner dan Administrator pada 320, 768, dan 1366 px. Pengujian operasional ini juga memastikan mobile Owner memiliki hamburger, bottom navigation, dan tidak ada error console.

## Batas pengujian

- Detail transaksi dengan data operasional nyata dan aksi perubahan status tidak dijalankan agar tidak mengubah histori.
- Drill-down dikonfirmasi melalui tautan yang dirender; setiap workflow perubahan Trucking/Equipment tetap mengikuti suite modul masing-masing.
- Filter periode/cabang diperiksa keberadaan dan sumber backend; pengujian perbandingan angka lintas periode memerlukan dataset transaksi yang tersedia.

## Status akhir

**PASS dengan batas pengujian di atas.** Tidak ditemukan kegagalan navigasi atau JavaScript yang memerlukan perubahan kode. Tidak ada perubahan database, permission, state machine, atau aturan bisnis.

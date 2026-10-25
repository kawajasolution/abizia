# HLS V2 Roadmap

Tanggal pembaruan: 25 Oktober 2026

## Tujuan dan prinsip

HLS V2 tetap satu aplikasi dengan satu database yang dikonfigurasi. Modul berbagi RBAC, branch scope, CSRF, audit, dan ledger transaksi. Owner bersifat baca-saja untuk transaksi sensitif. Fitur baru tidak dinyatakan selesai hanya karena route atau menu tersedia.

## Status modul saat ini

| Modul | Status | Catatan |
|---|---|---|
| Trucking & Logistics | Berjalan | Delivery Note, Manifest, Transit, Penerimaan, Klaim, dan Tracking tersedia sesuai cakupan implementasi. |
| Equipment Rental | Berjalan sebagian | Kontrak, BA, Timesheet, dan Verifikasi tersedia; billing lanjutan masih direncanakan. |
| Finance & Accounting | Berjalan sebagian | Invoice, Piutang, Pembayaran, Kas & Bank, Pengeluaran, Utang, Dashboard, dan Laba/Rugi tersedia dengan batas pengujian/klasifikasi yang terdokumentasi. |
| Inventory & Warehouse | Berjalan tahap awal | Stok Barang dan Barang Masuk tersedia; Barang Keluar, mutasi, transfer, gudang, dan laporan persediaan berikutnya. |
| Fleet Management | Belum diimplementasikan | Menggunakan master kendaraan/unit existing sebagai fondasi, tanpa tabel baru pada pembaruan ini. |
| Maintenance Management | Belum diimplementasikan | Menunggu desain work order, jadwal servis, biaya, dan integrasi inventory. |
| Reporting & Analytics | Belum lengkap | Laporan operasional, keuangan, cabang, dan persediaan masih dalam roadmap. |
| External Integration | Belum diimplementasikan | ERP dan IoT bersifat opsional, terisolasi, dan tidak boleh mengubah transaksi tanpa validasi. |

## Kebutuhan Equipment dan custom billing

Kebutuhan yang disetujui untuk perencanaan: HM awal/akhir, total HM, tarif HM, minimum HM kontrak, master shift, jadwal dan pergantian operator, timesheet dengan jam kerja/overtime, persetujuan timesheet, dan alur Kontrak → Penugasan → Timesheet → Persetujuan → Billing → Invoice → Piutang → Pembayaran.

Kebutuhan tarif, minimum HM, overtime, dan pengakuan billing harus mengikuti kontrak serta keputusan bisnis. Tidak ada invoice kedua; integrasi menggunakan modul Finance existing.

## Fleet dan Maintenance

Fleet akan mengelola kendaraan/unit, nomor polisi, jenis, cabang, status, kilometer/HM, dan riwayat penggunaan dengan memanfaatkan master existing. Maintenance akan mencakup preventive maintenance berbasis tanggal/km/HM dan work order dengan teknisi, spare part, biaya, status, serta riwayat.

Penggunaan spare part wajib mengikuti alur Work Order → Permintaan Spare Part → Barang Keluar → Ledger Stok → Biaya Maintenance. Stok tidak boleh dikurangi langsung dari work order.

## Inventory lanjutan dan multi-gudang

Ledger `inv_stock_ledger` saat ini menggunakan dimensi barang dan cabang. Multi-gudang memerlukan rancangan additive untuk `warehouse_id`, master gudang, transfer antar gudang/cabang, dan backfill yang aman. Jangan mengubah transaksi existing sebelum rancangan migrasi, strategi default gudang, indeks, dan pengujian disetujui.

## Trucking lanjutan

Roadmap mencakup uang jalan sopir dengan pengajuan, persetujuan, pencairan, realisasi, pertanggungjawaban, pengembalian, dan integrasi Kas/Bank tanpa ledger ganda; konsumsi BBM; pengembangan Delivery Note digital/e-CMR; serta integrasi tracking pada workflow existing. Kepatuhan hukum e-CMR memerlukan analisis terpisah.

## Integrasi eksternal

Arsitektur integrasi ERP (SAP/Oracle/lainnya) dan IoT harus opsional, memakai mapping, autentikasi, logging, retry, idempotensi, dan isolasi kegagalan. Data IoT tidak boleh langsung mengubah stok atau transaksi keuangan.

## Urutan pengembangan berikutnya

1. Selesaikan Inventory: Barang Keluar, mutasi, transfer, dan laporan persediaan.
2. Fleet Management berbasis master existing.
3. Maintenance Management dan integrasi spare part.
4. Advanced Equipment Billing dan Timesheet.
5. Uang Jalan dan BBM.
6. Surat jalan digital/e-CMR.
7. Reports & Analytics.
8. External Integration.

Urutan dapat berubah bila ketergantungan teknis atau keputusan bisnis memerlukannya.

## Migrasi, risiko, dan pengujian tertunda

Migration inventory yang sudah dibuat harus dijalankan melalui migrator resmi setelah backup terverifikasi. Perubahan multi-gudang, fleet, maintenance, billing HM/overtime, uang jalan, dan integrasi memerlukan migration additive, constraint, audit, dan rencana rollback.

Pengujian transaksi Utang Supplier nyata masih tertunda karena supplier aktif belum tersedia. Pengujian browser terautentikasi untuk modul Finance dan Inventory juga perlu dijalankan menggunakan fixture terkontrol. Jangan menandai fitur tersebut PASS tanpa bukti.
## Prioritas strategis pembaruan 25 Oktober 2026

- **P0 Integritas Inventory:** tampilkan stok fisik, dicadangkan, tersedia; samakan laporan/CSV; lindungi Transfer dan Adjustment dari penggunaan stok yang dicadangkan; lakukan UAT pada environment terisolasi.
- **P1 Dokumen Equipment:** advanced timesheet, digital BAST, digital P2H.
- **P2 Maintenance:** jadwal servis, work order, breakdown, spare part, service report, riwayat.
- **P3 Integrasi Billing:** timesheet ke billing/invoice, maintenance cost, profitabilitas unit.
- **P4 Komersial:** uang jalan, BBM, e-POD, customer portal, mobile field operations, multi-company.

Maintenance menjadi kelompok modul utama, tetapi submenu yang belum memiliki route/controller nyata tetap disabled.

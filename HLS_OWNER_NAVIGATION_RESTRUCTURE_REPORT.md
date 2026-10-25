# HLS Owner Navigation Restructure Report

Tanggal: 24 Oktober 2026 (WITA)

## Perubahan

Dashboard tidak lagi menampilkan kumpulan tombol navigasi di tengah halaman. Sidebar desktop dan drawer mobile tetap menggunakan satu registry `app/navigation.php`; dashboard sekarang berisi filter, KPI operasional, panel Finance berstatus belum tersedia, dan area pemantauan.

## Menu sebelum dan sesudah

Sebelum, dashboard merender seluruh item navigasi yang terlihat sebagai `dashboard-actions`, sehingga shortcut Trucking, Equipment, dan Master Data mendominasi halaman.

Sesudah, navigasi tersebut dihapus dari dashboard. Menu tetap berada pada kelompok sidebar/drawer sesuai registry dan permission:

| Kelompok | Route/permission yang tersedia |
|---|---|
| Dashboard | `/`, `foundation.view` |
| Trucking | `/trucking/dns`, `expedition.view`; `/trucking/manifests`, `expedition.manifest.view`; `/trucking/transit`, `expedition.transit`; `/trucking/receipts`, `expedition.receive`; `/trucking/claims`, `expedition.claim.view`; `/trucking/tracking`, `expedition.view` |
| Equipment | `/equipment/contracts`, `equipment.contract.view`; `/equipment/handovers`, `equipment.handover.view`; `/equipment/timesheets`, `equipment.timesheet.view_scoped`; `/equipment/my-timesheets`, `equipment.timesheet.view_own`; `/equipment/verification`, `equipment.verification.view` |
| Master Data | Route master yang memiliki controller dan permission `master.*.view`, serta `/branches` dengan `branches.view` |
| Pengaturan | `/users`, `/roles`, `/audit` hanya untuk grant global yang sesuai |

Invoice, pembayaran, piutang, utang, kas/bank, laporan, Inventory, Reservasi/penugasan Equipment terpisah, dan laporan Trucking/Equipment tetap tidak ditampilkan sebagai menu aktif karena route atau modulnya belum tersedia. Tidak ada permission baru atau grant sensitif.

## Dashboard Owner

Dashboard Owner kini memprioritaskan filter periode/cabang, KPI Trucking, KPI Equipment, panel Finance yang menjelaskan status implementasi, dan informasi pemantauan. KPI tetap menggunakan agregasi database aktual dan drill-down yang tersedia. Dashboard tidak lagi menjadi pengganti sidebar.

## Pengujian aktual

| Pengujian | Hasil |
|---|---|
| PHP lint dashboard | PASS |
| Owner desktop 1366 | PASS |
| Owner tablet 768 | PASS |
| Owner mobile 320 | PASS |
| Administrator desktop 1366 | PASS |
| Administrator tablet 768 | PASS |
| Administrator mobile 320 | PASS |
| CSS/ikon/console/overflow | PASS pada 6 skenario |
| Expand/collapse sidebar/drawer | PASS pada regresi interface/navigation yang tersedia |
| Route dan permission backend | Tidak diubah; baseline permission tetap berlaku |
| Browser seluruh submenu transaksi | NOT TESTED ulang pada target utama; daftar route existing tetap menjadi baseline |

Screenshot terbaru tersimpan di `tests/results/demo-owner-320.png`, `demo-owner-768.png`, `demo-owner-1366.png`, serta pasangan Administrator. Nama file mengikuti runner lama; URL yang diuji adalah `/hls-v2/public/` pada database utama `hls_v2`.

## File berubah

- `app/Views/dashboard.php`: menghapus render shortcut navigasi dari dashboard.
- `HLS_OWNER_NAVIGATION_RESTRUCTURE_REPORT.md`: laporan ini.

Tidak ada perubahan database, state machine, permission, route, atau aturan bisnis.

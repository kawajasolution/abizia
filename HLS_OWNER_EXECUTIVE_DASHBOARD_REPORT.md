# HLS Owner Executive Dashboard Report

Tanggal: 24 Oktober 2026 (WITA)

## Implementasi

Dashboard Owner sekarang memiliki ringkasan operasional terukur untuk Trucking dan Equipment, filter cabang sesuai cakupan, filter periode default bulan berjalan WITA, serta tautan drill-down ke route operasional yang tersedia. Panel Finance menjelaskan bahwa sumber keuangan belum tersedia dan tidak menampilkan angka pengganti.

KPI yang ditambahkan:

- Total Delivery Note dalam periode berdasarkan `exp_dns.document_date`.
- Pengiriman dalam proses: DN berstatus `departed`, `transit`, atau `arrived`.
- Pengiriman selesai: DN berstatus `received` atau `completed`.
- Manifest aktif: Manifest `draft`, `departed`, atau `transit` dalam periode.
- Klaim terbuka: klaim `REPORTED` atau `REVIEWING` berdasarkan waktu pencatatan.
- Total unit alat berat dari `eq_contract_units`.
- Unit sedang digunakan: unit `ACTIVE`.
- Unit tersedia: unit tidak `ACTIVE` dan belum terminal.
- Kontrak aktif: `eq_contracts.status='ACTIVE'`.
- Timesheet menunggu verifikasi: root yang memiliki revisi `SUBMITTED`.

Seluruh query menggunakan branch scope backend. Tidak ada perubahan status, state machine, permission, atau schema Finance.

## File berubah

- `app/Repositories/DashboardRepository.php`: agregasi KPI operasional scoped.
- `app/Services/Dashboard.php`: filter periode Owner dan penyediaan data KPI.
- `app/Views/components/dashboard-filters.php`: filter periode operasional Owner.
- `app/Views/dashboard.php`: kartu KPI Owner, drill-down, dan status Finance.
- `HLS_OWNER_EXECUTIVE_DASHBOARD_REPORT.md`: laporan ini.

## Pengujian aktual

| Pemeriksaan | Hasil |
|---|---|
| PHP lint repository/service/view terkait | PASS, 4/4 |
| Dashboard URL utama HTTP | PASS, 200 |
| Owner KPI pada database utama kosong | PASS, seluruh nilai berasal query dan bernilai 0 karena transaksi memang 0 |
| Filter periode Owner | PASS, form dan query menerima `start/end` |
| Filter cabang out-of-scope | PASS melalui guard existing |
| Owner dashboard browser 320 px | PASS |
| Owner dashboard browser 768 px | PASS |
| Owner dashboard browser 1366 px | PASS |
| Administrator dashboard regresi visual | PASS pada 3 viewport |
| Asset CSS/JS dan console error | PASS pada 6 skenario browser |
| Finance KPI | NOT IMPLEMENTED, sengaja tidak diberi angka |
| Data transaksi operasional non-kosong | NOT TESTED pada target utama; target saat ini memang 0 transaksi |
| Drill-down dengan record transaksi nyata | NOT TESTED karena tabel transaksi utama kosong |

Screenshot browser tersimpan di `tests/results/demo-owner-320.png`, `demo-owner-768.png`, dan `demo-owner-1366.png` (nama file test lama; URL yang diuji adalah `/hls-v2/public/`). Screenshot desktop menunjukkan kartu KPI Trucking/Equipment, filter periode/cabang, panel Finance berstatus belum tersedia, dan navigasi tetap responsif.

## Keterbatasan

1. Database utama belum memiliki transaksi Trucking/Equipment, sehingga dashboard menampilkan nol operasional yang merupakan hasil query aktual, bukan data sintetis.
2. Definisi terlambat dan kontrak mendekati jatuh tempo belum ditambahkan karena aturan tanggal dan indikator pendukung belum disetujui/tersedia.
3. KPI omzet, piutang, utang, kas/bank, pengeluaran, dan laba/rugi tetap ditunda sampai Finance memiliki schema, state machine, dan keputusan bisnis.
4. Drill-down filter status tertentu memerlukan dukungan filter pada masing-masing daftar; tautan hanya dibuat ke route yang sudah tersedia dan tidak mengklaim detail Finance.

# Laporan Tahap 3 — Dashboard berdasarkan role

Tanggal: 24 Oktober 2026, WITA. **Selesai dalam cakupan sumber yang tersedia.** Tidak membuat modul bisnis/migration/grant baru; Tahap 4 belum dimulai.

## Verifikasi awal

Membaca IMPLEMENTATION_PLAN.md, BUSINESS_RULES.md, DATABASE_DESIGN.md, UI_DESIGN_SYSTEM.md, DECISIONS.md, PROGRESS.md dan README.md; AGENTS.md tidak tersedia di v2. Suite Tahap 1–2 dijalankan sebelum perubahan: 109 pemeriksaan fondasi, 107 browser fondasi dan 236 navigasi/komponen lulus. Login, RBAC, sesi/CSRF, sidebar, hamburger, drawer, profil dan bottom nav tidak memiliki kegagalan kritis pada gerbang awal.

## Dashboard yang berfungsi

Route `GET /` langsung memanggil DashboardController dan memilih fokus tampilan dari role principal database. Sidebar dan bottom nav tetap menunjuk `/`; tidak ada halaman perantara, parameter role yang dipercaya, tombol Buka Dashboard Owner atau banner sambutan. Judul halaman tetap Dashboard dan posisi navigasi Tahap 2 tidak berubah.

| Role | Hasil yang benar-benar tersedia |
|---|---|
| Administrator global | KPI pengguna aktif/cabang/role/permission; distribusi pengguna aktif per role; audit terbaru dengan periode; tindak lanjut akun/cabang; aksi ke halaman fondasi yang diizinkan |
| Administrator scoped | KPI/daftar dan tindak lanjut cabang dalam cakupannya; tanpa KPI akun/role global atau audit |
| Owner | Fokus operasional/perusahaan, filter dan daftar cabang sendiri; ringkasan operasi, keuangan, monitoring, perhatian dan tren berstatus Belum tersedia |
| Admin Pengirim | Fokus pengiriman; status sumber DN/draft invoice belum tersedia |
| Admin Transit | Fokus manifest/transit; status sumber manifest dan DN transit belum tersedia |
| Admin Penerima | Fokus penerimaan/klaim; status sumber penerimaan dan penyelesaian klaim belum tersedia |
| Admin Sewa | Fokus kontrak dan verifikasi; status sumber kontrak/unit/timesheet belum tersedia |
| Operator Alat Berat | Fokus penugasan/timesheet sendiri; sumber belum tersedia, tanpa membuka penugasan atau tarif pihak lain |
| Finance | Fokus invoice, pembayaran dan kas; sumber keuangan belum tersedia, tanpa nominal/angka pengganti |
| Gudang | Fokus stok/pergerakan/tindak lanjut; sumber stok dan aturan minimum belum tersedia |
| Customer | Fokus pengiriman sendiri; tracking belum tersedia, tanpa membuat portal/route bisnis palsu |

Setiap role tetap dapat melihat identitas dan cabang dalam aksesnya dari sumber fondasi. Semua status bisnis belum tersedia berupa metadata kebutuhan ringkasan, bukan data transaksi/izin untuk membaca sumber bisnis. Tidak ada angka 0 pengganti sumber hilang. Daftar sumber/definisi per widget: [DASHBOARD_WIDGETS.md](DASHBOARD_WIDGETS.md).

## Data nyata dan filter

Query nyata berada di DashboardRepository, dipanggil service Dashboard dengan snapshot transaksi pembacaan. Permission per dataset dicek ulang di repository. Perubahan role/cakupan pada URL tidak memberi hak. Route tetap foundation.view; KPI pengguna mensyaratkan users.view + global, role/permisson mensyaratkan roles.view + global, audit mensyaratkan audit.view + global. Cakupan global tidak menggantikan permission.

Filter cabang dibatasi daftar cabang terotorisasi, termasuk ketika pengguna mengetik ID langsung. Filter berlaku pada daftar/jumlah cabang serta hitungan pengguna yang mempunyai akses ke cabang itu (global atau relasi user_branches, tidak dihitung ganda). KPI adalah kondisi saat ini; jumlah role/permission tetap matriks global. Default cabang: seluruh cabang yang diizinkan, bukan seluruh database bagi akun scoped.

Periode hanya tersedia bagi pembaca audit global. Default awal bulan sampai hari ini WITA; dua batas tanggal inklusif. Periode tidak mengubah KPI keadaan saat ini. Audit belum memiliki metadata cabang transaksi yang dapat dipastikan: ketika cabang tertentu dipilih, baris audit disembunyikan dan status audit per cabang belum tersedia. Tidak menebak scope audit dari aktor/JSON. Filter salah/tanggal tidak nyata/rentang terbalik ditolak; cabang luar akses dan periode audit tanpa izin mendapat 403.

Tindak lanjut berasal dari fakta saat ini: akun nonaktif, cabang nonaktif dan pengguna aktif tanpa penetapan cabang. Jika semua pemeriksaan yang diizinkan kosong, tampil empty state nyata. Tidak menetapkan SLA, limit finansial, ambang kontrak/stock atau aturan persetujuan baru.

## Sumber yang belum tersedia

V2 tetap sembilan tabel fondasi. Tidak ada DN/manifest, kontrak/unit/timesheet, invoice/pembayaran/expense, kas atau ledger stok. Karena itu grafik tren DN/invoice/pembayaran/operasional belum digambar; tidak menggunakan login/audit sebagai transaksi pengganti. Laba bersih, margin, HPP, pajak/depresiasi tidak dihitung. Klaim belum selesai, DN tertunda, kontrak mendekati akhir dan stok rendah menunggu model/status/SOP sumber, bukan ambang yang diasumsikan.

Katalog memeriksa ketersediaan tabel pada database v2 saja. Belum ada adapter agregasi bisnis aktif; nama tabel yang kebetulan tersedia kelak tidak otomatis mengaktifkan query/grant. Modul terkait harus menyediakan mapping status, permission, scope, formula dan pengujian terlebih dahulu.

## File dibuat/diubah

Baru:

- app/dashboard.php — katalog fokus role/dependensi widget.
- app/Controllers/DashboardController.php.
- app/Services/Dashboard.php.
- app/Repositories/DashboardRepository.php.
- app/Views/dashboard.php.
- app/Views/components/dashboard-filters.php.
- app/Views/components/dashboard-kpi.php.
- app/Views/components/dashboard-pending.php.
- tests/dashboard.php dan tests/dashboard.cjs.
- DASHBOARD_WIDGETS.md dan PHASE3_REPORT.md.

Diubah:

- app/routes.php — `/` didispatch ke controller dashboard, permission tetap.
- public/index.php — factory controller eksplisit untuk dashboard.
- app/Controllers/FoundationController.php — menghapus handler home lama yang sudah digantikan.
- public/assets/foundation.css — grid/filter/KPI/state dashboard dengan token dan breakpoint HLS yang ada.
- tests/run.php dan tests/browser.cjs — integrasi suite dashboard dan assertion judul Dashboard.
- README.md, DECISIONS.md, PROGRESS.md, CHANGELOG.md, IMPLEMENTATION_PLAN.md, UI_DESIGN_SYSTEM.md, NAVIGATION_BACKLOG.md.

Dihapus: app/Views/home.php yang tidak dipakai setelah dispatch baru. Tidak mengubah app/navigation.php, posisi/header/drawer/bottom nav, database/migrations, konfigurasi/credential development, proyek/database lama atau hosting.

## Pengujian aktual akhir

| Suite | Hasil | Bukti |
|---|---|---|
| Integrasi/service/HTTP fondasi dan dashboard | 196 assertion lulus, failure=null | tests/results/foundation.json |
| Bagian integrasi dashboard di dalam suite tersebut | 87 assertion lulus | tests/results/dashboard-integration.json |
| Browser regresi fondasi | 107 lulus | tests/results/browser.json |
| Browser regresi navigasi/komponen | 236 lulus | tests/results/navigation.json |
| Browser dashboard | 724 lulus | tests/results/dashboard-browser.json |
| Apache/isolasi DB | 14 lulus | tests/results/deployment.json |
| PHP lint | 62 berkas, 0 gagal | tests/results/lint.json |
| Sintaks JS | dashboard.cjs, browser.cjs, navigation.cjs, interface.js lulus node --check | Verifikasi akhir |

87 assertion dashboard adalah bagian dari 196, bukan suite tambahan yang perlu dijumlahkan. 196 juga mencakup gerbang keberhasilan browser. Hasil JSON di tests/results adalah run terbaru; laporan Tahap 1/2 merupakan snapshot historis.

| Viewport | Role diuji | Assertion dashboard | Hasil |
|---|---:|---:|---|
| 320 × 640 | 10 | 147 | Lulus |
| 375 × 812 | 10 | 147 | Lulus |
| 402 × 874 | 10 | 147 | Lulus |
| 768 × 1024 | 10 | 147 | Lulus |
| 1366 × 768 | 10 | 127 | Lulus |

Total viewport 715 ditambah sembilan assertion filter/scoped = 724. Browser benar-benar menjalankan Chromium; seluruh sembilan role yang diminta serta Customer diuji pada kelima viewport, ditambah Administrator scoped. Pemeriksaan meliputi direct dashboard setelah login/klik navigasi, role benar, widget tanpa izin disembunyikan, data hilang tanpa angka palsu, tidak ada link bisnis kosong/banner, tidak ada overflow, header/sidebar/bottom nav tetap dan akhir konten dapat digulir bebas dari bottom nav.

Integrasi merekonsiliasi KPI/distribusi dengan query sumber, memeriksa schema availability, filter cabang/global, date invalid/inverted, batas inklusif WITA, periode kosong, scope audit, repository/service/route permission, parameter role palsu, Owner global tanpa tambahan grant, source bisnis hilang, serta tindak lanjut ketika status akun/cabang/penetapan cabang berubah. Fixture hanya administratif dan audit fiktif pada DB test, tidak membuat transaksi bisnis palsu. Status dan grant yang diuji dikembalikan sebelum browser; DB/akun/credential/cookie/sesi test dibersihkan.

## Screenshot

- [Administrator desktop](tests/results/phase3-administrator-1366.png)
- [Owner desktop](tests/results/phase3-owner-1366.png)
- [Administrator mobile](tests/results/phase3-administrator-375.png)
- [Owner mobile](tests/results/phase3-owner-375.png)
- Screenshot role lain di tests/results/phase3-*-375.png.

Angka pada screenshot Administrator berasal dari fixture administratif DB disposable saat pengambilan gambar, bukan data perusahaan atau seed development. Screenshot role bisnis menampilkan Belum tersedia secara eksplisit.

## Batas dan status berikutnya

Tidak ada pengujian kritis Tahap 3 yang masih gagal. Ringkasan transaksi/keuangan/grafik serta shortcut bisnis menunggu modul dan permission sah. Tidak ada perubahan aturan bisnis/akuntansi atau migration. Nilai 0 pada data fondasi yang memang kosong tetap sah; nilai 0 tidak dipakai untuk sumber bisnis yang belum ada.

MySQL 8, TLS/hosting, Safari dan perangkat fisik/safe-area nyata belum diuji; viewport memakai Chromium. Tidak ada akses hosting atau database lama. **Berhenti setelah Tahap 3 dan tunggu persetujuan sebelum Tahap 4.**

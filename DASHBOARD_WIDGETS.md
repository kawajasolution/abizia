# Sumber dan definisi widget dashboard — Tahap 3

Tanggal: 24 Oktober 2026, WITA. Route tunggal `GET /`, permission `foundation.view`; role diambil dari akun terautentikasi, bukan parameter URL. Catalog fokus role ada di app/dashboard.php. Seluruh query nyata melalui DashboardRepository dan service Dashboard, dibaca dalam satu transaksi konsisten pada database v2.

## Widget dengan sumber nyata

| Widget | Sumber / definisi | Permission dan cakupan | Filter |
|---|---|---|---|
| Pengguna aktif | COUNT users dengan active=1 | users.view + all_branches | Jika cabang dipilih, akun all_branches atau user_branches yang cocok dihitung tepat sekali; kondisi saat ini |
| Cabang dalam cakupan | Jumlah branches dalam cabang eksplisit akun atau seluruh cabang untuk akun global; termasuk nonaktif | branches.view; daftar wajib dibatasi cabang | Cabang terpilih atau semua yang diizinkan; kondisi saat ini |
| Role terdaftar | COUNT roles | roles.view + all_branches | Matriks global, tidak dipengaruhi periode/cabang |
| Permission terdaftar | COUNT permissions | roles.view + all_branches | Matriks global, tidak dipengaruhi periode/cabang |
| Pengguna aktif per role | COUNT users.active=1, LEFT JOIN roles; role tanpa pengguna boleh bernilai 0 karena sumber nyata ada | users.view + roles.view + all_branches | Sama dengan KPI pengguna aktif; jumlah tabel merekonsiliasi KPI |
| Pengguna nonaktif | COUNT users.active=0 | users.view + all_branches | Cakupan akun cabang terpilih; hanya menjadi tindak lanjut bila jumlah positif |
| Pengguna aktif tanpa penetapan cabang | COUNT active=1, all_branches=0, tidak ada user_branches | users.view + all_branches | Akun yang tidak memiliki akses cabang tidak ikut hitungan saat cabang tertentu dipilih |
| Cabang nonaktif | COUNT branches.active=0 pada daftar yang terotorisasi | branches.view; cakupan akun | Cabang terpilih; hanya menjadi tindak lanjut bila positif |
| Audit terbaru | Maksimal delapan audit_logs, actor name melalui LEFT JOIN users, urut ID terbaru | audit.view + all_branches | Tanggal WITA inklusif 00:00:00 sampai 23:59:59; default awal bulan sampai hari ini |
| Identitas dan daftar cabang sendiri | Identitas principal DB dan branches dalam penetapan akun | foundation.view; akses milik sendiri | Daftar cabang mengikuti pilihan yang diizinkan, tidak menampilkan pengguna/audit lain |
| Aksi dashboard | Item tersedia pada registry navigasi, kecuali Dashboard itu sendiri | Route GET, permission dan syarat global yang sama dengan sidebar | Tidak membuat shortcut bisnis yang belum memiliki route |

KPI administrasi bukan nilai historis pada tanggal akhir. Filter periode hanya berlaku untuk audit; label UI menjelaskan ini. Audit belum mempunyai kolom cabang transaksi yang dapat dipastikan. Ketika cabang tertentu dipilih, seluruh baris audit disembunyikan dan ditandai belum tersedia per cabang; jangan menampilkan audit global sebagai audit cabang. Tidak menebak cabang melalui aktor atau JSON.

Administrator scoped hanya memperoleh KPI cabang yang diizinkan. Grant role yang kebetulan dimiliki tidak mengatasi syarat all_branches untuk pengguna/role/audit. Owner bercakupan global tetap tidak memperoleh izin administrasi dari nama role atau cakupannya.

## Widget yang menunggu sumber bisnis

V2 saat Tahap 3 hanya memiliki sembilan tabel fondasi. Sumber berikut belum ada. Service memeriksa metadata tabel pada database v2 saja; tidak membaca database lama. Tidak ada adapter query bisnis yang diaktifkan, sehingga keberadaan nama tabel secara kebetulan di masa depan tidak otomatis memberi akses/query tanpa desain permission, scope dan mapping status yang benar.

| Role | Ringkasan yang ditandai Belum tersedia | Sumber/dependensi berikutnya |
|---|---|---|
| Owner | Total DN, dalam perjalanan/selesai, manifest aktif, kontrak aktif, timesheet menunggu; invoice/pembayaran/piutang/pengeluaran/kas; monitoring cabang; perhatian; tren | Trucking, Equipment, Finance, Petty Cash dan aturan monitoring yang terdefinisi |
| Admin Pengirim | DN hari ini/belum dimanifest/dalam perjalanan/selesai/terbaru; draft invoice cabang | exp_shipments, exp_manifest_items, fin_invoices; permission draft dan cabang sumber |
| Admin Transit | Manifest aktif/menuju cabang/tiba/belum selesai; DN transit | exp_manifests, exp_shipments, exp_events dan pemetaan lintasan |
| Admin Penerima | Menunggu penerimaan, diterima hari ini, belum diambil; klaim belum selesai | exp_shipments/exp_events/exp_claims dan SOP penerimaan/penyelesaian klaim |
| Admin Sewa | Kontrak aktif/mendekati akhir, unit disewa; timesheet menunggu/terverifikasi | rent_contracts/rent_units/rent_timesheets; definisi mendekati akhir |
| Operator Alat Berat | Penugasan aktif sendiri; timesheet terbaru/menunggu/dikembalikan | rent_contracts/rent_timesheets, operator principal, mapping status yang didukung |
| Finance | Draft masuk/menunggu terbit/terbit, pembayaran/piutang/pengeluaran, kas sesuai izin | fin_invoices/fin_payments/fin_expenses/pc_accounts/pc_entries dan permission terkait |
| Gudang | Item stok, masuk/keluar terbaru, transfer aktif, tindak lanjut opname, stok rendah | inv_stock/inv_documents/inv_transfers/inv_items; minimum stok/SOP yang sah |
| Customer | Pelacakan pengiriman sendiri | Sumber Trucking dan kebijakan identitas/pengiriman Customer; bukan portal atau tracking palsu |

Administrator tidak mendapat ringkasan finansial hanya karena namanya Administrator. Dashboard role lain menampilkan daftar kebutuhan ringkasan dengan label Belum tersedia, tanpa angka, grafik kosong bersumbu nol, nominal, data transaksi atau CTA ke route kosong. Metadata kebutuhan widget bukan pemberian akses ke sumber bisnis.

## Definisi yang sengaja belum diaktifkan

- Total DN dan tren: perlu sumber v2, mapping status serta aturan visibility asal/tujuan/transit; periode harus mengikuti tanggal dokumen/event yang disepakati. Tidak menghitung dari audit fondasi.
- DN tertunda dan kontrak mendekati akhir: SLA/ambang waktunya belum ditentukan; tidak mengasumsikan 7/14/30 hari.
- Klaim belum selesai: model klaim lama deskriptif, SOP penyelesaian belum disetujui. Jangan membuat status penyelesaian atau kewajiban kompensasi untuk mengisi KPI.
- Invoice/pembayaran/piutang: perlu definisi state efektif dan reversal, tanggal masing-masing sumber, cabang pencatatan serta DECIMAL/integer sen. Jangan menganggap penerimaan kas sebagai pendapatan/laba.
- Timesheet dikembalikan: hanya diaktifkan jika status dan otorisasi sumber Equipment v2 mendukungnya. Tidak membuat status baru pada tahap dashboard.
- Stok rendah: perlu batas minimum per barang/gudang dan saldo sah; tidak mengarang ambang. Stock opname tindak lanjut juga menunggu SOP sumber.
- Grafik Owner/tren keuangan/operasional: belum digambar karena sumber belum tersedia. Tidak menggunakan aktivitas login/audit sebagai pengganti DN atau invoice.
- Laba bersih, margin, HPP, depresiasi dan rumus pajak sama sekali tidak ditambahkan.

Tidak ada migration, grant, data transaksi atau modul bisnis yang dibuat pada Tahap 3. Penambahan sumber, permission dan formula dilakukan pada tahap terkait setelah aturan yang belum jelas disepakati.
# Catatan sumber Tahap 4

Penambahan tabel md_* hanya menyediakan master referensi. Tidak mengaktifkan widget DN/sewa/invoice/piutang/stok/Petty Cash; sumber transaksi tersebut tetap belum tersedia, tanpa angka pengganti. Owner sekarang memiliki branches.view untuk membaca master cabang; widget cabang fondasi existing muncul mengikuti permission dan scope nyata. Suite dashboard diulang: 724 browser serta pemeriksaan integrasi sumber/filter lulus. Layout/definisi KPI bisnis tidak diubah berdasarkan asumsi.


## Catatan Tahap 5 parsial

Tabel dokumen DN/Manifest tidak mengesahkan state machine perjalanan. Adapter/metrik operasional masih belum diaktifkan karena Q03 diblokir. Metadata pending mencatat adapter yang belum ada selain tabel yang belum ada; tabel exp_manifests saja tidak cukup untuk menyajikan status perjalanan, penerimaan atau SLA. Dashboard administrasi/regresi dipertahankan dan tautan aksi menggunakan registry route nyata. Tidak menyajikan angka simulasi.

## Baseline operasional Tahap 5 disetujui

Blokir Q03/alur klaim Q09 sebelumnya telah digantikan mandat baseline sementara pengguna. Enam route Trucking nyata terintegrasi lewat registry/action links. Dashboard fondasi dan agregasi bisnis yang belum mempunyai adapter tetap dipertahankan; tidak membuat angka simulasi, widget invoice atau kompensasi klaim. Regresi dashboard tetap dijalankan, bukan mengandalkan kelulusan historis.

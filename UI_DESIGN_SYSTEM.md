# Design system dan navigasi v2 — spesifikasi audit

Tahap 2 sudah mengimplementasikan sidebar, drawer, bottom nav, header profil dan komponen reusable pada halaman fondasi. Tahap 3 menambahkan dashboard per role dengan KPI administrasi nyata dan status Belum tersedia untuk sumber bisnis yang belum ada; detail di PHASE3_REPORT.md/DASHBOARD_WIDGETS.md. Dasar identitas: AGENTS.md, DECISIONS.md dan public/assets/theme.css proyek lama; perilaku target mengikuti master prompt terbaru. Hasil navigasi di PHASE2_REPORT.md, ketersediaan v2 di NAVIGATION_BACKLOG.md. Tabel kondisi sumber lama di bawah merupakan hasil audit historis, bukan klaim modul tersebut tersedia di v2.

## Identitas

| Token | Nilai | Fungsi |
|---|---|---|
| Navy | #073B78 | Sidebar/identitas |
| Biru | #087CCB | Aksi/menu aktif |
| Cyan | #26B9EC | Aksen terbatas |
| Surface | #FFFFFF | Permukaan |
| Background | #F4F7FB | Latar |
| Ink | #182B43 | Teks |
| Muted | #52657C | Teks sekunder |
| Danger | #D92F47 | Galat/aksi destruktif |

Logo resmi sumber: `D:/xampp/htdocs/hlstransport/public/assets/images/logo.png`; ukuran 2170 × 725. Salinan identik tersedia pada `public/assets/images/logo.png` v2 sesuai instruksi tindak lanjut Tahap 1. Gunakan PNG utuh dengan width responsif, height auto, object-fit contain; jangan memotong/mewarnai/mengubah proporsi dan jangan menambah kotak putih. Bentuk kartu, tipografi dan kepadatan dasar lama dipertahankan, dengan perbaikan navigasi sesuai instruksi. UI berbahasa Indonesia, tanggal WITA; nilai input/snapshot tidak diubah oleh format teks baca.

## Struktur navigasi target dan backlog

Daftar berikut merupakan rancangan informasi lengkap. Hanya Dashboard, Cabang, Pengguna, Role & Hak Akses serta Audit Log tersedia di v2 Tahap 2; item lain tidak dirender.

| Kelompok | Submenu target | Kondisi sumber lama/gap |
|---|---|---|
| Dashboard | Langsung tanpa submenu | Root masih Ringkasan; dispatch per role perlu dirancang |
| Trucking | Delivery Note (DN), Manifest, Transit, Penerimaan, Klaim, Tracking | Ada modul; Klaim masih pada penerimaan |
| Equipment | Unit Alat Berat, Kontrak Sewa, Berita Acara, Timesheet, Verifikasi Timesheet | BAP pada kontrak; verifikasi pada timesheet |
| Keuangan | Invoice Trucking, Invoice Equipment, Pembayaran, Piutang, Pengeluaran, Petty Cash | Pembayaran masih aksi invoice; draft belum teruji khusus |
| Gudang & Inventori | Barang Masuk, Barang Keluar, Stok Barang, Transfer Stok, Pemakaian Barang, Stock Opname | Transaksi sebagian berada di daftar mutasi bersama |
| Master Data | Cabang, Customer, Pengirim & Penerima, Lokasi & Rute, Tarif Trucking, Tarif Equipment, Kendaraan & Unit, Driver & Operator, Barang & Kategori, Supplier | Sebagian master gabung; truk/driver terpisah belum ada; kontak lama bukan otomatis skema pihak final |
| Laporan | Trucking, Equipment, Keuangan, Gudang, Petty Cash, Laba Rugi | Laporan operasional tersedia; laba rugi akuntansi backlog aturan bisnis |
| Pengaturan | Pengguna, Role & Hak Akses, Audit Log | Role saat ini baca-saja; editor tidak diasumsikan |

Tambah/Edit/Detail/Hapus/Simpan/Cetak/Filter adalah aksi, tidak menjadi submenu. Menu yang belum berfungsi tidak dirender sebagai tautan. Tahap 2 hanya mengekspos fungsi fondasi yang benar-benar ada; menu lain tetap dalam backlog dokumen ini.

## Konfigurasi bersama

Satu registry server-side dengan id, label, route, SVG, permission baca, ketentuan cakupan, grup dan prioritas shortcut per role. Registry yang sama menghasilkan sidebar, drawer dan bottom nav. Permission aksi diperiksa lagi di endpoint/service; menyembunyikan menu tidak memberi keamanan. Jangan memberi semua role izin baca demi menampilkan menu. Status aktif memakai id route/tab/divisi yang konsisten; submenu berlabel berbeda tidak dibuat aktif ganda karena URL sama.

Desktop: sidebar kiri bergulir, logo, Dashboard langsung dan accordion; header kanan notifikasi/profil. Mobile: satu hamburger kiri atas, logo, notifikasi, profil; drawer bertombol X, overlay/Escape menutup. Kembalikan fokus ke pemicu, cegah fokus ke drawer tersembunyi, kelola fokus dan aria-expanded/controls. Header tidak terpotong pada 320px.

Bottom nav maksimal lima shortcut operasional sesuai permission/role; tidak ada Menu/hamburger/Profil. Tinggi dasar 60–64px ditambah safe-area, SVG 20–22px, label 10–11px. Warna membedakan aktif tanpa perubahan ukuran font. Sisakan padding konten agar aksi terakhir tetap terjangkau.

## Komponen dan keadaan

Tabel dengan gulir lokal, kartu mobile bila sesuai, filter/pagination, label field/error, tombol utama/sekunder/destruktif, badge status dengan teks, empty state berbasis hasil query, pesan gagal dan konflik versi. Form menampilkan kesalahan tanpa kehilangan input aman; nominal kosong tidak diubah menjadi nol. Tidak ada banner selamat datang/motivasi, kartu pengantar atau dekorasi besar. Tidak menampilkan angka dummy, indikator notifikasi palsu atau ringkasan finansial rekaan.

## Dashboard per role

| Role | Fokus data setelah modul tersedia |
|---|---|
| Owner | DN, manifest, equipment, invoice, pembayaran, piutang, pengeluaran; filter cabang/periode |
| Administrator | Pengguna, cabang, audit |
| Admin Pengirim | DN/aktivitas kirim, draft sesuai izin |
| Admin Transit | Manifest/transit |
| Admin Penerima | Penerimaan/klaim |
| Admin Sewa | Kontrak/timesheet |
| Operator | Timesheet milik sendiri/status verifikasi |
| Finance | Invoice/pembayaran/piutang/pengeluaran |
| Gudang | Stok/transaksi barang |

Semua angka dari query database dan cakupan akun. Pada fondasi jangan mengisi KPI bisnis sebelum modul ada. Role tanpa modul tersedia memperoleh penjelasan akses yang jujur, bukan halaman operasional dummy. Istilah Operator pada prompt dipetakan ke Operator Alat Berat lama setelah pengecekan matriks, tanpa role duplikat otomatis.

Realisasi Tahap 3: satu direct route Dashboard untuk semua role dengan fokus dari principal DB. KPI grid empat kolom desktop/dua kolom mobile, section dua kolom desktop/satu mobile dan tabel dengan scroll lokal. Filter cabang tersedia sesuai penetapan, periode hanya untuk audit yang diizinkan. Posisi header/hamburger/logo/profil dan bottom nav tidak diubah. Grafik bisnis belum digambar karena belum ada sumber yang sah. Seluruh sepuluh role diuji pada lima viewport.

## Gerbang uji Tahap 2

Viewport wajib: 320×640, 375×812, 402×874, 768×1024, 1366×768. Tahap 2 sudah menguji kelimanya: Dashboard langsung, hamburger kiri, X/overlay/Escape, Tab/Shift+Tab/fokus, profil, ukuran bottom nav dan ruang konten, tidak ada overflow halaman, menu aktif, logo utuh dan navigasi antarhalaman. Notifikasi tidak dirender karena belum ada sumber. Permission negatif diuji pada backend/URL/POST selain screenshot. Browser navigasi/komponen: 236 assertion lulus; rincian di PHASE2_REPORT.md. Safe-area fisik/Safari belum diuji.
# Implementasi Master Data Tahap 4

Sepuluh submenu master membuka route nyata; tab membagi 15 entity dengan izin backend masing-masing. Daftar memiliki toolbar Tambah, search/status/cabang relevan, tabel responsif dan pagination. Tambah/edit/detail adalah halaman terpisah; formulir dibatasi lebar, mobile satu kolom, label/error/cancel jelas. Status nonaktif/aktif kembali memakai konfirmasi dan POST CSRF, tanpa hard delete.

Warna/logo resmi dan posisi header/sidebar/drawer/bottom navigation Tahap 2 dipertahankan. CSS tambahan lokal di foundation.css. Owner/master operasional mendapat menu sesuai grant nyata, tanpa menu transaksi dummy. Browser lima viewport 320/375/402/768/1366 menguji overflow dan tombol simpan pada akhir scroll agar bebas bottom navigation; screenshot di PHASE4_REPORT.md. Tidak mengklaim pengujian Safari/perangkat fisik.


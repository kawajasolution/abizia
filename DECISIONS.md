# Keputusan v2

## 24 Oktober 2026 — M5 Timesheet dan Verifikasi

Mandat terbaru mengizinkan M5 saja. G01–G12 tetap baseline sementara, bukan SOP perusahaan. Tidak mengubah lifecycle M4, keputusan Trucking/Finance, atau memulai M6/M7.

Klarifikasi pengguna M5: penugasan operator CONFIRMED yang sah dapat dipakai timesheet saat unit telah ACTIVE dan interval berada dalam jadwal, tanpa mengubah status/actual_start operator. work_date adalah tanggal mulai interval pertama WITA; awal interval lain pada tanggal itu atau hari berikutnya. Root pertama maupun perubahan/revisi setelah unit/kontrak terminal memerlukan equipment.timesheet.revise_terminal dan alasan; interval tetap dibatasi penggunaan aktual dan jadwal historis. Tidak menyemai grant C.

Konsekuensi M4–M5 disetujui pengguna: timesheet yang sudah dibuat ketika penugasan masih sah dapat diverifikasi/direvisi dari snapshot historis setelah RETURN M4 membatalkan penugasan CONFIRMED. Root pertama untuk penugasan CANCELLED ditolak. Draft lama yang dikirim tanpa mengedit fakta bukan revisi terminal; submit/approve memeriksa kembali batas aktual/hash. Perubahan atau revisi baru terminal tetap khusus. Snapshot baru mencatat kebutuhan permission terminal; tidak mengganti snapshot/fakta pada revisi lama.

APPROVED immutable; root/revisi author disimpan terpisah, reviewer dilarang sama dengan salah satunya. Pending revision tidak mengganti approved efektif hingga APPROVED baru commit. RETURNED/REJECTED wajib alasan dan perbaikan berupa row revisi baru. Reset/penggantian HM dan koreksi fakta BA tetap BLOCKED sampai prosedur khusus disetujui. Hasil aktual: PHASE6_M5_REPORT.md.

## 24 Oktober 2026 — M4 Berita Acara Equipment

Mandat terbaru mengizinkan M4 saja. G01–G12 tetap baseline sementara V2, bukan SOP final perusahaan. Tidak mengubah Trucking/Finance atau memulai M5–M7.

Jawaban pengguna untuk M4: bukti opsional JPEG/PNG/PDF maksimal 5 MB per file, privat, tanpa penghapusan lewat aplikasi. HANDOVER hanya mengaktifkan operator CONFIRMED yang intervalnya mencakup kejadian aktual; penugasan mendatang tetap CONFIRMED dan tidak aktif otomatis karena waktu berjalan. RETURN menutup operator ACTIVE dan membatalkan penugasan yang belum dimulai dengan histori. Petugas memilih NORMAL/EARLY; EARLY wajib alasan dan equipment.contract.terminate. Header hanya terminal setelah semua detail/penugasan selesai, TERMINATED jika terdapat EARLY.

Koreksi administratif adalah addendum terhubung: hanya catatan administratif baru, seluruh unit/tanggal/kondisi/HM/snapshot disalin tanpa mengubah sumber atau mengulang efek lifecycle. equipment.handover.correct tetap tanpa grant otomatis. Koreksi fakta operasional, reversal lifecycle dan reset/penggantian HM **BLOCKED** sampai prosedur khusus disetujui; tidak dibuat jalur bypass. Recovery master nonaktif memerlukan equipment.recovery.close, alasan dan audit; grant tetap deny secara default.

Penerapan dan hasil aktual M4: PHASE6_M4_REPORT.md. Bagian M1–M3 berikut merupakan riwayat batas mandat saat itu.

## 24 Oktober 2026 — izin M3 Kontrak Sewa multi-unit

Mandat pengguna mengizinkan kontrak/reservasi/backend dan UI Kontrak Sewa saja. Batas sebelumnya M1–M2 digantikan untuk M3; M4–M7 belum diizinkan. G01–G12 tetap baseline sementara, belum SOP resmi. Tidak mengubah keputusan Trucking/Finance.

No self-approval lintas cabang ditegaskan mandat M3: pemohon tidak menjadi approver, dua pihak memakai akun berbeda dengan scope/permission kini; global tidak bypass. Grant C tidak disemai. Portal approval ditolak secara default sampai penugasan eksplisit. Tidak membuat akun/grant palsu pada development.

Implementasi teknis: staging detail/operator/periode setelah confirm belum mengikat sampai dikonfirmasi/diterapkan secara atomik; extension dan pergantian jadwal menyimpan record lama. Penomoran KS hanya saat confirm header, tahun WITA saat penerbitan, kode cabang terkunci sesudah KS pertama tanpa mengubah DN/MF. Semua aksi M3 diaudit bersama event/idempotency/sequence. Detail keputusan dan hasil uji: PHASE6_M3_REPORT.md; tidak melanjutkan BA/timesheet/keuangan/deployment.

## 24 Oktober 2026 — G01–G12 dan izin terbatas M1–M2 Equipment

Pengguna mengesahkan seluruh G01–G12 pada mandat Equipment sebagai baseline sementara V2, belum SOP perusahaan. Register lengkap disalin pada EQUIPMENT_DESIGN.md; transisi tersusun pada EQUIPMENT_STATE_MACHINE.md. Persetujuan hanya M1 gate T1–5 dan M2 skema/permission aditif. M3–M7 memerlukan mandat baru; tidak ada izin workflow/route/lima halaman Equipment, Finance atau deployment.

Jawaban klarifikasi grant: **“Jangan seed grant C; definisi permission saja.”** Katalog 43 kode, grant Y/O saja: Administrator 26, Admin Sewa 22, Operator Alat Berat 10 own, Owner 6 baca; role lain 0 Equipment. C pada semua role tetap deny. Tidak ada bypass dua akun lintas cabang, self-approval atau scope. Tidak membuat role/akun Manager/dummy.

Keputusan teknis turunan M2: 16 tabel eq_* memakai master existing; tambahan eq_meter_corrections memisahkan reset/replacement HM dan bukti dari reading normal. FK komposit menjaga parent/root; generated unique menjaga satu detail aktif per kontrak/unit, root WITHOUT dan satu pending revisi. SQL/MariaDB tidak menyediakan exclusion constraint kalender; overlap/transisi/immutable/pointer eligible tetap pekerjaan service M3–M5. DDL dijournal/ditandatangani hash dan fingerprint; gagal parsial tidak dianggap lengkap, drift/objek asing berhenti tanpa DROP/reset. Hasil aktual dan batas recovery di PHASE6_M1_M2_REPORT.md.

Penomoran Equipment runtime dan perluasan lock kode cabang Equipment baru pada M3–M4; M2 hanya menyiapkan counter terpisah. Generator/keputusan DN/MF/Q03/Q04/Q09 tetap. Tidak mengubah proyek/database lama, tidak mengakses database lama atau hosting.

## Keputusan terbaru — Tahap 5 dilanjutkan dengan baseline sementara

Pengguna mengesahkan model logistik umum untuk Q03/Q04/Q09 pada 24 Oktober 2026, untuk implementasi V2 dan validasi Manager, **bukan SOP resmi perusahaan**. Blokir Q03/Q04/alur klaim operasional sebelumnya telah digantikan oleh mandat ini. Tidak mengubah aturan Finance terkunci atau memulai Tahap 6.

Tabel transisi ditulis terlebih dahulu di TRUCKING_STATE_MACHINE.md. Manifest trip-based memiliki leg eksplisit dari master, tujuan DN dapat berbeda jika pada lintasan; kendaraan tiba, DN tiba, penurunan dan penerimaan adalah peristiwa terpisah. Pergantian kendaraan menyimpan sumber/tujuan/alasan/aktor/waktu dengan Manifest baru. Nomor resmi terpisah dari identifier internal, diterbitkan tepat saat konfirmasi melalui sequence terkunci per jenis/cabang/tahun. Nomor issued tidak berubah/dipakai ulang.

Klaim memakai REPORTED/REVIEWING/APPROVED/REJECTED/CLOSED dengan histori, permission, bukti privat dan tanpa efek Finance. Klarifikasi pengguna: penerimaan hanya utuh; selisih menjadi klaim, bukti boleh menyusul, CANCELLED sebelum berangkat diperbolehkan setelah kosong dengan alasan/histori/nomor tetap. Penetapan kendaraan/driver draf dapat dikoreksi sebelum konfirmasi; setelah itu ganti kendaraan melalui Manifest baru.

Migration 004_trucking_operations aditif mempertahankan seluruh tabel/dokumen/identifier/histori 001–003; tidak reset development. Schema baru tidak membuat fin_* atau generator INV aktif. Format INV yang disetujui hanya menjadi ketentuan untuk implementasi Finance saat ISSUED pada mandat berikutnya.

Grant enam permission tambahan tersimpan eksplisit di database: konfirmasi DN, transit, penerimaan, baca/lapor/review klaim. Administrator memproses review/keputusan klaim sementara; Owner baca; petugas operasional mengikuti cabang aktif dan penetapan efektif. Tautan tidak memberikan kewenangan. Bukti JPEG/PNG/PDF maksimal 5 MB disimpan privat, immutable, hash dan download terotorisasi; batas teknis bukan ketentuan kompensasi.

Hasil aktual/finalisasi dicatat di PHASE5_REPORT.md. Tidak ada hosting, perubahan database/proyek lama, transaksi keuangan baru atau Tahap 6.

## 24 Oktober 2026 — Tahap 3 dashboard sesuai role

- Instruksi pengguna mengizinkan dashboard dengan sumber yang sudah tersedia dan status eksplisit untuk sumber hilang. Gerbang Tahap 1–2 lulus sebelum implementasi; tidak ada perubahan grant/migration atau implementasi transaksi bisnis.
- GET / tetap satu route dengan foundation.view; dispatch ke DashboardController. Role berasal dari principal DB, bukan query parameter. Nama Operator memakai role seed Operator Alat Berat tanpa role duplikat.
- Permission sumber dicek di service/repository, terpisah dari fokus tampilan role. Pengguna/role/audit global tetap memerlukan izin dan all_branches. Owner global tidak memperoleh akses tambahan otomatis.
- KPI administrasi saat ini dihitung dari users/branches/roles/permissions, bukan data dummy. Akun global termasuk pengguna yang dapat mengakses cabang terpilih, dihitung sekali. Distribusi role harus merekonsiliasi pengguna aktif.
- Filter periode hanya untuk audit global, dua batas hari inklusif WITA. KPI/role/permission bukan saldo historis; UI menjelaskan cakupan filter. Audit per cabang belum punya metadata transaksi yang dapat dipastikan, sehingga dipilih cabang tertentu berarti menyembunyikan audit, bukan menebak dari aktor/JSON.
- Semua sumber bisnis belum ada pada v2: status Belum tersedia tanpa angka/graph/CTA palsu. Metadata tabel diperiksa hanya pada DB v2, dan adapter bisnis tidak otomatis diaktifkan hanya karena nama tabel kelak ada. SLA tertunda, kontrak mendekati akhir, penyelesaian klaim, stok minimum dan formula keuangan tidak diasumsikan.
- Snapshot pembacaan dipakai untuk query dashboard; navigasi, logo, header dan bottom nav Tahap 2 dipertahankan. Definisi dan hasil aktual ada di DASHBOARD_WIDGETS.md/PHASE3_REPORT.md. Berhenti sebelum Tahap 4.

## Tahap 2 — UI design system dan navigasi disetujui

- Instruksi lampiran Tahap 2 mengizinkan navigasi global/komponen UI pada fondasi saja. Gate Tahap 1 dijalankan ulang dan lulus sebelum perubahan; tidak memulai Tahap 3 atau modul bisnis.
- Satu registry app/navigation.php dipakai oleh sidebar/drawer (partial sama) dan bottom nav. Metadata 38 item backlog tidak menjadi link; lima item nyata mengikuti route GET, permission dan cakupan.
- Dashboard langsung menggunakan route `/` yang sudah ada, menampilkan data akses akun. Nama menu/heading menjadi Dashboard tanpa agregasi bisnis atau halaman perantara.
- Breakpoint desktop 1024px; 768px memakai layout tablet dengan drawer/shortcut. Bottom nav dasar 64px + safe-area, SVG 21px, label 10px tanpa pembesaran aktif. Shortcut Pengaturan admin menuju `/roles` nyata.
- Profil berfungsi lewat identitas akun dan logout POST. Tidak membuat tombol notifikasi sampai event/data/penerima/status baca tersedia. Semua grant/cakupan lama tetap.
- Menggunakan komponen reusable pada halaman nyata. Pagination fondasi 10 catatan setelah scope; audit tetap 100 terbaru. List pengguna ID terbaru. Error form mempertahankan isian allowlist, tidak pernah password. Konfirmasi diterapkan pada edit pengguna/cabang; tidak menambahkan persetujuan bisnis baru.
- Fokus drawer memfilter submenu accordion tertutup; X, overlay, Escape, pilih menu dan pergantian breakpoint mengembalikan keadaan layout. Form loading diuji lewat observasi DOM sebelum navigasi, tidak memberi delay aplikasi.
- Hasil akhir dan keterbatasan tercatat di PHASE2_REPORT.md. Tidak mengubah route bisnis, migration, database lama atau hosting. Tahap 3 menunggu persetujuan.

## 23 Oktober 2026 — Tahap 0

- Otorisasi saat ini hanya audit/dokumentasi; implementasi aplikasi baru menunggu persetujuan pengguna.
- Proyek lama dan database lama tidak diubah, hosting tidak diakses. Tidak menjalankan suite lama karena menulis fixture/artefak; hanya membaca hasil historis.
- Gunakan keputusan bisnis terbaru terdokumentasi sebagai dasar; konfigurasi demo tidak otomatis menjadi SOP perusahaan.
- Pertahankan kontrak Equipment; definisi RA belum disetujui. Jangan membuat perhitungan finansial baru.
- Navigasi mengikuti master prompt terbaru: Dashboard langsung, satu konfigurasi, SVG dan shortcut berbasis izin; logo resmi tanpa kotak putih tambahan.
- Database hls_v2_dev, struktur fondasi dan tahapan pada IMPLEMENTATION_PLAN.md merupakan usulan teknis, belum diimplementasikan.
- A01–A10 dicatat sebagai temuan statis. Q01–Q11 tetap pertanyaan terbuka, bukan keputusan yang telah disetujui.

## 23 Oktober 2026 — Tahap 1 disetujui dan dilaksanakan

- Pengguna menyetujui audit dan secara eksplisit mengizinkan fondasi saja. Berhenti setelah Tahap 1; navigasi lengkap dan modul bisnis tidak dibangun.
- Database `hls_v2_dev` benar-benar dibuat baru pada MariaDB 10.4.32. Akun aplikasi khusus `hls_v2_app` dengan password acak hanya memiliki grant pada DB baru. Tidak membaca credential/database lama.
- Migration fondasi baru 001 berisi sembilan tabel. Seed hanya sepuluh role/tujuh permission, tanpa pengguna/cabang/password. Semua role memiliki foundation.view; hanya Administrator mendapat permission pengelolaan fondasi. Ini matriks teknis fondasi, bukan keputusan akses bisnis Q05.
- users/roles/audit memerlukan permission dan cakupan seluruh cabang; branches dibatasi cabang. Membuat cabang perlu cakupan global. all_branches tidak memberikan permission aksi. Pengelolaan diri sendiri ditolak; minimal satu administrator global aktif dipertahankan.
- Route deklaratif dipisahkan dari controller; service mengulang validasi izin untuk mutasi. Repository hanya akses data, audit dan perubahan master atomik. Tidak menyalin service bisnis lama.
- Login gagal maksimal lima per email ATAU IP dalam 15 menit; hash email/IP disimpan untuk limiter. Advisory lock per identitas/IP menserialisasi pemeriksaan dan pencatatan. Login sukses tidak menghapus kegagalan. Audit tidak menyimpan password/hash/token atau payload sesi.
- Sesi file privat khusus aplikasi, strict mode, HttpOnly/SameSite=Lax, ID regenerasi, idle 30 menit; perubahan user menaikkan auth_version dan membatalkan sesi lama. Tidak ada remember-me.
- Bootstrap admin hanya CLI saat users kosong, password input tersembunyi/STDIN, tanpa default. Database development sengaja masih tanpa akun hingga pemilik memilih credential sendiri; bootstrap telah diuji pada DB disposable.
- UI minimum menggunakan form/tabel/link nyata, tidak mengimplementasikan sidebar/bottom nav atau dashboard bisnis. Tabel lebar memakai scroll lokal. Tidak menampilkan profil/notifikasi yang belum memiliki endpoint.
- Tes awal menemukan session path XAMPP tidak writable dalam sandbox dan label select Role ambigu; keduanya diperbaiki. Chromium memerlukan izin proses di luar sandbox; run akhir benar-benar berjalan dan lulus. Tidak menganggap kegagalan awal sebagai hasil akhir.
- Tidak mengklaim kompatibilitas MySQL 8, HTTPS/TLS nyata atau kesiapan produksi. Detail dan hasil akhir di PHASE1_REPORT.md.

## Penegasan instruksi Tahap 1

- Instruksi terbaru secara eksplisit meminta logo resmi pada halaman minimum. Logo sumber PNG disalin identik (SHA-256 sama), digunakan pada header dengan ukuran proporsional tanpa background/border/padding kotak logo; header memakai surface putih aplikasi.
- Tidak membuat ulang database development atau mengisi akun default. Regresi memakai DB disposable v2, tanpa akses database lama.
- Menambahkan CPANEL_PREPARATION.md. Struktur tetap public/private; dukungan prefix DB cPanel, bootstrap hosting tanpa SSH dan pengujian staging adalah pekerjaan deployment yang belum diotorisasi/dikerjakan. Tidak mengklaim paket siap hosting.
# Keputusan Tahap 4 — 24 Oktober 2026

Mandat terbaru menetapkan Tahap 4 hanya Master Data Management, menggantikan usulan lama yang menggabungkan master dan transaksi Trucking. Tahap 5 belum diotorisasi. Desain sebelum migration: MASTER_DATA_DESIGN.md; hasil: PHASE4_REPORT.md.

- Memakai kembali branches dan menambah 12 tabel md_* melalui migration 002 aditif. Tidak reset, menyalin data atau mengakses database lama.
- Customer bersama lintas divisi; pihak kirim/terima satu identitas dengan peran, bukan daftar duplikat. Kendaraan/unit dan driver/operator masing-masing memakai tabel berjenis, dengan permission tab terpisah.
- Katalog barang/kategori/satuan global bersama, tanpa saldo cabang; mutasi memerlukan all_branches. Master operasional dimiliki cabang; rute memerlukan akses kedua endpoint. Kepemilikan cabang tidak dipindah melalui edit.
- Administrator menulis sesuai permission/cakupan; Owner baca semua master sesuai cakupan. Role operasional hanya baca referensi yang relevan; tidak memberi hak write secara asumsi. Grant eksplisit tersimpan di DB, tanpa bypass nama role. Total 53 permission.
- Tidak ada hard delete. FK RESTRICT, version/lock, penolakan relasi baru ke parent nonaktif dan audit atomik melindungi histori. Referensi tertentu yang sudah dipakai tidak diganti diam-diam. Tidak mengklaim integritas modul transaksi yang belum dibuat.
- Tarif manual nullable, kosong berbeda dari nol, dua desimal tanpa float/pembulatan. Trucking reguler/carter/pickup; Equipment jam/shift/bulan. Tarif harian dan rumus/overtime/prorata belum disetujui dan tidak diimplementasikan.
- Akun personel opsional tidak membuat login/grant; nama berasal dari akun tertaut, tidak menyalin password. Akun harus aktif dan memiliki cakupan cabang terkait.
- Layout global Tahap 2 dipertahankan. Owner kini memperoleh KPI cabang nyata karena branches.view, sesuai pemeriksaan permission dashboard existing. Master tidak mengaktifkan widget transaksi atau angka stok/tagihan palsu.


## Riwayat Tahap 5 — keputusan sebelum baseline sementara

- Pengguna memastikan DN dan Manifest termasuk cakupan mandat awal meskipun bagian L lanjutan menyebut empat modul lainnya.
- Jawaban final untuk gerbang Q03 saat ini: "Belum final; blokir transisi yang bergantung Q03". Tidak mengesahkan workflow demo menjadi SOP V2. Transit/penerimaan/penyelesaian/pemindahan keanggotaan tetap blocked.
- Bagian independen: DN created satu deskripsi barang; Manifest draft; batch DN dengan rute persis sama, tanpa perpindahan barang; histori dan Tracking internal. Tidak mengubah created/draft hanya karena masuk manifest.
- Q04 tetap terbuka; identifier internal 128 bit acak/unique/immutable, tanpa penomoran resmi rekaan. Q09 penanganan klaim tetap terbuka; tidak menambah state approval/resolved atau transaksi keuangan. Klaim operasional menunggu sumber penerimaan sah.
- Empat grant ekspedisi aditif mengikuti matriks di PHASE5_REPORT; tidak memberi Customer tracking publik atau bypass berdasarkan nama role. Akses read asal/tujuan aktif; write cabang asal aktif. Pilihan pihak tujuan hanya dalam konteks rute DN, bukan pelebaran menu master.
- Tahap 5 belum selesai karena dependensi. Tidak melanjutkan tahap berikutnya/hosting.

Klarifikasi penomoran tambahan pengguna: kode cabang dikunci setelah nomor resmi pertama agar kode lama tidak menjadi namespace cabang baru; nama, alamat dan kontak tetap dapat diubah. Validasi server-side berbagi lock cabang dengan allocator nomor.

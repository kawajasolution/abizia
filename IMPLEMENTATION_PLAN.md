# Rencana implementasi bertahap

Status 24 Oktober 2026: Tahap 1–4 dipertahankan. Pengguna menyetujui baseline sementara Q03/Q04/alur klaim Q09 untuk menyelesaikan Tahap 5; bukan SOP resmi perusahaan. Tahap 6 belum dimulai.

## Tahap 1 — fondasi terisolasi (selesai dalam lingkup)

1. Tetapkan struktur PHP native 8.2+: public/index.php dan aset publik; app untuk controller/service/repository/middleware/view; config privat di luar public root; database/migrations, tests dan storage privat. Larang akses HTTP source, SQL, log dan konfigurasi.
2. Buat konfigurasi lokal dari contoh tanpa rahasia; verifikasi PHP/extensions dan versi DB aktual; gunakan database development baru `hls_v2_dev` serta akun khusus, tanpa membaca/mengubah database lama. Installer menolak target lama.
3. Buat migration fondasi pada DATABASE_DESIGN.md dan bootstrap admin eksplisit tanpa password default. Pertahankan nama role terdokumentasi, matriks deny-by-default; tidak memberi akses global berdasarkan nama role.
4. Implementasikan routing eksplisit, login/logout, hashing, regenerasi sesi, idle timeout, cookie HttpOnly/SameSite/Secure sesuai HTTPS, CSRF semua mutasi, validasi, prepared PDO, escaping, rate limit dan error handling tanpa bocoran.
5. Implementasikan RBAC per aksi dan cakupan cabang, pengguna/cabang serta audit atomik sesuai lingkup fondasi. Tentukan batas admin global dan penonaktifan tanpa menghapus histori. Tidak membangun editor role dinamis tanpa keputusan.
6. Sediakan halaman login/fondasi fungsional minimum agar dapat diuji. Design system/navigasi lengkap tetap Tahap 2; dashboard bisnis tetap Tahap 3/modul terkait.
7. Perbarui README, DECISIONS, PROGRESS, CHANGELOG dengan hasil aktual, perintah verifikasi dan kekurangan. Berikan laporan untuk review sebelum tahap berikutnya.

Kriteria selesai: fresh install ke DB baru berhasil; DSN lama ditolak; login benar/salah/rate-limit/logout/session expiry/nonaktif diuji; CSRF hilang/salah dan akses cabang/aksi tak berizin ditolak; audit gagal me-rollback mutasi master; source/SQL/config tidak dapat dibaca HTTP. Semua PHP baru lulus lint; suite otomatis pada DB uji v2 lulus; browser login/master desktop/mobile benar-benar dijalankan bila tersedia, atau batasnya dicatat tanpa klaim lulus. Tidak menyalin akun/transaksi/password dari proyek lama.

## Tahap 2 — design system dan navigasi global (selesai dalam lingkup)

Implementasi UI_DESIGN_SYSTEM.md, registry tunggal, drawer/sidebar/bottom nav, logo resmi dan komponen bersama. Hanya route nyata ditampilkan. Lulus lima viewport wajib, akses keyboard, penutupan overlay/X/Escape dan matriks permission sebelum modul bisnis. Profil/ganti password perlu endpoint nyata jika ditampilkan. Notifikasi kosong harus jujur; event aktif menunggu Q11.

## Tahap 3 — dashboard berdasarkan role (selesai dalam cakupan sumber tersedia)

Bangun dispatch langsung dan query terbatasi cabang. Data fondasi dapat disajikan segera; agregasi DN/finance/stok dilengkapi saat modulnya tersedia. Jangan menjadikan angka nol sebagai pengganti modul yang belum dibangun. Gunakan empty state yang membedakan belum ada data dan fitur belum tersedia.

## Tahap 4 — Master Data Management (selesai dalam lingkup)

Sepuluh submenu/15 entity master, migration aditif 002, CRUD tanpa hard delete, pencarian/filter/pagination, permission per aksi/tab, scope cabang, audit atomik dan regresi lima viewport. Desain: MASTER_DATA_DESIGN.md; hasil aktual: PHASE4_REPORT.md. Tidak memasukkan transaksi DN, sewa, invoice/pembayaran, stok atau Petty Cash.

## Tahap 5 — Trucking / Ekspedisi, baseline sementara disetujui

Enam modul DN/Manifest trip-based/Transit/Penerimaan/Klaim/Tracking internal. Migration 004 aditif mempertahankan dokumen/histori 003; sequence DN/MF saat konfirmasi, invoice hanya ketentuan masa depan. State machine sebelum implementasi: TRUCKING_STATE_MACHINE.md. Penerimaan utuh, bukti menyusul, CANCELLED sebelum berangkat dan kode cabang terkunci pascapenomoran telah diklarifikasi pengguna. PHASE5_REPORT.md mencatat hasil aktual dan batas verifikasi. Tidak membuat Finance/deployment/Tahap 6.

## Gerbang setiap tahap

Implementasi → PHP lint → tes otomatis relevan → browser desktop/mobile bila tersedia → pemeriksaan permission/cabang positif dan negatif → dokumentasi → laporan hasil/kekurangan. Untuk operasi finansial/stok tambahkan idempotensi, konkurensi, rollback audit dan integritas histori. Jangan menjalankan tes v2 yang menunjuk source/database lama.

Keputusan bisnis belum final ditulis sebelum kode terkait; nilai finansial/SOP tidak diisi berdasarkan asumsi. Tidak ada deployment, migrasi data lama, atau perubahan keputusan terkunci tanpa persetujuan yang sesuai. Kerjakan hanya Tahap 5 sesuai baseline sementara yang telah disetujui, lalu berhenti setelah laporan hasil.

Mandat Tahap 5 mencakup DN/Manifest/Transit/Penerimaan/Klaim/Tracking. Q03/Q04/alur klaim Q09 sudah disetujui sebagai baseline sementara implementasi, bukan SOP resmi perusahaan. Lihat PHASE5_REPORT.md untuk hasil aktual. Tahap berikutnya belum diotorisasi.

Instruksi terbaru mengesahkan baseline sementara, menggantikan catatan blocked/parsial historis. Selesaikan hanya Tahap 5, laporkan pengujian aktual dan berhenti sebelum tahap berikutnya. Validasi Manager sebagai SOP resmi tetap diperlukan.

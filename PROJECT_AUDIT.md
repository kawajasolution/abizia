# Audit proyek HLS lama — Tahap 0

Tanggal: 23 Oktober 2026, WITA. Perusahaan: PT Hanqia Lintas Sarana.
Sumber baca-saja: `D:/xampp/htdocs/hlstransport`. Hasil: `D:/xampp/htdocs/hls-v2`.

## Batas dan metode

Audit statis terhadap dokumen, source PHP/JS/CSS, SQL migration, definisi tes dan artefak hasil tes. Tidak menjalankan aplikasi lama, bootstrap, seed, migration, build, installer, atau suite integrasi/browser. Tidak menghubungkan database, tidak mengakses hosting, tidak menyalin data/credential. Struktur SQL merupakan desain di berkas, bukan verifikasi skema database yang sedang berjalan. Tidak ada aplikasi baru dibuat.

Dokumen dibaca: AGENTS.md, MASTER_BLUEPRINT.md, DECISIONS.md, bagian relevan PROGRESS.md/README.md, NAVIGATION_MAPPING.md dan IMPLEMENTATION_GAP_ANALYSIS.md. Pemeriksaan source mencakup public/index.php, app/bootstrap.php, Access, AuthController, FinanceController/Repository/Service/SourceGuard, ManifestService, TimesheetService, Security, layout, CSS branding/theme dan JS drawer. Inventaris mencakup controller, service, repository, migration dan tes semua modul. Audit ini bukan review setiap baris seluruh aplikasi atau sertifikasi keamanan.

## Kondisi implementasi

| Area | Bukti implementasi lama | Penilaian untuk pembangunan ulang |
|---|---|---|
| Fondasi | bootstrap, front controller, Access, AuthController, Repository | PHP native modular/PDO; routing dan rendering masih banyak terpusat |
| Trucking | ExpeditionController; ShipmentService, ManifestService, TrackingService; migration 002 | DN, manifest multi-DN, transit, penerimaan, klaim deskriptif, tracking tersedia di source |
| Equipment | RentalController; RentalService, TimesheetService, RentalUpload; migration 003 | Unit, kontrak, BAP, timesheet/verifikasi tersedia; RA belum didefinisikan |
| Finance | FinanceController/Service/Query/Repository; migration 004 dan 009 | Invoice, pembayaran/reversal, piutang, expense; draft perlu perbaikan dan tes khusus |
| Gudang | InventoryController/Service/Query/Repository; migration 006 | Katalog, saldo, mutasi, transfer, pemakaian, opname; bukan valuasi persediaan |
| Petty Cash | PettyCashController/Service/Repository; migration 007 | Pengajuan, pencairan, realisasi, pertanggungjawaban, integrasi expense |
| Owner | OwnerController, OwnerReports; migration 008 | Laporan lintas modul; bukan laba rugi akuntansi |
| PWA | manifest/service worker, tes pwa/release | Dokumen membatasi cache pada aset; transaksi online |
| Pengaturan | users/branches/roles/audit di front controller | Role-permission berbasis SQL; halaman role baca-saja, bukan editor |

Keberadaan source tidak berarti seluruh fitur lulus uji pada sesi ini.

## Temuan prioritas

| ID | Dampak | Bukti dan temuan statis | Tindak lanjut v2 |
|---|---|---|---|
| A01 | Tinggi | FinanceService.php:13 createDraft: INSERT memiliki 12 kolom tetapi hanya 11 ekspresi VALUES, 8 placeholder untuk 9 parameter. Placeholder issue_date sebelum literal draft hilang. | Susun ulang statement, tes create draft sampai commit/rollback pada DB baru |
| A02 | Tinggi | FinanceService.php:14,19 submitDraft/transitionDraft tidak demand finance.draft maupun cek pembuat. Endpoint hanya dilindungi finance.view di FinanceController; repository memeriksa cabang. | Izin aksi dan kepemilikan wajib; tes POST langsung oleh pembaca/akun lain dalam cabang |
| A03 | Tinggi | createInvoice memeriksa finance.invoice dan langsung menerbitkan; publishDraft memakai finance.publish. Guard duplikasi createInvoice hanya mencari issued, sementara unique DB baru mencakup draft. | Putuskan apakah penerbitan langsung masih diizinkan; satu otorisasi penerbit yang konsisten, konflik draft ditolak jelas |
| A04 | Sedang | public/index.php menolak route profile sebelum dispatch; layout.php menautkan profile dan profile#password; view profile.php ada | Definisikan endpoint profil/ganti password dan tes akses, jangan menganggap view berarti fitur bekerja |
| A05 | Sedang | app.js:37,41 memakai querySelector data-sidebar-close. Tombol X muncul sebelum overlay pada layout sehingga hanya X mendapat listener | Semua penutup diikat; tes X, overlay, Escape dan pemulihan fokus |
| A06 | Sedang | layout.php mendefinisikan groups dan shortcuts terpisah; Dashboard masih berlabel Ringkasan; sidebar memakai emoji | Satu registry permission/navigasi, Dashboard langsung, SVG konsisten |
| A07 | Sedang | branding.css memberi background putih pada brand-official; app.css bottom nav height 64px termasuk padding safe-area | Ikuti instruksi baru tanpa bidang putih tambahan; tinggi 60–64px ditambah safe-area |
| A08 | Sedang | Submenu manifest/transit/receipts/claim memakai expedition.view; verifikasi memakai rental.view. Label Klaim menuju receipts yang sama | Bedakan izin baca/aksi secara eksplisit; jangan memberi grant baru karena kebutuhan menu |
| A09 | Sedang | Dashboard dasar berjudul Ringkasan sistem; operator diarahkan rental, Owner memakai route owner terpisah; notification selalu teks kosong/dot statis | Dashboard langsung per role/cakupan; notifikasi perlu sumber event, jangan tampilkan indikator rekaan |
| A10 | Sedang | migration 009 DROP CONSTRAINT CONSTRAINT_3 bergantung nama otomatis DB; build paket/SQL instalasi terpisah ada | Migration v2 bernama eksplisit dan uji fresh install; jangan menyalin SQL lama langsung |

A01–A10 adalah temuan source, belum direproduksi di browser/database. A03 memerlukan keputusan bisnis, bukan izin mengubah alur. ManifestService.attach memeriksa posisi dan cabang asal, tetapi tidak terlihat pemeriksaan jalur menuju tujuan akhir DN; definisi kecocokan rute transit harus dipastikan sebelum menerapkan guard lebih ketat.

## Kualitas dan keamanan yang layak dipertahankan

Source menyediakan password_verify, session regeneration/timeout, CSRF global POST, output escaping, CSP/no-store, prepared PDO dan RBAC/cabang. Guard keuangan memakai transaksi, row lock, integer sen, idempotensi dan unique active source. Manifest menjaga histori perpindahan dan satu keanggotaan aktif. Dokumentasi upload menetapkan MIME/decode/re-encode, batas ukuran/piksel, penyimpanan privat dan unduh berotorisasi. Seluruh kontrol ini harus diuji ulang di v2; audit tidak membuktikan ketiadaan celah pada semua endpoint.

## Bukti tes historis dan batasnya

- tests/results/readiness-finance.log berakhir dengan 98 pemeriksaan Finance lulus.
- tests/results/release-ui.json memuat 217 halaman, 868 pemeriksaan, failures/errors kosong; sampel awal lebar 320 dan 390. Ini artefak historis, bukan pengujian viewport baru.
- PROGRESS.md bagian 23 Oktober mencatat integration 27, expedition 64, finance 98; juga menyatakan Playwright workflow draft terhambat spawn EPERM dan suite draft khusus belum lengkap.
- tests/finance.php dan finance.spec.js tidak ditemukan pemanggilan khusus createDraft/submitDraft/publishDraft pada pencarian statis. Kelulusan suite Finance umum tidak membuktikan workflow 009.
- playwright.config.js menulis hasil ke tests/results di proyek lama. Tes integrasi memuat fixture; tidak aman dijalankan dalam mandat audit baca-saja.

Hasil sesi ini: audit statis dan dokumentasi. PHP lint serta browser/permission runtime tidak dijalankan; tidak ada PHP baru untuk di-lint. Database live, MySQL 8, perangkat fisik dan hosting tidak diverifikasi.

## Gerbang

Tahap 0 selesai sebagai audit statis. Tahap 1 hanya setelah pengguna menyetujui hasil dan rencana. Pertanyaan bisnis terdapat di BUSINESS_RULES.md; tidak wajib memutuskan seluruh tarif/SOP untuk mengerjakan fondasi terisolasi setelah persetujuan.

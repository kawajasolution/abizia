# Tahap 6 — M5 Timesheet dan Verifikasi Equipment

24 Oktober 2026, WITA. **M5 selesai dengan catatan: seluruh pengujian akhir pada ruang lingkup implementasi lulus, 0 FAIL. Reset/penggantian HM khusus dan koreksi fakta BA tetap BLOCKED sesuai mandat.** Run akhir selesai **19:01:26 WITA**. G01–G12 tetap baseline sementara V2, bukan SOP final perusahaan. Berhenti pada M5; tidak melanjutkan M6/M7 atau deployment.

## 1. Fitur selesai

| Fitur | Implementasi |
|---|---|
| Root timesheet | Satu seri unit/assignment/tanggal kerja; WITHOUT assignment NULL; WITH assignment sah milik unit; identitas root tidak dipindah lewat edit |
| Scoped dan own | Admin berizin mencatat operator berakun/tanpa akun atau WITHOUT; Operator hanya assignment miliknya berdasarkan ID/account mapping, bukan nama |
| Interval kerja | Beberapa interval datetime WITA [awal,akhir), lintas malam, berdampingan sah, overlap internal ditolak; istirahat integer menit dalam batas durasi |
| Jam kerja bersih | Jumlah selisih detik interval dikurangi break_minutes ×60; integer seconds tanpa rounding tersembunyi, ditampilkan jam:menit:detik; tidak menghitung tarif/biaya |
| Tanggal kerja | Tanggal mulai interval pertama; awal interval lain hari itu/hari berikutnya; tetap dibatasi periode efektif, actual_start/actual_end unit dan jadwal/aktual operator |
| HM normal | Kosong keduanya atau berpasangan, nonnegatif, maksimal tiga desimal, akhir >= awal; HM terpisah dari jam kerja |
| Draft | Create/edit dengan permission backend, optimistic root/revision versions; before/after audit; hanya interval row kerja DRAFT diganti, histori event tetap |
| Submission | DRAFT → SUBMITTED, konten/snapshot/root diikat SHA-256; tidak dapat diedit langsung |
| Keputusan | SUBMITTED → APPROVED/RETURNED/REJECTED; alasan wajib RETURNED/REJECTED; satu keputusan per revision/request |
| No-self | Reviewer berbeda dari pembuat root DAN pembuat revisi, termasuk Administrator; form disembunyikan dan POST/service tetap menolak |
| Revisi | Row baru dari APPROVED/RETURNED/REJECTED dengan previous/base-approved/reason; satu pending DRAFT/SUBMITTED per root; row lama immutable |
| Efektif/pending | Approved lama tetap efektif selama revisi pending/returned/rejected; approved baru memindah pointer efektif dan melepas pending atomik |
| Terminal | Root pertama/edit/revisi terminal memerlukan timesheet.revise_terminal dan alasan; tidak mengaktifkan kembali kontrak/unit/operator |
| Histori M4 | Penugasan CONFIRMED dapat dicatat tanpa aktivasi rekaan; setelah RETURN membatalkannya, root historis sah tetap diproses berdasarkan snapshot; root pertama CANCELLED ditolak |
| Konflik pekerjaan | Saat submit/approve, pekerjaan submitted/approved efektif root lain tidak boleh overlap pada asset/operator sama; DRAFT belum menjadi pekerjaan efektif |
| Antarmuka | Daftar/search/status/tanggal, form interval tambah/hapus, HM, detail/histori revisi, indikator approved efektif/pending, antrean dan detail keputusan; desktop/tablet/mobile |

Timesheet tidak menulis status atau actual_start/actual_end Equipment. WITHOUT tidak membuat personel/akun palsu. Nama operator berakun berasal dari akun tertaut sesuai master existing, lalu dibekukan pada snapshot. Daftar menampilkan revisi terbaru beserta pointer approved efektif secara terpisah; filter status mengacu revisi terbaru, bukan menutupi histori yang ditolak.

## 2. Klarifikasi pengguna yang diterapkan

1. Assignment CONFIRMED yang sah boleh dipakai saat unit ACTIVE dan interval berada dalam jadwal, tanpa mengubah lifecycle/operator actual_start.
2. work_date mengikuti awal interval pertama WITA; awal interval lain pada hari itu atau berikutnya.
3. Pencatatan root pertama maupun revisi setelah terminal wajib permission khusus dan alasan, dengan batas penggunaan aktual/jadwal historis.
4. Root yang dibuat saat assignment sah tetap dapat diverifikasi/direvisi setelah RETURN M4 membuat assignment CANCELLED; root pertama CANCELLED tidak dibuat. Fakta dan histori M4 tidak ditulis ulang.

Submit draft lama tanpa edit bukan pembuatan/revisi fakta terminal. Snapshot menyimpan requires_terminal_permission agar data baru/perubahan terminal tetap diperiksa khusus ketika dikirim. Approval keputusan biasa tidak membuat revisi fakta baru; reviewer tetap memerlukan permission verifikasi/scope dan lolos no-self. Perubahan terminal memakai grant C eksplisit, tidak otomatis diperoleh Administrator.

## 3. Route, permission dan branch scope

| Route | Pemeriksaan |
|---|---|
| GET/POST `/equipment/timesheets` | timesheet.view_scoped; aksi create/update/submit/revise_scoped dalam transaksi; scope cabang kontrak efektif |
| GET/POST `/equipment/my-timesheets` | timesheet.view_own; aksi own; assignment.effective_account_id dan md_personnel.account_id harus sama dengan aktor kini; membership sumber efektif dan cabang kontrak aktif |
| GET/POST `/equipment/verification` | verification.view untuk antrean/detail; verification.decide untuk keputusan, scope kontrak, author root/revisi berbeda dari reviewer |

Own assignment lintas cabang yang telah diotorisasi tidak memberi full contract/customer/sibling access. Scope sumber membuat Operator cabang pemilik dapat mencatat penugasannya tanpa diberi membership seluruh cabang kontrak. Proyeksi own hanya unit/assignment/timesheet terkait; data customer/alamat proyek tidak disertakan. Assignment lintas cabang tetap dibentuk/disahkan melalui M3 dan HANDOVER M4; M5 tidak membuat approval atau mengubah penugasan.

Seluruh POST memakai CSRF. Prepared PDO, input/parent identity/status/jadwal/actual bounds, actor aktif/role/auth_version, grant DB/membership kini diperiksa. Akses object own di luar kewenangan memberi 404; route tanpa grant 403. Relink akun tidak memberikan akses ke histori assignment lama hanya karena nama sama atau account baru tertaut.

**Katalog/grant/role M2 tidak berubah:** 43 permission Equipment, total 106 permission/215 grant/10 role. verification.decide tetap Administrator sel Y; Admin Sewa view/decide verifikasi tetap C/deny. timesheet.revise_terminal, meter.correct, handover.fact_correct dan seluruh C tetap tanpa grant default. Grant positif terminal/cross-approval hanya sementara pada DB disposable, lalu dicabut. Tidak membuat user/grant development.

Registry existing dipakai untuk menu Timesheet, Timesheet Saya dan Verifikasi. Shortcut Admin Sewa menambah Timesheet, Operator menambah Timesheet Saya sesuai permission. Tidak mendesain ulang sidebar/Bottom Navigation atau membangun penyempurnaan UI M6.

## 4. Database, transaksi dan histori

**Tidak ada migration/DDL/tabel/kolom/index/seed baru.** Tetap 48 tabel dan 16 eq_* dari migration 005, fingerprint tetap. Memakai eq_timesheets, eq_timesheet_revisions, eq_timesheet_work_entries, eq_timesheet_verifications, eq_events dan eq_requests existing. eq_meter_corrections tidak ditulis karena prosedur reset/replacement belum ditetapkan.

EquipmentWrite menambah resource_type timesheet tanpa mengubah default contract atau BA. Named lock per request key melindungi first use/replay, lalu transaksi memeriksa actor/grant/cabang, header kontrak, root/revisi, sumber unit/operator dan interval konflik. Versi root/revisi/hash diperiksa sebelum perubahan. Konflik unique/deadlock/timeout mengembalikan 409 dan rollback; retry memakai token yang sama. Lock sumber stabil melindungi pemeriksaan pekerjaan walaupun kalender awal kosong.

Keputusan, status revisi, pointer pending/effective, event, audit dan committed idempotency result commit bersama. CHECK/FK komposit author dan unique pending/verification menjadi pertahanan tambahan. Hash di-recompute dari body yang tersimpan ketika verifikasi; bukan hanya membandingkan hidden field klien. Approved lama/intervalnya tidak diubah ketika approved pengganti diterbitkan. Event memuat kontrak/unit/assignment/root/revisi, actor/branch/request/status dan waktu.

Perubahan DRAFT boleh mengganti row kerja interval, tetapi before/after lengkap tetap di ledger. SUBMITTED/APPROVED tidak memakai jalur edit tersebut. Snapshot historis assignment dahulu CONFIRMED/ACTIVE serta RETURN confirmed diperlukan untuk pengecualian root lama dengan assignment kini CANCELLED. Tidak membuat actual_start/operator atau mereset status M4 sebagai jalan pintas.

Development tidak direset/diisi fixture. Verifier baca-saja membandingkan row/struktur 32 tabel Tahap 1–5 terhadap snapshot pra-M2 dan memastikan 16 tabel Equipment tetap kosong, nama tabel/permission/grant tetap. Populated upgrade diuji pada DB disposable, bukan diisi data development palsu. `php bin/migrate.php`: migration sudah terpasang, tidak ada perubahan. Proyek/database lama dan hosting tidak diakses.

## 5. Hasil pengujian aktual

| Suite | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Integrasi/HTTP lengkap T1–5 dan M1–M5 | **906** | **0** | [foundation.json](tests/results/foundation.json), failure=null, temporary_database_removed=true |
| M5 backend/HTTP/security/concurrency, subset 906 | **72** | **0** | [equipment-timesheets.json](tests/results/equipment-timesheets.json) |
| Browser seluruh modul | **2.305 assertion** | **0** | browser/navigation/dashboard/master/expedition/trucking/Equipment JSON |
| Browser M5, subset 2.305 | **90 assertion** | **0** | [equipment-timesheet-browser.json](tests/results/equipment-timesheet-browser.json) |
| M2 fresh, upgrade terisi, constraint, partial/recovery, concurrency/idempotensi | **122** | **0** | [equipment-migrations.json](tests/results/equipment-migrations.json), 5 DB uji dibersihkan |
| Development preservation/nama tabel/grant, baca-saja | **86** | **0** | [equipment-development.json](tests/results/equipment-development.json) |
| Integritas development | **230** | **0** | [database-integrity.json](tests/results/database-integrity.json) |
| Apache lokal/isolasi DB dan asset M5 | **17** | **0** | [deployment.json](tests/results/deployment.json) |
| PHP lint source | **113 file** | **0** | [equipment-m5-lint.json](tests/results/equipment-m5-lint.json) |
| JavaScript syntax | **11 file** | **0** | [equipment-m5-javascript-lint.json](tests/results/equipment-m5-javascript-lint.json) |

Tidak menjumlahkan ulang subset atau run ulangan sebagai kasus unik. Regresi M3 74, M4 backend 99 dan A01–A04 26 berada pada total integrasi. Browser breakdown: 108 fondasi + 521 navigasi + 724 dashboard + 351 master + 108 dokumen Trucking + 230 operasional Trucking + 62 kontrak M3 + 111 BA M4 + 90 M5 = **2.305**. Gate browser pada integrasi bukan tambahan assertion browser baru.

Perintah aktual: php tests/run.php, php tests/equipment-migrations.php, php tests/equipment-development.php verify, php tests/database-integrity.php, php tests/deployment.php, php bin/migrate.php (no-op), php -l seluruh 113 PHP source dan node --check 11 JS/CJS. Runtime lokal PHP 8.2.12/MariaDB 10.4.32.

Pengujian M5 mencakup WITH berakun, WITH tanpa akun/CONFIRMED, WITHOUT, beberapa interval, lintas malam, break, presisi detik, half-open adjacency, overlap internal/cross-root, HM NULL/pair/negatif/menurun, batas tanggal/jadwal, duplicate root, replay save/revise/decision, versi root/revisi/hash stale, hash konten DB dimodifikasi sebagai fixture negatif, submit/approve/return/reject, alasan wajib, dua author no-self, immutable approved lama, pending tunggal, pending/returned tidak menghilangkan approved, rollback audit/decision/pointer, terminal khusus dan snapshot CANCELLED, dua reviewer berbeda, own IDOR/membership/relink, cross-branch own tanpa customer/full access, Owner read-only, Admin Sewa deny C, CSRF, XSS escape dan asset JavaScript benar-benar tersaji.

## 6. Konkurensi dan idempotensi

Worker PHP berbeda proses/koneksi memakai ready barrier dan gate bersama:

| Kasus | Hasil aktual |
|---|---|
| Dua reviewer berbeda: APPROVED versus RETURNED pada submission yang sama | **OK + CONFLICT**; tepat satu record keputusan |
| Dua proses dengan aktor/token/payload keputusan sama | **OK + OK** replay; tepat satu record keputusan |

Exit/barrier worker juga diperiksa. Key terikat actor/action/payload/branch/versions; replay tidak membuat root/revisi/keputusan/event tambahan. Unique satu verification per revision dan satu pending root melindungi integritas tambahan. Kegagalan audit yang disengaja membuktikan pointer approved lama dan pending submission tetap utuh, tanpa keputusan parsial.

Ini bukti concurrency dua proses, bukan benchmark throughput produksi atau seluruh interleaving deadlock/power-loss.

## 7. Browser desktop/tablet/mobile

Chromium lokal: **320×640, 375×812, 402×874, 768×1024, 1366×768**; **90 PASS/0 FAIL M5**. Pada setiap viewport: login Admin Sewa, list/form, tambah interval lewat JavaScript, lintas malam/break/HM, create/edit draft, submit dan immutable UI, reviewer berbeda, RETURNED beralasan, revisi baru, submit/approve, approved lama tetap efektif saat revisi berikutnya DRAFT, histori, no body overflow dan no JS error. Own Operator read/IDOR/deny verifikasi serta penyembunyian form self-approval juga diuji.

Screenshot: tests/results/phase6-timesheet-{320,375,402,768,1366}.png dan phase6-verification-{320,375,402,768,1366}.png. Screenshot timesheet mobile 320 dan verifikasi desktop 1366 ditinjau visual. Tabel lebar memakai scroll lokal existing. Backend menguji REJECTED/terminal/cross-branch/race; tidak mengklaim semua kombinasi itu diulang di browser. Perangkat fisik/Safari tidak diuji.

## 8. File berubah

Baru:

- app/Services/EquipmentWorkIntervals.php — parsing/validasi interval/break/HM dan detik bersih.
- app/Repositories/EquipmentTimesheetRepository.php — scope scoped/own/reviewer, proyeksi, list, root/revisi/interval/histori.
- app/Services/EquipmentTimesheets.php — draft, revisi, submission, keputusan, hash, pointer, konflik dan audit atomik.
- app/Controllers/EquipmentTimesheetController.php — dispatch/input/error/view untuk timesheet/own/verifikasi.
- app/Views/equipment-timesheets.php — halaman responsif list/form/detail/revisi/antrean/pemeriksaan.
- public/assets/equipment-timesheets.js — tambah/hapus interval draft tanpa inline script.
- tests/equipment-timesheets.php, tests/equipment-timesheets.cjs — regresi permanen backend/HTTP dan browser.
- PHASE6_M5_REPORT.md — laporan ini; JSON/screenshot hasil pada tests/results.

Dimodifikasi:

- app/Services/EquipmentWrite.php — whitelist resource timesheet, default perilaku M3/M4 tetap.
- app/routes.php, public/index.php — route/factory controller dengan permission eksplisit.
- app/navigation.php — menu dan shortcut sesuai route nyata/permission.
- public/router.php — whitelist eksplisit script M5 pada PHP development server; tidak melonggarkan akses config/private.
- public/assets/foundation.css — interval/revisi tidak overflow pada mobile.
- tests/run.php — rangkaian M5 dan ekspektasi menu aktual; tests/equipment-worker.php — keputusan race; tests/browser.cjs dan tests/navigation.cjs — browser M5/shortcut; tests/deployment.php — asset M5 Apache lokal.
- BUSINESS_RULES.md, DECISIONS.md, DATABASE_DESIGN.md, EQUIPMENT_DESIGN.md, EQUIPMENT_STATE_MACHINE.md, EQUIPMENT_PERMISSION_MATRIX.md, PHASE6_IMPLEMENTATION_PLAN.md — aturan M5 terbaru/keputusan/scope/skema tanpa menulis ulang riwayat milestone.
- README.md, PROGRESS.md, CHANGELOG.md — status dan hasil M5.

Tidak mengubah migration/installer, permission seed, konfigurasi sensitif, service Trucking/Finance atau lifecycle bisnis M3/M4.

## 9. Riwayat pengujian dan koreksi

Baseline M1–M4 sebelum integrasi: **834 PASS/0 FAIL** dengan browser. Run M5 pertama berhenti setelah 833 pemeriksaan karena fixture personel berakun melanggar CHECK existing (nama harus NULL bila account_id terisi). Fixture diperbaiki sesuai master; snapshot/pilihan operator memakai nama akun tertaut.

Run berikutnya berhenti setelah 888 PASS dengan satu assertion IDOR HTTP gagal: objek WITHOUT pada endpoint own ditolak 403, sedangkan kebijakan objek di luar kepemilikan mengharuskan 404. Respons disamakan menjadi 404; tidak ada data yang sempat terbuka.

Run berikutnya 897 PASS lalu gate browser gagal: script interval belum dilayani whitelist router PHP lokal, sehingga penambahan interval timeout. Ditambahkan whitelist eksplisit, regresi HTTP MIME/script dan pemeriksaan asset Apache. Run akhir **906 integrasi/HTTP dan 2.305 assertion browser seluruhnya PASS**, termasuk 72 backend/HTTP M5 dan 90 browser M5. Tidak menyatakan run yang terhenti sebagai lulus dan tidak memakai hasil lama untuk menutupi kegagalan.

SQLSTATE 45000 pada fixture trigger audit adalah kegagalan yang sengaja dipicu untuk uji rollback; bukan FAIL akhir. Semua database/account/credential fixture, cookie/session dan file uji dibersihkan.

## 10. Status, BLOCKED dan risiko tersisa

| Kategori | Status |
|---|---|
| PASS | Ruang lingkup M5 di atas, 906 integrasi/HTTP, 2.305 browser assertions, migration/preservation/integritas/Apache/lint |
| FAIL | **0 pada run akhir** |
| BLOCKED | Reset/penggantian HM khusus belum mempunyai prosedur aman yang disetujui; koreksi fakta operasional BA tetap BLOCKED; grant C development memerlukan delegasi eksplisit |
| NOT IMPLEMENTED | M6 penyempurnaan UI Equipment keseluruhan, M7 audit akhir, Finance/Invoice/pembayaran/Inventory/Petty Cash/tarif otomatis; tidak membuat workflow reset atau revisi fakta BA |
| NOT TESTED | MySQL 8, Safari/perangkat fisik, stress/seluruh interleaving deadlock, power-loss nyata, hosting/TLS/deployment |

HM normal divalidasi sebagai pasangan awal/akhir per revisi, bukan dihitung menjadi jam/tarif atau digabung otomatis antar-root/BA. Perubahan SOP/otoritas koreksi memerlukan persetujuan tersendiri. Pilihan form dibatasi 500 penugasan terproyeksi dan maksimal 100 interval per revisi; bukan pengganti rancangan skala produksi. Lock mengutamakan integritas dan dapat menserialisasi penulisan satu cabang/sumber; tidak mengklaim target throughput.

**M5 selesai dengan catatan BLOCKED yang dinyatakan di atas. Berhenti dan menunggu pemeriksaan pengguna. Jangan otomatis melanjutkan M6/M7 atau deployment.**

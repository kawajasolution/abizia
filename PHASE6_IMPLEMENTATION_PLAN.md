# Rencana implementasi Equipment — Tahap 6

## Mandat terbaru M5

Pengguna mengizinkan M5 setelah M4: timesheet WITH/WITHOUT, own/scoped, beberapa interval lintas malam/break/HM, immutable revisions, submission/hash, no-self verifikasi, pending/effective pointers, terminal permission dan UI terkait. Memakai schema 005 tanpa migration atau seed C. Pengujian mencakup positif/negatif, snapshot, HTTP/CSRF/IDOR/membership, race dua reviewer dan replay, browser lima viewport serta regresi T1–5/M1–M4. Hasil eksekusi: PHASE6_M5_REPORT.md. M6/M7, Finance dan deployment belum diizinkan; reset HM/koreksi fakta BA tetap BLOCKED.

## Mandat terbaru M4

Pengguna mengizinkan M4 setelah laporan M3 0 FAIL. M4 memakai schema 005 tanpa perubahan, backend/service/repository/controller/view BA, bukti privat dan integrasi lifecycle/agregat. Pengujian: subset/ALL HANDOVER/RETURN, status master berubah, rollback audit/file, race dua proses, replay, BA number, addendum tanpa efek ulang, permission/membership/cabang/CSRF, snapshot dan browser lima viewport; regresi existing tetap dijalankan. Hasil aktual ada pada PHASE6_M4_REPORT.md, bukan angka historis bagian M1–M3 di bawah. M5–M7 tetap belum diizinkan; koreksi fakta operasional BLOCKED sampai prosedur khusus disetujui.

## Mandat M3 — 24 Oktober 2026

M1–M2 telah lulus dan pengguna mengizinkan **M3 Kontrak Sewa multi-unit/reservasi beserta antarmuka Kontrak Sewa**. Catatan batas M1–M2 di bawah adalah riwayat. Tidak mengizinkan M4–M7, Finance atau deployment.

Implementasi M3 memakai eq_* existing tanpa migration baru: DRAFT header/customer/proyek, detail unit dan periode, WITH/WITHOUT dan penugasan operator; konfirmasi header/detail, KS saat konfirmasi header, cancellation pra-ACTIVE, serta histori event/audit/request atomik. DRAFT tambahan setelah header confirm belum mengikat; konfirmasi detail menerapkan semua guard tanpa nomor KS baru. Edit detail DRAFT menambah versi periode, tidak menghapus versi sebelumnya.

Perpanjangan dua langkah: usulan eq_unit_periods EXTENSION belum efektif, lalu penerapan terotorisasi memeriksa konflik/versi/approval kembali dan memindah pointer current_period_id atomik. Penugasan pengganti memakai previous_assignment_id. Pengganti DRAFT membatalkan draf lama dengan histori; pengganti CONFIRMED tetap DRAFT sampai konfirmasi pengganti membatalkan jadwal lama dan mengikat jadwal baru atomik. Perubahan operator yang sudah ACTIVE menunggu alur BA/pengembalian; M3 tidak membuat lifecycle baru.

Tanggal sewa inklusif, operator [awal,akhir), shift lintas tengah malam sah. Unit DRAFT tidak mereservasi. Unit ACTIVE yang belum kembali menolak reservasi berikutnya walaupun tanggal rencana berbeda. Semua sumber dikunci melalui row master yang stabil sebelum pemeriksaan konflik current locking read, termasuk saat kalender reservasi awal kosong; semua detail batch rollback jika ada satu kegagalan.

Lintas cabang terikat unit/operator, kontrak dan versi periode. Request dari cabang kontrak, persetujuan pihak pemilik dan pengelola dari dua akun berbeda. Mandat M3 menegaskan **tidak boleh self-approval**: pemohon bukan salah satu approver. Role/akun global tidak melewati guard ini. Kedua approver tetap aktif/berizin/bercakupan ketika konfirmasi dijalankan. Pencabutan menyimpan histori/aktor/alasan dan tidak otomatis mengakhiri kontrak. **Semua C tetap tanpa grant default**. Penugasan permission approval harus eksplisit; fixture uji mendapat grant sementara hanya di DB disposable lalu dibersihkan.

Route nyata: GET/POST /equipment/contracts (equipment.contract.view + permission aksi) dan GET/POST /equipment/authorizations (equipment.cross_branch.approve). Portal approval hanya memproyeksikan sumber/periode/cabang/alasan yang relevan, tanpa customer atau full kontrak cabang lain. Own Operator tidak memperoleh full contract.view dari view_own. Satu menu Kontrak Sewa di registry existing, shortcut Admin Sewa; tidak membuat menu BA/Timesheet/Verifikasi atau halaman Equipment lain.

KS/{KODE_CABANG}/{TAHUN}/{000001} diterbitkan memakai waktu konfirmasi WITA/counter KS tersendiri, bukan periode rental. Cancel tidak menghapus nomor. Guard kode cabang kini mengenali eq_document_sequences selain exp_sequences dengan lock cabang yang sama. Generator DN/MF tidak diubah. Semua POST memakai CSRF router; permission/scope/master/state/version diperiksa server dalam transaksi. Token acak terikat actor/action/payload/branch, replay tidak mengulang nomor/event. Named lock per request key melindungi first-use token yang sama pada dua koneksi; transaksi/row lock menjaga konflik kalender dan sequence. Deadlock/constraint ditolak 409 dengan rollback penuh dan retry token yang sama.

Hasil aktual pengujian, file berubah, status grant development dan batas fitur dicatat pada PHASE6_M3_REPORT.md. Berhenti setelah M3; transisi ACTIVE/COMPLETED/TERMINATED operasional, BA, timesheet/verifikasi, halaman Equipment lainnya dan audit akhir belum diimplementasikan.

24 Oktober 2026, WITA. **Mandat terbaru hanya M1 dan M2.** G01–G12 telah disetujui sebagai baseline sementara V2, belum SOP final perusahaan. Detail keputusan: EQUIPMENT_DESIGN.md; transisi: EQUIPMENT_STATE_MACHINE.md; grant/scope: EQUIPMENT_PERMISSION_MATRIX.md. Tidak membuka ulang Q03/Q04/Q09 atau aturan Finance.

## Milestone dan gate

| Milestone | Keluaran | Status otorisasi |
|---|---|---|
| M1 | Regresi penuh existing T1–5, browser, A01–A04, lint/integritas dan isolasi DB | Diizinkan; bila gagal STOP dan laporkan |
| M2 | Skema aditif, FK/CHECK/unique/index/permission sah; fresh/upgrade populated/failure recovery disposable; preservation development | Diizinkan hanya setelah M1 PASS |
| M3 | Kontrak multi-unit, reservasi, operator/cross-approval, periode, KS, branch-code lock Equipment | Belum diizinkan |
| M4 | BA wajib HANDOVER/RETURN, multi-unit atomik, koreksi/evidence, penomoran BA | Belum diizinkan |
| M5 | Timesheet/interval/HM, immutable revisions, verification, own-scope, koreksi terminal | Belum diizinkan |
| M6 | Lima halaman operasional responsif beserta route/menu nyata | Belum diizinkan |
| M7 | Audit akhir dan pengujian end-to-end Equipment lengkap | Belum diizinkan |

## M1

Jalankan tests/run.php: autentikasi/session/CSRF/RBAC/active membership/cabang, dashboard/nav/master, DN/Manifest/Transit/penerimaan/klaim/tracking, state machine, audit atomik, idempotensi/konkurensi T5 dan upgrade. Semua regresi permanen A01–A04 harus lulus. Jalankan tests/database-integrity.php, tests/deployment.php dan lint PHP/JS. Browser existing pada 320/375/402/768/1366. Simpan snapshot artefak di tests/results/phase6-m1 sebelum run M2 menimpa nama generik. Angka historis bukan hasil gate sekarang.

## M2 — struktur aditif

005_equipment_operations.sql setelah 001–004: 16 tabel eq_*. Gunakan branches/md_customers/md_assets(kind equipment)/md_personnel(kind operator)/users existing. Tidak membuat ulang master. eq_meter_corrections memperjelas G03; eq_evidence memiliki tepat satu dari tiga target. Tidak membuat tabel Finance/Invoice/Inventory/Petty Cash atau isi transaksi/akun/operator/nomor pada development.

Urutan: contracts → units → periods → pointer period → assignments → authorizations → BA header/detail → timesheet root/revision → pointer revisi → work entries/verification → meter correction → event/request/sequence/evidence → pointer bukti. FK siklik ditambahkan setelah target ada, tanpa foreign_key_checks=0. Metadata fk/check/unique/index aktual disimpan dalam equipment-migrations.json dan laporan M1–M2.

DDL tidak atomik. EquipmentMigration menggunakan advisory lock per database dan journal START/DONE terikat hash SQL serta fingerprint SHOW CREATE TABLE. Hanya langkah terverifikasi yang dilewati saat resume; schema drift/objek asing dihentikan. Penanda lengkap 005 dan seed permission/grant commit bersama setelah semua DDL selesai. Tidak mengubah generator DN/MF. Metadata journal menambah baris schema_migrations, bukan dokumen Equipment.

### Recovery

1. Hentikan writer/install paralel dan simpan backup; pastikan target V2 melalui guard nama dan SELECT DATABASE().
2. Bila interupsi **sesudah DONE**: jalankan kembali bin/migrate.php; installer memverifikasi fingerprint langkah terakhir per tabel lalu melanjutkan tanpa DROP/reset atau seed ganda.
3. Bila kegagalan seed: seluruh seed/marker rollback; hilangkan penyebab izin/error lalu jalankan kembali migration, DDL lengkap yang cocok tidak diulang.
4. Bila tabel asing/schema drift atau crash di jendela DDL sukses tetapi DONE belum tercatat: **hentikan otomatis**. Periksa SHOW CREATE TABLE, journal START, hash DDL dan backup. Jangan menerapkan CREATE IF NOT EXISTS atau menandai lengkap secara manual tanpa verifikasi. Recovery kasus ambigu membutuhkan review DBA terhadap struktur aktual; tidak dianggap resume otomatis yang sudah terbukti. Kembalikan hanya perubahan teknis drift setelah review, tanpa menghapus data, atau lanjutkan melalui prosedur repair terotorisasi terpisah.
5. Fresh/upgrade, interupsi checkpoint, seed failure, drift/objek asing dan dua koneksi diuji di database disposable. Uji power-loss nyata tidak termasuk klaim PASS.

Sebelum development, ambil snapshot privat melalui tests/equipment-development.php snapshot; jangan ditimpa. Setelah uji disposable lulus, jalankan bin/migrate.php secara aditif lalu verify snapshot: seluruh row dan DDL 32 tabel awal tetap, hanya katalog/grant/journal bertambah, semua tabel Equipment kosong. Verifikasi integritas development dan Apache lokal sesudahnya.

## Rencana uji M3–M7 (belum dijalankan)

- Kontrak multi-unit atomik, tanggal inklusif, reservasi saat confirm, konflik kalender kosong dan unit overdue aktif, detail tambahan/extension/termination berhistori.
- Race dua proses untuk unit/operator/KS/BA, token replay identik/berbeda aktor/payload, deadlock/rollback audit; nomor WITA/nonreuse, branch code lock Equipment tanpa mengubah DN/MF.
- Cross-branch dua approver berbeda akun, cakupan sumber/kontrak/periode, expiry/revocation/extension, global bukan bypass.
- BA ALL/subset satu kontrak, invalid batch rollback, efek sekali saja, confirmed immutable, koreksi admin/fakta, return dengan master nonaktif melalui recovery sah.
- Root unit/operator/hari, WITHOUT/no-account, datetime lintas tengah malam/break, HM optional/pair/reset evidence, APPROVED immutable dan correction pending tidak menghilangkan effective approved.
- Self-approval root/revisi oleh semua role, base/version/hash stale, satu pending, terminal correction tidak reaktivasi; relink operator tidak membuka histori otomatis.
- Upload private/MIME/ekstensi/ukuran/path/hash, target/own/full projection, no arbitrary historical deletion; parameter/scope/CSRF/auth/permission HTTP.
- Lima halaman 320/375/402/768/1366, filter/detail/form/revisi/histori/loading/error/409, actual screenshots dan pemeriksaan visual.
- Regresi T1–5, lint, semua FK/orphan/current pointers/history, tanpa efek Finance.

## Pelaporan dan batas

PHASE6_M1_M2_REPORT.md memuat hasil aktual PASS/FAIL/BLOCKED/NOT TESTED, file/migration/tabel/constraint/grant, preservation populated upgrade/development, recovery dan risiko. Tidak menyatakan Tahap 6 selesai pada M2. Keputusan pengguna: semua grant C tidak disemai, definisi permission saja. Otoritas khusus tetap deny sampai mandat terpisah. Retensi/format/batas bukti, delegasi dan detail pemanfaatan sisa hari actual return ditetapkan sebelum workflow terkait. Tidak mengubah proyek/database lama, hosting atau deployment. **Berhenti setelah M1–M2; jangan lanjut M3.**

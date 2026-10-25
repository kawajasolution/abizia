# Tahap 6 — M4 Berita Acara Equipment

24 Oktober 2026, WITA. **M4 selesai dengan catatan: alur yang diimplementasikan lulus seluruh pengujian akhir, 0 FAIL; koreksi fakta operasional tetap BLOCKED sesuai batas mandat.** Run akhir selesai **18:18:25 WITA**. M4 saja; M5–M7, Finance dan deployment tidak dikerjakan. G01–G12 tetap baseline sementara, bukan SOP final perusahaan.

## 1. Hasil implementasi

| Fitur | Perilaku |
|---|---|
| BA DRAFT | Satu kontrak CONFIRMED/ACTIVE; HANDOVER/RETURN; seluruh unit eligible atau subset; tanggal/jam WITA, kondisi dan HM opsional per unit; identifier internal tanpa nomor resmi |
| Edit/cancel | Hanya DRAFT, versi optimistis; perubahan menyimpan before/after di eq_events; pembatalan wajib alasan dan mempertahankan detail/bukti/histori |
| ALL | ID detail diekspansi/dibekukan saat simpan; unit tambahan sesudahnya tidak ikut otomatis; pilihan tidak lengkap ditolak |
| HANDOVER | Hanya unit CONFIRMED → ACTIVE dengan actual_start; master/customer/operator kini, reservasi dan approval lintas cabang diperiksa ulang menggunakan guard M3 |
| Operator | Hanya interval CONFIRMED yang mencakup HANDOVER menjadi ACTIVE; jadwal mendatang tetap CONFIRMED, tanpa scheduler otomatis; WITHOUT tidak membuat operator palsu |
| RETURN | Hanya unit ACTIVE → COMPLETED/NORMAL atau TERMINATED/EARLY, actual_end >= actual_start; menutup operator aktual dan membatalkan jadwal/usulan yang belum dimulai dengan histori |
| Kontrak | Partial return tetap ACTIVE bila ada detail belum selesai; terminal hanya setelah seluruh detail/penugasan selesai; EARLY memerlukan alasan/terminate dan menghasilkan TERMINATED setelah semua selesai |
| Integrasi cancellation | Setelah return sah, cancellation detail terakhir yang belum diserahkan juga menghitung agregasi dengan lock dan permission close/terminate; tidak mengubah guard cancellation pra-ACTIVE M3 |
| Penomoran | BA/{kode cabang kontrak}/{tahun konfirmasi WITA}/{000001}; counter BA terpisah KS/DN/MF, row lock, unique dan commit atomik; nomor sumber tidak dihapus/dipakai ulang |
| Koreksi administratif | BA addendum DRAFT baru correction_of_id; alasan administratif baru, fakta unit/tanggal/kondisi/HM/snapshot disalin; konfirmasi bernomor baru dengan lifecycle_effect NULL; sumber immutable |
| Bukti privat | Opsional JPEG/PNG/PDF <=5 MB/file, ekstensi sesuai MIME aktual, nama tersanitasi, key acak tanpa ekstensi, SHA-256/ukuran, akses download backend dan no-store/nosniff/attachment |
| UI | Daftar/search/filter/pagination, pilih kontrak, form/unit/kondisi/HM, edit, bukti, konfirmasi, detail/histori/cetak; menu BA nyata serta tautan dari Kontrak Sewa; HLS logo/warna/navigasi existing |

Confirmed tidak dapat diedit, dibatalkan langsung, atau ditambah bukti melalui endpoint M4. Detail draft yang telah mempunyai bukti tidak dapat dikeluarkan: cancellation draft dan BA baru mempertahankan bukti lama. Detail draft tanpa bukti boleh diganti; snapshot before/after di ledger tidak dihapus. Print tetap terautentikasi dan memperlihatkan DRAFT bila belum confirmed; label status unit kini dipisahkan dari efek historis BA.

## 2. Keputusan tambahan pengguna

Disetujui melalui jawaban klarifikasi pada sesi M4:

1. Bukti opsional JPEG/PNG/PDF maksimal 5 MB/file, privat, tanpa fitur penghapusan pada M4.
2. HANDOVER hanya mengaktifkan operator yang intervalnya mencakup kejadian; jadwal mendatang tetap CONFIRMED. RETURN menyelesaikan yang ACTIVE dan membatalkan yang belum mulai dengan histori, tanpa actual_start rekaan.
3. Petugas memilih NORMAL/EARLY; EARLY beralasan dan equipment.contract.terminate. Header terminal hanya setelah semua selesai; TERMINATED bila terdapat EARLY.

Koreksi fakta operasional/reversal lifecycle/reset atau penggantian meter **BLOCKED**: belum ada prosedur khusus cukup rinci dan tidak dibuat sebagai asumsi. Addendum administratif hanya catatan tambahan, bukan cara mengubah fakta tersebut.

## 3. Route, permission dan scope

- GET/POST `/equipment/handovers`: equipment.handover.view, kemudian create/update/confirm/cancel/correct sesuai aksi pada backend/transaksi.
- HANDOVER juga equipment.contract.activate. RETURN NORMAL memerlukan contract.close; EARLY memerlukan contract.terminate dan alasan. Recovery sumber nonaktif memerlukan equipment.recovery.close dan alasan/audit, tanpa mengaktifkan ulang master atau melewati cabang kontrak efektif.
- GET `/equipment/handover-evidence?id=...`: equipment.evidence.view plus akses BA penuh/cabang efektif; metadata/file sumber dicek, SHA-256/ukuran diverifikasi. Upload memerlukan evidence.add dan versi BA DRAFT terkini; target unit harus milik BA.
- Actor aktif, role/auth_version/scope kini, grant DB dan active membership/cabang efektif diperiksa. Owner hanya baca sesuai cabang. Own grant Operator tidak membuka BA multi-unit, print atau seluruh bukti; projection own untuk penugasan/timesheet bukan halaman M4.
- CSRF berlaku semua POST melalui router. Tidak ada endpoint koreksi fakta, penghapusan bukti atau direct cancel confirmed.

**Tidak ada perubahan katalog/grant/role M2.** handover.correct, handover.fact_correct, recovery.close, meter.correct dan seluruh C tetap tanpa grant otomatis, termasuk Administrator. Alur positif correction/recovery/cross-approval menggunakan grant sementara hanya pada DB disposable, lalu dicabut; tidak membuat akun/grant development.

## 4. Database dan integritas

**Tidak ada perubahan skema/migration.** Tetap 48 tabel/16 eq_* dan fingerprint 005. Memakai eq_handover_documents, eq_handover_units, eq_evidence, eq_events, eq_requests, eq_document_sequences serta lifecycle pada kontrak/unit/operator existing. eq_meter_corrections/timesheet/verifications tidak ditulis M4.

Transaksi memakai boundary EquipmentWrite: named lock per request key, actor/permission/cabang terkini, lock header kontrak, row BA/unit/operator/master/approval dan sequence. Payload canonical terikat actor/action/resource/scope/version. eq_requests resource_type handover digunakan untuk BA; default contract M3 tetap. Replay commit mengembalikan hasil tanpa efek/nomor/event ganda. Konflik versi/status/unique/deadlock ditolak dengan rollback; klien dapat mengulang token sama. Unique unit/lifecycle_effect adalah pertahanan tambahan, bukan pengganti validasi.

Mutasi BA, unit/operator, aggregate, sequence, event, audit dan hasil idempotensi commit bersama. eq_events menggunakan FK konteks BA/unit/operator yang sesuai, status sebelum/sesudah, actor, branch, kejadian WITA dan waktu pencatatan. Snapshot master confirmed tidak diubah ketika nama/status master berubah.

Development tidak direset atau diisi fixture. Preservation 32 tabel Tahap 1–5, nama 48 tabel, 16 Equipment kosong dan grant sensitif diperiksa baca-saja terhadap snapshot pra-M2. Migration development no-op. Seluruh akun, source, dokumen, bukti dan grant uji berada pada DB/direktori disposable V2 yang dibersihkan. Proyek/database lama dan hosting tidak diakses.

## 5. Pengujian aktual

Hasil eksekusi akhir; foundation.json failure=null dan temporary_database_removed=true. Assertion browser dihitung terpisah dari gate browser di suite integrasi.

| Suite | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Draft BA M4, subset integrasi | 20 | 0 | tests/results/equipment-handover-drafts.json |
| Operasional/HTTP/security/concurrency M4, subset integrasi | 79 | 0 | tests/results/equipment-handovers.json |
| Integrasi/HTTP lengkap Tahap 1–5 dan M1–M4 | **834** | **0** | tests/results/foundation.json |
| Browser desktop/tablet/mobile seluruh modul | **2.185 assertion** | **0** | tests/results/*browser.json dan navigation.json |
| Browser BA M4, subset 2.185 | **111 assertion** | **0** | tests/results/equipment-handover-browser.json |
| Migration M2 fresh/upgrade terisi/partial/recovery/constraint/concurrency/idempotensi | 122 | 0 | tests/results/equipment-migrations.json |
| Development preservation, baca-saja | 86 | 0 | tests/results/equipment-development.json |
| Integritas database development | 230 | 0 | tests/results/database-integrity.json |
| Apache lokal/isolasi DB | 16 | 0 | tests/results/deployment.json |
| PHP lint | 108 file | 0 | tests/results/equipment-m4-lint.json |
| JavaScript syntax | 9 file | 0 | tests/results/equipment-m4-javascript-lint.json |

Subset tidak dijumlahkan ulang sebagai kasus unik. M4 backend 20+79=99 pemeriksaan berada pada total 834; regresi M3 74 dan A01–A04 26 juga subset total integrasi. Browser: 108 fondasi + 491 navigasi + 724 dashboard + 351 master + 108 dokumen Trucking + 230 operasional Trucking + 62 kontrak M3 + 111 BA M4 = 2.185. Pengujian negatif yang diharapkan mengembalikan penolakan dihitung PASS; kegagalan proses tak terduga bukan PASS.

Perintah aktual: php tests/run.php (suite integrasi/HTTP/barrier workers/browser), php tests/equipment-migrations.php, php tests/equipment-development.php verify, php tests/database-integrity.php, php tests/deployment.php, php bin/migrate.php (no-op), php -l seluruh 108 PHP dan node --check seluruh 9 JS/CJS. MariaDB 10.4.32 dan PHP 8.2.12. Tidak mengklaim PASS dari sekadar inspeksi route atau file pengujian.

Skenario M4 yang dieksekusi: HANDOVER/RETURN satu unit, subset dan ALL; unit lain tetap; header normal/EARLY/partial; duplicate dan replay; status master berubah setelah draft; master nonaktif/recovery; HM menurun/waktu return tidak sah; unit kontrak lain; batch rollback audit; cancelled/confirmed immutable; addendum tanpa efek ulang; cross-approval dicabut dan approval dua akun yang baru; nomor memakai cabang kontrak/tahun konfirmasi; snapshot setelah nama master berubah; membership dicabut, Owner write, Operator own/full denial, IDOR detail/bukti dan anonim; MIME/ekstensi/ukuran, hash file rusak, upload replay, rollback file/metadata; print HTTP.

## 6. Bukti konkurensi dan idempotensi

Worker PHP berbeda proses/koneksi menunggu barrier yang sama, bukan panggilan berurutan:

| Race | Hasil yang diperiksa |
|---|---|
| Dua BA HANDOVER berbeda, satu unit | OK + CONFLICT; tepat satu lifecycle_effect HANDOVER |
| Dua request RETURN dengan token sama | OK + OK replay; tepat satu nomor/event konfirmasi |
| Dua BA sah pada unit berbeda | OK + OK; nomor resmi berbeda |
| Dua BA RETURN berbeda, satu unit | OK + CONFLICT; tidak ada return ganda |

Setiap worker exit/barrier juga diperiksa. Pengujian upload dan create/confirm/correction membuktikan replay tidak menggandakan record/file/event. Uji audit error yang disengaja membuktikan rollback nomor/status/batch dan pembersihan file baru. Tidak mengklaim stress test throughput produksi atau seluruh pola deadlock.

## 7. Browser

Browser Chromium lokal pada **320×640, 375×812, 402×874, 768×1024, 1366×768**. Run akhir M4 **111 PASS/0 FAIL**, seluruh browser 2.185 assertion PASS. Pada tiap viewport: list, create DRAFT HANDOVER dan RETURN, ALL, kondisi/HM, edit draft, upload bukti nyata, confirm/nomor/lifecycle, immutable UI, histori, print CSS, status kontrak setelah return, no overflow dan no JS error. Owner tanpa tombol write diuji. Backend membuktikan multi-unit/approval/recovery/race; tidak mengklaim seluruh kombinasi itu diulang di browser.

Screenshot tests/results/phase6-ba-handover-{320,375,402,768,1366}.png dan phase6-ba-return-{...}.png. Screenshot mobile 320 dan desktop 1366 ditinjau visual. Cetak diuji sebagai halaman/print media browser; printer fisik tidak diuji. Safari/perangkat fisik/MySQL 8/hosting/TLS/deployment tidak diuji.

## 8. File berubah

Baru:

- app/Repositories/EquipmentHandoverRepository.php — scoped BA reads/list/history/evidence metadata.
- app/Services/EquipmentHandovers.php — draft/cancel/confirm/number/lifecycle/aggregate/addendum.
- app/Services/EquipmentHandoverEvidence.php — upload privat dan download terotorisasi.
- app/Controllers/EquipmentHandoverController.php — dispatch/validation/error/view/download.
- app/Views/equipment-handovers.php — list/form/detail/history/print responsif.
- tests/equipment-handover-drafts.php, tests/equipment-handovers.php, tests/equipment-handovers.cjs — regresi permanen dan browser.
- PHASE6_M4_REPORT.md — laporan ini; artefak JSON/screenshot pada tests/results.

Dimodifikasi:

- app/Services/EquipmentContracts.php — reuse guard M3 untuk HANDOVER; aggregate setelah cancellation detail terakhir pasca-return.
- app/Services/EquipmentWrite.php — resource type handover opsional, default contract tetap, label transisi close-after-cancel.
- public/index.php, app/routes.php, app/navigation.php — factory/route/menu BA berizin.
- app/Views/equipment-contracts.php — tautan BA kontrak.
- public/assets/foundation.css — fieldset/file input BA tidak overflow.
- tests/run.php — rangkaian M4, direktori bukti disposable dan cleanup, ekspektasi satu menu BA baru.
- tests/equipment-worker.php — operasi confirm BA pada worker existing; tests/browser.cjs — suite BA; tests/navigation.cjs — jumlah route nyata terbaru.
- BUSINESS_RULES.md, DECISIONS.md, DATABASE_DESIGN.md, EQUIPMENT_DESIGN.md, EQUIPMENT_STATE_MACHINE.md, EQUIPMENT_PERMISSION_MATRIX.md, PHASE6_IMPLEMENTATION_PLAN.md — baseline M4/keputusan/transaksi/scope terkini; bagian M1–M3 tetap histori.
- README.md, PROGRESS.md, CHANGELOG.md — status M4, hasil dan tautan laporan terbaru.

Tidak ada migration, schema installer, grant seed, master/Trucking/Finance service atau konfigurasi sensitif development yang diubah.

## 9. Risiko dan batas

- **BLOCKED:** koreksi fakta operasional/reversal/reset HM menunggu prosedur dan otoritas khusus. Tidak ada default grant untuk menggunakannya.
- Recovery/correction/cross-approval pada development memerlukan delegasi permission eksplisit; fixture positif tidak menjadi grant development.
- Tidak ada aktivasi operator otomatis berdasarkan jam, Timesheet/Verifikasi, halaman Equipment lain M6 atau audit akhir M7.
- File dan transaksi DB bukan satu storage engine. Kegagalan biasa membersihkan file baru; power loss antara move dan commit dapat meninggalkan orphan privat. Rekonsiliasi orphan/retensi/kuota/backup produksi tidak diimplementasikan pada M4; bukti committed tidak dihapus aplikasi.
- MariaDB 10.4.32/PHP 8.2 lokal yang diuji. MySQL 8, printer fisik, perangkat/Safari, stress produksi dan hosting/deployment NOT TESTED.

## 10. Riwayat verifikasi dan status akhir

Baseline sebelum integrasi BA: 735 integrasi/HTTP; lalu draft 755, keduanya lulus dengan browser existing. Run awal M4 berhenti pada ekspektasi jumlah menu lama (19 pemeriksaan lulus, satu gagal), diperbarui untuk menu BA nyata. Run selanjutnya berhenti setelah 792 pemeriksaan karena fixture mencoba login ulang session yang sudah login sehingga tidak menemukan token login; fixture memakai session autentikasi M3 yang sah. Bukan alasan melewatkan pengujian akhir. Run berikutnya 813 integrasi dan browser M4 111 assertion lulus; kemudian regresi diperkuat untuk lintas cabang/snapshot/bukti/return race/agregasi terakhir.

| Kategori | Hasil akhir |
|---|---|
| PASS | 834 integrasi/HTTP, 2.185 assertion browser, migration M2 122, preservation 86, integritas 230, Apache/isolasi 16, lint PHP 108/JS 9 |
| FAIL | **0 pada run akhir**; dua penghentian fixture/ekspektasi pengujian selama pengembangan telah diperbaiki dan diulang |
| BLOCKED | Prosedur koreksi fakta/reversal lifecycle/reset HM belum disetujui; delegasi permission C development belum diberikan |
| NOT IMPLEMENTED | M5 Timesheet/Verifikasi, M6 halaman lain/own projections, M7 audit akhir, Finance/Invoice/pembayaran/Inventory/Petty Cash; penghapusan bukti dan scheduler aktivasi tidak dibuat |
| NOT TESTED | MySQL 8, Safari/perangkat/printer fisik, stress/semua interleaving deadlock, power-loss nyata, hosting/TLS/deployment |

**Berhenti setelah M4. Menunggu pemeriksaan pengguna; tidak melanjutkan M5 atau deployment.**

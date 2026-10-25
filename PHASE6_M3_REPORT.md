# Laporan Tahap 6 — M3 Kontrak Sewa Multi-Unit dan Reservasi

24 Oktober 2026, WITA. **M3 selesai dan lulus pengujian dalam ruang lingkup mandat; 0 FAIL pada run akhir.** Penggunaan approval lintas cabang pada development memerlukan penugasan permission eksplisit; tidak ada grant C otomatis. M4–M7 belum dimulai. G01–G12 tetap baseline sementara V2, belum SOP resmi perusahaan.

## 1. Hasil implementasi

| Kemampuan | Perilaku yang tersedia |
|---|---|
| Kontrak DRAFT | Header customer master/cabang/proyek; edit header hanya DRAFT, versi optimistis, identifier internal tetap |
| Multi-unit | Tambah/edit detail DRAFT dengan unit master existing, periode per unit, WITH/WITHOUT; versi periode lama tetap tersimpan |
| Operator | Personel master ID, akun opsional tanpa dummy, beberapa jadwal datetime termasuk lintas tengah malam; interval setengah terbuka |
| Konfirmasi | Seluruh detail/operator diperiksa atomik, DRAFT → CONFIRMED, reservasi mulai mengikat, nomor KS saat confirm header saja |
| Penomoran | KS/cabang/tahun konfirmasi WITA/6 digit; counter terpisah, transaksi/lock, no reuse committed, cancel tetap menyimpan nomor |
| Pembatalan | Header DRAFT/CONFIRMED sebelum pernah aktif, alasan wajib; detail/operator terkait dibatalkan atomik, reservasi dilepas, histori tidak dihapus |
| Tambahan sesudah confirm | Detail tambahan berstatus DRAFT dan belum mereservasi; konfirmasi detail mengulang guard dan tidak menerbitkan KS baru |
| Perpanjangan | Usulan period revision belum efektif; penerapan memeriksa ulang versi, konflik dan approval periode, lalu memindahkan pointer atomik; nomor tetap |
| Pergantian jadwal | Record baru dengan previous_assignment_id; DRAFT lama dibatalkan berhistori, confirmed lama tetap mengikat sampai pengganti confirmed atomik; operator yang sudah ACTIVE tidak diganti melalui M3 |
| Lintas cabang | Request per sumber/kontrak/periode, dua pihak berbeda akun, pemohon tidak self-approve, cek permission/scope kini, histori/pencabutan tanpa otomatis mengakhiri kontrak |
| Histori/audit | eq_events berisi status sebelum/sesudah, referensi, aktor/cabang/waktu/request; audit_logs dan eq_requests commit bersama perubahan dan sequence |
| Antarmuka | Daftar/search/filter cabang/status/pagination, create/edit/detail, pilihan master, unit/operator, reservasi, usulan/approval dan histori yang terbaca pada desktop/tablet/mobile |

Tidak mengaktifkan kontrak/unit tanpa BA, tidak menyelesaikan unit tanpa return aktual. M3 tidak mempunyai aksi operasional ACTIVE/COMPLETED/TERMINATED, BA, timesheet/verifikasi atau transaksi keuangan. Header CONFIRMED bukan bukti unit mulai bekerja.

## 2. Route dan permission

- GET/POST `/equipment/contracts`: `equipment.contract.view` pada route, ditambah permission setiap aksi di service/transaksi (create/update/confirm/cancel/assignment.manage/contract.extend/cross_branch.request).
- GET/POST `/equipment/authorizations`: `equipment.cross_branch.approve`; proyeksi request sumber/periode/cabang/alasan sesuai cabang efektif, tanpa membuka customer atau seluruh kontrak cabang lain. Ini subproses kontrak M3, bukan halaman Equipment umum M6.
- Menu **Kontrak Sewa** terhubung registry existing; shortcut Admin Sewa aktif. Sidebar/drawer/Bottom Navigation tidak didesain ulang. BA/Timesheet/Verifikasi tetap tanpa route/menu aktif.

Seluruh grant/role M2 tetap: 43 permission Equipment, Administrator 26 Y, Admin Sewa 22 Y, Operator 10 own, Owner 6 baca; total katalog 106 permission/215 grant/10 role. `equipment.verification.decide` tetap Administrator Y tetapi tidak mempunyai endpoint M5 pada M3. Tidak ada tambahan grant.

**Seluruh C tetap deny**, termasuk `equipment.cross_branch.approve`, recovery, koreksi BA/HM, revisi terminal dan relink. Admin Sewa tidak mendapat extension/terminate/verification C. Operator own tidak mendapat full contract.view melalui perubahan URL. Owner hanya baca dalam scope.

**Kondisi development:** tidak ada akun/petugas dengan permission approval lintas cabang. Dua approval yang sah harus ditugaskan secara eksplisit sebelum proses lintas cabang dapat dikonfirmasi. Administrator/all_branches tidak melewati hal ini. Implementasi/tes tidak menambahkan grant atau akun pada development. Grant approval hanya diberikan sementara kepada fixture DB disposable untuk membuktikan alur positif/negatif, lalu dicabut sebelum akhir suite.

## 3. Integritas dan transaksi

Actor/session/role/auth_version/grant dan cabang efektif diperiksa kembali. Owner sumber berasal dari master/FK, bukan input branch klien. Master kind/active dan akun operator yang tertaut diperiksa pada penugasan/konfirmasi baru. Snapshot/histori confirmed tidak ditulis ulang. Pembatalan pra-ACTIVE tidak memerlukan mengaktifkan ulang master unit/operator hanya untuk melepas reservasi, tetapi tetap membutuhkan permission dan scope cabang kontrak efektif.

Konfirmasi memegang lock konteks cabang/header dan row master asset/personel yang stabil, dengan urutan ID sumber konsisten, lalu current locking read konflik. Karena row master sudah ada, kalender yang awalnya kosong tetap terlindungi. Tanggal sewa inklusif; operator `[start,end)`; overlap operator maupun dua operator serentak pada satu unit ditolak. Unit ACTIVE yang belum kembali memblokir reservasi baru walaupun rencana tanggalnya berbeda. Fixture ACTIVE dipakai hanya untuk uji negatif; tidak ada endpoint membuat ACTIVE pada M3.

Semua mutasi, status, period pointer, sequence, event, audit dan token-result satu transaksi PDO. Deadlock/constraint/lock timeout mengembalikan konflik 409 dengan rollback penuh; klien dapat mengulangi token sama. Lock ini mengutamakan integritas dan dapat menserialisasi mutasi pada cabang/permission yang sama; tidak mengklaim benchmark throughput produksi.

Token idempotensi acak 64 hex terikat actor/action/payload/version/branch. Named lock per key menserialisasi first-use token yang sama sebelum transaksi, bukan mengandalkan gap-lock kalender kosong. Replay memeriksa akses kini dan mengembalikan hasil commit tanpa nomor/event baru. Token sama dengan payload/aktor berbeda ditolak.

Guard kode cabang Master Data kini mengenali sequence Equipment committed selain sequence Trucking. Konfirmasi dan perubahan kode cabang mengunci row branch yang sama. Generator DN/MF dan keputusan Q03/Q04/Q09 tidak diubah.

## 4. Database dan development

**Tidak ada migration atau perubahan schema baru pada M3.** Tetap 48 tabel melalui 001–005; 16 tabel Equipment existing digunakan ulang. FK/CHECK/unique/index dan fingerprint journal 005 tetap. `php bin/migrate.php` menghasilkan **“Migration sudah terpasang; tidak ada perubahan.”**

Data operasional M3 berada pada eq_contracts, eq_contract_units, eq_unit_periods, eq_operator_assignments, eq_branch_authorizations, eq_document_sequences (KS), eq_events dan eq_requests. Tidak menulis BA/timesheet/meter/evidence Equipment atau master baru sebagai efek transaksi kontrak. Master uji dibuat hanya sebagai fixture disposable.

Verifikasi development terhadap snapshot pra-M2: **86 PASS/0 FAIL**. Semua row/struktur 32 tabel T1–5 terjaga, 16 tabel Equipment tetap kosong, termasuk sequence/event/request. Development tetap nol pengguna/cabang/master/Trucking sesuai baseline yang sudah ada; tidak membuat akun/operator/kontrak/nomor palsu. Pelestarian database yang benar-benar berisi transaksi diuji melalui populated upgrade disposable, bukan mengisi development. Proyek/database lama dan hosting tidak diubah atau diakses untuk operasi database/deployment.

## 5. File baru

| File | Tujuan |
|---|---|
| app/Repositories/EquipmentRepository.php | Header/detail/list/filter/pagination/choices sesuai scope serta proyeksi request approval |
| app/Services/EquipmentAccess.php | Revalidasi actor/grant dan cakupan cabang efektif |
| app/Services/EquipmentWrite.php | Batas transaksi/idempotency/key lock, event/status dan audit atomik |
| app/Services/EquipmentContracts.php | Aturan kontrak/unit/operator/reservasi/konfirmasi/KS/cancel/extension/cross-approval |
| app/Controllers/EquipmentController.php | Dispatch HTTP aksi M3 dan error input/konflik; tidak menumpuk aturan bisnis di controller |
| app/Views/equipment-contracts.php | UI HLS kontrak dan subproses approval, form/daftar/detail/histori, output escaping |
| tests/equipment-contracts.php | 74 pemeriksaan M3 backend/HTTP/security/state/race, terintegrasi suite disposable |
| tests/equipment-worker.php | Worker PHP terpisah dan barrier untuk race nyata |
| tests/equipment-contracts.cjs | Browser M3 lima viewport dengan transaksi nyata dan pemeriksaan read-only |
| PHASE6_M3_REPORT.md | Laporan ini |

## 6. File dimodifikasi

| File | Perubahan |
|---|---|
| app/routes.php | Dua route kontrak/approval nyata, auth/permission eksplisit |
| public/index.php | Wiring controller/service/repository Equipment pada front controller |
| app/navigation.php | Satu item Kontrak Sewa tersedia sesuai contract.view dan shortcut Admin Sewa |
| app/Repositories/MasterDataRepository.php | Branch code lock memperhitungkan KS/BA committed, tanpa mengubah penomoran Trucking |
| tests/run.php | Menjalankan kasus M3/fixture browser; hitungan route bertambah sesuai route nyata |
| tests/concurrency.php | Helper barrier mendukung worker Equipment melalui allowlist; default worker Trucking dipertahankan |
| tests/browser.cjs | Menjalankan browser M3 setelah seluruh browser existing |
| tests/navigation.cjs | Memverifikasi menu kontrak nyata dan shortcut baru Admin Sewa; pembatasan role lainnya tetap |
| EQUIPMENT_DESIGN.md, EQUIPMENT_STATE_MACHINE.md, EQUIPMENT_PERMISSION_MATRIX.md, PHASE6_IMPLEMENTATION_PLAN.md | Addendum izin/perilaku M3, staging/locking/approval/KS serta batas M4–M7 |
| DATABASE_DESIGN.md, BUSINESS_RULES.md, DECISIONS.md, README.md | Menjelaskan realisasi M3, tanpa migration/grant baru dan keputusan no-self-approval |
| PROGRESS.md, CHANGELOG.md | Hasil final serta batas milestone |

Tidak mengubah migration 001–005, EquipmentPermissions, konfigurasi sensitif, generator DN/MF, layanan/controller/view Trucking, CSS global atau library. Tidak ada migration/reset/deployment.

## 7. Hasil pengujian aktual akhir

Run final selesai **24 Oktober 2026 pukul 17:34:45 WITA**.

| Rangkaian yang dijalankan | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Integrasi/HTTP dan regresi penuh T1–5 + M3 | **735** | **0** | [foundation.json](tests/results/foundation.json), failure=null, cleanup=true |
| Backend/HTTP/security/state/concurrency M3, **subset 735** | **74** | **0** | [equipment-contracts.json](tests/results/equipment-contracts.json) |
| Regresi permanen A01–A04 T5, **subset 735** | **26** | **0** | [audit-repairs.json](tests/results/audit-repairs.json) |
| Regresi fresh/populated upgrade/partial recovery/constraint/idempotency M2 | **122** | **0** | [equipment-migrations.json](tests/results/equipment-migrations.json), lima DB disposable dibersihkan |
| Browser fondasi | 108 | 0 | [browser.json](tests/results/browser.json) |
| Browser navigasi termasuk route kontrak nyata | 476 | 0 | [navigation.json](tests/results/navigation.json) |
| Browser dashboard | 724 | 0 | [dashboard-browser.json](tests/results/dashboard-browser.json) |
| Browser master | 351 | 0 | [master-browser.json](tests/results/master-browser.json) |
| Browser dokumen Trucking | 108 | 0 | [expedition-browser.json](tests/results/expedition-browser.json) |
| Browser operasional Trucking | 230 | 0 | [trucking-browser.json](tests/results/trucking-browser.json) |
| Browser Kontrak Sewa M3 | **62** | **0** | [equipment-browser.json](tests/results/equipment-browser.json) |
| Preservation development baca-saja | **86** | **0** | [equipment-development.json](tests/results/equipment-development.json) |
| Integritas development baca-saja | **230** | **0** | [database-integrity.json](tests/results/database-integrity.json) |
| Apache lokal/isolasi akun DB | **16** | **0** | [deployment.json](tests/results/deployment.json) |
| PHP lint | **101 file** | **0** | [lint.json](tests/results/lint.json) |
| JavaScript syntax | **8 file** | **0** | [javascript-lint.json](tests/results/javascript-lint.json) |

Total browser **2.059 assertion**: 1.997 existing termasuk 15 pemeriksaan navigasi tambahan untuk route nyata + 62 M3. Tidak menjumlahkan subset 74/26 sebagai kasus unik tambahan ke 735, atau 62 lagi ke 2.059. Tidak menghitung pengulangan run sebagai tambahan kasus unik.

### Cakupan backend dan HTTP M3

- Satu/multi-unit, WITH/WITHOUT, operator tanpa akun, shift berurutan dan lintas tengah malam; tanpa operator fiktif.
- Create/replay/actor berbeda, edit header DRAFT, edit detail mempertahankan versi periode, stale version, confirmed tidak diedit langsung.
- DRAFT tidak mengikat, batas tanggal inklusif, interval operator bersebelahan sah, konflik unit/operator lintas unit dan multi-unit rollback.
- KS dari tahun konfirmasi WITA (bukan tahun periode), nomor tetap pada cancel/tambahan detail, branch code terkunci pada KS pertama walaupun belum ada DN/MF.
- Unit/operator setelah confirm staged dan dikonfirmasi terotorisasi, replacement DRAFT maupun CONFIRMED berhistori.
- Extension proposal belum efektif, apply memindah pointer tanpa menimpa periode lama, konflik diperiksa ulang, approval periode lama tidak dipakai untuk extension baru.
- Cancel sebelum ACTIVE, replay tidak ganda, payload token berbeda ditolak, ACTIVE belum kembali memblokir pemakaian lain.
- Audit failure nyata melalui trigger disposable: status/unit/sequence/event/request rollback penuh; tidak ada nomor yang terpublikasi dari transaksi gagal.
- Role read-only, Admin Sewa Y positif/C extension negatif, membership dicabut, master dinonaktifkan setelah draft, CSRF/escaping/IDOR HTTP, tidak ada endpoint ACTIVE/BA.
- Cross branch tanpa approval/default grant/global bypass ditolak; requester self-approval, akun sama untuk dua pihak dan scope salah ditolak. Dua akun berizin pada cabang yang tepat berhasil, termasuk HTTP portal approval dan CSRF.
- Pencabutan mempertahankan dua identitas approver/history, tidak otomatis mengakhiri kontrak. Grant fixture dibersihkan.
- Ledger previous/next state eksplisit; seluruh row DN/Manifest/event/receipt/claim/sequence T5 tetap sama selama operasi M3. Tidak membuat BA/timesheet/keuangan.

### Konkurensi dan idempotensi nyata

Tiga skenario memakai **dua proses PHP/koneksi database terpisah**, barrier ready/go dan token nyata:

1. Dua kontrak pada unit/periode sama: **satu OK, satu CONFLICT**, bukan dua reservasi overlap.
2. Dua proses pada kontrak/token/payload sama: **keduanya OK**, hanya satu nomor/event konfirmasi/commit.
3. Dua kontrak sah pada unit berbeda: **keduanya OK**, mendapat nomor KS berbeda.

Interupsi/seed failure/drift dan dua koneksi installer M2 diuji ulang melalui suite 122. Pengujian ini tidak membuktikan seluruh pola deadlock/lintas cabang di bawah beban produksi; tidak mengklaim stress/performance test.

### Browser desktop, tablet dan mobile

Viewport **320×640, 375×812, 402×874, 768×1024, 1366×768**. Pada masing-masing: login, daftar, create DRAFT, memilih master customer/unit, menyimpan unit, confirm/nomor KS/status reservasi, histori, screenshot, cancel dan pelepasan reservasi; tanpa overflow/error JS. Owner tanpa tombol write dan tanpa akses approval juga diuji. Backend multi-unit/operator/extension/cross-approval diuji pada suite HTTP/service; tidak mengklaim semua kombinasi tersebut diulang melalui browser.

Screenshot: [320](tests/results/phase6-contract-320.png), [375](tests/results/phase6-contract-375.png), [402](tests/results/phase6-contract-402.png), [768](tests/results/phase6-contract-768.png), [1366](tests/results/phase6-contract-1366.png). Screenshot desktop/mobile ditinjau visual; antarmuka memakai panel/field/table serta navigasi existing. Bukan uji perangkat fisik/Safari.

## 8. Riwayat pelaksanaan dan koreksi selama M3

Run awal **716 PASS/0 FAIL** (55 pemeriksaan M3), dengan browser existing; file browser M3 belum menjadi bagian proses yang sudah berjalan, sehingga **tidak diklaim sebagai PASS browser M3**. Artefak awal foundation disimpan sebagai equipment-m3-initial-foundation.json. Run berikutnya 724 lalu 734 lulus dengan 62 assertion browser M3, sambil pemeriksaan backend diperkuat.

Inspeksi lanjutan menemukan jalur penggantian operator yang masih DRAFT perlu menutup draf lama dan mengizinkan konfirmasi pengganti yang terhubung ke record CANCELLED. Diperbaiki sebelum run final, dengan regresi permanen yang benar-benar dieksekusi. Jadwal CONFIRMED lama tetap tidak dibatalkan sampai pengganti berhasil; jadwal ACTIVE tetap tidak diubah M3. Histori UI diubah dari JSON teknis menjadi label/status/alasan yang terbaca; detail DRAFT mempunyai form edit, unit/operator dipilih dari master, referensi lintas cabang tidak membuka daftar master cabang lain. Tidak ada test gagal pada run akhir dan tidak mengklaim reproduksi gagal runtime untuk temuan inspeksi ini.

Error SQLSTATE 45000 yang disengaja pada fixture audit adalah uji negatif rollback, bukan kegagalan suite akhir. Tidak ada masalah M3 diselesaikan dengan reset database, perubahan histori lama, grant otomatis atau perubahan state machine BA.

## 9. Status kategori, risiko dan batas

| Kategori | Status akhir |
|---|---|
| PASS | Ruang lingkup M3 di atas, regresi T1–5/M2, concurrency/idempotency yang dijalankan, HTTP/browser/lint/integritas/preservation |
| FAIL | **0 pada run akhir** |
| BLOCKED operasional development | Approval lintas cabang memerlukan penugasan permission dan dua approver berbeda dari requester; saat ini default C tidak diberikan. Bukan bypass yang disembunyikan atau klaim alur development sudah mendapat approval |
| NOT IMPLEMENTED | M4 BA/aktivasi/pengembalian/COMPLETED/TERMINATED operasional; perubahan operator ACTIVE, M5 timesheet/verifikasi/HM, M6 halaman Equipment lain, M7 audit akhir, Finance/Invoice/pembayaran/Inventory/Petty Cash |
| NOT TESTED | MySQL 8, Safari/perangkat fisik, hosting/TLS/deployment, stress test beban produksi, seluruh kombinasi deadlock/rollover tahun, power-loss nyata/recovery manual jendela DDL ambigu M2 |

Baseline sementara tetap perlu validasi Manager. Persetujuan/delegasi C, otoritas recovery/koreksi, detail bukti/retensi/tanda tangan dan aturan setelah pengembalian tetap mengikuti desain/persetujuan milestone berikutnya; tidak dibuat sebagai asumsi M3. Kontrak CONFIRMED tidak dapat menjadi ACTIVE sampai M4 diizinkan dan BA aktual diimplementasikan. Tidak ada kompensasi/refund/invoice otomatis.

**Berhenti setelah M3. Tunggu pemeriksaan pengguna; jangan lanjut M4.**

# Matriks permission dan scope Equipment — Tahap 6

## Runtime M5 — scoped, own dan reviewer terpisah

- /equipment/timesheets: timesheet.view_scoped + create/update/submit/revise_scoped per aksi dalam transaksi, dengan cabang kontrak efektif.
- /equipment/my-timesheets: timesheet.view_own + create/update/submit/revise_own; assignment.effective_account_id dan master.account_id harus sama dengan aktor kini, membership sumber efektif dan cabang kontrak aktif. Penugasan lintas cabang yang sah hanya membuka proyeksi unit/penugasan itu, tanpa customer/sibling/full kontrak.
- /equipment/verification: verification.view untuk antrean/detail, verification.decide untuk keputusan; cabang kontrak efektif, root/revision author berbeda dari reviewer. Owner hanya baca, Administrator tidak melewati no-self, Admin Sewa tetap deny C verifikasi.
- timesheet.revise_terminal wajib untuk pembuatan/edit/revisi data terminal dengan alasan. Submit draft lama yang tidak diubah memakai izin submit biasa; perubahan terminal baru tetap terikat flag snapshot dan grant khusus. Tidak seed C. Meter/fakta BA khusus tetap BLOCKED.

Route scoped dan own dipisahkan agar registry permission existing tetap eksplisit; tidak menambah permission OR/global bypass atau grant role baru. Semua POST memakai CSRF dan backend guard; menu bukan otorisasi.

## Runtime M4 — tanpa perubahan seed/grant

GET/POST /equipment/handovers memerlukan equipment.handover.view dan permission aksi backend dalam transaksi. HANDOVER juga contract.activate; RETURN NORMAL contract.close, EARLY contract.terminate dan alasan. Upload evidence.add; unduh evidence.view plus BA penuh/cabang efektif. Own grant Operator tidak membuka BA multi-unit, print atau unduh penuh; projection own untuk konteks penugasan/timesheet belum menjadi halaman M4. Owner baca saja dalam scope.

handover.correct tetap C tanpa grant; implementasi addendum diuji dengan grant sementara hanya DB disposable. handover.fact_correct/meter.correct tetap tanpa workflow sampai SOP khusus. recovery.close hanya pengecualian sumber nonaktif pada return, wajib alasan/audit dan tidak melewati scope cabang kontrak. Tidak menambahkan grant C/default/global bypass atau endpoint M5.

## Mandat M3 — 24 Oktober 2026

M1–M2 telah lulus dan pengguna mengizinkan **M3 Kontrak Sewa multi-unit/reservasi beserta antarmuka Kontrak Sewa**. Catatan batas M1–M2 di bawah adalah riwayat. Tidak mengizinkan M4–M7, Finance atau deployment.

Implementasi M3 memakai eq_* existing tanpa migration baru: DRAFT header/customer/proyek, detail unit dan periode, WITH/WITHOUT dan penugasan operator; konfirmasi header/detail, KS saat konfirmasi header, cancellation pra-ACTIVE, serta histori event/audit/request atomik. DRAFT tambahan setelah header confirm belum mengikat; konfirmasi detail menerapkan semua guard tanpa nomor KS baru. Edit detail DRAFT menambah versi periode, tidak menghapus versi sebelumnya.

Perpanjangan dua langkah: usulan eq_unit_periods EXTENSION belum efektif, lalu penerapan terotorisasi memeriksa konflik/versi/approval kembali dan memindah pointer current_period_id atomik. Penugasan pengganti memakai previous_assignment_id. Pengganti DRAFT membatalkan draf lama dengan histori; pengganti CONFIRMED tetap DRAFT sampai konfirmasi pengganti membatalkan jadwal lama dan mengikat jadwal baru atomik. Perubahan operator yang sudah ACTIVE menunggu alur BA/pengembalian; M3 tidak membuat lifecycle baru.

Tanggal sewa inklusif, operator [awal,akhir), shift lintas tengah malam sah. Unit DRAFT tidak mereservasi. Unit ACTIVE yang belum kembali menolak reservasi berikutnya walaupun tanggal rencana berbeda. Semua sumber dikunci melalui row master yang stabil sebelum pemeriksaan konflik current locking read, termasuk saat kalender reservasi awal kosong; semua detail batch rollback jika ada satu kegagalan.

Lintas cabang terikat unit/operator, kontrak dan versi periode. Request dari cabang kontrak, persetujuan pihak pemilik dan pengelola dari dua akun berbeda. Mandat M3 menegaskan **tidak boleh self-approval**: pemohon bukan salah satu approver. Role/akun global tidak melewati guard ini. Kedua approver tetap aktif/berizin/bercakupan ketika konfirmasi dijalankan. Pencabutan menyimpan histori/aktor/alasan dan tidak otomatis mengakhiri kontrak. **Semua C tetap tanpa grant default**. Penugasan permission approval harus eksplisit; fixture uji mendapat grant sementara hanya di DB disposable lalu dibersihkan.

Route nyata: GET/POST /equipment/contracts (equipment.contract.view + permission aksi) dan GET/POST /equipment/authorizations (equipment.cross_branch.approve). Portal approval hanya memproyeksikan sumber/periode/cabang/alasan yang relevan, tanpa customer atau full kontrak cabang lain. Own Operator tidak memperoleh full contract.view dari view_own. Satu menu Kontrak Sewa di registry existing, shortcut Admin Sewa; tidak membuat menu BA/Timesheet/Verifikasi atau halaman Equipment lain.

KS/{KODE_CABANG}/{TAHUN}/{000001} diterbitkan memakai waktu konfirmasi WITA/counter KS tersendiri, bukan periode rental. Cancel tidak menghapus nomor. Guard kode cabang kini mengenali eq_document_sequences selain exp_sequences dengan lock cabang yang sama. Generator DN/MF tidak diubah. Semua POST memakai CSRF router; permission/scope/master/state/version diperiksa server dalam transaksi. Token acak terikat actor/action/payload/branch, replay tidak mengulang nomor/event. Named lock per request key melindungi first-use token yang sama pada dua koneksi; transaksi/row lock menjaga konflik kalender dan sequence. Deadlock/constraint ditolak 409 dengan rollback penuh dan retry token yang sama.

Hasil aktual pengujian, file berubah, status grant development dan batas fitur dicatat pada PHASE6_M3_REPORT.md. Berhenti setelah M3; transisi ACTIVE/COMPLETED/TERMINATED operasional, BA, timesheet/verifikasi, halaman Equipment lainnya dan audit akhir belum diimplementasikan.

24 Oktober 2026. **Baseline G01–G12 disetujui; M2 memasang katalog dan grant Y/O, C hanya definisi tanpa grant sesuai jawaban pengguna.** Baseline operasi di [EQUIPMENT_DESIGN.md](EQUIPMENT_DESIGN.md), transisi di [EQUIPMENT_STATE_MACHINE.md](EQUIPMENT_STATE_MACHINE.md). G01–G12 mengikuti register desain. Tidak mengubah grant T1–5, tidak membuat role Manager otomatis.

## Prinsip akses

- Grant DB per aksi + scope efektif + hubungan sumber + state/version. Nama role hanya dasar usulan seed, bukan bypass runtime. all_branches tidak otomatis memberi izin lintas cabang atau approval.
- Penetapan efektif mengikuti fondasi: akun aktif/auth_version sesuai, grant terkini, cabang aktif dan user_branches masih ada, atau cakupan global sesuai kebijakan. Tidak mengarang kolom membership.active baru.
- Cabang kontrak mengelola dokumen; cabang pemilik unit/operator tetap identitas sumber. Lintas cabang perlu record persetujuan eksplisit terikat detail/sumber/periode; akses ke satu unit pinjaman tidak memberikan akses seluruh master, customer atau kontrak cabang lain.
- Operator berakun hanya assignment yang sah dan miliknya sendiri; pencocokan lewat ID, bukan nama/email bebas. Operator tanpa akun tidak diberi akun dummy. Admin Sewa mencatat dengan actor_id sendiri, performed_by dari personel penugasan.
- Self-approval tetap dilarang bagi seluruh role termasuk Administrator. Delegasi baru, override penutupan master nonaktif, revisi pascaterminal dan approval lintas cabang harus permission/kebijakan eksplisit (G05/G07/G10/G12).

## Katalog permission M2

Prefix **equipment.** terpisah dari master.* dan expedition.*. Simbol: **Y** grant sesuai scope; **O** grant hanya own assignment/root yang diizinkan; **C** belum mendapat grant; **—** deny. C **tidak boleh disemai sebagai grant otomatis**. Rincian author root/revisi mengikuti G07.

| Permission U | Administrator | Admin Sewa | Operator Alat Berat | Owner | Finance / Gudang / Customer / petugas Trucking |
|---|---|---|---|---|---|
| equipment.unit.view | Y | Y | — | Y | — |
| equipment.unit.view_own | — | — | O | — | — |
| equipment.contract.view | Y | Y | — | Y | — |
| equipment.contract.view_own | — | — | O, ringkasan penugasan saja | — | — |
| equipment.contract.create | Y | Y | — | — | — |
| equipment.contract.update | Y | Y, draf sesuai cabang | — | — | — |
| equipment.contract.confirm | Y | Y | — | — | — |
| equipment.contract.activate | Y | Y | — | — | — |
| equipment.contract.close | Y | Y | — | — | — |
| equipment.contract.cancel | Y | Y | — | — | — |
| equipment.contract.terminate | Y | C | — | — | — |
| equipment.contract.extend | Y | C | — | — | — |
| equipment.assignment.manage | Y | Y | — | — | — |
| equipment.handover.view | Y | Y | — | Y | — |
| equipment.handover.view_own | — | — | O, detail unit sendiri | — | — |
| equipment.handover.create | Y | Y | — | — | — |
| equipment.handover.update | Y | Y, DRAFT | — | — | — |
| equipment.handover.confirm | Y | Y | — | — | — |
| equipment.handover.cancel | Y | Y, DRAFT saja | — | — | — |
| equipment.handover.correct | C | C | — | — | — |
| equipment.timesheet.view_scoped | Y | Y | — | Y | — |
| equipment.timesheet.view_own | — | — | O | — | — |
| equipment.timesheet.create_scoped | Y | Y | — | — | — |
| equipment.timesheet.create_own | — | — | O | — | — |
| equipment.timesheet.update_scoped | Y | Y, DRAFT | — | — | — |
| equipment.timesheet.update_own | — | — | O, DRAFT | — | — |
| equipment.timesheet.submit_scoped | Y | Y | — | — | — |
| equipment.timesheet.submit_own | — | — | O | — | — |
| equipment.timesheet.revise_scoped | Y | Y | — | — | — |
| equipment.timesheet.revise_own | — | — | O | — | — |
| equipment.verification.view | Y | C | — | Y, histori baca | — |
| equipment.verification.decide | Y, bukan pembuat | C, bukan pembuat | — | — | — |
| equipment.cross_branch.request | Y | Y | — | — | — |
| equipment.cross_branch.approve | C | C | — | — | — |
| equipment.evidence.view | Y | Y | — | Y | — |
| equipment.evidence.view_own | — | — | O, target sendiri | — | — |
| equipment.evidence.add | Y | Y, sesuai target/state | — | — | — |
| equipment.evidence.add_own | — | — | O, revisi sendiri sesuai G08 | — | — |

M2 memasang grant Y/O sebagai metadata RBAC, tanpa endpoint Equipment. Grant tidak memberi bypass guard G01–G12 yang wajib diterapkan pada M3–M5. Owner hanya baca dalam scope, tidak approve karena jabatan. Finance tidak memperoleh akses operasional hanya untuk menyiapkan fitur invoice yang di luar tahap; kebutuhan membaca approved source masa depan harus dimandatkan terpisah. Grant master existing tidak diperluas otomatis.

Dengan pemisahan *_own dan grant scoped pada katalog ini, guard endpoint memilih cabang kebijakan berdasarkan grant aktual, **bukan mengubah ID yang dikirim klien agar dianggap own**. equipment.contract.view_own dan equipment.handover.view_own adalah projection terbatas untuk konteks timesheet/penugasan, bukan izin mengunduh dokumen full berisi semua unit/customer/bukti.

## Matriks scope dan proyeksi data

| Konteks | Syarat baca | Syarat mutasi |
|---|---|---|
| Kontrak dan customer | Grant contract.view dan cabang kontrak efektif; Operator hanya identitas kontrak/unit/periode penugasannya | Grant aksi terkait, cabang kontrak efektif, state/version dan master terkini; bukan sekadar berada di cabang pemilik salah satu unit |
| Detail unit milik cabang kontrak | Grant dan cakupan cabang sesuai | Cek kind=equipment/active untuk penetapan baru, periode/jadwal; owner branch dari DB, bukan POST |
| Unit/operator lintas cabang | Pilihan konteks hanya sumber yang diizinkan oleh persetujuan valid; daftar master cabang lain tidak dibuka secara umum | Cabang kontrak efektif + permission aksi + persetujuan owner/contract yang sah dan mencakup sumber/periode; G05 menentukan authority, tidak menganggap global sudah cukup |
| Pihak cabang pemilik sumber | Projection unit/periode/request otorisasi yang menyangkut sumber sendiri | Hanya menyetujui sumber dalam kewenangannya bila grant approve dan kebijakan G05 terpenuhi; tidak otomatis edit keseluruhan kontrak |
| BA seluruh kontrak/multi-unit | Pembaca full perlu scope kontrak; Operator hanya detail unit sendiri dengan informasi pihak lain disembunyikan | Grant handover dan seluruh sumber yang diproses sah. U: confirm HANDOVER membutuhkan contract.activate; RETURN membutuhkan contract.close atau terminate sesuai efek. Tidak konfirmasi sebagian secara diam-diam |
| Timesheet Operator | Grant own, assignment.operator_id → personel/account aktor sah dan sesuai kebijakan G11; root/periode terkait | DRAFT/revisi eligible, own assignment, interval dalam jadwal; tidak boleh memakai operator_id lain di POST. WITHOUT bukan pekerjaan own operator |
| Timesheet Admin Sewa | Grant scoped dan cabang kontrak; boleh operator berakun/tanpa akun atau WITHOUT | Aktor aktual dicatat terpisah dari operator pelaksana; kewenangan mencatat tidak memberi izin approve diri sendiri |
| Verifikasi | Grant view sesuai cabang, revisi eligible; Owner baca histori, bukan inbox untuk bertindak | Grant decide, bukan pembuat sesuai G07, versi/hash/submission masih sama; grant create/submit bukan grant approve |
| Bukti privat | Grant evidence.view atau evidence.view_own sesuai jenis proyeksi **dan** hak target/revisi/detail saat ini | Grant add/add_own sesuai cakupan + hak target/state; file tidak dapat dipindahkan ke target/cabang lain lewat ID. BA full multi-unit tidak diunduh Operator jika dapat membocorkan unit lain; gunakan proyeksi tanpa file full |
| Perpanjangan/penghentian | Hak kontrak/detail serta histori | Grant extend/terminate + cross-approval untuk revisi periode; tidak memperluas izin hanya karena tahu nomor KS |
| Penutupan saat master nonaktif | Histori tetap dapat dibaca oleh yang berwenang | G10: jalur recovery terkontrol yang terpisah; jangan memberi bypass actor/grant/cabang hanya karena ingin menutup kontrak |

Pemilihan personel tidak memerlukan membuka daftar seluruh akun. ID personel aktif dipakai; untuk membaca/pilih user link berlaku permission fondasi yang sudah ada. Tidak memberikan users.view/global kepada Admin Sewa hanya agar dropdown operator berfungsi.

## Rancangan otorisasi eksplisit lintas cabang (G05)

U: request mencatat kontrak/detail, resource type/id (unit/operator), branch pemilik dan branch kontrak, periode/revisi, tujuan/alasan, requester. Approval dari pihak owner dan kontrak tercatat dengan actor/time/keputusan; tidak boleh memalsukan owner_branch atau menyetujui resource di luar scope. G05 mengharuskan dua akun berbeda walaupun satu akun memiliki dua cabang/all_branches; dua klik akun sama ditolak.

Perubahan sumber/perpanjangan di luar rentang yang disetujui membutuhkan persetujuan tambahan sebelum commit. Record persetujuan tidak mengubah cabang pemilik master. Pencabutan menolak penetapan/extension baru, menyimpan histori, dan tidak mengakhiri sewa aktif otomatis; prosedur akhir mengacu G10. Tidak ada izin lintas cabang implisit dari Administrator, Owner, all_branches atau keberadaan tombol.

## Pemeriksaan backend, UI dan uji negatif

Daftar, pencarian, pagination, detail, pilihan FK, timeline, bukti dan aksi POST memakai scope yang sama. Kasus campuran unit beberapa cabang harus discope pada query/projection; jangan memuat seluruh header-detail lalu sekadar menyembunyikan tombol. Request key/replay juga diperiksa akses kini. Pesan bentrok jadwal tidak membocorkan nama customer/kontrak/pegawai pihak yang tidak diizinkan.

UI hanya menawarkan aksi sesuai grant/state; sidebar/drawer/bottom nav dari registry existing tanpa menu ber-route kosong. Grant katalog M2 diuji pada database terisolasi; guard runtime Equipment belum diimplementasikan/diuji. Rencana uji kelak mencakup semua role existing, global vs scoped, grant dicabut setelah form terbuka, membership/cabang/personel nonaktif, own ID diganti, approval diri sendiri, lintas cabang tanpa approval/kedaluwarsa/periode berubah, file multi-unit, dan token replay oleh aktor lain. Tidak menambah grant Customer/Finance agar menu terlihat.


## Permission khusus dan keputusan grant

Tambahan teknis yang diturunkan dari G03/G08/G10/G11/G12 (definisi saja, tidak otomatis memberi grant):

| Permission | Kegunaan | Grant M2 |
|---|---|---|
| equipment.handover.correct | Koreksi administratif BA, tanpa mengulang efek unit | C, deny |
| equipment.handover.fact_correct | Koreksi fakta operasional dengan prosedur khusus | C, deny |
| equipment.cross_branch.approve | Approval sumber/periode dari pihak owner/kontrak, wajib dua akun | C, deny |
| equipment.recovery.close | Recovery return/close sumber nonaktif dengan audit pengecualian | C, deny |
| equipment.meter.correct | Koreksi reset/penggantian HM dengan alasan/bukti/otorisasi | C, deny |
| equipment.timesheet.revise_terminal | Revisi pascaterminal tanpa mengaktifkan kontrak | C, deny |
| equipment.operator.relink | Penautan ulang akun eksplisit, tidak membuka histori otomatis | C, deny |

Katalog total **43 permission baru**; 38 pada tabel utama dan lima definisi tambahan (handover.correct/cross_branch.approve sudah ada pada tabel utama). Grant biasa: Administrator 26, Admin Sewa 22, Operator Alat Berat 10 (own), Owner 6 (baca). Finance/Gudang/Customer/petugas Trucking 0 grant Equipment. Sel C untuk Admin Sewa contract.terminate/extend/verification.view/decide tetap deny. Administrator verification.view/decide adalah Y sesuai matriks, tetap bukan pembuat root/revisi. Semua kode C khusus tanpa grant sesuai keputusan eksplisit pengguna: jangan seed grant C; definisi permission saja. Tidak ada role Manager baru atau akun palsu.

Cakupan efektif harus diperiksa kembali oleh service nanti: grant database, akun/session valid, cabang aktif/penetapan terkini, assignment/personel/account sah. Foreign key dan seed bukan pengujian runtime RBAC. Tidak menambahkan route/menu kosong agar permission terlihat berfungsi. Penomoran, approval, immutable BA/timesheet, download/evidence dan scope Equipment adalah M3–M6 yang belum diizinkan.

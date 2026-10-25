# State machine Equipment — baseline Tahap 6

## Runtime M5 — transisi revisi dan pointer

Baru → DRAFT, DRAFT → SUBMITTED, SUBMITTED → APPROVED/RETURNED/REJECTED. Revisi terminal tidak dikembalikan menjadi DRAFT; perbaikan selalu row baru dengan previous_revision_id dan alasan. Satu pending DRAFT/SUBMITTED per root. Submit membekukan hash; keputusan mengikat revision/version/hash yang diperiksa. Reviewer != root_created_by dan created_by revisi. APPROVED baru memindah effective_approved_revision_id dan melepas pending atomik; RETURNED/REJECTED melepas pending tanpa mengubah approved efektif lama. Tidak ada perubahan lifecycle unit/operator/kontrak oleh timesheet.

CONFIRMED operator dapat dipakai tanpa aktivasi rekaan sesuai klarifikasi M5. Setelah RETURN, root historis yang dibuat sah tetap dapat diproses berdasarkan snapshot; root pertama CANCELLED tidak dibuat. Root baru/edit/revisi setelah terminal memerlukan grant khusus/alasan; submit draft lama tanpa edit dan verifikasi fakta tidak mengarang revisi baru. Reset HM/fakta BA tetap BLOCKED. Hasil transisi/race/HTTP/browser aktual: PHASE6_M5_REPORT.md.

## Runtime M4 — mandat terbaru

M4 kini diizinkan; bagian larangan M4 pada riwayat M1–M3 di bawah telah digantikan mandat pengguna. DRAFT BA → CONFIRMED menerbitkan nomor BA. HANDOVER mengubah hanya unit CONFIRMED terpilih → ACTIVE dan actual_start; RETURN mengubah hanya unit ACTIVE terpilih → COMPLETED/NORMAL atau TERMINATED/EARLY dan actual_end. Seluruh batch, operator, aggregate, nomor, token dan audit atomik. Confirmed tidak dapat diedit/cancel langsung. Koreksi administratif adalah BA baru correction_of_id dengan NULL lifecycle_effect dan semua fakta sumber tetap; koreksi fakta operasional BLOCKED.

Operator CONFIRMED yang intervalnya mencakup HANDOVER → ACTIVE; lainnya tetap CONFIRMED, tidak otomatis aktif oleh jam. RETURN: ACTIVE → COMPLETED/TERMINATED, DRAFT/CONFIRMED yang belum mulai → CANCELLED berhistori. Tidak mengarang actual_start bagi penugasan yang belum terjadi. Header tetap ACTIVE jika masih ada detail belum selesai; seluruh detail/penugasan terminal → COMPLETED atau TERMINATED jika ada EARLY. Agregat juga diperiksa setelah pembatalan sah detail terakhir yang belum diserahkan, dengan permission close/terminate. Akhir tanggal bukan trigger.

## Mandat M3 — 24 Oktober 2026

M1–M2 telah lulus dan pengguna mengizinkan **M3 Kontrak Sewa multi-unit/reservasi beserta antarmuka Kontrak Sewa**. Catatan batas M1–M2 di bawah adalah riwayat. Tidak mengizinkan M4–M7, Finance atau deployment.

Implementasi M3 memakai eq_* existing tanpa migration baru: DRAFT header/customer/proyek, detail unit dan periode, WITH/WITHOUT dan penugasan operator; konfirmasi header/detail, KS saat konfirmasi header, cancellation pra-ACTIVE, serta histori event/audit/request atomik. DRAFT tambahan setelah header confirm belum mengikat; konfirmasi detail menerapkan semua guard tanpa nomor KS baru. Edit detail DRAFT menambah versi periode, tidak menghapus versi sebelumnya.

Perpanjangan dua langkah: usulan eq_unit_periods EXTENSION belum efektif, lalu penerapan terotorisasi memeriksa konflik/versi/approval kembali dan memindah pointer current_period_id atomik. Penugasan pengganti memakai previous_assignment_id. Pengganti DRAFT membatalkan draf lama dengan histori; pengganti CONFIRMED tetap DRAFT sampai konfirmasi pengganti membatalkan jadwal lama dan mengikat jadwal baru atomik. Perubahan operator yang sudah ACTIVE menunggu alur BA/pengembalian; M3 tidak membuat lifecycle baru.

Tanggal sewa inklusif, operator [awal,akhir), shift lintas tengah malam sah. Unit DRAFT tidak mereservasi. Unit ACTIVE yang belum kembali menolak reservasi berikutnya walaupun tanggal rencana berbeda. Semua sumber dikunci melalui row master yang stabil sebelum pemeriksaan konflik current locking read, termasuk saat kalender reservasi awal kosong; semua detail batch rollback jika ada satu kegagalan.

Lintas cabang terikat unit/operator, kontrak dan versi periode. Request dari cabang kontrak, persetujuan pihak pemilik dan pengelola dari dua akun berbeda. Mandat M3 menegaskan **tidak boleh self-approval**: pemohon bukan salah satu approver. Role/akun global tidak melewati guard ini. Kedua approver tetap aktif/berizin/bercakupan ketika konfirmasi dijalankan. Pencabutan menyimpan histori/aktor/alasan dan tidak otomatis mengakhiri kontrak. **Semua C tetap tanpa grant default**. Penugasan permission approval harus eksplisit; fixture uji mendapat grant sementara hanya di DB disposable lalu dibersihkan.

Route nyata: GET/POST /equipment/contracts (equipment.contract.view + permission aksi) dan GET/POST /equipment/authorizations (equipment.cross_branch.approve). Portal approval hanya memproyeksikan sumber/periode/cabang/alasan yang relevan, tanpa customer atau full kontrak cabang lain. Own Operator tidak memperoleh full contract.view dari view_own. Satu menu Kontrak Sewa di registry existing, shortcut Admin Sewa; tidak membuat menu BA/Timesheet/Verifikasi atau halaman Equipment lain.

KS/{KODE_CABANG}/{TAHUN}/{000001} diterbitkan memakai waktu konfirmasi WITA/counter KS tersendiri, bukan periode rental. Cancel tidak menghapus nomor. Guard kode cabang kini mengenali eq_document_sequences selain exp_sequences dengan lock cabang yang sama. Generator DN/MF tidak diubah. Semua POST memakai CSRF router; permission/scope/master/state/version diperiksa server dalam transaksi. Token acak terikat actor/action/payload/branch, replay tidak mengulang nomor/event. Named lock per request key melindungi first-use token yang sama pada dua koneksi; transaksi/row lock menjaga konflik kalender dan sequence. Deadlock/constraint ditolak 409 dengan rollback penuh dan retry token yang sama.

Hasil aktual pengujian, file berubah, status grant development dan batas fitur dicatat pada PHASE6_M3_REPORT.md. Berhenti setelah M3; transisi ACTIVE/COMPLETED/TERMINATED operasional, BA, timesheet/verifikasi, halaman Equipment lainnya dan audit akhir belum diimplementasikan.

24 Oktober 2026, WITA. **G01–G12 disetujui sebagai baseline sementara V2, belum SOP resmi perusahaan.** Sumber keputusan lengkap: EQUIPMENT_DESIGN.md. Mandat implementasi saat ini hanya M1–M2; tabel transisi berikut adalah kontrak implementasi M3–M5, belum workflow runtime.

## Invariant

- Header kontrak, detail unit, assignment operator, BA, root/revisi timesheet dan verification adalah entitas terpisah.
- Tanggal sewa inklusif; operator dan interval kerja [awal,akhir) menggunakan datetime lengkap WITA, termasuk lintas tengah malam. DRAFT tidak mereservasi; CONFIRMED memulai reservasi.
- Unit/operator tidak boleh overlap. Unit belum kembali tetap digunakan walaupun tanggal berakhir; keterlambatan terlihat. Aktivasi kontrak berikut ditolak selama unit masih aktif pada kontrak sebelumnya.
- Header tidak terminal selama ada detail/operator/penugasan aktif atau belum selesai. Tanggal lewat bukan pemicu penyelesaian.
- Seluruh transisi memeriksa permission, active membership/cakupan, master terkini untuk penugasan baru, source/version dan persetujuan lintas cabang. Perubahan, event, audit, request-result dan nomor commit atomik.
- Tidak ada transisi keuangan, pengubahan histori, terminal → ACTIVE atau bypass Administrator/Owner/all_branches.

## Kontrak

| Dari | Aksi | Ke | Guard/efek |
|---|---|---|---|
| DRAFT | Konfirmasi | CONFIRMED | Semua detail/period/operator valid, master aktif, konflik dan cross-approval diperiksa atomik; terbit KS, mulai reservasi |
| CONFIRMED | Konfirmasi BA HANDOVER pertama | ACTIVE | BA wajib; hanya detail CONFIRMED yang tercakup berubah ACTIVE |
| DRAFT/CONFIRMED | Pembatalan sebelum pernah aktif | CANCELLED | Alasan, histori, pelepasan reservasi yang belum berjalan; nomor terbit tetap |
| ACTIVE | Return subset | ACTIVE | Efek hanya unit terkait; header belum terminal bila masih ada detail terbuka |
| CONFIRMED/ACTIVE | Tambah detail/extension | State sama | Proses diotorisasi dan tercatat; detail/periode baru melewati seluruh guard reservasi/cross-branch |
| ACTIVE | Minta penghentian awal | ACTIVE | Intent/alasan berhistori; belum menyatakan pengembalian |
| ACTIVE | Tutup normal | COMPLETED | Seluruh detail dan operator terminal, semua actual return yang diwajibkan sah |
| ACTIVE | Selesaikan penghentian | TERMINATED | Seluruh detail/operator terminal, actual return sah, intent/alasan tersimpan |

COMPLETED/CANCELLED/TERMINATED terminal. Koreksi timesheet pascaterminal dengan permission khusus/alasan/audit tidak mengaktifkan kontrak/reservasi. Satu detail yang cancelled tidak menentukan status header; agregasi diperiksa di bawah lock header dan seluruh detail terkait, bukan MAX/MIN string status.

## Detail unit dan periode

| Dari | Aksi | Ke/efek |
|---|---|---|
| DRAFT | Konfirmasi kontrak/detail tambahan | CONFIRMED, reservasi periode efektif |
| CONFIRMED | Konfirmasi BA HANDOVER aktual | ACTIVE, actual_start |
| ACTIVE | Konfirmasi BA RETURN normal | COMPLETED, actual_end, seluruh operator terkait diselesaikan |
| ACTIVE | BA RETURN penghentian dini sah | TERMINATED, akhir aktual/alasan, histori tetap |
| DRAFT/CONFIRMED | Pembatalan beralasan | CANCELLED; tidak boleh membatalkan detail ACTIVE |
| CONFIRMED/ACTIVE | Extension/perubahan periode | State sama; append eq_unit_periods, previous pointer, current pointer atomik; cek konflik dan approval tambahan |

Satu unit fisik hanya satu detail nonterminal dalam kontrak yang sama. Extension bukan detail duplikat. Tidak mengganti asset_id detail confirmed diam-diam. Master nonaktif menolak penugasan baru; sumber yang berjalan tetap terbaca, return/close sah melalui recovery berotorisasi dengan audit pengecualian. Recovery tidak menghilangkan permission/scope/self-approval.

## Assignment operator

| Dari | Aksi | Ke/guard |
|---|---|---|
| DRAFT | Konfirmasi | CONFIRMED; personel operator aktif, sumber/periode sah, interval tidak overlap, persetujuan lintas cabang lengkap |
| CONFIRMED | Mulai aktual | ACTIVE; unit sudah ACTIVE melalui BA HANDOVER |
| ACTIVE | Selesai aktual | COMPLETED; tidak otomatis menyelesaikan unit |
| DRAFT/CONFIRMED | Batalkan sebelum mulai | CANCELLED; alasan/histori, jadwal tidak dihapus |
| ACTIVE | Akhiri lebih awal secara sah | TERMINATED; aktual/alasan, tidak mengarang return unit |

Perubahan jadwal confirmed memakai record pengganti berhubungan previous_assignment_id, bukan menulis ulang histori. Beberapa operator per unit berurutan tidak bertabrakan; WITHOUT tidak membuat assignment/operator palsu. Operator tanpa akun tetap md_personnel; Admin Sewa berizin mencatat sebagai aktor sebenarnya. Link/relink akun eksplisit dan diaudit; akun baru tidak otomatis memperoleh histori lama.

## BA

| Dari | Aksi | Ke/efek |
|---|---|---|
| DRAFT | Edit detail/kondisi | DRAFT; tanpa nomor/efek lifecycle |
| DRAFT | Confirm HANDOVER | CONFIRMED + BA resmi; semua detail CONFIRMED → ACTIVE atomik |
| DRAFT | Confirm RETURN | CONFIRMED + BA resmi; semua detail ACTIVE → COMPLETED/TERMINATED sesuai penyelesaian sah atomik |
| DRAFT | Cancel beralasan | CANCELLED; tanpa efek pada unit |
| CONFIRMED | Koreksi administratif | Row lama tetap immutable; dokumen koreksi baru menunjuk BA lama; tidak mengulang HANDOVER/RETURN |

ALL diekspansi dan dibekukan menjadi ID detail nyata; tidak berubah ketika unit ditambahkan kemudian. Satu kontrak dan satu jenis per BA. Satu unit invalid menggagalkan seluruh batch. Unique lifecycle_effect mencegah efek awal diulang lewat BA berbeda; koreksi memakai NULL effect. Tidak ada direct cancel confirmed setelah efek lifecycle. Koreksi fakta operasional memerlukan prosedur khusus, histori dan otorisasi; tidak membangun reversal otomatis sebagai asumsi. Bukti privat dan akses terotorisasi.

## Timesheet, revisi dan verification

Root: satu unit/assignment operator/tanggal kerja; WITHOUT menggunakan NULL assignment yang dinormalisasi. Revisi memuat beberapa interval datetime penuh dan break, jam kerja terpisah dari HM. HM opsional berpasangan, normal tidak menurun; reset/replacement memakai koreksi khusus dengan alasan, bukti, otorisasi. Tidak menghasilkan tarif/tagihan.

| Dari | Aksi | Ke/efek |
|---|---|---|
| Baru | Buat konten | DRAFT; own assignment sah atau scoped Admin Sewa, hanya satu pending root |
| DRAFT | Submit | SUBMITTED; validasi jadwal/jam/HM/master/scope; bekukan isi/hash |
| SUBMITTED | Approve | APPROVED; reviewer berbeda dari pembuat root DAN revisi, termasuk Administrator; keputusan/event/audit/pointer efektif atomik |
| SUBMITTED | Return | RETURNED; alasan wajib; approved sebelumnya tetap efektif |
| SUBMITTED | Reject | REJECTED; alasan wajib; approved sebelumnya tetap efektif |
| APPROVED/RETURNED/REJECTED | Koreksi | **Row DRAFT baru**, previous/base-approved pointer dan alasan; row sebelumnya tidak berubah |

Tidak ada RETURNED/REJECTED → DRAFT pada row lama. SUBMITTED tidak dapat diedit langsung. Maksimal satu DRAFT/SUBMITTED per root. Approve koreksi memastikan base-approved masih efektif dan versi/hash sama; pointer approved berpindah atomik, approved lama tetap utuh. Pending/rejected tidak menghilangkan approved efektif. Revisi setelah kontrak terminal memerlukan permission khusus/alasan/audit dan tidak membuat reservasi ulang.

## Dukungan dan batas M2

FK komposit melarang pointer sibling/root/kontrak berbeda; generated unique menjaga detail aktif, root NULL dan satu revisi pending; CHECK reviewer/approval dua akun menjaga invariant lokal. **Belum ada enforcement service state machine, immutable history, overlap kalender, lifecycle BA/aggregate, replay/audit bisnis atau own-scope runtime Equipment pada M2.** HTTP yang ada hanya Tahap 1–5. Uji seluruh transisi/race/CSRF/security Equipment wajib pada M3–M7; keberadaan constraint tidak membuktikan seluruh workflow PASS.

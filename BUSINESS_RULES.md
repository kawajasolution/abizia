# Aturan bisnis dan daftar keputusan

## M5 Equipment — Timesheet dan Verifikasi

Root per unit/penugasan/tanggal kerja, WITHOUT memakai NULL assignment. WITH harus menunjuk assignment sah milik unit; operator tanpa akun dicatat petugas scoped berizin, tanpa akun dummy. Own Operator dicocokkan dengan effective_account_id assignment dan account_id master kini, bukan nama; relink tidak memberikan histori lama otomatis. Own lintas cabang dibatasi penugasan berotorisasi dan membership sumber, dengan proyeksi tanpa customer/seluruh kontrak; scoped/reviewer memakai cabang kontrak efektif.

Beberapa interval [mulai,akhir) datetime WITA, termasuk lintas malam; interval dalam revisi tidak overlap, batas berdampingan sah. Istirahat integer menit, >=0 dan tidak melebihi durasi. Total bersih dihitung sebagai detik integer dari interval dikurangi istirahat, ditampilkan jam:menit:detik tanpa pembulatan atau tarif. HM opsional berpasangan/nonnegatif/end>=start, tiga desimal, terpisah dari jam. work_date mengikuti awal interval pertama; awal interval lain hari itu atau hari berikutnya, tetap dalam periode efektif/penggunaan aktual/jadwal operator. Tidak membuat lifecycle operator dari timesheet.

Draft dapat diedit secara terotorisasi dengan versi root/revisi dan before/after audit. SUBMITTED tidak dapat diedit; content_hash mengikat konten, root dan snapshot. Verifikasi APPROVED/RETURNED/REJECTED dengan permission backend/cabang dan reviewer berbeda dari pembuat root DAN revisi, termasuk Administrator. RETURNED/REJECTED wajib alasan. Perbaikan/revisi approved membuat revisi baru; maksimal satu DRAFT/SUBMITTED per root. Approved lama tetap efektif sampai pengganti approved commit atomik. Pekerjaan submitted/approved efektif lintas root pada unit/operator yang sama tidak boleh overlap; draft belum menjadi sumber efektif.

Root baru/edit/revisi terminal memerlukan equipment.timesheet.revise_terminal dan alasan, tanpa reaktivasi sumber. Draft yang dibuat sebelum terminal boleh dikirim tanpa edit sesuai snapshot sah; verifikasi tidak mengubah fakta menjadi revisi baru. Penugasan CANCELLED oleh RETURN tetap dapat dipakai histori root yang dibuat sah sebelumnya; root pertama CANCELLED tetap ditolak. Koreksi/reset HM dan fakta BA tetap BLOCKED. Tidak membuat invoice, tarif otomatis atau sumber Finance baru.

## M4 Equipment — BA aktual per unit

BA satu kontrak/satu jenis, DRAFT dapat diedit/dibatalkan beralasan. ALL dibekukan menjadi ID detail yang memenuhi syarat saat penyimpanan; tambahan unit berikutnya tidak ikut diam-diam. Konfirmasi memeriksa ulang seluruh unit, sumber/master, scope, versi, reservasi dan approval; satu kegagalan membatalkan batch, nomor, event dan audit.

HANDOVER hanya CONFIRMED → ACTIVE dalam periode efektif, actual_start dicatat per unit. RETURN hanya ACTIVE → COMPLETED (NORMAL) atau TERMINATED (EARLY beralasan/permission khusus), actual_end tidak mendahului actual_start. HM opsional nonnegatif sampai tiga desimal; HM RETURN tidak boleh menurun dari HANDOVER tanpa prosedur meter khusus yang belum dibuat. Tidak menebak jam kerja atau tarif dari HM.

Header ACTIVE selama masih ada detail DRAFT/CONFIRMED/ACTIVE; terminal hanya setelah semua detail dan operator selesai. Pengembalian sebagian tidak menyelesaikan unit lain. Setelah return sah, pembatalan sah detail terakhir yang belum mulai juga menghitung agregat di bawah lock dan permission penutupan. Tanggal berakhir tidak menutup kontrak. Status EARLY menghasilkan header TERMINATED setelah seluruh detail selesai.

Operator pada HANDOVER hanya aktif jika interval CONFIRMED mencakup kejadian. Jadwal mendatang tidak otomatis aktif; RETURN menutup penugasan aktual dan membatalkan usulan/jadwal yang belum pernah dimulai, tanpa mengarang waktu kerja. WITHOUT tidak membuat operator palsu.

BA confirmed immutable; koreksi administratif baru menunjuk BA sebelumnya dengan lifecycle_effect NULL. Koreksi fakta/reset HM menunggu SOP khusus (BLOCKED). Seluruh permission C tetap tanpa seed grant. Bukti per unit BA opsional JPEG/PNG/PDF <=5 MB, MIME aktual/ekstensi/ukuran/SHA-256 divalidasi, storage privat dan unduh terotorisasi; confirmed tidak menerima edit/upload baru atau penghapusan bukti. Detail draft yang sudah mempunyai bukti tidak dapat dikeluarkan: batalkan draft dan buat dokumen baru agar bukti tetap utuh.

Nomor BA/{kode cabang kontrak}/{tahun konfirmasi WITA}/{6 digit} hanya saat konfirmasi, counter terpisah KS/DN/MF dan tidak digunakan ulang setelah commit. Idempotensi, row locking, audit/event dan nomor berada pada transaksi yang sama. Tidak ada sumber Finance baru.

## Realisasi M3 Equipment — baseline sementara

Pengguna mengizinkan Kontrak Sewa multi-unit/reservasi dan UI kontrak. Transisi M3: DRAFT → CONFIRMED, DRAFT/CONFIRMED → CANCELLED sebelum pernah ACTIVE. Tidak membuat ACTIVE tanpa BA HANDOVER, atau COMPLETED/TERMINATED tanpa pengembalian sah. WITH memerlukan penugasan saat confirm; WITHOUT tidak membuat operator dummy. DRAFT tidak mereservasi, CONFIRMED mengikat tanggal inklusif; operator memakai interval datetime setengah terbuka.

Unit/operator overlap ditolak server di dalam transaksi, termasuk request bersamaan. Unit ACTIVE belum kembali tidak tersedia untuk reservasi berikutnya. Detail tambahan, extension dan pengganti operator melalui record/proposal berhistori lalu commit guard ulang; tidak menimpa periode/jadwal confirmed. Nomor KS resmi diterbitkan saat confirm header (WITA), tidak pada penambahan unit; cancel tidak menghapus nomor atau histori.

Lintas cabang memerlukan request, dua approver berbeda akun dari cabang pemilik/pengelola, tanpa self-approval pemohon. Otorisasi terikat sumber/kontrak/periode dan dicek ulang; pencabutan tidak otomatis mengakhiri kontrak. Seluruh C tetap tanpa grant default. Detail implementasi/pengujian: PHASE6_M3_REPORT.md. Finance dan M4–M7 tetap di luar mandat.

## Baseline Equipment disetujui — mandat M1–M2, 24 Oktober 2026

G01–G12 pada EQUIPMENT_DESIGN.md telah disetujui pengguna sebagai baseline sementara V2, belum SOP resmi perusahaan. Mengatasi pertanyaan Q06 dan konfigurasi demo satu-unit/timesheet tanpa lintas hari untuk bagian operasional yang tercakup, tanpa mengubah keputusan Finance.

Kontrak multi-unit WITH/WITHOUT operator; status per detail, periode tanggal inklusif dan jadwal datetime setengah terbuka; reservasi mulai CONFIRMED; BA wajib/atomik untuk HANDOVER aktivasi dan RETURN aktual. Kontrak tetap ACTIVE selama masih ada unit/operator/detail terbuka; overdue tidak auto-complete. Extension/termination/detail tambahan berhistori. Dua persetujuan lintas cabang wajib akun berbeda, terikat sumber/kontrak/periode tanpa bypass global. Master nonaktif menolak penugasan baru, recovery sah tetap berizin/diaudit.

Root timesheet unit/assignment/tanggal, beberapa interval datetime lengkap lintas tengah malam dan break; HM terpisah/opsional berpasangan, normal nonmenurun, reset melalui koreksi khusus dengan alasan/bukti/otorisasi. SUBMITTED frozen; RETURNED/REJECTED/APPROVED diperbaiki dengan revisi baru. Reviewer bukan pembuat root DAN revisi untuk semua role. Satu pending, approved lama tidak ditimpa/hilang; koreksi terminal tidak membuka kontrak/reservasi. Operator tanpa akun tidak dibuatkan dummy; relink eksplisit tidak memberi histori otomatis.

KS dan BA per jenis/cabang kontrak/tahun konfirmasi WITA, diterbitkan saat confirm, nomor committed tidak dipakai ulang, kode cabang terkunci setelah nomor pertama Equipment kelak. Generator DN/MF tidak diubah. BA confirmed immutable; koreksi administratif tidak mengulang lifecycle, koreksi fakta perlu prosedur khusus. Bukti privat/terotorisasi. Seluruh sel C permission **definisi saja, tidak disemai sebagai grant**, sesuai jawaban eksplisit pengguna.

Implementasi saat ini hanya M1 dan M2 (struktur/constraint/seed); seluruh workflow di atas belum aktif. Finance/invoice/pembayaran/Petty Cash/Inventory/tarif otomatis tetap di luar mandat. Hasil: PHASE6_M1_M2_REPORT.md. Bagian lama di bawah bersifat historis.

## Keputusan terbaru — baseline sementara Tahap 5, 24 Oktober 2026

Pengguna menyetujui Q03, Q04 dan alur operasional Q09 sebagai baseline implementasi V2; **belum SOP resmi PT Hanqia Lintas Sarana**. Menggantikan blokir sebelumnya. Tabel transisi sebelum implementasi: [TRUCKING_STATE_MACHINE.md](TRUCKING_STATE_MACHINE.md). Manager masih perlu memvalidasi SOP; perubahan berikutnya tidak menghapus histori. Aturan Finance yang terkunci tetap berlaku.

- Q03: Manifest mewakili trip kendaraan dengan leg dari master rute/lokasi yang eksplisit dan berkesinambungan. DN dapat berbeda tujuan pada stop mendatang; satu DN hanya satu keanggotaan aktif. Tidak membuat jaringan rute atau menganggap seluruh cabang berada pada lintasan. Pergantian kendaraan setelah konfirmasi memakai Manifest baru, alasan dan histori perpindahan.
- Konfirmasi dokumen terpisah dari keberangkatan. Kedatangan kendaraan tidak otomatis mencatat kedatangan DN; petugas memilih DN yang benar-benar tiba. Penurunan dan penerimaan aktual terpisah. Manifest selesai tidak membuat DN received/completed.
- Pengguna menyetujui hanya penerimaan utuh/sesuai; bila selisih, tidak konfirmasi penerimaan dan catat klaim. Pengguna menyetujui CANCELLED untuk Manifest sebelum berangkat, sudah kosong, dengan alasan, nomor tetap dan histori.
- Q04: DN/{KODE_CABANG}/{TAHUN}/{000001} dan MF/{KODE_CABANG}/{TAHUN}/{000001} saat konfirmasi. Sequence terpisah jenis/cabang/tahun, tahun waktu penerbitan WITA; tanggal dokumen mundur tidak mengubah nomor. Identifier internal tetap. Nomor committed tidak digunakan ulang; rollback sebelum commit tidak menerbitkan nomor.
- INV/{KODE_CABANG}/{TAHUN}/{000001} hanya saat ISSUED adalah keputusan terdokumentasi untuk Finance; tidak membuat invoice/issuance/transaksi keuangan pada Tahap 5.
- Q09: REPORTED → REVIEWING → APPROVED/REJECTED → CLOSED, catatan dan histori wajib. Jenis masalah, deskripsi, pelapor, aktor/waktu serta bukti privat dicatat. Pengguna menyetujui bukti boleh menyusul dan status belum dilampirkan terlihat. Approval/penutupan hanya operasional; tidak mengubah invoice, pembayaran, refund atau kompensasi.
- Batas implementasi sementara: satu deskripsi barang per DN, tidak ada penerimaan sebagian, satu lokasi tidak berulang dalam satu trip, kendaraan wajib saat konfirmasi dan identitas armada dibekukan setelahnya. Driver tetap referensi opsional; penjadwalan/konflik penugasan lintas trip menunggu mandat/SOP tersendiri. Perubahan batas ini memerlukan validasi Manager, bukan asumsi otomatis.

Bagian historis di bawah dibaca sesuai tanggalnya; pertanyaan Q03/Q04/alur operasional Q09 kini mempunyai baseline sementara ini. Bagian finansial Q09, Finance lain dan SOP resmi perusahaan tetap belum diputuskan.

Tanggal audit: 23 Oktober 2026. Referensi utama: DECISIONS.md proyek lama; bagian terbaru mengatasi catatan tahap lama yang sudah digantikan. Status persetujuan historis di sini mengikuti dokumen, bukan rekonstruksi percakapan manajemen. Instruksi pembangunan ulang terbaru menjadi batas kerja.

## Aturan yang dipertahankan

| ID | Aturan | Dasar |
|---|---|---|
| B01 | DN adalah dokumen pengiriman, satu manifest memuat banyak DN pada satu lintasan; satu DN hanya satu manifest aktif | DECISIONS Tahap 2 dan istilah Trucking/Equipment 23 Oktober; migration 002 |
| B02 | DN sesuai cabang/posisi dan lintasan; pindah manifest menyimpan hubungan lama/baru, alasan, aktor/waktu | ManifestService.attach; aturan Tahap 2 |
| B03 | Satu invoice aktif per DN; aktif meliputi draft, submitted, returned, issued; void mempertahankan histori | Keputusan workflow draft 23 Oktober dan migration 009 |
| B04 | Admin Pengirim menyiapkan/mengedit draft sesuai cabang; submitted diterbitkan pihak berizin Finance/Administrator; returned untuk koreksi | Keputusan workflow draft terbaru |
| B05 | Nomor invoice final hanya saat terbit; pembayaran hanya issued; nominal manual tanpa tarif/pajak/diskon otomatis | Keputusan workflow draft; FinanceService.pay |
| B06 | Tarif trucking/pickup dan harga equipment merupakan referensi opsional, kosong berbeda dari nol | Keputusan terkonfirmasi Tahap 2/3 |
| B07 | Equipment memakai kontrak rental; sumber tagihan hanya timesheet disetujui | Keputusan Tahap 3/4; RA belum diputuskan |
| B08 | Invoice sewa boleh saat kontrak berjalan dengan sumber terverifikasi; penambahan sumber tidak otomatis menambah nominal | Koreksi eksplisit pengguna pada keputusan Finance |
| B09 | Pembayaran tidak melebihi sisa, memakai transaksi/lock dan jejak audit; koreksi melalui reversal, bukan menghapus riwayat | Keputusan Finance dan FinanceService |
| B10 | Petty cash: pencairan menambah kas cabang, realisasi mengurangi kas, pengembalian mengurangi kas tanpa expense | Keputusan terkonfirmasi Tahap 6 |
| B11 | Satu realisasi petty cash membuat/menaut tepat satu expense Finance secara atomik; jangan menghitung biaya dua kali | Keputusan terkonfirmasi Tahap 6 |
| B12 | Pertanggungjawaban ditutup hanya ketika realisasi + pengembalian efektif sama dengan pencairan; pembuat tidak menyetujui sendiri | Keputusan terkonfirmasi Tahap 6 |
| B13 | Semua baca/tulis dibatasi permission dan cabang; transaksi penting diaudit; sumber historis tidak dihapus | Master prompt dan keputusan keamanan |
| B14 | Laba rugi, HPP, pajak, depresiasi dan pendapatan akuntansi belum dihitung | Keputusan Finance/Inventory/Owner; master prompt |

## Konfigurasi lama yang belum menjadi SOP final

Jangan mengangkat konfigurasi berikut menjadi keputusan perusahaan tanpa konfirmasi:

- DN: created → departed → transit → arrived → received → completed (lihat config/expedition.php untuk identifier/transisi persis); transit dapat berulang. Manifest selesai tidak berarti pelanggan menerima barang. Nomor sementara memakai tanggal/sufiks acak; usulan nomor pendek belum disetujui.
- Klaim masih deskripsi kerusakan setelah tiba, tanpa keputusan kompensasi, tanggung jawab, atau penyelesaian finansial. Alamat tambahan bukan pengiriman parsial multi-penerima/cabang.
- Rental: satu unit/operator per kontrak, batas tanggal inklusif, periode tidak tumpang tindih, BAP satu kali; timesheet satu hari tanpa lintas tengah malam. Draf → submitted → approved/rejected; persetujuan oleh admin lain, snapshot sumber atomik. Ini batas demo yang perlu SOP.
- Stok: satu item per dokumen, satu satuan dasar, presisi 3 desimal, saldo tidak negatif. Transfer keluar mengurangi asal, diterima menambah tujuan sekali; tidak ada penerimaan parsial. Opname menggunakan versi saldo. Koreksi membuat leg baru.
- Finance: skema DP/termin/bayar tujuan manual; guard tanggal, referensi unik dan penomoran sementara merupakan batas implementasi. Piutang periode merupakan saldo terkini sumber terfilter, bukan saldo historis pada akhir periode.
- Akun satu role + cabang eksplisit/all_branches; akses global dan delegasi awal dalam seed bukan kebijakan final seluruh perusahaan. Customer tersedia dalam blueprint; akses portal Customer terpisah belum berarti diimplementasikan.

## Perbedaan dan pertanyaan yang perlu keputusan sebelum modul terkait

| ID | Pertanyaan | Dampak/tahap |
|---|---|---|
| Q01 | Penerbitan invoice Trucking langsung oleh finance.invoice tetap boleh, atau wajib seluruhnya melalui submitted dan finance.publish? | Dua jalur source lama; putuskan sebelum Finance |
| Q02 | Draft hanya pembuat yang mengedit/mengajukan/membatalkan? Ada delegasi resmi, dan aksesnya cabang asal DN saja atau asal/tujuan? | Source lama memberi pengecualian all_branches pada edit/cancel dan menerima cabang asal/tujuan; perlu selaraskan dengan keputusan terbaru |
| Q03 | Apa definisi tepat kecocokan rute DN pada lintasan transit? Apakah ada daftar lintasan sah menuju tujuan akhir? | Guard lama terutama posisi/cabang; jangan mengarang jaringan rute |
| Q04 | Format resmi nomor DN/manifest/invoice, reset urutan, kode cabang, dokumen mundur tanggal? | Sebelum penomoran operasional |
| Q05 | Matriks izin tiap role, Owner/Customer, delegasi akses global, audit/retensi? | Tahap 1 mempertahankan deny-by-default dan matriks terdokumentasi; grant final operasional perlu persetujuan |
| Q06 | Definisi RA, multi-unit/operator, shift, overtime, koreksi timesheet/BAP, perpanjangan? | Sebelum perluasan Equipment; kontrak tetap dipakai |
| Q07 | Tarif riil, satuan/volume, pickup, diskon, pajak, pendapatan, HPP, depresiasi, periode buku? | Tidak memblokir fondasi; blokir perhitungan terkait |
| Q08 | Kendaraan/driver: identitas unik, kepemilikan cabang, mutasi, konflik jadwal? | Master baru tidak disamakan otomatis dengan rent_units |
| Q09 | Klaim/bukti/kompensasi, refund, rekonsiliasi, penagihan sewa lanjutan? | Sebelum alur finansial terkait |
| Q10 | Transfer parsial, konversi satuan, valuasi stok, opname/persetujuan, limit/delegasi kas? | Sebelum perluasan Gudang/Petty Cash |
| Q11 | Sumber notifikasi, penerima, event, penandaan dibaca dan retensi? | Sebelum indikator notifikasi aktif |

Identitas warna lama tetap. Instruksi terbaru secara eksplisit mengganti label Ringkasan menjadi Dashboard langsung dan melarang kotak putih tambahan logo. Ini perubahan presentasi yang diminta, bukan perubahan SOP. Halaman Pembayaran, Berita Acara dan Klaim terpisah pada rancangan baru harus memakai aturan sumber yang sama, bukan menggandakan transaksi.
# Batas implementasi Master Data — Tahap 4

Master operasional dibatasi cabang; rute hanya terlihat jika kedua endpoint diizinkan. Katalog barang/kategori/satuan global adalah referensi bersama, bukan stok lintas cabang. Cabang pemilik tidak dipindahkan melalui edit; mutasi antar cabang menunggu SOP. Tidak ada hard delete; nonaktif tidak menghapus relasi/histori, tetapi tidak dapat menjadi relasi baru. Riwayat perubahan melalui audit atomik, bukan transaksi bisnis.

Tarif Trucking reguler/carter/pickup dan Equipment jam/shift/bulan hanyalah referensi manual. Kosong berarti belum ditentukan, berbeda dari nol; tidak dihitung menjadi tagihan. Per hari, definisi jam/shift, prorata/overtime, tier berat/volume, pajak dan biaya operator/bahan bakar/mobilisasi memerlukan persetujuan sebelum implementasi. Kondisi fisik unit tidak menunjukkan sedang disewa. Driver/operator tertaut akun tidak memberi akses login/grant baru. Penugasan/jadwal/gaji belum dibuat.

Keputusan implementasi lengkap di MASTER_DATA_DESIGN.md; keputusan terbuka historis di bawah tetap berlaku untuk modul transaksi berikutnya. Tahap 5 belum dimulai.


## Riwayat Tahap 5 — gerbang sebelum persetujuan baseline

Pengguna mengonfirmasi DN/Manifest termasuk lingkup, tetapi memilih "Belum final; blokir transisi yang bergantung Q03". Alur demo lama tetap belum menjadi SOP. Pembuatan dokumen awal/manifest draft dan keanggotaan rute persis bukan perpindahan atau penerimaan aktual. Transit, penerimaan, penyelesaian, koreksi/pindah manifest tetap blocked sampai keputusan. Q04 nomor resmi belum final: identifier internal boleh dipakai untuk pengujian lokal. Q09 status/penanganan klaim belum final; tidak membuat approval, penutupan atau dampak keuangan. Tahap 5 belum selesai karena dependensi.

Klarifikasi terbaru Q04: pengguna menyetujui kode cabang dikunci setelah penerbitan nomor resmi pertama. Nama/alamat/kontak tetap editable. Ini menjaga namespace dan tidak mengganti nomor dokumen yang sudah terbit.

# Baseline sementara Tahap 5 — 24 Oktober 2026

Disetujui pengguna sebagai baseline implementasi V2, **bukan SOP resmi perusahaan**. Dokumen ini ditulis sebelum perubahan workflow. Menggantikan blokir Q03/Q04/Q09 sebelumnya; Finance tetap tidak berubah. Penyesuaian setelah validasi Manager melalui migration/aturan baru, bukan mengubah histori.

## Pemisahan status dan peristiwa

| Entitas | Dari | Aksi dan prasyarat | Ke |
|---|---|---|---|
| DN | created | Konfirmasi oleh cabang asal, referensi aktif; nomor DN diterbitkan | confirmed |
| DN | confirmed/transit | Keberangkatan trip dari posisi aktual DN; anggota aktif, tujuan berada pada stop mendatang | departed |
| DN | departed | Petugas mencatat kedatangan DN tertentu di stop tempat kendaraan benar-benar berhenti | transit jika perantara; arrived jika lokasi tujuan akhir tepat |
| DN | transit | Tetap di kendaraan untuk leg berikutnya atau diturunkan/dipindah dengan histori | transit, tanpa penerimaan otomatis |
| DN | arrived | Konfirmasi penerimaan aktual tujuan, tidak lagi anggota manifest aktif | received |
| DN | received | Penyelesaian administratif oleh petugas penerimaan tujuan | completed |
| Manifest | draft | Konfirmasi; lintasan eksplisit berkesinambungan, kendaraan ditetapkan, anggota DN terkonfirmasi memenuhi lintasan; nomor MF diterbitkan | confirmed |
| Manifest | confirmed/transit | Petugas cabang stop saat ini menyatakan keberangkatan; seluruh DN aktif telah tercatat pada posisi itu, tidak melewati tujuan DN | departed |
| Manifest | departed | Petugas tujuan leg menyatakan kendaraan tiba pada stop berikutnya | transit |
| Manifest | transit di stop terakhir | Semua anggota sudah diturunkan/dipindah secara aktual | completed |
| Manifest | draft/confirmed, belum berangkat | Semua DN sudah dipindah; alasan pembatalan wajib, nomor tidak digunakan ulang | cancelled |
| Klaim | REPORTED | Petugas berizin mulai pemeriksaan | REVIEWING |
| Klaim | REVIEWING | Keputusan operasional dengan catatan, tanpa implikasi keuangan | APPROVED atau REJECTED |
| Klaim | APPROVED/REJECTED | Penutupan dengan catatan | CLOSED |

Transit adalah ledger peristiwa keberangkatan/kedatangan/penurunan/perpindahan dengan posisi dan aktor aktual; bukan status penerimaan. Penerimaan adalah record tersendiri yang unik per DN. Manifest tiba hanya mencatat kendaraan, **tidak otomatis mencatat kedatangan DN**. Petugas memilih DN yang benar-benar tiba; DN lain tetap berstatus perjalanan hingga dicatat. Manifest selesai tidak membuat record penerimaan atau completed pada DN.

## Lintasan trip dan pergantian kendaraan

- Setiap leg memakai master md_routes aktif dengan origin_location/destination_location yang eksplisit. Leg pertama dari route_id legacy; tambah leg hanya saat draft. Lokasi akhir leg sebelumnya harus sama dengan lokasi awal leg berikutnya. Tidak menyimpulkan jaringan rute atau memasukkan semua cabang secara otomatis.
- Lokasi tidak berulang dalam satu trip untuk menghindari tujuan/posisi ambigu. Trip baru dapat dibuat untuk perjalanan lanjutan; batas ini dinyatakan pada UI dan dapat ditinjau Manager.
- DN boleh berbeda tujuan jika destination_location_id ada pada stop mendatang, posisi aktualnya sama dengan stop muat, dan statusnya memenuhi syarat. Kecocokan hanya nama cabang tidak cukup.
- Susun DN pada draft; konfirmasi manifest memvalidasi seluruh anggota. Pergantian kendaraan setelah konfirmasi menggunakan manifest baru. Tidak mengedit identitas kendaraan perjalanan lama.
- Penurunan DN di stop aktual melepas keanggotaan aktif dengan alasan/aktor/waktu. Pindah ke manifest baru dilakukan atomik, menyimpan sumber/tujuan dan alasan; tidak menghapus anggota lama. Tidak boleh pindah saat kendaraan bergerak.
- Semua transisi mempunyai version, token idempotensi terikat aktor/aksi/payload, row lock dan event/audit atomik. Nomor, histori dan bukti tidak dihapus.

## Penomoran

DN/{KODE_CABANG}/{TAHUN}/{000001} dan MF/{KODE_CABANG}/{TAHUN}/{000001} saat konfirmasi. Sequence terpisah per jenis/cabang/tahun, memakai tahun waktu konfirmasi WITA; tanggal dokumen mundur tidak mengubah nomor. Nomor internal number legacy dipertahankan, official_number disimpan terpisah dan unik. Nomor committed tidak pernah dikembalikan/dipakai ulang; rollback sebelum publikasi tidak menerbitkan nomor. Rentang enam digit yang habis ditolak, tidak reset/wrap.

INV/{KODE_CABANG}/{TAHUN}/{000001} hanya saat ISSUED adalah keputusan tercatat untuk Finance berikutnya. Tidak membuat invoice, endpoint issuance, atau transaksi keuangan di Tahap 5.

Pengguna menyetujui kode cabang dikunci setelah nomor resmi pertama diterbitkan, untuk mencegah namespace lama dipakai cabang lain. Nama, alamat dan kontak tetap dapat diedit. Pemeriksaan berjalan server-side dalam transaksi dan selaras dengan lock cabang saat penerbitan nomor.

## Klaim dan bukti

Klaim merujuk DN valid dalam cakupan cabang pelapor; jenis masalah, deskripsi, nama pelapor, aktor dan waktu dicatat. Tidak perlu mengarang penerimaan agar masalah perjalanan bisa dilaporkan. Bukti disimpan privat dengan nama acak, validasi MIME/ukuran, hash, izin download dan audit; bukan URL public. Pengguna menyetujui bukti boleh menyusul, diberi status belum dilampirkan. Pengguna menyetujui hanya penerimaan utuh/sesuai; selisih tidak dikonfirmasi sebagai penerimaan dan dicatat sebagai klaim. Pengguna juga menyetujui CANCELLED sebelum keberangkatan dengan alasan/histori dan nomor tidak dipakai ulang. Alur approval hanya keputusan operasional; tidak membuat refund, kompensasi, invoice, pembayaran atau expense.

Grant tambahan: Administrator semua aksi operasional; Admin Pengirim konfirmasi DN; Admin Transit kelola/konfirmasi/perjalanan manifest dan catat DN transit; Admin Penerima catat penerimaan dan lapor klaim; Owner baca operasional/klaim; petugas Trucking dapat melapor klaim dalam cakupan, review/keputusan/penutupan awal hanya Administrator. Tidak menambah editor grant atau bypass nama role runtime. Mutasi hanya di cabang peristiwa aktif dengan penetapan efektif; akses lintasan bukan akses global master.

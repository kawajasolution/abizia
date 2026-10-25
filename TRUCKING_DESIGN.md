# Desain Tahap 5 — Trucking / Ekspedisi

Status terkini: enam modul telah diimplementasikan pada baseline sementara yang disetujui pengguna. Bagian gerbang awal berikut adalah riwayat; keputusan yang berlaku terdapat pada bagian baseline terbaru dan TRUCKING_STATE_MACHINE.md. Hasil eksekusi ulang tercatat di PHASE5_REPORT.md.

## Mandat dan gerbang

Mandat awal dan lanjutan berlaku bersama. Pengguna menegaskan DN dan Manifest termasuk cakupan Tahap 5. Tracking hanya internal terautentikasi. Tidak ada Finance, kompensasi, transaksi Equipment/Inventory, hosting, atau modifikasi proyek/database lama.

Gerbang sebelum kode: regresi aktual 481 integrasi/HTTP, 108 browser fondasi, 371 navigasi, 724 dashboard, 351 master browser dan 14 Apache/isolasi database lulus. Development 21 tabel, 10 role, 53 permission, tanpa akun/cabang/master contoh. Migration existing 001_foundation dan 002_master_data. Tidak ada transaksi DN/Manifest atau sumber operasional lain di V2.

Sumber yang diperiksa: BUSINESS_RULES.md, DATABASE_DESIGN.md, UI_DESIGN_SYSTEM.md, IMPLEMENTATION_PLAN.md, DECISIONS.md, PROGRESS.md, README.md; source/DECISIONS/config expedition proyek lama hanya baca-saja. Tidak ditemukan AGENTS.md pada proyek atau direktori induk XAMPP yang diperiksa.

## Riwayat gerbang awal — digantikan baseline terbaru

- Q03: dokumen lama menyebut state machine sebagai demo, bukan SOP final. Pengesahan alur lama untuk V2 diminta kepada pengguna sebelum transisi operasional diimplementasikan. Posisi/cabang saja tidak membuktikan lintasan menuju tujuan akhir sah; jaringan lintasan otomatis tidak akan dibuat.
- Q04: nomor resmi belum final. Gunakan identifier internal acak dengan unique constraint, tetap setelah dibuat, dilabeli internal dan belum menjadi format dokumen resmi. Tidak memakai nomor invoice atau format SJ/MF lama sebagai keputusan final.
- Q09: laporan klaim deskriptif diizinkan; approval, penyelesaian, kompensasi, bukti wajib dan dampak tagihan belum final. Tidak menambah status klaim/penyelesaian atau proses keuangan secara asumsi.
- Satu DN satu deskripsi barang, jumlah/satuan dan berat/volume opsional sesuai mandat; bukan multi-item atau barang inventory. Tidak ada hitung tarif, berat/volume atau tagihan otomatis.

## Batas arsitektur

Route/permission, controller, service transaksi, repository query dan views terpisah mengikuti fondasi. Service memeriksa permission/aktor/cabang aktif dan melakukan locking/transaksi/audit. UI tidak memberikan kewenangan. Pilihan referensi hanya master aktif yang relevan; dokumen mempertahankan snapshot agar perubahan master tidak mengubah histori.

Setiap perubahan operasional harus menyimpan aktor, waktu, cabang, status sebelum/sesudah dan korelasi permintaan. Constraint unik keanggotaan aktif melindungi satu DN/satu manifest aktif. Idempotensi mengikat token ke aktor/aksi/payload; replay berbeda ditolak. Version dan current locking read mencegah perubahan bersamaan menimpa histori. Batch manifest harus seluruhnya valid atau seluruhnya rollback.

Membership V2 existing adalah relasi user_branches tanpa kolom active; pengguna dan cabang memiliki active. Tidak mengarang flag membership lama. Implementasi operasional harus memeriksa keaktifan akun, cabang dan relasi penetapan yang masih berlaku, termasuk penolakan cabang nonaktif bagi akun global. Detail kebijakan dicatat saat implementasi, tanpa mengganti aturan master/fondasi.

Navigasi menggunakan registry tunggal; hanya enam submenu Trucking nyata yang akan diaktifkan. Tidak membuat halaman placeholder atau tracking publik. Dashboard hanya ditambah adapter jika sumber dan definisi metrik sah tersedia; keberadaan tabel saja tidak mengaktifkan data bisnis.

## Riwayat hasil gerbang sebelum persetujuan baseline

Pengguna memilih: "Belum final; blokir transisi yang bergantung Q03". Implementasi dibatasi dokumen DN created, manifest draft dan keanggotaan dengan rute persis sama, histori serta Tracking internal. Tidak membuat keberangkatan, transit, penerimaan atau penyelesaian manifest/klaim berdasarkan demo. Laporan PHASE5_REPORT.md harus berstatus belum selesai karena dependensi, tanpa menganggap pengujian positif proses blocked sudah lulus.

Migration 003 memakai FK komposit customer/pihak/rute/kendaraan/driver dengan cabang terkait. Kecocokan cabang tujuan rute dan jenis/peran master tetap diperiksa service. `exp_manifest_items` generated unique active_dn_id menjadi pertahanan DB tambahan; current locking read setelah menunggu lock diperlukan agar query active membership tidak memakai snapshot REPEATABLE READ lama. Guard operasional memakai pembacaan grant terkini pada transaksi. Regresi akhir dan uji dua aktor/proses ada di PHASE5_REPORT.md.

## Baseline terbaru menggantikan blokir historis

Pengguna menyetujui model trip-based, nomor resmi DN/MF saat konfirmasi dan klaim operasional stateful sebagai baseline sementara V2, bukan SOP resmi perusahaan. Tabel transisi baru: TRUCKING_STATE_MACHINE.md; laporan terkini PHASE5_REPORT.md menggantikan laporan partial. Penerimaan utuh, bukti menyusul, CANCELLED sebelum berangkat dan penguncian kode cabang pascanomor telah disetujui pengguna. Finance tidak berubah; Tahap 6 belum dimulai.

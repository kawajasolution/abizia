# Desain Master Data — Tahap 4, 24 Oktober 2026

## Audit sebelum migration

Gerbang awal aktual: 196 integrasi/HTTP, 107 browser fondasi, 236 navigasi dan 724 browser dashboard lulus. V2 memiliki sembilan tabel fondasi: schema_migrations, roles, permissions, role_permissions, branches, users, user_branches, audit_logs, login_attempts. Tidak ada master/customer/rute/unit/barang atau tabel transaksi pada v2 sebelum tahap ini. Tidak membaca database lama; sumber lama hanya file SQL/DECISIONS baca-saja.

Sumber lama: exp_customers dipakai sebagai pihak cabang, rent_tenants terpisah secara historis, rent_units berisi identitas dan referensi tarif jam/shift/bulan, inventory memakai katalog kategori/satuan/barang global dan supplier cabang. V2 menyatukan customer lintas divisi sesuai instruksi, tanpa menyalin data/source/migration lama. Pihak kirim/terima satu entitas dengan peran pengirim/penerima/keduanya, bukan dua daftar identitas duplikat. Barang inventory adalah katalog barang/suku cadang, bukan uraian barang kiriman DN.

## Struktur dan relasi

Migration 002_master_data menambah 12 tabel master, bukan transaksi:

- md_customers: customer cabang yang dipakai bersama Trucking/Equipment.
- md_parties: pihak kirim/terima cabang; kode unik dan fingerprint identitas mencegah duplikat persis dalam cabang.
- md_locations dan md_routes: lokasi terkait cabang; rute menyimpan dua cabang/lokasi. Composite FK memastikan lokasi asal/tujuan sesuai cabangnya.
- md_assets: satu identitas kendaraan/unit, kind truck/equipment; code unik, identitas nomor polisi/seri dinormalisasi dan unik per jenis. Kapasitas berupa referensi teks, bukan rumus muatan.
- md_personnel: driver/operator; account_id opsional unik ke users. Akun tertaut menjadi sumber nama, tanpa menyalin password atau membuat akun/grant otomatis.
- md_trucking_tariffs: reguler/carter/pickup, rute untuk reguler/carter, pickup dimiliki cabang tanpa rute wajib; nominal nullable dan basis teks manual.
- md_equipment_tariffs: referensi tarif unit jam/shift/bulan, nominal nullable, masa berlaku opsional; composite FK ke unit/cabang.
- md_categories, md_units, md_items: katalog bersama global sesuai konsep lama; item merujuk kategori/satuan. Tidak ada saldo atau stok awal.
- md_suppliers: supplier barang/jasa cabang; tanpa pembelian/pengeluaran.

branches digunakan kembali, ditambah kota/provinsi/telepon, version dan timestamp; tidak membuat tabel cabang baru. Semua master ber-ID tetap, code unik, active, version, timestamps. Semua FK bernama eksplisit dengan RESTRICT; tidak ada cascade delete. Index cabang/status/nama dan code mendukung daftar/filter/pencarian. Pencarian teks memakai prepared LIKE dengan wildcard pengguna di-escape, bukan interpolasi.

## Cakupan dan integritas

Master cabang dibaca sesuai penetapan akun. Master operasional dimiliki satu cabang. Cabang pemilik tidak dipindahkan melalui edit; perubahan kepemilikan/mutasi memerlukan SOP terpisah. Rute hanya terlihat jika kedua cabang dalam akses. Tarif dan referensi unit/lokasi harus sesuai cabang induk dan akses pembaca/penulis. Pilihan relasi hanya sumber aktif dalam scope; referensi lama nonaktif tetap dapat ditampilkan pada detail dan dipertahankan saat edit yang tidak menggantinya.

Kategori/satuan/barang adalah katalog global bersama, berlabel jelas, bukan data stok cabang lain. Pembuatan/perubahan katalog perlu permission dan all_branches. Cabang/identitas yang sudah menjadi referensi tetap tersimpan; tidak ada hard delete pada UI/service. Informasi referensi dan audit sensitif hanya untuk audit.view + global. Referensi dan histori dibaca lewat ID, perubahan diaudit sebelum/sesudah; unit/jenis/identitas relasi yang sudah direferensikan tidak diubah diam-diam.

Create/update memakai transaksi, lock master/parent dan optimistic version. Konflik versi mendapat 409. Keunikan DB tetap melindungi penulisan bersamaan. Relasi FK diuji pada DB, pemeriksaan scope/jenis/aktif juga di service. Audit pembuatan, pembaruan, nonaktif dan aktif kembali atomik; tanpa password/rahasia.

## RBAC

Identifier branches.view/manage yang sudah ada dipertahankan. Entity master baru memakai master.<entity>.view/create/update; tab gabungan memakai permission view kelompok dan view entity. Status aktif/nonaktif adalah update, bukan hard delete/permission baru. Semua aksi diperiksa backend, termasuk tab, ID, pilihan FK dan POST.

Seed aditif: Administrator mempunyai izin master baru, tetap scope akun; Owner baca master saja (termasuk branches.view); role operasional baca referensi yang diperlukan, tidak otomatis memperoleh create/update. Admin Pengirim membaca customer/pihak/lokasi/rute/tarif Trucking/kendaraan/driver; Transit membaca pihak/lokasi/rute/kendaraan/driver; Penerima membaca customer/pihak/lokasi/rute; Admin Sewa membaca customer/unit/operator/tarif Equipment; Operator membaca unit; Finance membaca customer/supplier; Gudang membaca katalog/supplier/unit. Customer tidak mendapat izin master baru. Pengubahan grant dinamis/delegasi write operasional belum dibuat.

Nama role hanya dipakai pada seed konfigurasi yang eksplisit, bukan bypass runtime. Pemilihan akun personel memerlukan users.view + global agar tidak membocorkan daftar akun. Relasi akun harus aktif dan memiliki akses cabang personel; tidak mengubah role/password akun.

## Batas bisnis

Tarif hanya referensi manual, kosong berbeda dari nol. Presisi uang dua desimal, maksimal sepuluh digit sebelum desimal sebagai batas teknis; tidak memakai float atau pembulatan. Berat/volume/kelas kendaraan tidak dijadikan rumus. Hari/per hari Equipment belum mempunyai dasar persetujuan lama, sehingga ditunda; paket jam/shift/bulan tersedia sebagai label referensi, tanpa definisi durasi/prorata/overtime. Masa berlaku hanya metadata manual, tanpa pemilihan/hitung tarif otomatis.

Belum ada jadwal/kontrak/DN/invoice/pembayaran/stok/ledger baru. Tidak menyimpulkan unit sedang disewa dari status master. Bahan bakar, operator, mobilisasi, pajak, gaji, konflik penugasan, mutasi antar cabang, tarif harian dan tier berat/volume menunggu SOP modul berikutnya. MySQL 8 ditargetkan melalui SQL standar bernama eksplisit, tetapi hanya MariaDB lokal yang dapat diverifikasi pada lingkungan ini.

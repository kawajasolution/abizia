# Rancangan database — audit dan realisasi fondasi

## M5 — Timesheet memakai schema existing

Tidak ada migration/DDL/seed baru. eq_timesheets menyimpan identitas root, root author, versi serta pointer pending/approved efektif; eq_timesheet_revisions menyimpan author revisi, previous/base-approved, alasan, konten/snapshot/hash dan versi; eq_timesheet_work_entries menyimpan interval datetime dan break_minutes. Total bersih diturunkan dari interval sebagai detik integer, bukan kolom nominal. eq_timesheet_verifications menyimpan reviewer/keputusan/alasan/waktu/request, dengan FK author komposit, CHECK no-self dan unique satu keputusan per revisi. Seluruh fingerprint 005 tetap.

eq_events mengikat kontrak/unit/assignment/root/revisi secara konsisten; before/after draft dan keputusan append-only. Hanya row kerja interval DRAFT yang diganti ketika diedit; snapshot before/after di event tetap, interval revisi SUBMITTED/APPROVED tidak ditulis ulang. eq_requests resource_type timesheet memakai boundary transaksi/lock/idempotensi existing. Pergantian pointer approved, keputusan, event/audit dan token commit bersama.

Snapshot menyimpan unit/operator/jadwal/periode/aktual, serta requires_terminal_permission untuk membedakan perubahan pascaterminal dari submit fakta draft lama tanpa edit. Penugasan kini CANCELLED memerlukan snapshot assignment dahulu CONFIRMED/ACTIVE dan bukti RETURN confirmed untuk root historis; tidak membuat histori sumber baru. eq_meter_corrections tetap tanpa workflow reset/replacement. Data development tidak direset/diisi fixture.

## M4 — BA memakai schema existing

M4 tidak menambah migration/tabel/kolom/constraint dan tidak mengubah fingerprint 005. eq_handover_documents/eq_handover_units menyimpan draft, snapshot dan konfirmasi; unique(unit,lifecycle_effect) tetap pertahanan efek HANDOVER/RETURN tunggal. Koreksi administratif memakai correction_of_id dan NULL lifecycle_effect, sumber immutable. eq_evidence per BA-unit menyimpan metadata privat; tidak menduplikasi bukti lama. eq_events mengikat kontrak/BA/unit/operator dengan FK existing; before/after draft tersimpan sebagai histori event. Mengeluarkan detail draft tanpa bukti boleh menghapus row kerja draft karena snapshot before/after tetap di ledger; row dengan bukti tidak dihapus.

eq_document_sequences tipe BA dikunci per cabang/tahun; eq_requests resource_type handover terpisah dari kontrak. Perubahan lifecycle, agregasi, event, audit, sequence dan hasil idempotensi commit bersama. File baru dibersihkan saat rollback terdeteksi; crash proses antara penulisan file dan commit masih dapat meninggalkan orphan privat untuk rekonsiliasi operasional, bukan metadata committed yang menunjuk file hilang akibat rollback biasa. Tidak ada endpoint penghapusan file/histori.

## M3 — pemakaian schema existing, tanpa migration baru

M3 memakai 16 tabel eq_* dari 005: kontrak/detail, periode/operator berhistori, authorization, sequence KS, request dan event. Tidak menambah/mengubah tabel, FK, CHECK, indeks, seed, role atau permission. Fingerprint journal 005 tetap valid; master existing dipakai kembali. BA/timesheet/meter/evidence belum ditulis oleh operasi M3.

Unit/operator proposal DRAFT belum mengikat sampai confirmed; extension eq_unit_periods efektif setelah pointer current_period_id dipindah atomik. Jadwal confirmed lama dipertahankan saat replacement melalui previous_assignment_id; status lama CANCELLED dan event menyimpan hubungan/alasan, bukan delete. Ledger eq_events kini menyimpan previous_state/next_state bersama actor/branch/request/time, audit_logs dan eq_requests dalam transaksi yang sama. Counter KS terpisah per cabang/tahun WITA; kode cabang freeze juga memeriksa eq_document_sequences.

Development tetap tanpa fixture/akun/operator/kontrak/nomor palsu; preservation terhadap snapshot pra-M2 diperiksa baca-saja. Semua data transaksi pengujian, termasuk fixture ACTIVE untuk guard unit belum kembali dan grant approval sementara, hanya DB disposable. Hasil aktual: PHASE6_M3_REPORT.md.

## Skema aktual M2 Equipment — 24 Oktober 2026

hls_v2_dev memiliki **48 tabel**, migration 001–005; 32 tabel T1–5 tetap utuh, 16 tabel Equipment aditif. 10 role, 106 permission (63 existing + 43 Equipment), 215 grant (151 existing + 64 Y/O baru). Seluruh sel C tanpa grant sesuai keputusan pengguna. Metadata teknis START/DONE 005 disimpan pada schema_migrations; total 43 row mencakup lima marker lengkap dan 38 journal, bukan 43 migration bisnis.

Tabel baru: eq_contracts, eq_contract_units, eq_unit_periods, eq_operator_assignments, eq_branch_authorizations, eq_handover_documents, eq_handover_units, eq_timesheets, eq_timesheet_revisions, eq_timesheet_work_entries, eq_timesheet_verifications, eq_meter_corrections, eq_events, eq_requests, eq_document_sequences, eq_evidence.

DDL aktual: database/migrations/005_equipment_operations.sql. Seluruh tabel InnoDB, **60 FK RESTRICT, 55 CHECK, 16 primary key, 32 unique constraint dan 114 indeks total** (termasuk primary/unique/pendukung FK). Inventory nama/kolom dan relasi aktual pada tests/results/equipment-migrations.json; daftar per tabel di PHASE6_M1_M2_REPORT.md. Dipakai ulang branches, users, md_customers, md_assets(kind equipment), md_personnel(kind operator); tanpa master Equipment duplikat.

FK komposit menjaga cabang customer/header/detail/asset/personel, BA satu kontrak, period/previous/current dan revision/previous/base/pending/effective milik sumber yang benar. Reviewer menyimpan author ID yang diikat FK serta CHECK beda root/revision author. Generated unique active_asset_id menjaga satu detail nonterminal dalam satu kontrak, assignment_scope menutup lubang NULL WITHOUT, pending_root_id satu DRAFT/SUBMITTED. Unique BA lifecycle_effect mencegah dua sumber efek awal pada unit/jenis sama, sedangkan koreksi memakai NULL. eq_meter_corrections dan pointer evidence komposit menjaga bukti reset yang tepat.

Snapshot privat sebelum pemasangan menyimpan DDL/row 32 tabel awal, tidak ditimpa. Verifikasi sesudah migration: seluruh row existing tetap identik, struktur existing sama (hanya counter AUTO_INCREMENT permissions bertambah sah akibat seed). Semua 16 tabel Equipment kosong, nol akun/cabang/master/transaksi palsu. No-op migration development telah diuji. Integritas 230 PASS/0 FAIL.

Fresh/upgrade terisi dan failure/recovery diuji pada DB disposable, bukan reset development. Constraint lokal bukan pengganti service: master kind/active/scope, kalender overlap, state machine, immutable history, eligible pointers, audit atomik dan allocator/branch lock Equipment belum runtime M2. MariaDB 10.4.32 teruji; MySQL 8 belum diuji. Tidak ada tabel keuangan baru. Bagian Tahap 1–5 di bawah adalah riwayat.

## Skema aktual Tahap 5 — baseline sementara disetujui pengguna

Migration aditif `004_trucking_operations.sql` menambah tujuh tabel, total **32 tabel**, serta enam permission menjadi **63 permission**. Tidak reset atau mengubah migration terpasang 001–003. Q03/Q04/alur operasional Q09 telah disetujui sebagai baseline pengembangan V2, bukan SOP resmi perusahaan; tabel transisi ada di TRUCKING_STATE_MACHINE.md.

| Tabel baru | Tujuan dan integritas |
|---|---|
| exp_trip_legs | Leg eksplisit bernomor per Manifest; unique manifest/position; composite FK route/cabang dan lokasi/cabang; snapshot, waktu kendaraan tiba; index cabang/manifest |
| exp_sequences | PK jenis/cabang/tahun dan counter terkunci; hanya DN/MF pada Tahap 5; batas 999999 tanpa wrap/reset |
| exp_requests | PK token idempotensi; aktor, cabang, aksi, hash payload dan hasil; replay terikat identitas/permission/cakupan efektif |
| exp_receipts | Satu record unik per DN; cabang/aktor, nama penerima, jumlah utuh, kondisi dan waktu aktual; FK RESTRICT |
| exp_claims | DN/cabang/aktor, jenis/deskripsi/pelapor, state dan version; index cabang/status/tanggal/id dan DN/id |
| exp_claim_events | Ledger perubahan status dengan sebelum/sesudah/catatan/aktor/waktu; index klaim/id |
| exp_evidence | Metadata bukti privat, storage_key acak unik, MIME/size/SHA-256; unique klaim/hash mencegah lampiran identik ganda; FK aktor/klaim |

Kolom aditif: official_number unik nullable, confirmed_at pada DN/Manifest; posisi cabang/lokasi DN; current_stop Manifest; actor/alasan/target pemindahan pada membership. CHECK status diperluas untuk confirmed dan cancelled (Manifest) sesuai baseline. Identifier `number` internal tetap. Data legacy dipertahankan; posisi awal dan leg pertama dibackfill dari referensi rute yang sudah dimiliki dokumen. Backfill tidak membuat event keberangkatan, kedatangan atau penerimaan rekaan.

Snapshot membekukan nama/lokasi/armada dokumen; edit armada hanya draf dan diaudit. Generated unique active_dn_id dari 003 tetap menjadi pertahanan satu anggota aktif. Row locking, version, idempotensi dan audit berlangsung dalam transaksi yang sama; penomoran committed tidak dikembalikan saat pembatalan. File bukti berada di storage privat; kegagalan DB/audit membersihkan file baru, tidak menghapus bukti lama. Receipt tidak dibentuk dari selesai Manifest, dan klaim tidak mengubah sumber Finance.

Format INV disetujui untuk issuance Finance di masa depan; **tidak ada tabel/nomor/transaksi invoice baru pada Tahap 5**. SQL diuji pada MariaDB lokal; MySQL 8/cPanel/TLS bukan klaim terverifikasi. Bagian di bawah memuat riwayat skema/tahap lama, bukan status terkini.

Pembaruan Tahap 1: migration baru `database/migrations/001_foundation.sql` sudah dipasang pada `hls_v2_dev`. Tabel aktual: schema_migrations, roles, permissions, role_permissions, branches, users, user_branches, audit_logs, login_attempts. Semua InnoDB/utf8mb4 dengan constraint bernama eksplisit. users menambah auth_version untuk pencabutan sesi; login_attempts menyimpan hash email/IP; audit_logs menyimpan metadata JSON. Tidak ada tabel bisnis. Pengujian fresh install/idempotensi/integritas/rollback berjalan pada DB disposable baru. MariaDB 10.4.32 terverifikasi, MySQL 8 belum. Bagian berikut adalah inventaris audit proyek lama dan rancangan dependensi, bukan tabel yang disalin ke v2.

Pada Tahap 0 tidak ada koneksi DB atau SQL yang dieksekusi. Inventaris audit berikut berdasarkan database/schema.sql dan migrations/002–009 proyek lama; database lama aktual tidak diperiksa. Usulan `hls_v2_dev` kemudian direalisasikan pada Tahap 1 tanpa mengambil credential/DSN lama.

## Inventaris sumber

| Kelompok | Tabel di source |
|---|---|
| Fondasi | roles, permissions, role_permissions, branches, users, user_branches, audit_logs, login_attempts |
| Versi | schema_migrations (didefinisikan migration 002) |
| Trucking | exp_destinations, exp_routes, exp_customers, exp_tariffs, exp_pickups, exp_manifests, exp_shipments, exp_stops, exp_manifest_items, exp_events, exp_claims, exp_changes, exp_tracking_attempts |
| Equipment | rent_units, rent_tenants, rent_projects, rent_contracts, rent_handovers, rent_timesheets, rent_timesheet_events, rent_uploads, rent_changes, rent_verified_sources |
| Finance | fin_invoices, fin_payments, fin_payment_reversals, fin_invoice_sources, fin_expenses, fin_uploads, fin_events |
| Auth tambahan | auth_remember_tokens, simulation_accounts, auth_user_revisions |
| Inventori | inv_categories, inv_units, inv_items, inv_warehouses, inv_suppliers, inv_stock, inv_documents, inv_transfers, inv_ledger, inv_events |
| Petty Cash | pc_accounts, pc_requests, pc_entries, pc_uploads, pc_events |

Migration 008 menambah kebutuhan laporan/permission Owner; 009 mengubah invoice dan permission draft/publish. Jumlah inventaris source tidak disamakan dengan baseline tabel historis atau DB live.

## Relasi dan invariant

- users → roles; roles ↔ permissions lewat role_permissions; users ↔ branches lewat user_branches. all_branches adalah cakupan, bukan permission aksi.
- exp_shipments menyimpan cabang asal/tujuan/posisi; exp_manifests memiliki asal/tujuan lintasan; exp_manifest_items menghubungkan banyak DN dan menyimpan keanggotaan historis. Generated unique active shipment mencegah dua manifest aktif.
- rent_contracts merujuk unit/penyewa/proyek/operator; handover dan timesheet mengacu kontrak. rent_verified_sources menyimpan snapshot verifikasi; invoice sources menaut sumber tersebut.
- fin_invoices memiliki tepat satu sumber DN atau kontrak sesuai divisi; unique generated active source mencakup draft/submitted/returned/issued setelah 009. number nullable sebelum terbit dan unique ketika terisi.
- fin_payments merujuk invoice/cabang; fin_payment_reversals membalik pembayaran sekali. Lock invoice dan current read pembayaran efektif mencegah overpayment bersamaan.
- inv_stock mewakili barang/gudang; dokumen dan ledger menyimpan delta/saldo; transfer mempunyai leg keluar/masuk/koreksi. CHECK nonnegatif dan unique leg memperkuat service.
- pc_requests merujuk akun/cabang; pc_entries menyimpan mutasi dan unique expense Finance. Pencairan per pengajuan, saldo awal dan reversal dibatasi unique source. Expense dan ledger kas harus commit bersama.

## Rancangan v2 bertahap

Tahap 1 hanya skema fondasi: schema_migrations, roles, permissions, role_permissions, branches, users, user_branches, audit_logs, login_attempts. Remember-me bersifat opsional setelah kontrol sesi dasar teruji; tidak menyalin akun simulasi atau password seed. Tidak membuat seluruh tabel bisnis untuk memenuhi menu.

Tahap bisnis mempertahankan invariant sumber, snapshot dan histori di atas. Nama tabel final ditetapkan saat desain modul; alias UI DN tidak memerlukan rename identifier historis. Tidak membuat tabel RA, jurnal, pajak, HPP atau laba rugi tanpa keputusan. Master customer/pihak dan kendaraan perlu desain identitas serta deduplikasi yang disetujui sebelum skema final.

Standar teknis usulan: InnoDB, utf8mb4, foreign key dan index eksplisit; ID sumber tetap; DECIMAL uang dua desimal dengan aritmetika integer sen, kuantitas tiga desimal dengan integer skala 1000 mengikuti batas lama. WITA untuk tampilan dan koneksi DB. NULL mempertahankan makna belum ditetapkan. Nilai finansial tidak memakai float. Tidak menganggap DDL dapat di-rollback atomik.

Unique/FK/CHECK tidak menggantikan validasi permission/cabang/state di service. Indeks filter mencakup cabang/status/tanggal dan foreign key sesuai query; validasi EXPLAIN dilakukan pada data uji baru ketika query tersedia.

## Isolasi dan validasi yang direncanakan

1. Konfigurasi privat di luar public document root; akun DB khusus hanya untuk database baru. Tolak DSN database lama pada perintah setup/test.
2. Tidak mengimpor database, akun, saldo atau transaksi lama pada Tahap 1. Seed minimum role/permission dan bootstrap admin eksplisit, tanpa password bawaan.
3. Migration baru bernama constraint eksplisit; jangan membawa DROP CONSTRAINT CONSTRAINT_3 dari migration 009.
4. Tes fresh install dan upgrade berurutan pada DB disposable khusus v2; MySQL 8 dan MariaDB diuji terpisah sebelum mengklaim kompatibilitas. Generated columns, CHECK, FK dan ALTER berbeda antar versi.
5. Tes konkurensi active manifest/invoice, pembayaran, saldo stok/kas, idempotensi serta rollback audit ketika modulnya dibuat.
6. Import/migrasi data historis dan pemulihan lampiran merupakan proyek terpisah yang memerlukan pemetaan serta persetujuan; bukan bagian audit atau fondasi.
# Skema terpasang Tahap 4 — 24 Oktober 2026

Status pada akhir Tahap 4: 21 tabel pada hls_v2_dev, melalui migration 001 dan 002_master_data.sql. Bagian rancangan tahap sebelumnya di bawah merupakan riwayat/dependensi, bukan daftar tabel transaksi yang sudah tersedia. Tidak membaca atau memigrasikan database lama.

Sembilan tabel fondasi tetap: schema_migrations, roles, permissions, role_permissions, branches, users, user_branches, audit_logs, login_attempts. Dua belas tabel baru: md_customers, md_parties, md_locations, md_routes, md_assets, md_personnel, md_trucking_tariffs, md_equipment_tariffs, md_categories, md_units, md_items, md_suppliers. branches dipakai kembali dengan city/province/phone/version/created_at/updated_at; created_at historis NULL, bukan tanggal rekaan.

Master cabang mempunyai FK branches dan index cabang/status/nama. Rute memakai composite FK lokasi/cabang untuk kedua endpoint; tarif memakai composite FK rute/unit dan cabang terkait. Asset/personel memakai discriminator kind, bukan identitas ganda per tab. Personel opsional menunjuk users dengan account_id unik, nama dibaca dari akun. Barang menunjuk kategori/satuan katalog global, tanpa quantity/balance. Parties mempunyai fingerprint unik per cabang selain code unik. Seluruh FK bernama eksplisit dan RESTRICT; semua master memiliki ID stabil, code unik, active, version dan timestamps.

Nilai tarif DECIMAL(12,2) nullable; tidak ada rumus atau float. Penulisan service memakai transaksi/lock/version dan audit atomik; SQL DDL tidak atomik sehingga kegagalan parsial diperiksa manual, tanpa reset. Migration ulang no-op diuji; fresh install dan upgrade dari fondasi mempertahankan data/audit diuji pada DB disposable. MariaDB 10.4.32 terverifikasi; MySQL 8 belum dijalankan.

Rincian relasi/scope/keputusan: MASTER_DATA_DESIGN.md dan PHASE4_REPORT.md. Tidak ada tabel DN, kontrak, invoice, payment, inventory mutation, ledger atau Petty Cash pada Tahap 4.


## Realisasi parsial Tahap 5

Migration 003_trucking.sql menambah exp_dns, exp_manifests, exp_manifest_items, exp_events: total 25 tabel. Tidak ada tabel receipt/claim/keuangan yang dibuat sebelum keputusan SOP. FK master/aktor/cabang, snapshot JSON, CHECK nilai, unique identifier/request_key dan generated unique active_dn_id melindungi dokumen; index cabang/status/tanggal dan timeline mendukung query. Detail kolom/relasi dan batas service: PHASE5_REPORT.md. Tidak menambah membership.active rekaan pada user_branches; status efektif adalah akun aktif, cabang aktif dan penetapan masih ada.

Pemeriksaan kode cabang memakai exp_sequences yang sudah memiliki last_value>0, dalam transaksi setelah lock branches; allocator juga mengunci branch sebelum counter. Upgrade mempertahankan updated_at dokumen lama secara eksplisit dan backfill snapshot leg dari snapshot Manifest, bukan nama master yang mungkin sudah berubah.

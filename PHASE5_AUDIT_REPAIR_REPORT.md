# Laporan perbaikan terbatas audit Tahap 5 — A01–A04

24 Oktober 2026, WITA. Lingkup hanya empat temuan PHASE5_FINAL_AUDIT.md. Tahap 6, Equipment, Finance, deployment dan akses proyek/database lama tidak dilakukan.

**Status: PASS — perbaikan A01–A04 selesai dan lulus pengujian akhir; menunggu pemeriksaan pengguna.**

## Reproduksi sebelum perbaikan

Empat skenario audit asli dijalankan ulang sebelum perubahan kode aplikasi pada DB disposable V2. Hasil: **0 PASS, 4 FAIL**. Bukti [audit-repair-before.json](tests/results/audit-repair-before.json). Harness persiapan menjalankan 634 pemeriksaan existing tanpa failure; DB/akun/credential/file uji dibersihkan.

| Temuan | Sebelum | Perubahan terbatas |
|---|---|---|
| A01 | Konfirmasi berhasil walaupun lokasi asal dinonaktifkan sesudah DN dibuat | confirmDn memeriksa kembali md_locations posisi asal DN dengan current locking read di dalam transaksi, sebelum nomor/status/event diterbitkan |
| A02 | Konfirmasi berhasil setelah pihak pengirim berubah menjadi receiver | Master pengirim terkini harus aktif dan party_role sender/both; snapshot lama tidak diganti. Prinsip kelayakan master terkini mengikuti mandat pengguna terbaru |
| A03 | Kendaraan/DN dapat departed ketika lokasi muat dinonaktifkan setelah konfirmasi | depart memeriksa kembali lokasi stop muat saat ini, termasuk stop transit, di dalam transaksi dengan row lock sebelum mutasi DN/Manifest |
| A04 | Alasan pembatalan tersimpan tetapi tidak tampil pada detail Manifest | Timeline merender note hanya dari event trip_cancel historis, di-escape; aktor/cabang/waktu tetap dari record event dan identitas aktor yang sudah digunakan. GET tidak membuat event atau menulis ulang histori |

Pemeriksaan baru memakai helper active() yang sudah melakukan SELECT FOR UPDATE dan melempar 422 untuk referensi nonaktif. Tidak ada perubahan state machine, generator nomor, penerimaan, klaim, pergantian kendaraan, permission atau struktur database. Kegagalan validasi membatalkan seluruh transaksi; token gagal dapat dipakai ulang setelah master memenuhi syarat. Replay sukses tetap memakai mekanisme idempotensi existing, tanpa menerbitkan ulang dokumen.

## Pengujian permanen

[tests/phase5-audit-repairs.php](tests/phase5-audit-repairs.php) menjadi bagian wajib tests/run.php. Kasus mencakup perubahan master melalui service master setelah dokumen dibuat/dikonfirmasi, penolakan dan pemulihan kondisi positif, sender dan both, snapshot/nomor/versi tetap, tidak ada event/audit/token/sequence parsial, replay, lokasi muat di stop transit, histori pembatalan melalui HTTP, scope cabang serta alasan berisi HTML yang harus di-escape tanpa mengubah nilai tersimpan.

Browser existing diperluas dengan pemeriksaan detail pembatalan pada lima viewport: satu event historis, alasan terlihat, aktor dan waktu pada event yang sama, HTTP sukses dan tanpa overflow. Screenshot phase5-cancellation-320/375/402/768/1366.png diambil dari alur nyata pada DB uji. Tidak menambah halaman atau fitur di luar A04.

Run browser awal menemukan overflow 9 px pada lebar 320 px: identifier DN panjang di daftar keanggotaan detail pembatalan belum membungkus. Bukti [diagnosis](tests/results/audit-repair-overflow.json) dan [screenshot awal](tests/results/audit-repair-overflow.png). Daftar tersebut sekarang memakai class exp-reference yang sudah ada (overflow-wrap:anywhere), tanpa CSS/navigasi global baru. [Run awal](tests/results/audit-repair-initial-foundation.json) mencatat 657 PASS dan satu gerbang browser FAIL; hasil ini disimpan sebagai riwayat, bukan dilaporkan sebagai kelulusan. Hasil akhir setelah koreksi dilaporkan terpisah di bawah.

Run berikutnya berhenti pada selector tes nomor Manifest yang ambigu karena class pembungkusan sekarang digunakan heading dan daftar. [Ringkasan](tests/results/audit-repair-selector-foundation.json) mencatat 660 PASS dan satu gerbang browser FAIL; [diagnosis selector](tests/results/audit-repair-selector-browser.json). Selector diubah menjadi h2.exp-reference agar tetap memverifikasi nomor resmi pada heading yang benar; ekspektasi format DN/MF tidak dikurangi. Tidak ada perubahan perilaku aplikasi untuk mengatasi kegagalan selector ini.

## Hasil aktual akhir

Run final 24 Oktober 2026 selesai pukul 14:01:53 WITA: **661 PASS/0 FAIL integrasi/HTTP**, termasuk **26 regresi permanen A01–A04**; **1.982 assertion browser PASS/0 FAIL** (fondasi 108, navigasi 461, dashboard 724, master 351, dokumen Trucking 108, operasional 230). Empat probe audit asli berubah dari 0 PASS/4 FAIL sebelum perbaikan menjadi **4 PASS/0 FAIL** sesudah perbaikan. Integritas development baca-saja **138 PASS/0 FAIL**, Apache lokal/isolasi DB **16 PASS/0 FAIL**, PHP lint **89 file lulus**, sintaks JavaScript **7 file lulus**. Fixture DB/akun/credential/cookie/sesi/file uji dibersihkan; failure=null dan temporary_database_removed=true pada run final.

| Rangkaian | PASS | FAIL | Bukti |
|---|---:|---:|---|
| Integrasi/HTTP dan regresi lengkap Tahap 1–5 | 661 | 0 | [foundation.json](tests/results/foundation.json) |
| Regresi permanen A01–A04, subset 661 | 26 | 0 | [audit-repairs.json](tests/results/audit-repairs.json) |
| Empat probe audit asli sesudah perbaikan, run terpisah | 4 | 0 | [audit-repair-after.json](tests/results/audit-repair-after.json) |
| Browser fondasi/navigasi/dashboard/master/dokumen/operasional | 1.982 | 0 | [fondasi](tests/results/browser.json), [navigasi](tests/results/navigation.json), [dashboard](tests/results/dashboard-browser.json), [master](tests/results/master-browser.json), [dokumen](tests/results/expedition-browser.json), [operasional](tests/results/trucking-browser.json) |
| Integritas development baca-saja | 138 | 0 | [database-integrity.json](tests/results/database-integrity.json) |
| Apache lokal/isolasi DB | 16 | 0 | [deployment.json](tests/results/deployment.json) |
| PHP lint | 89 file | 0 | [lint.json](tests/results/lint.json) |
| Sintaks JavaScript permanen | 7 file | 0 | node --check |

Tidak menjumlahkan subset 26 sebagai suite tambahan. Operasional browser 230 mencakup 200 pemeriksaan existing dan 30 pemeriksaan baru (6 per viewport). Harness empat probe sebelum/sesudah masing-masing mengulang 634 pemeriksaan persiapan existing; pengulangan ini bukan tambahan kasus unik pada total 661.

| Kategori akhir | Status dalam mandat A01–A04 |
|---|---|
| PASS | Empat temuan ditutup dengan probe, regresi positif/negatif, HTTP dan browser terkait |
| FAIL | 0 pada run akhir; reproduksi awal dan dua kegagalan browser selama pengerjaan disimpan terpisah sebagai riwayat |
| BLOCKED | 0 pengujian wajib perbaikan; validasi Manager sebagai SOP perusahaan tetap proses terpisah |
| NOT TESTED | 0 pengujian wajib A01–A04; platform dan kasus di luar mandat tetap dibatasi pada bagian akhir laporan |

Screenshot detail pembatalan aktual: [320](tests/results/phase5-cancellation-320.png), [375](tests/results/phase5-cancellation-375.png), [402](tests/results/phase5-cancellation-402.png), [768](tests/results/phase5-cancellation-768.png), [1366](tests/results/phase5-cancellation-1366.png). Screenshot 320 dan 1366 ditinjau secara visual. Data tetap fixture DB disposable, bukan data perusahaan.

Development tetap 32 tabel, 10 role, 63 permission, nol pengguna/cabang/master/transaksi pada pemeriksaan baca-saja. Tidak ada migration baru atau tabel Equipment. Tidak mengubah aturan penerimaan/klaim/penomoran/pergantian kendaraan atau permission; Q03/Q04/Q09 tetap baseline sementara yang sudah disetujui.

## File yang berubah dan alasannya

| File | Alasan |
|---|---|
| app/Services/TruckingOperations.php | Validasi lokasi asal DN, peran pengirim terkini dan lokasi stop muat dalam transaksi |
| app/Views/expedition.php | Menampilkan alasan historis trip_cancel dengan escaping, tanpa mutasi; membungkus referensi panjang pada daftar keanggotaan detail |
| tests/phase5-audit-repairs.php — baru | Regresi backend/HTTP permanen A01–A04 |
| tests/run.php | Mengikutsertakan regresi baru dalam suite penuh |
| tests/trucking-operations.cjs | Pemeriksaan browser detail pembatalan desktop/mobile |
| PHASE5_FINAL_AUDIT.md | Status penutupan terbaru dengan bukti; hasil FAIL audit awal tetap dilabeli riwayat |
| PHASE5_REPORT.md | Addendum hasil aktual perbaikan terbatas |
| PROGRESS.md, CHANGELOG.md | Mencatat mandat, perubahan dan hasil verifikasi |
| PHASE5_AUDIT_REPAIR_REPORT.md — baru | Laporan perbaikan ini |
| tests/results/ | JSON sebelum/sesudah, regresi dan screenshot aktual |

Tidak membuat/mengubah migration, tabel, grant, konfigurasi, PHASE6_PROPOSAL.md atau aturan operasional Q03/Q04/Q09. Perubahan master dan transaksi pada tes hanya fixture database disposable; data development tidak ditulis ulang.

## Batas verifikasi

Kelulusan hanya untuk perbaikan dan regresi yang benar-benar dieksekusi. Validasi Manager sebagai SOP resmi tetap terpisah dari kelulusan teknis. Batas NOT TESTED audit sebelumnya seperti MySQL 8, Safari/perangkat fisik, TLS/cPanel, counter habis/rollover tahun nyata, pemulihan crash dan beban produksi tidak dinyatakan lulus oleh pekerjaan ini. Tidak memperluas mandat untuk menutup seluruh backlog audit di luar A01–A04.

Pekerjaan berhenti untuk pemeriksaan pengguna; Tahap 6 belum dimulai.

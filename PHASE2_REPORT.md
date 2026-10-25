# Laporan Tahap 2 — UI design system dan navigasi

Tanggal: 23 Oktober 2026, WITA. **Tahap 2 selesai; tidak ada pengujian kritis yang masih gagal. Tahap 3 belum dimulai.**

## Gerbang sebelum implementasi

Membaca IMPLEMENTATION_PLAN.md, UI_DESIGN_SYSTEM.md, DECISIONS.md, PROGRESS.md dan README.md. AGENTS.md tidak tersedia pada proyek v2. Suite Tahap 1 dijalankan sebelum perubahan UI: 101 pemeriksaan fondasi dan 107 pemeriksaan browser lulus. Tidak menggunakan kelulusan historis saja.

## Hasil implementasi

- Satu registry `app/navigation.php` berisi 43 item informasi; lima route nyata tersedia, 38 item bisnis/master/laporan menjadi backlog. Semua rendering menapis availability, keberadaan route GET, kesesuaian permission, grant role dan cakupan global. Tidak mengubah role, permission, skema/migration atau aturan bisnis.
- Dashboard adalah tautan langsung `/`, bukan accordion/halaman pengantar. Kontennya tetap data fondasi akun/cakupan sendiri dari DB; tidak membuat KPI atau dashboard bisnis Tahap 3.
- Sidebar desktop dan drawer mobile menggunakan elemen/partial sidebar yang sama. Accordion, menu aktif, SVG, area scroll dan informasi cakupan mengikuti palet HLS. Breakpoint desktop 1024px; tablet 768px memakai drawer/bottom nav.
- Header desktop menampilkan judul kiri dan profil kanan; mobile menempatkan satu hamburger kiri, logo proporsional, profil paling kanan. Notifikasi belum mempunyai sumber data, sehingga tidak ada tombol/dot/badge palsu.
- Drawer: X, overlay, Escape dan pilihan menu menutup; scroll latar dikunci, workspace/bottom nav inert, role dialog/aria-modal saat buka, fokus awal X, fokus Tab/Shift+Tab berputar hanya pada elemen yang dapat dipakai, dan kembali ke pemicu saat ditutup. Submenu accordion tertutup dikecualikan dari fokus.
- Bottom nav berasal dari registry yang sama, maksimal lima item. Saat ini Administrator global memperoleh Dashboard/Pengguna/Cabang/Pengaturan, admin scoped Dashboard/Cabang, sembilan role lain Dashboard saja. Pengaturan menuju `/roles` yang nyata. Tinggi dasar 64px + safe-area, SVG 21px, label 10px, ukuran/font aktif sama. Konten memiliki ruang bawah untuk navigasi.
- Profil memakai identitas DB, tautan `/#account-details` dan logout POST/CSRF; tidak membuat route profil kosong.
- Komponen reusable terpasang pada halaman nyata: header, sidebar/drawer, bottom nav, breadcrumb, heading, card, tabel dengan scroll lokal, input/select/textarea, pagination, empty state, alert, validasi, modal konfirmasi dan loading state. Form edit Pengguna/Cabang menggunakan konfirmasi; pembuatan baru tidak diberi konfirmasi tambahan. Tanpa JavaScript, validasi server/otorisasi tetap berlaku.
- List fondasi dipaginasi 10 catatan setelah scope akses; audit tetap terbatas 100 terbaru seperti fondasi sebelumnya. Pengguna diurutkan ID terbaru agar hasil pembuatan muncul di halaman pertama. Error 422/duplikasi 409 mempertahankan isian aman, password selalu kosong. Tidak menampilkan credential di laporan/screenshot.

## Struktur komponen navigasi

```text
app/navigation.php (ID, label, route, ikon, grup, permission,
                    available, global, prioritas/label shortcut)
  -> Services/Navigation.php (validasi route + filter permission/cakupan)
     -> Http/View.php
        -> components/sidebar.php (desktop + drawer yang sama)
        -> components/bottom-navigation.php
        -> components/header.php (profil dan pemicu drawer)
public/assets/interface.js (interaksi, fokus, modal, validasi, loading)
public/assets/foundation.css (token, komponen dan layout responsif)
```

Backend route/controller/service tetap menegakkan hak akses. Menyembunyikan menu tidak menggantikan pemeriksaan backend. Rincian item yang ditunda: [NAVIGATION_BACKLOG.md](NAVIGATION_BACKLOG.md).

## Pengujian aktual akhir

| Suite | Hasil | Bukti |
|---|---|---|
| Service/HTTP, registry/pagination dan gerbang browser | 109 lulus, failure=null | tests/results/foundation.json |
| Browser regresi fondasi | 107 lulus | tests/results/browser.json |
| Browser navigasi/komponen | 236 lulus, tanpa failure | tests/results/navigation.json |
| Apache/aset/isolasi DB | 14 lulus | tests/results/deployment.json |
| PHP lint | 54 berkas, 0 gagal | tests/results/lint.json |
| Sintaks JavaScript | interface.js, browser.cjs, navigation.cjs lulus node --check | Verifikasi akhir |

109 assertion PHP mencakup satu gerbang hasil suite browser, bukan 109 skenario browser tambahan. Browser fondasi dan navigasi dijalankan pada Chromium nyata, menggunakan izin launch di luar sandbox yang memblokir spawn. Seluruh fixture ada pada database/akun v2 sementara, bukan database development atau database lama. Database, akun, file credential/cookie dan sesi test dibersihkan sesudah run.

| Viewport | Assertion navigasi khusus viewport | Hasil |
|---|---:|---|
| 320 × 640 | 42 | Lulus |
| 375 × 812 | 42 | Lulus |
| 402 × 874 | 42 | Lulus |
| 768 × 1024 | 42 | Lulus |
| 1366 × 768 | 28 | Lulus |

Total per viewport 196; ditambah 40 assertion komponen/pergantian akun = 236. Viewport mobile menguji drawer, fokus, X/overlay/Escape, header, bottom nav, ruang bawah, logo drawer utuh, dan header tetap atas saat scroll; desktop menguji sidebar/accordion. Semua viewport memeriksa route nyata, satu menu aktif, tidak ada overflow halaman, logo proporsional dan navigasi antarhalaman. Tabel lebar dapat digulir lokal.

Uji komponen memakai edit cabang sungguhan pada fixture: validasi inline, pembatalan/Escape dialog tanpa submit, input tetap ada, konfirmasi simpan, loading state teramati lewat MutationObserver sebelum navigasi POST, alert sukses, dan pagination menuju catatan berbeda. Jeda jaringan hanya di runner browser untuk observasi loading, bukan delay aplikasi.

## Pemeriksaan permission

Pergantian akun dilakukan pada browser context yang sama untuk mendeteksi menu yang tertinggal. Sepuluh role diuji: Administrator, Owner, Admin Pengirim, Admin Transit, Admin Penerima, Admin Sewa, Operator Alat Berat, Finance, Gudang, Customer. Hanya Administrator global melihat Pengguna dan dapat membuka `/users`; sembilan role lain mendapat 403, dan hanya shortcut Dashboard. Administrator scoped diuji terpisah: tidak melihat menu global, memiliki Dashboard/Cabang, dan tidak melihat cabang lain.

Suite HTTP juga tetap membuktikan penolakan POST tak berizin/luar cabang, CSRF, session timeout/logout/replay, rate limiting dan rollback audit. Registry diuji dengan Owner bercakupan global: all_branches tidak memberi izin menu tambahan. Tidak menambah grant agar menu bisnis muncul.

## Screenshot aktual

- [Desktop 1366×768](tests/results/phase2-1366.png)
- [Mobile 375×812](tests/results/phase2-375.png)
- [Drawer 320×640](tests/results/phase2-drawer-320.png)
- Viewport lain: phase2-320.png, phase2-402.png, phase2-768.png; drawer phase2-drawer-375/402/768.png; seluruhnya di tests/results.

Screenshot memakai data fiktif DB disposable. Teks payload script pada satu baris adalah fixture pengujian output escaping, ditampilkan sebagai teks aman. Snapshot drawer diambil setelah animasi selesai agar tidak merekam posisi transisi sebagai layout akhir.

## Daftar file ditambah/diubah

Konfigurasi dan helper:

- app/navigation.php (baru)
- app/Services/Navigation.php (baru)
- app/Http/Icons.php (baru)
- app/Http/Pagination.php (baru)
- app/Http/View.php
- app/Controllers/FoundationController.php
- app/Repositories/UserRepository.php

Views:

- app/Views/layout.php
- app/Views/login.php
- app/Views/home.php
- app/Views/users.php
- app/Views/branches.php
- app/Views/roles.php
- app/Views/audit.php
- app/Views/error.php

Komponen baru pada app/Views/components/:

- header.php, sidebar.php, bottom-navigation.php
- breadcrumb.php, page-heading.php, card.php
- table.php, field.php, pagination.php
- alert.php, empty-state.php, confirmation.php, loading.php

Aset dan pengujian:

- public/assets/foundation.css
- public/assets/interface.js (baru)
- public/router.php (allowlist aset JS)
- tests/browser.cjs
- tests/navigation.cjs (baru)
- tests/run.php
- tests/deployment.php
- tests/results/: JSON, log dan screenshot aktual (artefak lokal diabaikan Git)

Dokumentasi:

- README.md, DECISIONS.md, PROGRESS.md, CHANGELOG.md
- IMPLEMENTATION_PLAN.md, UI_DESIGN_SYSTEM.md
- NAVIGATION_BACKLOG.md (baru), PHASE2_REPORT.md (baru)

Tidak mengubah app/routes.php, skema/migration, config/local.php, aset logo resmi, proyek/database lama atau hosting.

## Kekurangan dan batas verifikasi

Tidak ada kegagalan kritis terbuka untuk Tahap 2. Notifikasi, 38 menu backlog, dashboard bisnis per role dan editor permission dinamis belum tersedia; tidak diwakili tombol/halaman palsu. Data akun, role, cabang dan audit tetap nyata.

Pengujian viewport menggunakan emulasi Chromium, bukan perangkat fisik. Nilai safe-area CSS diterapkan, tetapi inset perangkat fisik/Safari/iOS belum diverifikasi. MySQL 8, HTTPS/TLS dan hosting cPanel belum diuji. Database development tetap sembilan tabel fondasi, tanpa fixture test; akun admin tetap dibuat oleh pemilik lewat bootstrap tanpa default.

**Berhenti setelah Tahap 2. Tahap 3 hanya setelah persetujuan pengguna.**

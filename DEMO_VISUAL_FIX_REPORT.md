# Demo Visual Fix Report

Tanggal: 24 Oktober 2026 (WITA)

## Akar masalah

`config/demo.php` menggunakan base path `/hls-v2/public/demo`, sehingga `View::url()` menghasilkan URL seperti `/hls-v2/public/demo/assets/foundation.css`. Asset fisik tetap berada di `/hls-v2/public/assets`. Karena `public/demo/.htaccess` sebelumnya hanya meneruskan route ke front controller, request asset diproses sebagai halaman aplikasi dan menerima HTML/404. Browser kemudian menampilkan halaman tanpa CSS, sementara SVG inline kehilangan aturan ukuran stylesheet.

## Perbaikan

Ditambahkan rule Apache minimal pada `public/demo/.htaccess`:

```apache
RewriteRule ^assets/(.*)$ ../assets/$1 [L]
```

Resolver URL aplikasi tetap konsisten memakai base path demo; tidak ada duplikasi CSS/JS, perubahan desain, permission, database, atau aturan bisnis. URL development `/hls-v2/public` tidak diubah.

## Verifikasi asset aktual

| Asset | URL demo | Status | Content-Type |
|---|---|---:|---|
| CSS | `/hls-v2/public/demo/assets/foundation.css` | 200 | `text/css` |
| JavaScript | `/hls-v2/public/demo/assets/interface.js` | 200 | `text/javascript` |
| Logo | `/hls-v2/public/demo/assets/images/logo.png` | 200 | `image/png` |

## Pengujian browser nyata

Playwright Chromium dijalankan pada URL Apache demo, dengan Owner dan Administrator pada viewport 320, 768, dan 1366.

- 6/6 skenario visual PASS.
- CSS stylesheet terdeteksi.
- Sidebar tampil.
- Ikon berukuran normal.
- Tidak ada horizontal overflow.
- Tidak ada console error.
- Tidak ada response asset 4xx/5xx atau Content-Type salah.
- Login dan redirect dashboard berhasil.
- Screenshot tersimpan di `tests/results/demo-owner-320.png`, `demo-owner-768.png`, `demo-owner-1366.png`, serta pasangan Administrator.

Screenshot desktop Owner telah diperiksa secara visual dan menunjukkan sidebar, header, kartu dashboard, logo, ikon, dan grid layout telah tertata.

| Viewport | Owner | Administrator |
|---:|---|---|
| 320 | PASS | PASS |
| 768 | PASS | PASS |
| 1366 | PASS | PASS |

## Status development dan demo

- URL demo: `http://localhost/hls-v2/public/demo/login`.
- URL development tidak dialihkan ke database demo.
- Database dan permission tidak berubah.
- Apache global tidak diubah.
- Tidak ada deployment atau pekerjaan M6/M7.

Status visual demo: **PASS untuk skenario browser yang dijalankan**.

## Revisi identitas presentasi

Nama tampilan akun pada database demo diubah menjadi nama jabatan profesional dan nama cabang menjadi `Kantor Pusat`. Kode teknis `DMO`, database `hls_v2_demo`, email login, dan mekanisme isolasi tetap dipertahankan. Master fixture yang tampil pada UI juga menggunakan nama profesional tanpa label teknis demo.

Pemeriksaan browser ulang Owner/Administrator pada tiga viewport tetap **6/6 PASS** setelah perubahan label. Istilah teknis demo hanya tersisa pada konfigurasi privat, script setup/reset, dan dokumentasi internal; tidak dirender sebagai isi halaman.

Keterbatasan: pengujian dilakukan pada Chromium lokal; Safari/perangkat fisik dan hosting HTTPS belum diuji.

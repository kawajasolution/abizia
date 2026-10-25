# Perbaikan Dashboard Owner dan Navigasi

Tanggal: 24 Oktober 2026 (WITA)

## Perubahan

- KPI Owner dikelompokkan menjadi section `TRUCKING` dan `EQUIPMENT`.
- Masing-masing section memiliki lima kartu: label, angka, dan tautan detail.
- Nama modul tidak lagi diulang pada setiap kartu.
- Grid desktop menggunakan lima kolom, tablet tiga kolom, dan mobile dua kolom.
- Navigasi Owner sekarang selalu menampilkan tujuh kelompok utama: Dashboard, Trucking, Equipment, Keuangan, Inventory, Laporan, dan Master Data.
- Keuangan, Inventory, dan Laporan yang belum memiliki route ditampilkan sebagai `Dalam Pengembangan` tanpa tautan dan tanpa permission baru.
- RBAC, sumber KPI, query database, dan aturan bisnis tidak diubah.

## File diubah

- `app/Views/dashboard.php`
- `app/Views/components/sidebar.php`
- `app/Services/Navigation.php`
- `public/assets/foundation.css`

## Verifikasi

- PHP lint dashboard: PASS.
- PHP lint sidebar: PASS.
- PHP lint Navigation: PASS.
- Browser visual Owner/Administrator pada 320, 768, dan 1366 px: **6/6 PASS** setelah pengulangan untuk menghindari respons cache CSS 304.
- Screenshot desktop Owner: `tests/results/demo-owner-1366.png`.
- Screenshot mobile Owner: `tests/results/demo-owner-320.png`.
- Screenshot mobile drawer terbuka: `tests/results/owner-mobile-navigation-open.png`.

Screenshot desktop menunjukkan tujuh kelompok sidebar dan section KPI yang terpisah. Screenshot mobile menunjukkan kartu dua kolom tanpa horizontal overflow dan drawer navigasi dengan kelompok yang sama.

Tidak ada perubahan database, permission, state machine, atau modul Finance/Inventory.

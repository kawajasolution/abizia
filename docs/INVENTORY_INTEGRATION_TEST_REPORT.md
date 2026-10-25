# Inventory Integration Test Report

Tanggal: 25 Oktober 2026

## PASS

- PHP lint controller, routes, migrator, dan view Inventory terkait.
- Pemeriksaan static route/state/locking melalui `tests/inventory-integrity.php`.
- Migration 019-027 tercatat pada database aktif sebelumnya.

## FIXED

- Stock Opname dan Adjustment memiliki state transition terpisah.
- Adjustment hanya menulis `inv_stock_ledger` pada POSTED.
- Posting menggunakan lock header dan item serta validasi stok negatif.
- Approver tidak boleh menyetujui dokumen yang dibuat sendiri.

## NOT TESTED

- Browser responsive.
- UAT end-to-end dengan data stok.
- Transfer bersamaan, issue bersamaan, adjustment bersamaan.
- Rollback database nyata dan verifikasi tidak ada ledger parsial.

## BLOCKED

Pengujian integrasi database tidak dijalankan dengan fixture karena instruksi melarang membuat data uji pada database operasional `hls_v2` dan belum ada database isolasi yang diizinkan.

## Risiko tersisa

Pengujian concurrency/deadlock dan rekonsiliasi Stock Opname setelah transaksi pasca-snapshot masih memerlukan environment terisolasi. Pencegahan koreksi opname ganda dan rekonsiliasi sumber VERIFIED perlu diuji pada fixture database sebelum UAT.

Inventory belum dinyatakan production-ready; kesiapan UAT: **belum siap tanpa pengujian database dan browser terisolasi**.

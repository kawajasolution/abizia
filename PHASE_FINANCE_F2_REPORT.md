# Finance F2 — Implementasi Fondasi

Tanggal: 25 Oktober 2026 (WITA)

## Status

**Fondasi database terpasang; halaman Finance belum diaktifkan.**

## Backup sebelum migration

- File: `storage/private/backups/20261025_004706_pre-finance.sql`
- Ukuran: 114,713 bytes
- SHA-256: `8EF2CA3882A42AAE01718A4DAA2A79A503CE368201A81EDA7F7B5901FC25D3C0`
- Database sumber: `hls_v2`

## Migration

Migration `006_finance_foundation.sql` dipasang melalui `Hls\\Services\\Migrator::install()` dan dicatat sebagai `006_finance_foundation`.

Tabel yang dibuat:

- `fin_accounts`
- `fin_expense_categories`
- `fin_invoices`
- `fin_invoice_lines`
- `fin_payments`
- `fin_payment_allocations`
- `fin_supplier_bills`
- `fin_supplier_bill_lines`
- `fin_cash_ledger`
- `fin_expenses`
- `fin_events`

Semua tabel kosong, sehingga tidak ada transaksi finansial atau angka buatan yang masuk ke database.

## Integritas yang diterapkan

- Foreign key cabang, customer, supplier, rekening, invoice, payment, dan aktor.
- Nominal DECIMAL.
- Status lifecycle awal.
- Unique reference dan allocation.
- Index scope/status/tanggal.
- Ledger kas append-only secara desain.
- Event Finance dengan request key unik.

## File berubah

- `database/migrations/006_finance_foundation.sql`
- `app/Services/Migrator.php`
- `PHASE_FINANCE_F2_REPORT.md`

## Belum aktif

Route, controller, repository, service, form, dan menu Finance belum diaktifkan karena workflow invoice, pembayaran, approval, dan permission Finance belum memiliki implementasi server-side lengkap. Inventory dan Laporan juga belum dikerjakan.

## Pengujian aktual

- Backup dan checksum: PASS.
- Migration pada `hls_v2`: PASS.
- Migration idempoten dicatat melalui schema journal: PASS.
- Verifikasi 11 tabel dan row awal 0: PASS.
- Pengujian transaksi invoice/payment end-to-end: NOT TESTED — service dan route belum aktif.
- Browser Finance: NOT TESTED — menu tetap nonaktif.

Tidak ada perubahan pada tabel Trucking/Equipment, data existing, permission sensitif, atau aturan bisnis.
## Implementasi berkelanjutan 25 Oktober 2026

Migration aditif `007_finance_permissions.sql` berhasil dipasang setelah backup `storage/private/backups/20261025_005500_pre-finance-accounts.sql` (SHA-256 `A6362B9BA6C5933A1C04BC3E1D9E8627A9BF5F1CF563F25D82232E581D0355E4`).

Kas & Bank sekarang mendukung tambah rekening, perubahan status aktif/nonaktif, validasi kode unik per cabang, validasi cakupan cabang, optimistic version check, CSRF global, dan audit. Kategori Pengeluaran memiliki daftar serta tambah dengan validasi kode unik, status, CSRF, RBAC, dan audit.

Route aktif: `/finance/accounts` dan `/finance/expense-categories`. Permission baru didefinisikan dan hanya diberi ke role Finance: `finance.account.manage`, `finance.category.view`, `finance.category.manage`.

Verifikasi aktual: migration PASS; PHP lint 5 file PASS; endpoint tanpa autentikasi menolak dengan 303 ke login untuk kedua route; akses menu tetap permission-gated. Invoice, pembayaran, piutang, utang, pengeluaran, dan dashboard Finance belum diaktifkan karena workflow transaksinya belum selesai.

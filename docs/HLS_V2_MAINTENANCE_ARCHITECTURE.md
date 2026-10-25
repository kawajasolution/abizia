# HLS V2 Maintenance Architecture

Maintenance menjadi modul bersama untuk kendaraan dan alat berat, memakai master unit existing dan branch scope yang sama.

Alur utama:

`P2H -> Temuan -> Work Order -> Reservasi Spare Part -> Barang Keluar -> Service Report -> Unit Siap Operasi`

Work Order memiliki status DRAFT, SUBMITTED, APPROVED, IN_PROGRESS, WAITING_PARTS, COMPLETED, dan CANCELLED. Perubahan status memerlukan permission terpisah, audit, CSRF, dan locking.

Integrasi:
- Fleet/Equipment menyediakan unit, cabang, HM/KM, operator, dan status operasi.
- Inventory menyediakan reservasi, stok gudang, Barang Keluar, dan ledger.
- Finance menerima biaya mekanik, spare part, downtime, dan biaya per unit setelah klasifikasi disetujui.
- P2H kritis menempatkan unit HOLD; pelepasan HOLD memerlukan pemeriksaan dan otorisasi.

Belum dibuat pada putaran ini: migration, route aktif, transaksi maintenance, dan dashboard angka biaya.

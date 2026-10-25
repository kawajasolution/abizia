# HLS Transport System V2 — Finance F1 Design

Status: **Desain F1 saja — belum implementasi**  
Tanggal: 25 Oktober 2026 (WITA)

Dokumen ini merancang fondasi Finance tanpa mengubah database `hls_v2`, migration, route, permission, atau aturan operasional Tahap 1–6. Invoice, pembayaran, utang, kas/bank, dan laporan keuangan belum aktif.

## 1. Prinsip dan batas

Status operasional Trucking/Equipment tetap terpisah dari status keuangan. DN, Manifest, kontrak, BA, atau timesheet tidak otomatis membuat invoice atau omzet. Semua nilai finansial harus berasal dari transaksi Finance yang sah, memiliki aktor, cabang, tanggal WITA, sumber, dan histori.

## 2. Struktur tabel usulan

Migration aditif berikut diusulkan setelah keputusan bisnis dikunci:

| Tabel | Fungsi utama |
|---|---|
| `fin_accounts` | Rekening kas/bank, cabang pemilik, tipe, nomor, mata uang, status |
| `fin_account_events` | Pembukaan, perubahan status, dan histori rekening |
| `fin_invoices` | Header invoice, customer, cabang, nomor resmi, tanggal, jatuh tempo, status, subtotal, pajak/diskon manual, total |
| `fin_invoice_lines` | Baris tagihan, deskripsi, kuantitas, harga manual, sumber operasional |
| `fin_invoice_sources` | Referensi DN/receipts atau kontrak/timesheet; unique sumber aktif sesuai keputusan |
| `fin_invoice_events` | Ledger perubahan status dan koreksi invoice |
| `fin_payments` | Penerimaan pelanggan, tanggal, akun kas/bank, nominal, referensi, status |
| `fin_payment_allocations` | Alokasi pembayaran ke invoice dengan unique invoice/payment dan lock anti-overpayment |
| `fin_payment_reversals` | Pembalikan pembayaran satu kali dengan alasan dan audit |
| `fin_receivables` | Proyeksi saldo invoice issued, jatuh tempo, paid, outstanding; bukan saldo yang diedit manual |
| `fin_suppliers` | Referensi supplier dari master yang telah ada atau tabel relasi supplier |
| `fin_payables` | Kewajiban supplier, sumber, tanggal, jatuh tempo, status, nominal |
| `fin_payable_events` | Ledger perubahan kewajiban |
| `fin_expenses` | Pengeluaran operasional, kategori, cabang, akun sumber, bukti, approval, nominal |
| `fin_cash_transactions` | Mutasi kas/bank masuk, keluar, transfer, referensi, status |
| `fin_reconciliations` | Rekonsiliasi rekening/periode, saldo buku, saldo bank, selisih dan keputusan |
| `fin_evidence` | Bukti privat pembayaran, utang, pengeluaran, rekonsiliasi |
| `fin_requests` | Idempotency key, payload hash, aktor, hasil transaksi |
| `fin_sequences` | Counter invoice per jenis/cabang/tahun; nomor hanya dialokasikan saat terbit |

Semua tabel memakai primary key internal, `branch_id`, actor/timestamp bila relevan, foreign key `RESTRICT` untuk histori, indeks status/tanggal/cabang, unique idempotency token, dan optimistic version. Nominal memakai DECIMAL, bukan floating point.

## 3. Relasi

- Invoice memiliki customer, cabang, baris, sumber operasional dan event.
- Satu sumber penagihan aktif hanya boleh dipakai sesuai kebijakan jenis dokumen; invoice void mempertahankan histori dan tidak membuka penggunaan ulang tanpa aturan eksplisit.
- Payment memiliki satu atau banyak alokasi invoice; jumlah alokasi efektif tidak boleh melebihi nominal pembayaran atau saldo invoice.
- Payable memiliki supplier, cabang, sumber kewajiban, event dan pembayaran supplier bila model tersebut disetujui.
- Cash transaction mengikat account dan, bila relevan, invoice/payment/payable/expense.
- Semua relasi branch-scoped harus memeriksa active membership dan cakupan aktor di server.

## 4. Status dan alur invoice

Usulan state: `DRAFT → SUBMITTED → RETURNED/APPROVED → ISSUED → PARTIALLY_PAID → PAID`; `VOID` hanya melalui permission dan alasan. Status `ISSUED` menerbitkan nomor `INV/{KODE_CABANG}/{TAHUN}/{000001}`. Pembayaran hanya dapat dialokasikan ke invoice `ISSUED`, `PARTIALLY_PAID`, atau sesuai status terminal yang disetujui. Tidak ada penerbitan otomatis dari DN, Manifest, kontrak, BA, atau timesheet.

## 5. Piutang

Piutang adalah saldo invoice yang sudah `ISSUED` dikurangi alokasi pembayaran efektif dan pembalikan yang sah. Jatuh tempo ditentukan oleh tanggal terbit + termin yang disetujui, bukan sekadar invoice belum dibayar. Aging memisahkan belum jatuh tempo, jatuh tempo, dan lewat jatuh tempo berdasarkan WITA.

## 6. Utang dan pengeluaran

Utang dibuat dari tagihan supplier atau kewajiban operasional yang disetujui, bukan dari setiap master supplier. Pengeluaran memerlukan kategori, nominal, tanggal, cabang, rekening sumber, referensi, bukti opsional/wajib sesuai keputusan, approval, dan histori. Pembayaran utang harus idempotent, mengunci payable, dan tidak boleh melebihi saldo efektif.

## 7. Kas dan bank

`fin_accounts` menyimpan rekening, bukan saldo yang dapat diedit. Saldo dihitung dari opening balance yang disetujui dan `fin_cash_transactions` yang committed. Transfer antar rekening membuat pasangan mutasi atomik. Rekonsiliasi menutup periode/rekening dengan snapshot saldo bank, saldo buku, selisih, alasan, dan aktor; koreksi memakai transaksi pembalik, bukan edit histori.

## 8. Integrasi Trucking

Adapter penagihan hanya membaca DN/receipt/claim sesuai keputusan sumber penagihan. Kandidat invoice harus menunjukkan DN, customer, cabang, status penerimaan/penyelesaian, dan sumber yang belum ditagihkan. Klaim tidak membuat refund, kompensasi, atau credit otomatis. Tanggal pengakuan pendapatan harus diputuskan terpisah dari tanggal DN, penerimaan, dan invoice.

## 9. Integrasi Equipment

Adapter membaca kontrak, unit, periode aktual, BA, dan timesheet `APPROVED` sesuai aturan. Timesheet `SUBMITTED` belum menjadi dasar penagihan final kecuali keputusan mengizinkan accrual. Nilai kontrak tidak sama dengan omzet yang diakui. Tarif, jam, HM, minimum charge, termin, dan perubahan periode harus berasal dari aturan serta input Finance yang disetujui, bukan kalkulasi otomatis asumtif.

## 10. Role dan permission usulan

Permission didefinisikan tetapi tidak di-seed otomatis pada F1:

- `finance.dashboard.view`
- `finance.invoice.view/create/update/submit/approve/issue/void`
- `finance.receivable.view`
- `finance.payment.view/create/allocate/reverse`
- `finance.payable.view/create/approve`
- `finance.expense.view/create/submit/approve`
- `finance.account.view/manage`
- `finance.cash.view/post/reconcile`
- `finance.report.view/export`

Grant harus mengikuti pemisahan tugas, branch scope, dan keputusan organisasi. Pembuat invoice tidak otomatis boleh menerbitkan; pembuat pembayaran tidak otomatis boleh membalik; pembuat pengeluaran tidak otomatis menyetujui.

## 11. Audit, idempotensi, konkurensi

Setiap perubahan menulis event append-only dan `audit_logs` dalam transaksi yang sama. Request key + payload hash mencegah pengiriman ganda. Sequence, invoice, saldo payment, payable, dan cash account dikunci saat transaksi. Rollback harus membatalkan data bisnis, event, audit, sequence allocation yang belum committed, dan file metadata. Histori confirmed/issued/paid/void tidak dihapus atau ditimpa.

## 12. Definisi omzet dan laba/rugi

Definisi sementara untuk desain: omzet bukan nilai kontrak atau invoice draft; omzet hanya dapat dihitung setelah kebijakan tanggal pengakuan dan status `ISSUED`/delivery terpenuhi. Pendapatan ditagihkan, pendapatan diakui, dan kas diterima harus menjadi metrik terpisah. Laba/rugi memerlukan pendapatan diakui dikurangi beban yang diakui pada periode yang sama, termasuk kebijakan accrual, koreksi, pajak, dan tutup buku.

## 13. Keputusan yang masih memerlukan persetujuan

1. Sumber invoice Trucking: DN confirmed, receipt, completed, atau kombinasi.
2. Sumber invoice Equipment: kontrak, BA, approved timesheet, HM, atau kombinasi.
3. Tanggal pengakuan pendapatan dan kebijakan accrual.
4. Termin, jatuh tempo, DP, cicilan, pajak, diskon, credit note, refund, write-off.
5. Apakah satu DN/kontrak boleh memiliki lebih dari satu invoice aktif.
6. Model supplier dan dokumen utang yang sah.
7. Kategori, approval, dan bukti pengeluaran.
8. Saldo awal kas/bank, transfer, rekonsiliasi, dan periode tutup buku.
9. Hak Owner lintas cabang terhadap nominal sensitif.
10. Role Finance yang menerima grant setiap permission dan aturan maker-checker.
11. Koreksi setelah invoice issued atau periode ditutup.
12. Format ekspor laporan dan retensi bukti.

## Status F1

Dokumen desain selesai sebagai bahan persetujuan. Tidak ada migration, tabel, route, seed permission, atau perubahan database yang dibuat. Menu Finance tetap nonaktif sampai F1 disetujui dan F2 benar-benar diimplementasikan.

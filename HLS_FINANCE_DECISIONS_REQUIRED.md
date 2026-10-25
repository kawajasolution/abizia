# HLS Finance — Keputusan yang Diperlukan Sebelum Implementasi

Dokumen ini merangkum keputusan yang memblokir migration dan transaksi Finance. Menu Finance, Inventory, dan Laporan tetap nonaktif sampai keputusan berikut disetujui.

1. **Dasar invoice Trucking** — invoice boleh dibuat berdasarkan DN terkonfirmasi, DN diterima, DN selesai, atau kombinasi dengan syarat per customer?
2. **Dasar invoice Equipment** — invoice berdasarkan kontrak, BA HANDOVER/RETURN, timesheet APPROVED, HM, periode aktual, atau kombinasi?
3. **Pengakuan omzet** — tanggal pengakuan mengikuti invoice ISSUED, penerimaan aktual, penyelesaian layanan, atau jurnal accrual terpisah?
4. **Termin dan jatuh tempo** — termin standar per customer, tanggal tetap, atau input per invoice; bagaimana DP dan cicilan dicatat?
5. **Pajak dan diskon** — apakah diterapkan manual per invoice/baris; jenis dan tarif apa yang sah?
6. **Koreksi invoice** — apakah koreksi memakai credit/debit note; kapan invoice boleh VOID; bagaimana invoice pada periode tutup dikoreksi?
7. **Invoice ganda** — apakah satu DN/kontrak boleh memiliki lebih dari satu invoice aktif untuk termin atau sebagian layanan?
8. **Pembayaran pelanggan** — apakah pembayaran parsial diperbolehkan; apakah satu pembayaran boleh dialokasikan ke banyak invoice; bagaimana overpayment dan reversal?
9. **Utang supplier** — dokumen apa yang menciptakan kewajiban; apakah pembayaran supplier termasuk Finance tahap ini?
10. **Pengeluaran** — kategori wajib, batas approval, bukti wajib, dan siapa yang boleh membuat/menyetujui/posting?
11. **Kas dan bank** — saldo awal, transfer antar rekening, rekening per cabang, rekonsiliasi, serta periode tutup buku.
12. **Hak akses** — grant setiap permission Finance untuk role Finance, Administrator, Owner, dan role lain; apakah Owner hanya membaca agregat lintas cabang?
13. **Laba/rugi** — metode pengakuan beban, accrual, pajak, periode tutup, dan perlakuan koreksi setelah tutup buku.
14. **Laporan** — kebutuhan ekspor, format, pembulatan, zona waktu, dan retensi dokumen/bukti.

Implementasi dapat dimulai setelah jawaban ini dikunci. Pekerjaan teknis yang tidak bergantung pada keputusan, seperti migration journal, tabel idempotency, dan skeleton repository, sebaiknya tetap menunggu agar tidak membekukan model yang salah.

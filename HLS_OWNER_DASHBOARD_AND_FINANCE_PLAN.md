# HLS Owner Dashboard and Finance Plan

Status: **Rencana analisis — belum implementasi**  
Tanggal: 24 Oktober 2026 (WITA)

## 1. Evaluasi dashboard Owner saat ini

Dashboard saat ini berhasil melakukan autentikasi, filter cabang, menampilkan jumlah cabang, shortcut yang memiliki route, identitas akses, serta bagian administrasi. Definisi Owner memang memuat operasi, keuangan, monitoring, perhatian, dan tren, tetapi `Dashboard` menandai seluruh bagian tersebut `unavailable` karena belum ada business adapter dan sumber Finance. Akibatnya Owner belum memperoleh KPI operasional maupun keuangan yang dapat dipertanggungjawabkan.

Kondisi ini benar secara integritas data karena sistem tidak mengarang angka. Namun secara kebutuhan klien, dashboard belum selesai: tombol dan daftar sumber kosong tidak dapat menggantikan ringkasan yang bersumber dari transaksi nyata.

## 2. Data yang sudah tersedia

Trucking sudah memiliki tabel DN, Manifest, item Manifest, event perjalanan, trip leg, receipt, claim, claim event, evidence, request, sequence, dan audit terkait. Sumber yang dapat dihitung setelah ada data adalah jumlah DN per status, manifest aktif, event terakhir, penerimaan aktual, klaim operasional, dan cakupan cabang.

Equipment sudah memiliki kontrak multi-unit, periode unit, reservasi/penugasan operator, otorisasi cabang, BA HANDOVER/RETURN, timesheet dan revisi/verifikasi, event, evidence, request, sequence, serta master alat/operator. Sumber yang dapat dihitung adalah unit per status, kontrak per status/periode, timesheet SUBMITTED, dan aktivitas BA.

Database utama saat ini belum memiliki transaksi bisnis; karena itu semua KPI operasional harus tetap kosong atau berstatus belum tersedia sampai workflow menghasilkan data sah.

## 3. Data yang belum tersedia

Belum ada tabel atau service Finance untuk invoice, pembayaran, piutang, utang, kas/bank, pengeluaran, dan jurnal laba/rugi. Menu Finance dan laporan keuangan yang `route=null` tidak boleh dijadikan tautan aktif. Tidak boleh menyimpulkan omzet dari nilai kontrak, jumlah DN, atau timesheet; tidak boleh menyimpulkan pembayaran dari invoice; dan tidak boleh menyebut saldo jatuh tempo tanpa aturan tanggal/status yang disetujui.

## 4. Struktur menu Owner yang diusulkan

Menu aktif hanya route yang memiliki controller, service, repository, permission, dan pengujian. Struktur yang diusulkan:

- Dashboard Executive.
- Trucking: DN, Manifest, Transit, Penerimaan, Klaim, Tracking.
- Equipment: Kontrak, Berita Acara, Timesheet, Verifikasi.
- Keuangan: Invoice, Pembayaran, Piutang, Utang, Kas dan Bank, Pengeluaran, Laporan Keuangan — **ditahan sampai Finance dibangun**.
- Inventory dan Laporan lain — **ditahan sampai modul tersedia**.
- Master Data sesuai permission Owner baca.

Tidak ada permission baru atau menu kosong yang diaktifkan untuk memenuhi tampilan.

## 5. Rancangan Executive Dashboard

### Operasional yang dapat dibangun lebih dahulu

Kartu dan drill-down harus dihitung dari tabel aktual dengan filter periode WITA dan cabang yang diizinkan:

- DN: total, `created`, `departed/transit`, `arrived`, `received`, `completed`.
- Manifest: draft, aktif dalam perjalanan, selesai, dan item aktif.
- Penerimaan: penerimaan aktual pada periode.
- Klaim: jumlah per status dan klaim yang memerlukan tindak lanjut.
- Equipment: kontrak/unit per status, periode mendekati akhir, BA terakhir, timesheet SUBMITTED/APPROVED.

Setiap angka membuka daftar terfilter yang menjadi sumbernya. Status yang tidak memiliki data diberi `Belum tersedia` atau `0` hanya jika query benar-benar menghitung nol.

### Keuangan setelah Finance tersedia

Kartu omzet bulan/tahun, piutang, utang, kas/bank, pengeluaran, laba/rugi, invoice jatuh tempo, dan grafik bulanan hanya boleh membaca agregasi Finance yang telah disetujui. Tren pendapatan harus memakai tanggal pengakuan yang ditetapkan, bukan tanggal kontrak atau tanggal DN secara asumtif.

## 6. Integrasi Finance dengan Trucking dan Equipment

Invoice harus memiliki sumber dokumen, status lifecycle, nomor resmi, tanggal terbit, tanggal jatuh tempo, nilai manual, dan histori. Pembayaran hanya terkait invoice yang sah dan statusnya; piutang adalah saldo invoice terbit dikurangi pembayaran teralokasi. Utang memerlukan sumber kewajiban dan pihak yang dibayar. Kas/bank memerlukan akun, transaksi masuk/keluar, rekonsiliasi, dan periode. Pengeluaran memerlukan kategori, cabang, akun sumber, bukti, dan approval.

Trucking dan Equipment hanya mengirim referensi operasional yang valid. Pembuatan atau penyelesaian klaim tidak memicu refund/kompensasi. Kontrak, BA, dan timesheet tidak otomatis menjadi omzet sebelum aturan pengakuan pendapatan disetujui.

## 7. Kebutuhan database dan backend

Finance kemungkinan memerlukan tabel invoice header/detail, invoice events, payment header/allocation, receivable snapshot atau ledger, payable header, cash/bank accounts, cash transactions, expenses, approval/reconciliation events, numbering sequences, evidence, requests/idempotency, dan audit. Semua migration harus aditif, FK/index/unique/check lengkap, transaksi atomik, locking, idempotency, branch scope, dan audit.

Dashboard memerlukan repository agregasi terpisah, service KPI yang menolak sumber tidak tersedia, filter cabang server-side, periode inklusif WITA, dan drill-down permission-aware. Jangan menambahkan kolom/tabel Finance sebelum desain dan keputusan bisnis disetujui.

## 8. Keputusan bisnis yang memerlukan persetujuan

1. Definisi omzet dan tanggal pengakuan Trucking serta Equipment.
2. Apakah invoice berasal dari DN, penerimaan, kontrak, BA, timesheet, atau kombinasi.
3. Status invoice yang masuk piutang dan arti jatuh tempo.
4. Model utang, vendor, dan tanggal kewajiban.
5. Akun kas/bank, transfer antar akun, rekonsiliasi, dan saldo awal.
6. Kategori pengeluaran, approval, bukti, dan koreksi.
7. Pajak, diskon, DP/termin, pembatalan, credit note, refund, dan write-off.
8. Definisi laba/rugi, periode tutup buku, dan koreksi setelah periode ditutup.
9. Cakupan Owner lintas cabang dan pembatasan angka sensitif.
10. Kebutuhan ekspor laporan dan audit trail.

Keputusan yang belum final tidak boleh diwakili angka atau aturan default.

## 9. Urutan implementasi

1. **Tahap A:** buat adapter KPI operasional Trucking/Equipment berbasis tabel yang sudah ada; tambahkan filter periode/cabang dan drill-down; uji backend, permission, dan browser.
2. **Tahap B:** finalkan keputusan Finance, desain schema/state machine/permission, lalu implementasikan master akun dan invoice secara aditif.
3. Implementasikan pembayaran, piutang, utang, kas/bank, dan pengeluaran dengan audit/idempotency/konkurensi.
4. **Tahap C:** aktifkan KPI keuangan dan grafik hanya setelah sumber transaksi serta rekonsiliasi lulus pengujian.
5. Jalankan regresi Tahap 1–6, browser desktop/mobile, integritas database, dan verifikasi angka terhadap transaksi sumber.

Tidak ada perubahan kode, schema Finance, permission sensitif, atau angka keuangan palsu yang dibuat dalam rencana ini.

<?php
declare(strict_types=1);
// Role determines presentation only. Every live dataset has a separate backend permission gate.
return [
    'Owner' => [
        'focus' => 'Operasional perusahaan',
        'sections' => [
            ['id'=>'operations','title'=>'Ringkasan operasional','items'=>['Total DN','DN dalam perjalanan','DN selesai','Manifest aktif','Kontrak Equipment aktif','Timesheet menunggu verifikasi'],'requires'=>['exp_shipments','exp_manifests','rent_contracts','rent_timesheets']],
            ['id'=>'finance','title'=>'Ringkasan keuangan','items'=>['Invoice terbit','Pembayaran diterima','Piutang berjalan','Pengeluaran','Saldo Petty Cash'],'requires'=>['fin_invoices','fin_payments','fin_expenses','pc_accounts']],
            ['id'=>'monitoring','title'=>'Monitoring cabang','items'=>['Trucking per cabang','Equipment per cabang','Invoice dan pembayaran per cabang'],'requires'=>['exp_shipments','rent_contracts','fin_invoices','fin_payments']],
            ['id'=>'attention','title'=>'Aktivitas yang membutuhkan perhatian','items'=>['DN tertunda','Manifest belum selesai','Klaim belum diselesaikan','Invoice menunggu penerbitan','Timesheet menunggu verifikasi'],'requires'=>['exp_shipments','exp_manifests','exp_claims','fin_invoices','rent_timesheets']],
            ['id'=>'trends','title'=>'Tren operasional dan keuangan','items'=>['Tren DN berdasarkan periode','Tren invoice dan pembayaran','Aktivitas Trucking dan Equipment'],'requires'=>['exp_shipments','fin_invoices','fin_payments','rent_contracts']],
        ],
    ],
    'Administrator' => ['focus'=>'Administrasi perusahaan','sections'=>[]],
    'Admin Pengirim' => ['focus'=>'Pengiriman','sections'=>[
        ['id'=>'dispatch','title'=>'Aktivitas pengiriman','items'=>['DN dibuat hari ini','DN belum masuk Manifest','DN dalam perjalanan','DN selesai','Daftar DN terbaru'],'requires'=>['exp_shipments','exp_manifest_items']],
        ['id'=>'drafts','title'=>'Draft invoice cabang','items'=>['Draft invoice sesuai cakupan dan permission'],'requires'=>['fin_invoices']],
    ]],
    'Admin Transit' => ['focus'=>'Manifest dan transit','sections'=>[
        ['id'=>'manifests','title'=>'Pemantauan manifest','items'=>['Manifest aktif','Manifest menuju cabang','Manifest tiba','Manifest menunggu penyelesaian'],'requires'=>['exp_manifests']],
        ['id'=>'transit','title'=>'Pengiriman transit','items'=>['DN dalam proses transit'],'requires'=>['exp_shipments','exp_events']],
    ]],
    'Admin Penerima' => ['focus'=>'Penerimaan dan klaim','sections'=>[
        ['id'=>'receipts','title'=>'Penerimaan barang','items'=>['DN menunggu penerimaan','DN diterima hari ini','DN belum diambil'],'requires'=>['exp_shipments','exp_events']],
        ['id'=>'claims','title'=>'Pemantauan klaim','items'=>['Klaim yang belum selesai'],'requires'=>['exp_claims']],
    ]],
    'Admin Sewa' => ['focus'=>'Kontrak dan verifikasi','sections'=>[
        ['id'=>'contracts','title'=>'Operasional Equipment','items'=>['Kontrak aktif','Kontrak mendekati akhir','Unit sedang disewa'],'requires'=>['rent_contracts','rent_units']],
        ['id'=>'timesheets','title'=>'Verifikasi timesheet','items'=>['Timesheet menunggu verifikasi','Timesheet terverifikasi'],'requires'=>['rent_timesheets']],
    ]],
    'Operator Alat Berat' => ['focus'=>'Penugasan dan timesheet saya','sections'=>[
        ['id'=>'assignments','title'=>'Penugasan saya','items'=>['Penugasan aktif'],'requires'=>['rent_contracts']],
        ['id'=>'my-timesheets','title'=>'Timesheet saya','items'=>['Timesheet terbaru','Timesheet menunggu verifikasi','Timesheet dikembalikan untuk koreksi'],'requires'=>['rent_timesheets']],
    ]],
    'Finance' => ['focus'=>'Penagihan dan pembayaran','sections'=>[
        ['id'=>'invoices','title'=>'Status invoice','items'=>['Draft invoice masuk','Invoice menunggu penerbitan','Invoice terbit'],'requires'=>['fin_invoices']],
        ['id'=>'payments','title'=>'Pencatatan keuangan','items'=>['Pembayaran diterima','Piutang berjalan','Pengeluaran tercatat'],'requires'=>['fin_invoices','fin_payments','fin_expenses']],
        ['id'=>'pettycash','title'=>'Petty Cash','items'=>['Ringkasan kas sesuai permission'],'requires'=>['pc_accounts','pc_entries']],
    ]],
    'Gudang' => ['focus'=>'Stok dan pergerakan barang','sections'=>[
        ['id'=>'inventory','title'=>'Persediaan barang','items'=>['Jumlah item stok','Barang masuk terbaru','Barang keluar terbaru'],'requires'=>['inv_stock','inv_documents']],
        ['id'=>'transfers','title'=>'Tindak lanjut gudang','items'=>['Transfer stok aktif','Stock opname yang memerlukan tindak lanjut','Peringatan stok rendah'],'requires'=>['inv_transfers','inv_documents','inv_items']],
    ]],
    'Customer' => ['focus'=>'Pengiriman saya','sections'=>[
        ['id'=>'customer-tracking','title'=>'Pelacakan pengiriman','items'=>['Tracking pengiriman sesuai akses pelanggan'],'requires'=>['exp_shipments','exp_events']],
    ]],
];

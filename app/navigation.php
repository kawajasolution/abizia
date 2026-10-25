<?php
declare(strict_types=1);
// Single registry for desktop sidebar, mobile drawer and bottom shortcuts.
// Planned business routes are deliberately null until real endpoints exist.
$item = static fn(string $id, string $label, ?string $route, string $icon, string $group, string $permission, bool $global = false, array $shortcuts = []): array => compact('id', 'label', 'route', 'icon', 'group', 'permission', 'global', 'shortcuts') + ['available' => $route !== null, 'shortcut_label' => $id === 'roles' ? 'Pengaturan' : $label];
return [
    $item('dashboard', 'Dashboard', '/', 'dashboard', 'Dashboard', 'foundation.view', false, ['*' => 1]),
    $item('dn', 'Delivery Note (DN)', '/trucking/dns', 'document', 'Trucking', 'expedition.view', false, ['Admin Pengirim' => 2]),
    $item('manifest', 'Manifest', '/trucking/manifests', 'truck', 'Trucking', 'expedition.manifest.view', false, ['Admin Transit' => 2]),
    $item('transit', 'Transit', '/trucking/transit', 'transfer', 'Trucking', 'expedition.transit', false, ['Admin Transit' => 3]),
    $item('receipts', 'Penerimaan', '/trucking/receipts', 'package', 'Trucking', 'expedition.receive', false, ['Admin Penerima' => 2]),
    $item('claims', 'Klaim', '/trucking/claims', 'alert', 'Trucking', 'expedition.claim.view', false, ['Admin Penerima' => 3]),
    $item('tracking', 'Tracking', '/trucking/tracking', 'search', 'Trucking', 'expedition.view', false, ['Admin Pengirim' => 3]),
    $item('units', 'Unit Alat Berat', null, 'equipment', 'Equipment', 'rental.view'),
    $item('contracts', 'Kontrak Sewa', '/equipment/contracts', 'document', 'Equipment', 'equipment.contract.view', false, ['Admin Sewa' => 2]),
    $item('handovers', 'Berita Acara', '/equipment/handovers', 'document', 'Equipment', 'equipment.handover.view'),
    $item('timesheets', 'Timesheet', '/equipment/timesheets', 'calendar', 'Equipment', 'equipment.timesheet.view_scoped', false, ['Admin Sewa' => 3]),
    $item('timesheets-own', 'Timesheet Saya', '/equipment/my-timesheets', 'calendar', 'Equipment', 'equipment.timesheet.view_own', false, ['Operator Alat Berat' => 2]),
    $item('verification', 'Verifikasi Timesheet', '/equipment/verification', 'check', 'Equipment', 'equipment.verification.view'),
    $item('p2h', 'P2H / Inspeksi Harian', '/maintenance/p2h', 'check', 'Maintenance', 'equipment.p2h.view'),
    $item('work-orders', 'Work Order', '/maintenance/work-orders', 'wrench', 'Maintenance', 'maintenance.wo.view'),
    $item('preventive', 'Jadwal Servis', '/maintenance/preventive', 'calendar', 'Maintenance', 'maintenance.pm.view'),
    $item('maintenance-cost-rates', 'Tarif Biaya Maintenance', '/maintenance/cost-rates', 'wallet', 'Maintenance', 'maintenance.cost.manage'),
    $item('profit-loss', 'Laba/Rugi', '/finance/profit-loss', 'chart', 'Keuangan', 'finance.account.view', false),
    $item('finance-dashboard', 'Dashboard Keuangan', '/finance/dashboard', 'dashboard', 'Keuangan', 'finance.account.view', false),
    $item('invoice-trucking', 'Invoice', '/finance/invoices', 'document', 'Keuangan', 'finance.invoice.view', false, ['Finance' => 2]),
    $item('invoice-equipment', 'Invoice Equipment', null, 'document', 'Keuangan', 'finance.view'),
    $item('cash-bank', 'Kas & Bank', '/finance/accounts', 'wallet', 'Keuangan', 'finance.account.view', false),
    $item('expense-categories', 'Kategori Pengeluaran', '/finance/expense-categories', 'wallet', 'Keuangan', 'finance.category.view', false),
    $item('receivables', 'Piutang', '/finance/receivables', 'wallet', 'Keuangan', 'finance.receivable.view', false),
    $item('payments', 'Pembayaran', '/finance/payments', 'wallet', 'Keuangan', 'finance.payment.view', false),
    $item('payments', 'Pembayaran', null, 'wallet', 'Keuangan', 'finance.payment', false, ['Finance' => 3]),
    $item('receivables', 'Piutang', null, 'wallet', 'Keuangan', 'finance.view'),
    $item('expenses', 'Pengeluaran', '/finance/expenses', 'wallet', 'Keuangan', 'finance.expense.view', false),
    $item('payables', 'Utang', '/finance/payables', 'wallet', 'Keuangan', 'finance.payable.view', false),
    $item('pettycash', 'Petty Cash', null, 'wallet', 'Keuangan', 'pettycash.view'),
    $item('stock-in', 'Barang Masuk', '/inventory/receipts', 'package', 'Gudang & Inventori', 'inventory.receipt.view', false),
    $item('stock-out', 'Barang Keluar', '/inventory/issues', 'package', 'Gudang & Inventori', 'inventory.issue.view', false),
    $item('stock', 'Stok Barang', '/inventory/stocks', 'package', 'Gudang & Inventori', 'inventory.view', false),
    $item('warehouses', 'Gudang', '/inventory/warehouses', 'building', 'Gudang & Inventori', 'inventory.warehouse.view', false),
    $item('stock-transfer', 'Transfer Gudang', '/inventory/transfers', 'transfer', 'Gudang & Inventori', 'inventory.transfer.view', false),
    $item('stock-usage', 'Pemakaian Barang', null, 'equipment', 'Gudang & Inventori', 'inventory.view'),
    $item('adjustments', 'Penyesuaian Stok', '/inventory/adjustments', 'check', 'Gudang & Inventori', 'inventory.adjustment.view', false),
    $item('report-stock', 'Laporan Persediaan', '/inventory/reports', 'chart', 'Gudang & Inventori', 'inventory.report.view', false),
    $item('stock-count', 'Stock Opname', '/inventory/stock-opnames', 'check', 'Gudang & Inventori', 'inventory.opname.view', false),
    $item('branches', 'Cabang', '/branches', 'building', 'Master Data', 'branches.view', false, ['Administrator' => 3]),
    $item('customers', 'Customer', '/master/customers', 'users', 'Master Data', 'master.customer.view'),
    $item('parties', 'Pengirim & Penerima', '/master/parties', 'users', 'Master Data', 'master.party.view'),
    $item('routes', 'Lokasi & Rute', '/master/routes', 'transfer', 'Master Data', 'master.routes.view'),
    $item('tariffs-trucking', 'Tarif Trucking', '/master/trucking-tariffs', 'wallet', 'Master Data', 'master.trucking_tariff.view'),
    $item('tariffs-equipment', 'Tarif Equipment', '/master/equipment-tariffs', 'wallet', 'Master Data', 'master.equipment_tariff.view'),
    $item('vehicles', 'Kendaraan & Unit', '/master/assets', 'truck', 'Master Data', 'master.assets.view'),
    $item('drivers', 'Driver & Operator', '/master/personnel', 'users', 'Master Data', 'master.personnel.view'),
    $item('catalog', 'Barang & Kategori', '/master/items', 'package', 'Master Data', 'master.catalog.view'),
    $item('suppliers', 'Supplier', '/master/suppliers', 'building', 'Master Data', 'master.supplier.view'),
    $item('report-trucking', 'Laporan Trucking', null, 'chart', 'Laporan', 'owner.view'),
    $item('report-equipment', 'Laporan Equipment', null, 'chart', 'Laporan', 'owner.view'),
    $item('report-finance', 'Laporan Keuangan', null, 'chart', 'Laporan', 'owner.view'),
    $item('report-stock', 'Laporan Gudang', null, 'chart', 'Laporan', 'owner.view'),
    $item('report-cash', 'Laporan Petty Cash', null, 'chart', 'Laporan', 'owner.view'),
    $item('report-profit', 'Laporan Laba Rugi', null, 'chart', 'Laporan', 'owner.view'),
    $item('users', 'Pengguna', '/users', 'users', 'Pengaturan', 'users.view', true, ['Administrator' => 2]),
    $item('roles', 'Role & Hak Akses', '/roles', 'shield', 'Pengaturan', 'roles.view', true, ['Administrator' => 4]),
    $item('audit', 'Audit Log', '/audit', 'history', 'Pengaturan', 'audit.view', true),
];








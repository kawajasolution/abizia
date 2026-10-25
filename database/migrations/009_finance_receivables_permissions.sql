INSERT IGNORE INTO permissions(code,name) VALUES ('finance.invoice.issue','Terbitkan invoice'),('finance.receivable.view','Lihat piutang'),('finance.payment.create','Catat pembayaran');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code IN ('finance.invoice.issue','finance.receivable.view','finance.payment.create') WHERE r.name='Finance';
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.receivable.view' WHERE r.name='Owner';

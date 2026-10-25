INSERT IGNORE INTO permissions(code,name) VALUES ('finance.invoice.view','Lihat invoice'),('finance.invoice.create','Buat draft invoice'),('finance.invoice.issue','Terbitkan invoice');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.invoice.view' WHERE r.name IN ('Finance','Owner');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code IN ('finance.invoice.create','finance.invoice.issue') WHERE r.name='Finance';

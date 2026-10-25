INSERT IGNORE INTO permissions(code,name) VALUES ('inventory.report.view','Lihat laporan persediaan');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='inventory.report.view' WHERE r.name IN ('Owner','Finance');

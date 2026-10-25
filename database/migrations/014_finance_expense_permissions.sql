INSERT IGNORE INTO permissions(code,name) VALUES ('finance.expense.view','Lihat pengeluaran'),('finance.expense.create','Catat pengeluaran');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.expense.view' WHERE r.name IN ('Owner','Finance');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.expense.create' WHERE r.name='Finance';

INSERT IGNORE INTO permissions(code,name) VALUES ('finance.payable.view','Lihat utang supplier'),('finance.payable.create','Catat utang supplier');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.payable.view' WHERE r.name IN ('Owner','Finance');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='finance.payable.create' WHERE r.name='Finance';

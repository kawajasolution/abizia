INSERT IGNORE INTO permissions(code,name) VALUES
('finance.account.manage','Kelola rekening kas dan bank'),
('finance.category.view','Lihat kategori pengeluaran'),
('finance.category.manage','Kelola kategori pengeluaran');
INSERT IGNORE INTO role_permissions(role_id,permission_id)
SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code IN ('finance.account.manage','finance.category.view','finance.category.manage') WHERE r.name='Finance';

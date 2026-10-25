INSERT IGNORE INTO permissions(code,name) VALUES ('finance.payable.post','Posting tagihan supplier'),('finance.payable.pay','Bayar utang supplier');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code IN ('finance.payable.post','finance.payable.pay') WHERE r.name='Finance';

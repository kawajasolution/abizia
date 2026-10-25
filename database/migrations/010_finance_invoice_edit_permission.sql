INSERT IGNORE INTO permissions(code,name) VALUES ('finance.invoice.edit','Edit draft invoice');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.id=(SELECT id FROM permissions WHERE code='finance.invoice.edit') WHERE r.name='Finance';

CREATE TABLE schema_migrations (version VARCHAR(80) PRIMARY KEY, applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB;
CREATE TABLE roles (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE permissions (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, code VARCHAR(100) NOT NULL UNIQUE, name VARCHAR(150) NOT NULL) ENGINE=InnoDB;
CREATE TABLE role_permissions (
 role_id INT UNSIGNED NOT NULL, permission_id INT UNSIGNED NOT NULL, PRIMARY KEY(role_id,permission_id),
 CONSTRAINT fk_rp_role FOREIGN KEY(role_id) REFERENCES roles(id), CONSTRAINT fk_rp_permission FOREIGN KEY(permission_id) REFERENCES permissions(id)
) ENGINE=InnoDB;
CREATE TABLE branches (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, code VARCHAR(12) NOT NULL UNIQUE, name VARCHAR(100) NOT NULL,
 address VARCHAR(500) NOT NULL DEFAULT '', active TINYINT UNSIGNED NOT NULL DEFAULT 1,
 CONSTRAINT ck_branch_active CHECK(active IN(0,1))
) ENGINE=InnoDB;
CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(190) NOT NULL UNIQUE, password_hash VARCHAR(255) NOT NULL,
 role_id INT UNSIGNED NOT NULL, active TINYINT UNSIGNED NOT NULL DEFAULT 1, all_branches TINYINT UNSIGNED NOT NULL DEFAULT 0,
 auth_version INT UNSIGNED NOT NULL DEFAULT 1, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_users_role FOREIGN KEY(role_id) REFERENCES roles(id),
 CONSTRAINT ck_user_active CHECK(active IN(0,1)), CONSTRAINT ck_user_global CHECK(all_branches IN(0,1))
) ENGINE=InnoDB;
CREATE TABLE user_branches (
 user_id INT UNSIGNED NOT NULL, branch_id INT UNSIGNED NOT NULL, PRIMARY KEY(user_id,branch_id),
 CONSTRAINT fk_ub_user FOREIGN KEY(user_id) REFERENCES users(id), CONSTRAINT fk_ub_branch FOREIGN KEY(branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;
CREATE TABLE audit_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, actor_id INT UNSIGNED NULL, action VARCHAR(80) NOT NULL, entity VARCHAR(80) NOT NULL,
 entity_id INT UNSIGNED NULL, detail LONGTEXT NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_audit_time(created_at,id), CONSTRAINT fk_audit_actor FOREIGN KEY(actor_id) REFERENCES users(id), CONSTRAINT ck_audit_json CHECK(JSON_VALID(detail))
) ENGINE=InnoDB;
CREATE TABLE login_attempts (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, email_key CHAR(64) NOT NULL, ip_key CHAR(64) NOT NULL,
 attempted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_attempt_email(email_key,attempted_at), INDEX ix_attempt_ip(ip_key,attempted_at)
) ENGINE=InnoDB;
INSERT INTO roles(name) VALUES ('Administrator'),('Owner'),('Admin Pengirim'),('Admin Transit'),('Admin Penerima'),('Admin Sewa'),('Operator Alat Berat'),('Finance'),('Gudang'),('Customer');
INSERT INTO permissions(code,name) VALUES
 ('foundation.view','Lihat akses fondasi sendiri'),('users.view','Lihat pengguna'),('users.manage','Kelola pengguna'),
 ('branches.view','Lihat cabang sesuai cakupan'),('branches.manage','Kelola cabang sesuai cakupan'),('roles.view','Lihat matriks role'),('audit.view','Lihat audit fondasi');
INSERT INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r CROSS JOIN permissions p WHERE r.name='Administrator' OR p.code='foundation.view';
INSERT INTO schema_migrations(version) VALUES ('001_foundation');

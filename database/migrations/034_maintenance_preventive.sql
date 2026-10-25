CREATE TABLE maintenance_pm_schedules (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 schedule_code VARCHAR(80) NOT NULL,
 schedule_name VARCHAR(160) NOT NULL,
 branch_id INT UNSIGNED NOT NULL,
 asset_id INT UNSIGNED NOT NULL,
 service_type VARCHAR(160) NOT NULL,
 basis VARCHAR(20) NOT NULL,
 interval_value DECIMAL(14,3) NOT NULL,
 initial_value DECIMAL(14,3) NULL,
 next_target DECIMAL(14,3) NULL,
 next_due_date DATE NULL,
 tolerance_value DECIMAL(14,3) NOT NULL DEFAULT 0,
 active TINYINT(1) NOT NULL DEFAULT 1,
 notes TEXT NULL,
 version INT UNSIGNED NOT NULL DEFAULT 1,
 created_by INT UNSIGNED NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_pm_schedule_code(schedule_code),
 KEY ix_pm_scope(branch_id,asset_id,basis,active),
 CONSTRAINT fk_pm_branch FOREIGN KEY(branch_id) REFERENCES branches(id),
 CONSTRAINT fk_pm_asset FOREIGN KEY(asset_id) REFERENCES md_assets(id),
 CONSTRAINT fk_pm_creator FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT ck_pm_basis CHECK(basis IN('HOUR_METER','KILOMETER','CALENDAR')),
 CONSTRAINT ck_pm_interval CHECK(interval_value>0),
 CONSTRAINT ck_pm_tolerance CHECK(tolerance_value>=0)
) ENGINE=InnoDB;
CREATE TABLE maintenance_pm_histories (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 schedule_id BIGINT UNSIGNED NOT NULL,
 work_order_id BIGINT UNSIGNED NOT NULL,
 performed_on DATE NOT NULL,
 meter_value DECIMAL(14,3) NULL,
 result TEXT NULL,
 verified_at DATETIME NULL,
 created_by INT UNSIGNED NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_pm_history_wo(schedule_id,work_order_id),
 CONSTRAINT fk_pm_hist_schedule FOREIGN KEY(schedule_id) REFERENCES maintenance_pm_schedules(id),
 CONSTRAINT fk_pm_hist_wo FOREIGN KEY(work_order_id) REFERENCES maintenance_work_orders(id),
 CONSTRAINT fk_pm_hist_actor FOREIGN KEY(created_by) REFERENCES users(id)
) ENGINE=InnoDB;
ALTER TABLE maintenance_work_orders ADD COLUMN pm_schedule_id BIGINT UNSIGNED NULL, ADD KEY ix_mwo_pm_schedule(pm_schedule_id), ADD CONSTRAINT fk_mwo_pm_schedule FOREIGN KEY(pm_schedule_id) REFERENCES maintenance_pm_schedules(id);
INSERT IGNORE INTO permissions(code,name) VALUES ('maintenance.pm.view','Lihat Jadwal Servis'),('maintenance.pm.create','Buat Jadwal Servis'),('maintenance.pm.update','Ubah Jadwal Servis'),('maintenance.pm.manage','Kelola Jadwal Servis'),('maintenance.pm.print','Cetak Jadwal Servis');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='maintenance.pm.view' WHERE r.name IN('Owner','Administrator');
INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code IN('maintenance.pm.create','maintenance.pm.update','maintenance.pm.manage','maintenance.pm.print') WHERE r.name='Administrator';

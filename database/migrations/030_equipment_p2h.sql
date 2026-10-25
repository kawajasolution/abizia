CREATE TABLE eq_p2h_inspections (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, internal_ref VARCHAR(80) NOT NULL, official_number VARCHAR(80) NULL,
 branch_id INT UNSIGNED NOT NULL, asset_id INT UNSIGNED NOT NULL, operator_id INT UNSIGNED NULL,
 inspected_at DATETIME NOT NULL, shift VARCHAR(40) NOT NULL DEFAULT '', location VARCHAR(255) NOT NULL DEFAULT '',
 meter_type VARCHAR(3) NOT NULL DEFAULT 'HM', meter_reading DECIMAL(12,3) NULL, status VARCHAR(10) NOT NULL DEFAULT 'DRAFT', fitness_status VARCHAR(16) NULL,
 general_note VARCHAR(2000) NOT NULL DEFAULT '', critical_finding TINYINT(1) NOT NULL DEFAULT 0, created_by INT UNSIGNED NOT NULL, reviewed_by INT UNSIGNED NULL, reviewed_at DATETIME NULL, version INT UNSIGNED NOT NULL DEFAULT 1, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_p2h_ref(internal_ref), UNIQUE KEY uq_p2h_number(official_number), UNIQUE KEY uq_p2h_daily(asset_id,inspected_at,shift), KEY ix_p2h_scope(branch_id,inspected_at,status),
 CONSTRAINT fk_p2h_branch FOREIGN KEY(branch_id) REFERENCES branches(id), CONSTRAINT fk_p2h_asset FOREIGN KEY(asset_id) REFERENCES md_assets(id), CONSTRAINT fk_p2h_operator FOREIGN KEY(operator_id) REFERENCES md_personnel(id), CONSTRAINT fk_p2h_creator FOREIGN KEY(created_by) REFERENCES users(id), CONSTRAINT fk_p2h_reviewer FOREIGN KEY(reviewed_by) REFERENCES users(id), CONSTRAINT ck_p2h_meter CHECK(meter_reading IS NULL OR meter_reading>=0), CONSTRAINT ck_p2h_status CHECK(status IN('DRAFT','SUBMITTED','REVIEWED','RETURNED','CANCELLED')), CONSTRAINT ck_p2h_fitness CHECK(fitness_status IS NULL OR fitness_status IN('FIT_FOR_OPERATION','FIT_WITH_NOTES','HOLD'))
) ENGINE=InnoDB;
CREATE TABLE eq_p2h_items (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, inspection_id BIGINT UNSIGNED NOT NULL, category VARCHAR(80) NOT NULL, item_code VARCHAR(80) NOT NULL, item_label VARCHAR(255) NOT NULL, result VARCHAR(12) NOT NULL, severity VARCHAR(8) NULL, note VARCHAR(2000) NOT NULL DEFAULT '', follow_up TINYINT(1) NOT NULL DEFAULT 0,
 UNIQUE KEY uq_p2h_item(inspection_id,item_code), KEY ix_p2h_item_result(inspection_id,result), CONSTRAINT fk_p2h_item_header FOREIGN KEY(inspection_id) REFERENCES eq_p2h_inspections(id) ON DELETE CASCADE, CONSTRAINT ck_p2h_item_result CHECK(result IN('BAIK','RUSAK','TIDAK_BERLAKU')), CONSTRAINT ck_p2h_item_severity CHECK(severity IS NULL OR severity IN('MINOR','MAJOR','CRITICAL'))
) ENGINE=InnoDB;

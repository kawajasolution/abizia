CREATE TABLE IF NOT EXISTS inv_reservations (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 reservation_ref VARCHAR(80) NOT NULL UNIQUE,
 reservation_date DATE NOT NULL,
 branch_id INT UNSIGNED NOT NULL,
 warehouse_id INT UNSIGNED NOT NULL,
 need_ref VARCHAR(100) NULL,
 need_type VARCHAR(80) NULL,
 note VARCHAR(255) NULL,
 status ENUM('DRAFT','RESERVED','FULFILLED','RELEASED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
 created_by INT UNSIGNED NOT NULL,
 reserved_at DATETIME NULL,
 released_at DATETIME NULL,
 fulfilled_at DATETIME NULL,
 created_at DATETIME NOT NULL,
 KEY ix_inv_res_scope (branch_id,warehouse_id,status,reservation_date),
 CONSTRAINT fk_inv_res_branch FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE RESTRICT,
 CONSTRAINT fk_inv_res_warehouse FOREIGN KEY (warehouse_id) REFERENCES inv_warehouses(id) ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS inv_reservation_lines (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 reservation_id INT UNSIGNED NOT NULL,
 item_id INT UNSIGNED NOT NULL,
 quantity_requested DECIMAL(18,3) NOT NULL,
 quantity_reserved DECIMAL(18,3) NOT NULL,
 quantity_fulfilled DECIMAL(18,3) NOT NULL DEFAULT 0,
 created_at DATETIME NOT NULL,
 UNIQUE KEY uq_inv_res_line (reservation_id,item_id),
 CONSTRAINT fk_inv_res_line_header FOREIGN KEY (reservation_id) REFERENCES inv_reservations(id) ON DELETE CASCADE,
 CONSTRAINT fk_inv_res_line_item FOREIGN KEY (item_id) REFERENCES md_items(id) ON DELETE RESTRICT,
 CHECK (quantity_requested > 0 AND quantity_reserved > 0 AND quantity_fulfilled >= 0 AND quantity_fulfilled <= quantity_reserved)
);
ALTER TABLE inv_issues ADD COLUMN reservation_id INT UNSIGNED NULL AFTER warehouse_id,
 ADD KEY ix_inv_issue_reservation (reservation_id),
 ADD CONSTRAINT fk_inv_issue_reservation FOREIGN KEY (reservation_id) REFERENCES inv_reservations(id) ON DELETE RESTRICT;
INSERT IGNORE INTO permissions(code,name) VALUES
 ('inventory.reservation.view','Lihat reservasi stok'),('inventory.reservation.create','Buat reservasi stok'),
 ('inventory.reservation.reserve','Kunci reservasi stok'),('inventory.reservation.release','Lepas reservasi stok'),
 ('inventory.reservation.fulfill','Penuhi reservasi stok'),('inventory.reservation.cancel','Batalkan reservasi stok');
INSERT IGNORE INTO role_permissions(role_id,permission_id)
 SELECT r.id,p.id FROM roles r JOIN permissions p ON p.code='inventory.reservation.view' WHERE r.name IN ('Owner','Finance');

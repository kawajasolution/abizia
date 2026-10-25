CREATE TABLE exp_dns (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, number VARCHAR(40) NOT NULL UNIQUE,
 document_date DATE NOT NULL, route_id INT UNSIGNED NOT NULL,
 origin_branch_id INT UNSIGNED NOT NULL, destination_branch_id INT UNSIGNED NOT NULL,
 customer_id INT UNSIGNED NOT NULL, sender_id INT UNSIGNED NOT NULL, receiver_id INT UNSIGNED NOT NULL,
 description VARCHAR(1000) NOT NULL, quantity DECIMAL(12,3) NOT NULL, unit VARCHAR(60) NOT NULL,
 weight DECIMAL(12,3) NULL, volume DECIMAL(12,3) NULL, note VARCHAR(1000) NOT NULL DEFAULT '',
 status VARCHAR(20) NOT NULL DEFAULT 'created', snapshot LONGTEXT NOT NULL,
 created_by INT UNSIGNED NOT NULL, version INT UNSIGNED NOT NULL DEFAULT 1,
 request_key CHAR(64) NOT NULL UNIQUE, request_hash CHAR(64) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX ix_exp_dn_origin(origin_branch_id,status,document_date,id), INDEX ix_exp_dn_destination(destination_branch_id,status,document_date,id),
 CONSTRAINT fk_exp_dn_route FOREIGN KEY(route_id,origin_branch_id) REFERENCES md_routes(id,branch_id),
 CONSTRAINT fk_exp_dn_origin FOREIGN KEY(origin_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_exp_dn_destination FOREIGN KEY(destination_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_exp_dn_customer FOREIGN KEY(customer_id,origin_branch_id) REFERENCES md_customers(id,branch_id),
 CONSTRAINT fk_exp_dn_sender FOREIGN KEY(sender_id,origin_branch_id) REFERENCES md_parties(id,branch_id),
 CONSTRAINT fk_exp_dn_receiver FOREIGN KEY(receiver_id,destination_branch_id) REFERENCES md_parties(id,branch_id),
 CONSTRAINT fk_exp_dn_actor FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT ck_exp_dn_quantity CHECK(quantity>0), CONSTRAINT ck_exp_dn_weight CHECK(weight IS NULL OR weight>=0),
 CONSTRAINT ck_exp_dn_volume CHECK(volume IS NULL OR volume>=0), CONSTRAINT ck_exp_dn_snapshot CHECK(JSON_VALID(snapshot)),
 CONSTRAINT ck_exp_dn_status CHECK(status IN('created','departed','transit','arrived','received','completed'))
) ENGINE=InnoDB;
CREATE TABLE exp_manifests (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, number VARCHAR(40) NOT NULL UNIQUE, document_date DATE NOT NULL,
 route_id INT UNSIGNED NOT NULL, origin_branch_id INT UNSIGNED NOT NULL, destination_branch_id INT UNSIGNED NOT NULL,
 vehicle_id INT UNSIGNED NULL, driver_id INT UNSIGNED NULL, note VARCHAR(1000) NOT NULL DEFAULT '',
 status VARCHAR(20) NOT NULL DEFAULT 'draft', snapshot LONGTEXT NOT NULL, created_by INT UNSIGNED NOT NULL,
 version INT UNSIGNED NOT NULL DEFAULT 1, request_key CHAR(64) NOT NULL UNIQUE, request_hash CHAR(64) NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_exp_manifest_origin(origin_branch_id,status,document_date,id),
 CONSTRAINT fk_exp_manifest_route FOREIGN KEY(route_id,origin_branch_id) REFERENCES md_routes(id,branch_id),
 CONSTRAINT fk_exp_manifest_origin FOREIGN KEY(origin_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_exp_manifest_destination FOREIGN KEY(destination_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_exp_manifest_vehicle FOREIGN KEY(vehicle_id,origin_branch_id) REFERENCES md_assets(id,branch_id),
 CONSTRAINT fk_exp_manifest_driver FOREIGN KEY(driver_id,origin_branch_id) REFERENCES md_personnel(id,branch_id),
 CONSTRAINT fk_exp_manifest_actor FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT ck_exp_manifest_snapshot CHECK(JSON_VALID(snapshot)),
 CONSTRAINT ck_exp_manifest_status CHECK(status IN('draft','departed','transit','completed'))
) ENGINE=InnoDB;
CREATE TABLE exp_manifest_items (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, manifest_id INT UNSIGNED NOT NULL, dn_id INT UNSIGNED NOT NULL,
 attached_by INT UNSIGNED NOT NULL, attached_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 removed_at TIMESTAMP NULL DEFAULT NULL,
 active_dn_id INT UNSIGNED GENERATED ALWAYS AS (CASE WHEN removed_at IS NULL THEN dn_id ELSE NULL END) STORED,
 UNIQUE KEY uq_exp_active_dn(active_dn_id), INDEX ix_exp_membership(manifest_id,removed_at,dn_id),
 CONSTRAINT fk_exp_item_manifest FOREIGN KEY(manifest_id) REFERENCES exp_manifests(id),
 CONSTRAINT fk_exp_item_dn FOREIGN KEY(dn_id) REFERENCES exp_dns(id),
 CONSTRAINT fk_exp_item_actor FOREIGN KEY(attached_by) REFERENCES users(id)
) ENGINE=InnoDB;
CREATE TABLE exp_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, dn_id INT UNSIGNED NULL, manifest_id INT UNSIGNED NULL,
 actor_id INT UNSIGNED NOT NULL, branch_id INT UNSIGNED NOT NULL, event_type VARCHAR(40) NOT NULL,
 detail LONGTEXT NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_exp_events_dn(dn_id,id), INDEX ix_exp_events_manifest(manifest_id,id),
 CONSTRAINT fk_exp_event_dn FOREIGN KEY(dn_id) REFERENCES exp_dns(id),
 CONSTRAINT fk_exp_event_manifest FOREIGN KEY(manifest_id) REFERENCES exp_manifests(id),
 CONSTRAINT fk_exp_event_actor FOREIGN KEY(actor_id) REFERENCES users(id),
 CONSTRAINT fk_exp_event_branch FOREIGN KEY(branch_id) REFERENCES branches(id),
 CONSTRAINT ck_exp_event_source CHECK(dn_id IS NOT NULL OR manifest_id IS NOT NULL),
 CONSTRAINT ck_exp_event_json CHECK(JSON_VALID(detail))
) ENGINE=InnoDB;

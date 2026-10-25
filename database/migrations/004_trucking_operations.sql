ALTER TABLE exp_dns DROP CONSTRAINT ck_exp_dn_status, ADD COLUMN official_number VARCHAR(80) NULL UNIQUE, ADD COLUMN confirmed_at TIMESTAMP NULL DEFAULT NULL, ADD COLUMN current_branch_id INT UNSIGNED NULL, ADD COLUMN current_location_id INT UNSIGNED NULL, ADD CONSTRAINT fk_exp_dn_current_branch FOREIGN KEY(current_branch_id) REFERENCES branches(id), ADD CONSTRAINT fk_exp_dn_current_location FOREIGN KEY(current_location_id) REFERENCES md_locations(id), ADD CONSTRAINT ck_exp_dn_status CHECK(status IN('created','confirmed','departed','transit','arrived','received','completed'));
UPDATE exp_dns d JOIN md_routes r ON r.id=d.route_id SET d.current_branch_id=d.origin_branch_id,d.current_location_id=r.origin_location_id,d.updated_at=d.updated_at WHERE d.current_branch_id IS NULL;
ALTER TABLE exp_manifests DROP CONSTRAINT ck_exp_manifest_status, ADD COLUMN official_number VARCHAR(80) NULL UNIQUE, ADD COLUMN confirmed_at TIMESTAMP NULL DEFAULT NULL, ADD COLUMN current_stop INT UNSIGNED NOT NULL DEFAULT 0, ADD CONSTRAINT ck_exp_manifest_status CHECK(status IN('draft','confirmed','departed','transit','completed','cancelled'));
ALTER TABLE exp_manifest_items ADD COLUMN removed_by INT UNSIGNED NULL, ADD COLUMN removal_reason VARCHAR(1000) NULL, ADD COLUMN moved_to_manifest_id INT UNSIGNED NULL, ADD CONSTRAINT fk_exp_item_removed_actor FOREIGN KEY(removed_by) REFERENCES users(id), ADD CONSTRAINT fk_exp_item_move_target FOREIGN KEY(moved_to_manifest_id) REFERENCES exp_manifests(id);
CREATE TABLE exp_trip_legs (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, manifest_id INT UNSIGNED NOT NULL, position INT UNSIGNED NOT NULL,
 route_id INT UNSIGNED NOT NULL, origin_branch_id INT UNSIGNED NOT NULL, destination_branch_id INT UNSIGNED NOT NULL,
 origin_location_id INT UNSIGNED NOT NULL, destination_location_id INT UNSIGNED NOT NULL,
 snapshot LONGTEXT NOT NULL, arrived_at TIMESTAMP NULL DEFAULT NULL,
 UNIQUE KEY uq_exp_leg_position(manifest_id,position), INDEX ix_exp_leg_origin(origin_branch_id,manifest_id), INDEX ix_exp_leg_destination(destination_branch_id,manifest_id),
 CONSTRAINT fk_exp_leg_manifest FOREIGN KEY(manifest_id) REFERENCES exp_manifests(id),
 CONSTRAINT fk_exp_leg_route FOREIGN KEY(route_id,origin_branch_id) REFERENCES md_routes(id,branch_id),
 CONSTRAINT fk_exp_leg_origin FOREIGN KEY(origin_location_id,origin_branch_id) REFERENCES md_locations(id,branch_id),
 CONSTRAINT fk_exp_leg_destination FOREIGN KEY(destination_location_id,destination_branch_id) REFERENCES md_locations(id,branch_id),
 CONSTRAINT ck_exp_leg_snapshot CHECK(JSON_VALID(snapshot))
) ENGINE=InnoDB;
INSERT INTO exp_trip_legs(manifest_id,position,route_id,origin_branch_id,destination_branch_id,origin_location_id,destination_location_id,snapshot) SELECT m.id,1,r.id,r.branch_id,r.destination_branch_id,r.origin_location_id,r.destination_location_id,JSON_OBJECT('route',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(m.snapshot,'$.route.name')),r.name),'origin',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(m.snapshot,'$.origin_location.name')),lo.name),'destination',COALESCE(JSON_UNQUOTE(JSON_EXTRACT(m.snapshot,'$.destination_location.name')),ld.name)) FROM exp_manifests m JOIN md_routes r ON r.id=m.route_id JOIN md_locations lo ON lo.id=r.origin_location_id JOIN md_locations ld ON ld.id=r.destination_location_id;
CREATE TABLE exp_sequences (
 document_type VARCHAR(2) NOT NULL, branch_id INT UNSIGNED NOT NULL, document_year SMALLINT UNSIGNED NOT NULL, last_value INT UNSIGNED NOT NULL DEFAULT 0,
 PRIMARY KEY(document_type,branch_id,document_year), CONSTRAINT fk_exp_sequence_branch FOREIGN KEY(branch_id) REFERENCES branches(id), CONSTRAINT ck_exp_sequence_type CHECK(document_type IN('DN','MF')), CONSTRAINT ck_exp_sequence_value CHECK(last_value<=999999)
) ENGINE=InnoDB;
CREATE TABLE exp_requests (
 request_key CHAR(64) PRIMARY KEY, actor_id INT UNSIGNED NOT NULL, branch_id INT UNSIGNED NOT NULL, action VARCHAR(80) NOT NULL, payload_hash CHAR(64) NOT NULL, result LONGTEXT NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_exp_request_actor FOREIGN KEY(actor_id) REFERENCES users(id), CONSTRAINT fk_exp_request_branch FOREIGN KEY(branch_id) REFERENCES branches(id), CONSTRAINT ck_exp_request_result CHECK(JSON_VALID(result))
) ENGINE=InnoDB;
CREATE TABLE exp_receipts (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, dn_id INT UNSIGNED NOT NULL UNIQUE, branch_id INT UNSIGNED NOT NULL, actor_id INT UNSIGNED NOT NULL,
 recipient_name VARCHAR(150) NOT NULL, quantity DECIMAL(12,3) NOT NULL, condition_note VARCHAR(1000) NOT NULL, received_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_exp_receipt_dn FOREIGN KEY(dn_id) REFERENCES exp_dns(id), CONSTRAINT fk_exp_receipt_branch FOREIGN KEY(branch_id) REFERENCES branches(id), CONSTRAINT fk_exp_receipt_actor FOREIGN KEY(actor_id) REFERENCES users(id), CONSTRAINT ck_exp_receipt_quantity CHECK(quantity>0)
) ENGINE=InnoDB;
CREATE TABLE exp_claims (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, dn_id INT UNSIGNED NOT NULL, branch_id INT UNSIGNED NOT NULL,
 problem_type VARCHAR(60) NOT NULL, description VARCHAR(2000) NOT NULL, reporter_name VARCHAR(150) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'REPORTED', version INT UNSIGNED NOT NULL DEFAULT 1, created_by INT UNSIGNED NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_exp_claim_branch(branch_id,status,created_at,id), INDEX ix_exp_claim_dn(dn_id,id),
 CONSTRAINT fk_exp_claim_dn FOREIGN KEY(dn_id) REFERENCES exp_dns(id), CONSTRAINT fk_exp_claim_branch FOREIGN KEY(branch_id) REFERENCES branches(id), CONSTRAINT fk_exp_claim_actor FOREIGN KEY(created_by) REFERENCES users(id), CONSTRAINT ck_exp_claim_status CHECK(status IN('REPORTED','REVIEWING','APPROVED','REJECTED','CLOSED'))
) ENGINE=InnoDB;
CREATE TABLE exp_claim_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, claim_id INT UNSIGNED NOT NULL, actor_id INT UNSIGNED NOT NULL,
 previous_status VARCHAR(20) NULL, next_status VARCHAR(20) NOT NULL, note VARCHAR(2000) NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_exp_claim_history(claim_id,id), CONSTRAINT fk_exp_claim_event_claim FOREIGN KEY(claim_id) REFERENCES exp_claims(id), CONSTRAINT fk_exp_claim_event_actor FOREIGN KEY(actor_id) REFERENCES users(id)
) ENGINE=InnoDB;
CREATE TABLE exp_evidence (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, claim_id INT UNSIGNED NOT NULL, actor_id INT UNSIGNED NOT NULL,
 storage_key CHAR(64) NOT NULL UNIQUE, file_name VARCHAR(190) NOT NULL, mime_type VARCHAR(60) NOT NULL, file_size INT UNSIGNED NOT NULL, sha256 CHAR(64) NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX ix_exp_evidence_claim(claim_id,id), UNIQUE KEY uq_exp_evidence_content(claim_id,sha256), CONSTRAINT fk_exp_evidence_claim FOREIGN KEY(claim_id) REFERENCES exp_claims(id), CONSTRAINT fk_exp_evidence_actor FOREIGN KEY(actor_id) REFERENCES users(id)
) ENGINE=InnoDB;

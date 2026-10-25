CREATE TABLE eq_contracts (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 internal_ref VARCHAR(80) NOT NULL, official_number VARCHAR(80) NULL,
 branch_id INT UNSIGNED NOT NULL, customer_id INT UNSIGNED NOT NULL,
 status VARCHAR(12) NOT NULL DEFAULT 'DRAFT', closure_kind VARCHAR(12) NULL,
 project_address VARCHAR(1000) NOT NULL DEFAULT '', snapshot LONGTEXT NOT NULL,
 confirmed_at DATETIME NULL, activated_at DATETIME NULL, closed_at DATETIME NULL,
 created_by INT UNSIGNED NOT NULL, version INT UNSIGNED NOT NULL DEFAULT 1,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_eq_contract_ref(internal_ref), UNIQUE KEY uq_eq_contract_number(official_number),
 UNIQUE KEY uq_eq_contract_branch(id,branch_id), KEY ix_eq_contract_scope(branch_id,status,id), KEY ix_eq_contract_customer(customer_id,id),
 CONSTRAINT fk_eq_contract_branch FOREIGN KEY(branch_id) REFERENCES branches(id),
 CONSTRAINT fk_eq_contract_customer FOREIGN KEY(customer_id,branch_id) REFERENCES md_customers(id,branch_id),
 CONSTRAINT fk_eq_contract_creator FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT ck_eq_contract_status CHECK(status IN('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
 CONSTRAINT ck_eq_contract_closure CHECK(closure_kind IS NULL OR closure_kind IN('NORMAL','EARLY')),
 CONSTRAINT ck_eq_contract_snapshot CHECK(JSON_VALID(snapshot)), CONSTRAINT ck_eq_contract_version CHECK(version>0)
) ENGINE=InnoDB;
CREATE TABLE eq_contract_units (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_id BIGINT UNSIGNED NOT NULL,
 contract_branch_id INT UNSIGNED NOT NULL, line_no INT UNSIGNED NOT NULL,
 asset_id INT UNSIGNED NOT NULL, asset_owner_branch_id INT UNSIGNED NOT NULL,
 operator_mode VARCHAR(7) NOT NULL, status VARCHAR(12) NOT NULL DEFAULT 'DRAFT',
 current_period_id BIGINT UNSIGNED NULL, actual_start DATETIME NULL, actual_end DATETIME NULL,
 snapshot LONGTEXT NOT NULL, version INT UNSIGNED NOT NULL DEFAULT 1,
 active_asset_id INT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status IN('DRAFT','CONFIRMED','ACTIVE') THEN asset_id ELSE NULL END) STORED,
 UNIQUE KEY uq_eq_unit_line(contract_id,line_no), UNIQUE KEY uq_eq_unit_active_asset(contract_id,active_asset_id),
 UNIQUE KEY uq_eq_unit_contract(id,contract_id), UNIQUE KEY uq_eq_unit_branch(id,contract_branch_id), KEY ix_eq_unit_asset(asset_id,status), KEY ix_eq_unit_state(contract_id,status),
 CONSTRAINT fk_eq_unit_contract FOREIGN KEY(contract_id,contract_branch_id) REFERENCES eq_contracts(id,branch_id),
 CONSTRAINT fk_eq_unit_asset FOREIGN KEY(asset_id,asset_owner_branch_id) REFERENCES md_assets(id,branch_id),
 CONSTRAINT ck_eq_unit_mode CHECK(operator_mode IN('WITH','WITHOUT')),
 CONSTRAINT ck_eq_unit_state CHECK(status IN('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
 CONSTRAINT ck_eq_unit_actual CHECK(actual_end IS NULL OR (actual_start IS NOT NULL AND actual_end>=actual_start)),
 CONSTRAINT ck_eq_unit_snapshot CHECK(JSON_VALID(snapshot)), CONSTRAINT ck_eq_unit_version CHECK(version>0 AND line_no>0)
) ENGINE=InnoDB;
CREATE TABLE eq_unit_periods (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_unit_id BIGINT UNSIGNED NOT NULL,
 revision_no INT UNSIGNED NOT NULL, starts_on DATE NOT NULL, ends_on DATE NOT NULL,
 previous_period_id BIGINT UNSIGNED NULL, change_kind VARCHAR(12) NOT NULL,
 effective_at DATETIME NULL, reason VARCHAR(2000) NOT NULL DEFAULT '', actor_id INT UNSIGNED NOT NULL,
 recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_eq_period_revision(contract_unit_id,revision_no), UNIQUE KEY uq_eq_period_unit(id,contract_unit_id),
 KEY ix_eq_period_dates(contract_unit_id,starts_on,ends_on),
 CONSTRAINT fk_eq_period_unit FOREIGN KEY(contract_unit_id) REFERENCES eq_contract_units(id),
 CONSTRAINT fk_eq_period_previous FOREIGN KEY(previous_period_id,contract_unit_id) REFERENCES eq_unit_periods(id,contract_unit_id),
 CONSTRAINT fk_eq_period_actor FOREIGN KEY(actor_id) REFERENCES users(id),
 CONSTRAINT ck_eq_period_dates CHECK(starts_on<=ends_on AND revision_no>0),
 CONSTRAINT ck_eq_period_kind CHECK(change_kind IN('INITIAL','EXTENSION','EARLY_END')),
 CONSTRAINT ck_eq_period_reason CHECK(change_kind='INITIAL' OR CHAR_LENGTH(TRIM(reason))>0)
) ENGINE=InnoDB;
ALTER TABLE eq_contract_units ADD CONSTRAINT fk_eq_unit_current_period FOREIGN KEY(current_period_id,id) REFERENCES eq_unit_periods(id,contract_unit_id);
CREATE TABLE eq_operator_assignments (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_unit_id BIGINT UNSIGNED NOT NULL,
 operator_id INT UNSIGNED NOT NULL, operator_owner_branch_id INT UNSIGNED NOT NULL,
 effective_account_id INT UNSIGNED NULL, starts_at DATETIME NOT NULL, ends_at_exclusive DATETIME NOT NULL,
 actual_start DATETIME NULL, actual_end DATETIME NULL, status VARCHAR(12) NOT NULL DEFAULT 'DRAFT',
 previous_assignment_id BIGINT UNSIGNED NULL, reason VARCHAR(2000) NOT NULL DEFAULT '', version INT UNSIGNED NOT NULL DEFAULT 1,
 UNIQUE KEY uq_eq_operator_unit(id,contract_unit_id),
 KEY ix_eq_operator_schedule(operator_id,status,starts_at,ends_at_exclusive), KEY ix_eq_unit_operator_schedule(contract_unit_id,status,starts_at,ends_at_exclusive),
 CONSTRAINT fk_eq_operator_unit FOREIGN KEY(contract_unit_id) REFERENCES eq_contract_units(id),
 CONSTRAINT fk_eq_operator_personnel FOREIGN KEY(operator_id,operator_owner_branch_id) REFERENCES md_personnel(id,branch_id),
 CONSTRAINT fk_eq_operator_account FOREIGN KEY(effective_account_id) REFERENCES users(id),
 CONSTRAINT fk_eq_operator_previous FOREIGN KEY(previous_assignment_id,contract_unit_id) REFERENCES eq_operator_assignments(id,contract_unit_id),
 CONSTRAINT ck_eq_operator_interval CHECK(starts_at<ends_at_exclusive),
 CONSTRAINT ck_eq_operator_state CHECK(status IN('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
 CONSTRAINT ck_eq_operator_actual CHECK(actual_end IS NULL OR (actual_start IS NOT NULL AND actual_end>=actual_start)),
 CONSTRAINT ck_eq_operator_version CHECK(version>0)
) ENGINE=InnoDB;
CREATE TABLE eq_branch_authorizations (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_unit_id BIGINT UNSIGNED NOT NULL,
 operator_assignment_id BIGINT UNSIGNED NULL, period_id BIGINT UNSIGNED NOT NULL,
 resource_type VARCHAR(8) NOT NULL, owner_branch_id INT UNSIGNED NOT NULL, contract_branch_id INT UNSIGNED NOT NULL,
 valid_from DATETIME NOT NULL, valid_until_exclusive DATETIME NOT NULL,
 requested_by INT UNSIGNED NOT NULL, owner_approved_by INT UNSIGNED NULL, owner_approved_at DATETIME NULL,
 contract_approved_by INT UNSIGNED NULL, contract_approved_at DATETIME NULL,
 status VARCHAR(10) NOT NULL DEFAULT 'REQUESTED', reason VARCHAR(2000) NOT NULL,
 revoked_by INT UNSIGNED NULL, revoked_at DATETIME NULL, revocation_reason VARCHAR(2000) NULL,
 version INT UNSIGNED NOT NULL DEFAULT 1,
 KEY ix_eq_authorization_unit(contract_unit_id,status), KEY ix_eq_authorization_owner(owner_branch_id,status), KEY ix_eq_authorization_contract(contract_branch_id,status),
 CONSTRAINT fk_eq_authorization_unit FOREIGN KEY(contract_unit_id,contract_branch_id) REFERENCES eq_contract_units(id,contract_branch_id),
 CONSTRAINT fk_eq_authorization_assignment FOREIGN KEY(operator_assignment_id,contract_unit_id) REFERENCES eq_operator_assignments(id,contract_unit_id),
 CONSTRAINT fk_eq_authorization_period FOREIGN KEY(period_id,contract_unit_id) REFERENCES eq_unit_periods(id,contract_unit_id),
 CONSTRAINT fk_eq_authorization_owner FOREIGN KEY(owner_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_eq_authorization_branch FOREIGN KEY(contract_branch_id) REFERENCES branches(id),
 CONSTRAINT fk_eq_authorization_requester FOREIGN KEY(requested_by) REFERENCES users(id),
 CONSTRAINT fk_eq_authorization_owner_actor FOREIGN KEY(owner_approved_by) REFERENCES users(id),
 CONSTRAINT fk_eq_authorization_contract_actor FOREIGN KEY(contract_approved_by) REFERENCES users(id),
 CONSTRAINT fk_eq_authorization_revoker FOREIGN KEY(revoked_by) REFERENCES users(id),
 CONSTRAINT ck_eq_authorization_resource CHECK((resource_type='UNIT' AND operator_assignment_id IS NULL) OR (resource_type='OPERATOR' AND operator_assignment_id IS NOT NULL)),
 CONSTRAINT ck_eq_authorization_interval CHECK(valid_from<valid_until_exclusive AND owner_branch_id<>contract_branch_id),
 CONSTRAINT ck_eq_authorization_state CHECK(status IN('REQUESTED','APPROVED','REJECTED','REVOKED')),
 CONSTRAINT ck_eq_authorization_two_accounts CHECK(owner_approved_by IS NULL OR contract_approved_by IS NULL OR owner_approved_by<>contract_approved_by),
 CONSTRAINT ck_eq_authorization_approval CHECK(status NOT IN('APPROVED','REVOKED') OR (owner_approved_by IS NOT NULL AND owner_approved_at IS NOT NULL AND contract_approved_by IS NOT NULL AND contract_approved_at IS NOT NULL)),
 CONSTRAINT ck_eq_authorization_revoke CHECK(status<>'REVOKED' OR (revoked_by IS NOT NULL AND revoked_at IS NOT NULL AND CHAR_LENGTH(TRIM(revocation_reason))>0)),
 CONSTRAINT ck_eq_authorization_reason CHECK(CHAR_LENGTH(TRIM(reason))>0 AND version>0)
) ENGINE=InnoDB;
CREATE TABLE eq_handover_documents (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_id BIGINT UNSIGNED NOT NULL,
 internal_ref VARCHAR(80) NOT NULL, official_number VARCHAR(80) NULL,
 document_type VARCHAR(8) NOT NULL, scope_mode VARCHAR(8) NOT NULL,
 status VARCHAR(10) NOT NULL DEFAULT 'DRAFT', occurrence_at DATETIME NOT NULL,
 confirmed_at DATETIME NULL, correction_of_id BIGINT UNSIGNED NULL,
 correction_reason VARCHAR(2000) NOT NULL DEFAULT '', created_by INT UNSIGNED NOT NULL, version INT UNSIGNED NOT NULL DEFAULT 1,
 UNIQUE KEY uq_eq_ba_ref(internal_ref), UNIQUE KEY uq_eq_ba_number(official_number), UNIQUE KEY uq_eq_ba_contract(id,contract_id),
 KEY ix_eq_ba_list(contract_id,document_type,status,occurrence_at),
 CONSTRAINT fk_eq_ba_contract FOREIGN KEY(contract_id) REFERENCES eq_contracts(id),
 CONSTRAINT fk_eq_ba_correction FOREIGN KEY(correction_of_id,contract_id) REFERENCES eq_handover_documents(id,contract_id),
 CONSTRAINT fk_eq_ba_creator FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT ck_eq_ba_type CHECK(document_type IN('HANDOVER','RETURN')),
 CONSTRAINT ck_eq_ba_scope CHECK(scope_mode IN('ALL','SELECTED')),
 CONSTRAINT ck_eq_ba_state CHECK(status IN('DRAFT','CONFIRMED','CANCELLED')),
 CONSTRAINT ck_eq_ba_correction CHECK(correction_of_id IS NULL OR CHAR_LENGTH(TRIM(correction_reason))>0),
 CONSTRAINT ck_eq_ba_version CHECK(version>0)
) ENGINE=InnoDB;
CREATE TABLE eq_handover_units (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, handover_id BIGINT UNSIGNED NOT NULL,
 contract_id BIGINT UNSIGNED NOT NULL, contract_unit_id BIGINT UNSIGNED NOT NULL,
 condition_note VARCHAR(2000) NOT NULL, hm_reading DECIMAL(12,3) NULL,
 occurrence_at DATETIME NOT NULL, snapshot LONGTEXT NOT NULL,
 lifecycle_effect VARCHAR(8) NULL,
 UNIQUE KEY uq_eq_ba_unit(handover_id,contract_unit_id), UNIQUE KEY uq_eq_ba_lifecycle(contract_unit_id,lifecycle_effect),
 CONSTRAINT fk_eq_ba_unit_header FOREIGN KEY(handover_id,contract_id) REFERENCES eq_handover_documents(id,contract_id),
 CONSTRAINT fk_eq_ba_unit_detail FOREIGN KEY(contract_unit_id,contract_id) REFERENCES eq_contract_units(id,contract_id),
 CONSTRAINT ck_eq_ba_unit_condition CHECK(CHAR_LENGTH(TRIM(condition_note))>0),
 CONSTRAINT ck_eq_ba_unit_hm CHECK(hm_reading IS NULL OR hm_reading>=0),
 CONSTRAINT ck_eq_ba_unit_snapshot CHECK(JSON_VALID(snapshot)),
 CONSTRAINT ck_eq_ba_unit_effect CHECK(lifecycle_effect IS NULL OR lifecycle_effect IN('HANDOVER','RETURN'))
) ENGINE=InnoDB;
CREATE TABLE eq_timesheets (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_unit_id BIGINT UNSIGNED NOT NULL,
 operator_assignment_id BIGINT UNSIGNED NULL, work_date DATE NOT NULL,
 root_created_by INT UNSIGNED NOT NULL, effective_approved_revision_id BIGINT UNSIGNED NULL, pending_revision_id BIGINT UNSIGNED NULL,
 version INT UNSIGNED NOT NULL DEFAULT 1,
 assignment_scope BIGINT UNSIGNED GENERATED ALWAYS AS (COALESCE(operator_assignment_id,0)) STORED,
 UNIQUE KEY uq_eq_timesheet_root(contract_unit_id,assignment_scope,work_date),
 UNIQUE KEY uq_eq_timesheet_creator(id,root_created_by), UNIQUE KEY uq_eq_timesheet_unit(id,contract_unit_id), KEY ix_eq_timesheet_date(contract_unit_id,work_date),
 CONSTRAINT fk_eq_timesheet_unit FOREIGN KEY(contract_unit_id) REFERENCES eq_contract_units(id),
 CONSTRAINT fk_eq_timesheet_assignment FOREIGN KEY(operator_assignment_id,contract_unit_id) REFERENCES eq_operator_assignments(id,contract_unit_id),
 CONSTRAINT fk_eq_timesheet_creator FOREIGN KEY(root_created_by) REFERENCES users(id), CONSTRAINT ck_eq_timesheet_version CHECK(version>0)
) ENGINE=InnoDB;
CREATE TABLE eq_timesheet_revisions (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, timesheet_id BIGINT UNSIGNED NOT NULL,
 revision_no INT UNSIGNED NOT NULL, previous_revision_id BIGINT UNSIGNED NULL, base_approved_revision_id BIGINT UNSIGNED NULL,
 status VARCHAR(10) NOT NULL DEFAULT 'DRAFT', created_by INT UNSIGNED NOT NULL,
 submitted_by INT UNSIGNED NULL, submitted_at DATETIME NULL, reason VARCHAR(2000) NOT NULL DEFAULT '', work_note VARCHAR(2000) NOT NULL DEFAULT '',
 hm_start DECIMAL(12,3) NULL, hm_end DECIMAL(12,3) NULL, snapshot LONGTEXT NOT NULL,
 content_hash CHAR(64) NULL, version INT UNSIGNED NOT NULL DEFAULT 1,
 pending_root_id BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN status IN('DRAFT','SUBMITTED') THEN timesheet_id ELSE NULL END) STORED,
 UNIQUE KEY uq_eq_revision_number(timesheet_id,revision_no), UNIQUE KEY uq_eq_revision_root(id,timesheet_id),
 UNIQUE KEY uq_eq_revision_author(id,timesheet_id,created_by), UNIQUE KEY uq_eq_revision_pending(pending_root_id),
 KEY ix_eq_revision_queue(status,submitted_at,id),
 CONSTRAINT fk_eq_revision_root FOREIGN KEY(timesheet_id) REFERENCES eq_timesheets(id),
 CONSTRAINT fk_eq_revision_previous FOREIGN KEY(previous_revision_id,timesheet_id) REFERENCES eq_timesheet_revisions(id,timesheet_id),
 CONSTRAINT fk_eq_revision_base FOREIGN KEY(base_approved_revision_id,timesheet_id) REFERENCES eq_timesheet_revisions(id,timesheet_id),
 CONSTRAINT fk_eq_revision_creator FOREIGN KEY(created_by) REFERENCES users(id),
 CONSTRAINT fk_eq_revision_submitter FOREIGN KEY(submitted_by) REFERENCES users(id),
 CONSTRAINT ck_eq_revision_status CHECK(status IN('DRAFT','SUBMITTED','APPROVED','RETURNED','REJECTED')),
 CONSTRAINT ck_eq_revision_hm CHECK((hm_start IS NULL AND hm_end IS NULL) OR (hm_start IS NOT NULL AND hm_end IS NOT NULL AND hm_start>=0 AND hm_end>=hm_start)),
 CONSTRAINT ck_eq_revision_submission CHECK(status='DRAFT' OR (submitted_by IS NOT NULL AND submitted_at IS NOT NULL AND content_hash IS NOT NULL)),
 CONSTRAINT ck_eq_revision_snapshot CHECK(JSON_VALID(snapshot)),
 CONSTRAINT ck_eq_revision_version CHECK(revision_no>0 AND version>0),
 CONSTRAINT ck_eq_revision_reason CHECK(previous_revision_id IS NULL OR CHAR_LENGTH(TRIM(reason))>0)
) ENGINE=InnoDB;
ALTER TABLE eq_timesheets ADD CONSTRAINT fk_eq_timesheet_effective FOREIGN KEY(effective_approved_revision_id,id) REFERENCES eq_timesheet_revisions(id,timesheet_id), ADD CONSTRAINT fk_eq_timesheet_pending FOREIGN KEY(pending_revision_id,id) REFERENCES eq_timesheet_revisions(id,timesheet_id);
CREATE TABLE eq_timesheet_work_entries (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, revision_id BIGINT UNSIGNED NOT NULL, line_no INT UNSIGNED NOT NULL,
 starts_at DATETIME NOT NULL, ends_at_exclusive DATETIME NOT NULL, break_minutes INT UNSIGNED NOT NULL DEFAULT 0, activity_note VARCHAR(2000) NOT NULL DEFAULT '',
 UNIQUE KEY uq_eq_work_line(revision_id,line_no), KEY ix_eq_work_interval(revision_id,starts_at,ends_at_exclusive),
 CONSTRAINT fk_eq_work_revision FOREIGN KEY(revision_id) REFERENCES eq_timesheet_revisions(id),
 CONSTRAINT ck_eq_work_interval CHECK(starts_at<ends_at_exclusive AND line_no>0),
 CONSTRAINT ck_eq_work_break CHECK(TIMESTAMPDIFF(SECOND,starts_at,ends_at_exclusive)>=break_minutes*60)
) ENGINE=InnoDB;
CREATE TABLE eq_timesheet_verifications (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, revision_id BIGINT UNSIGNED NOT NULL,
 timesheet_id BIGINT UNSIGNED NOT NULL, root_created_by INT UNSIGNED NOT NULL, revision_created_by INT UNSIGNED NOT NULL,
 reviewer_id INT UNSIGNED NOT NULL, decision VARCHAR(10) NOT NULL, note VARCHAR(2000) NOT NULL DEFAULT '',
 decided_at DATETIME NOT NULL, request_key CHAR(64) NOT NULL,
 UNIQUE KEY uq_eq_verification_revision(revision_id), UNIQUE KEY uq_eq_verification_request(request_key), KEY ix_eq_verification_actor(reviewer_id,decided_at),
 CONSTRAINT fk_eq_verification_root FOREIGN KEY(timesheet_id,root_created_by) REFERENCES eq_timesheets(id,root_created_by),
 CONSTRAINT fk_eq_verification_revision FOREIGN KEY(revision_id,timesheet_id,revision_created_by) REFERENCES eq_timesheet_revisions(id,timesheet_id,created_by),
 CONSTRAINT fk_eq_verification_reviewer FOREIGN KEY(reviewer_id) REFERENCES users(id),
 CONSTRAINT ck_eq_verification_decision CHECK(decision IN('APPROVED','RETURNED','REJECTED')),
 CONSTRAINT ck_eq_verification_self CHECK(reviewer_id<>root_created_by AND reviewer_id<>revision_created_by),
 CONSTRAINT ck_eq_verification_note CHECK(decision='APPROVED' OR CHAR_LENGTH(TRIM(note))>0)
) ENGINE=InnoDB;
CREATE TABLE eq_meter_corrections (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, timesheet_revision_id BIGINT UNSIGNED NOT NULL,
 correction_type VARCHAR(12) NOT NULL, previous_reading DECIMAL(12,3) NOT NULL, replacement_reading DECIMAL(12,3) NOT NULL,
 reason VARCHAR(2000) NOT NULL, requested_by INT UNSIGNED NOT NULL, authorized_by INT UNSIGNED NULL, authorized_at DATETIME NULL,
 status VARCHAR(10) NOT NULL DEFAULT 'REQUESTED', evidence_id BIGINT UNSIGNED NULL,
 UNIQUE KEY uq_eq_meter_revision(timesheet_revision_id), UNIQUE KEY uq_eq_meter_target(id,timesheet_revision_id),
 CONSTRAINT fk_eq_meter_revision FOREIGN KEY(timesheet_revision_id) REFERENCES eq_timesheet_revisions(id),
 CONSTRAINT fk_eq_meter_requester FOREIGN KEY(requested_by) REFERENCES users(id), CONSTRAINT fk_eq_meter_authorizer FOREIGN KEY(authorized_by) REFERENCES users(id),
 CONSTRAINT ck_eq_meter_type CHECK(correction_type IN('RESET','REPLACEMENT')),
 CONSTRAINT ck_eq_meter_state CHECK(status IN('REQUESTED','AUTHORIZED','REJECTED')),
 CONSTRAINT ck_eq_meter_values CHECK(previous_reading>=0 AND replacement_reading>=0 AND CHAR_LENGTH(TRIM(reason))>0),
 CONSTRAINT ck_eq_meter_authorized CHECK(status<>'AUTHORIZED' OR (authorized_by IS NOT NULL AND authorized_at IS NOT NULL AND evidence_id IS NOT NULL))
) ENGINE=InnoDB;
CREATE TABLE eq_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, contract_id BIGINT UNSIGNED NOT NULL, contract_unit_id BIGINT UNSIGNED NULL,
 period_id BIGINT UNSIGNED NULL, operator_assignment_id BIGINT UNSIGNED NULL,
 handover_id BIGINT UNSIGNED NULL, timesheet_id BIGINT UNSIGNED NULL, timesheet_revision_id BIGINT UNSIGNED NULL,
 event_type VARCHAR(80) NOT NULL, previous_state VARCHAR(20) NULL, next_state VARCHAR(20) NULL,
 actor_id INT UNSIGNED NOT NULL, branch_id INT UNSIGNED NOT NULL, request_key CHAR(64) NULL,
 detail LONGTEXT NOT NULL, occurred_at DATETIME NOT NULL, recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY ix_eq_event_contract(contract_id,id), KEY ix_eq_event_unit(contract_unit_id,id), KEY ix_eq_event_ba(handover_id,id),
 KEY ix_eq_event_revision(timesheet_revision_id,id), KEY ix_eq_event_request(request_key),
 CONSTRAINT fk_eq_event_contract FOREIGN KEY(contract_id,branch_id) REFERENCES eq_contracts(id,branch_id),
 CONSTRAINT fk_eq_event_unit FOREIGN KEY(contract_unit_id,contract_id) REFERENCES eq_contract_units(id,contract_id),
 CONSTRAINT fk_eq_event_period FOREIGN KEY(period_id,contract_unit_id) REFERENCES eq_unit_periods(id,contract_unit_id),
 CONSTRAINT fk_eq_event_operator FOREIGN KEY(operator_assignment_id,contract_unit_id) REFERENCES eq_operator_assignments(id,contract_unit_id),
 CONSTRAINT fk_eq_event_ba FOREIGN KEY(handover_id,contract_id) REFERENCES eq_handover_documents(id,contract_id),
 CONSTRAINT fk_eq_event_timesheet FOREIGN KEY(timesheet_id,contract_unit_id) REFERENCES eq_timesheets(id,contract_unit_id),
 CONSTRAINT fk_eq_event_revision FOREIGN KEY(timesheet_revision_id,timesheet_id) REFERENCES eq_timesheet_revisions(id,timesheet_id),
 CONSTRAINT fk_eq_event_actor FOREIGN KEY(actor_id) REFERENCES users(id),
 CONSTRAINT ck_eq_event_detail CHECK(JSON_VALID(detail)),
 CONSTRAINT ck_eq_event_context CHECK((period_id IS NULL AND operator_assignment_id IS NULL AND timesheet_id IS NULL OR contract_unit_id IS NOT NULL) AND (timesheet_revision_id IS NULL OR timesheet_id IS NOT NULL))
) ENGINE=InnoDB;
CREATE TABLE eq_requests (
 request_key CHAR(64) PRIMARY KEY, actor_id INT UNSIGNED NOT NULL, action VARCHAR(80) NOT NULL,
 resource_type VARCHAR(40) NOT NULL, resource_id BIGINT UNSIGNED NULL, scope_branch_id INT UNSIGNED NOT NULL,
 payload_hash CHAR(64) NOT NULL, committed_result LONGTEXT NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KEY ix_eq_request_actor(actor_id,created_at),
 CONSTRAINT fk_eq_request_actor FOREIGN KEY(actor_id) REFERENCES users(id), CONSTRAINT fk_eq_request_branch FOREIGN KEY(scope_branch_id) REFERENCES branches(id),
 CONSTRAINT ck_eq_request_result CHECK(JSON_VALID(committed_result))
) ENGINE=InnoDB;
CREATE TABLE eq_document_sequences (
 document_type CHAR(2) NOT NULL, branch_id INT UNSIGNED NOT NULL, document_year SMALLINT UNSIGNED NOT NULL, last_value INT UNSIGNED NOT NULL,
 PRIMARY KEY(document_type,branch_id,document_year),
 CONSTRAINT fk_eq_sequence_branch FOREIGN KEY(branch_id) REFERENCES branches(id),
 CONSTRAINT ck_eq_sequence_type CHECK(document_type IN('KS','BA')),
 CONSTRAINT ck_eq_sequence_value CHECK(last_value<=999999 AND document_year BETWEEN 1000 AND 9999)
) ENGINE=InnoDB;
CREATE TABLE eq_evidence (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, handover_unit_id BIGINT UNSIGNED NULL,
 timesheet_revision_id BIGINT UNSIGNED NULL, meter_correction_id BIGINT UNSIGNED NULL,
 actor_id INT UNSIGNED NOT NULL, storage_key VARCHAR(100) NOT NULL, filename VARCHAR(255) NOT NULL,
 mime_type VARCHAR(100) NOT NULL, size_bytes BIGINT UNSIGNED NOT NULL, sha256 CHAR(64) NOT NULL,
 recorded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_eq_evidence_key(storage_key), UNIQUE KEY uq_eq_evidence_ba_hash(handover_unit_id,sha256),
 UNIQUE KEY uq_eq_evidence_revision_hash(timesheet_revision_id,sha256), UNIQUE KEY uq_eq_evidence_meter_hash(meter_correction_id,sha256),
 UNIQUE KEY uq_eq_evidence_meter(id,meter_correction_id),
 CONSTRAINT fk_eq_evidence_ba FOREIGN KEY(handover_unit_id) REFERENCES eq_handover_units(id),
 CONSTRAINT fk_eq_evidence_revision FOREIGN KEY(timesheet_revision_id) REFERENCES eq_timesheet_revisions(id),
 CONSTRAINT fk_eq_evidence_meter FOREIGN KEY(meter_correction_id) REFERENCES eq_meter_corrections(id),
 CONSTRAINT fk_eq_evidence_actor FOREIGN KEY(actor_id) REFERENCES users(id),
 CONSTRAINT ck_eq_evidence_target CHECK((handover_unit_id IS NOT NULL)+(timesheet_revision_id IS NOT NULL)+(meter_correction_id IS NOT NULL)=1),
 CONSTRAINT ck_eq_evidence_size CHECK(size_bytes>0)
) ENGINE=InnoDB;
ALTER TABLE eq_meter_corrections ADD CONSTRAINT fk_eq_meter_evidence FOREIGN KEY(evidence_id,id) REFERENCES eq_evidence(id,meter_correction_id);

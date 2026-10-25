-- HLS backup demo 20261024_200808
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `actor_id` int(10) unsigned DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `entity` varchar(80) NOT NULL,
  `entity_id` int(10) unsigned DEFAULT NULL,
  `detail` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_audit_time` (`created_at`,`id`),
  KEY `fk_audit_actor` (`actor_id`),
  CONSTRAINT `fk_audit_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_audit_json` CHECK (json_valid(`detail`))
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('1','1','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('2','2','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('3','3','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('4','4','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('5','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('6','6','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('7','7','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:08');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('8','8','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:08');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('9','9','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:09');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('10','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:09');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('11',NULL,'login_failed','auth',NULL,'[]','2026-10-24 19:32:18');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('12',NULL,'login_failed','auth',NULL,'[]','2026-10-24 19:32:18');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('13','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:22');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('14','1','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:27');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('15','2','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:27');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('16','3','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('17','4','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('18','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('19','6','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('20','7','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('21','8','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('22','9','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:30');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('23','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:30');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('24','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:36:30');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('25','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:38');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('26','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:39');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('27','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:40');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('28','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:41');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('29','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:43');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('30','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:44');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('31','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:15');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('32','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:17');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('33','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:18');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('34','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:19');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('35','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:20');
INSERT INTO `audit_logs` (`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('36','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:21');
DROP TABLE IF EXISTS `branches`;
CREATE TABLE `branches` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(12) NOT NULL,
  `name` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL DEFAULT '',
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `city` varchar(100) NOT NULL DEFAULT '',
  `province` varchar(100) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  CONSTRAINT `ck_branch_active` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `branches` (`id`,`code`,`name`,`address`,`active`,`city`,`province`,`phone`,`version`,`created_at`,`updated_at`) VALUES ('1','DMO','Kantor Pusat','Alamat kantor pusat','1','','','','1',NULL,'2026-10-24 19:58:08');
DROP TABLE IF EXISTS `eq_branch_authorizations`;
CREATE TABLE `eq_branch_authorizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_unit_id` bigint(20) unsigned NOT NULL,
  `operator_assignment_id` bigint(20) unsigned DEFAULT NULL,
  `period_id` bigint(20) unsigned NOT NULL,
  `resource_type` varchar(8) NOT NULL,
  `owner_branch_id` int(10) unsigned NOT NULL,
  `contract_branch_id` int(10) unsigned NOT NULL,
  `valid_from` datetime NOT NULL,
  `valid_until_exclusive` datetime NOT NULL,
  `requested_by` int(10) unsigned NOT NULL,
  `owner_approved_by` int(10) unsigned DEFAULT NULL,
  `owner_approved_at` datetime DEFAULT NULL,
  `contract_approved_by` int(10) unsigned DEFAULT NULL,
  `contract_approved_at` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'REQUESTED',
  `reason` varchar(2000) NOT NULL,
  `revoked_by` int(10) unsigned DEFAULT NULL,
  `revoked_at` datetime DEFAULT NULL,
  `revocation_reason` varchar(2000) DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `ix_eq_authorization_unit` (`contract_unit_id`,`status`),
  KEY `ix_eq_authorization_owner` (`owner_branch_id`,`status`),
  KEY `ix_eq_authorization_contract` (`contract_branch_id`,`status`),
  KEY `fk_eq_authorization_unit` (`contract_unit_id`,`contract_branch_id`),
  KEY `fk_eq_authorization_assignment` (`operator_assignment_id`,`contract_unit_id`),
  KEY `fk_eq_authorization_period` (`period_id`,`contract_unit_id`),
  KEY `fk_eq_authorization_requester` (`requested_by`),
  KEY `fk_eq_authorization_owner_actor` (`owner_approved_by`),
  KEY `fk_eq_authorization_contract_actor` (`contract_approved_by`),
  KEY `fk_eq_authorization_revoker` (`revoked_by`),
  CONSTRAINT `fk_eq_authorization_assignment` FOREIGN KEY (`operator_assignment_id`, `contract_unit_id`) REFERENCES `eq_operator_assignments` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_authorization_branch` FOREIGN KEY (`contract_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_eq_authorization_contract_actor` FOREIGN KEY (`contract_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_authorization_owner` FOREIGN KEY (`owner_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_eq_authorization_owner_actor` FOREIGN KEY (`owner_approved_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_authorization_period` FOREIGN KEY (`period_id`, `contract_unit_id`) REFERENCES `eq_unit_periods` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_authorization_requester` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_authorization_revoker` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_authorization_unit` FOREIGN KEY (`contract_unit_id`, `contract_branch_id`) REFERENCES `eq_contract_units` (`id`, `contract_branch_id`),
  CONSTRAINT `ck_eq_authorization_resource` CHECK (`resource_type` = 'UNIT' and `operator_assignment_id` is null or `resource_type` = 'OPERATOR' and `operator_assignment_id` is not null),
  CONSTRAINT `ck_eq_authorization_interval` CHECK (`valid_from` < `valid_until_exclusive` and `owner_branch_id` <> `contract_branch_id`),
  CONSTRAINT `ck_eq_authorization_state` CHECK (`status` in ('REQUESTED','APPROVED','REJECTED','REVOKED')),
  CONSTRAINT `ck_eq_authorization_two_accounts` CHECK (`owner_approved_by` is null or `contract_approved_by` is null or `owner_approved_by` <> `contract_approved_by`),
  CONSTRAINT `ck_eq_authorization_approval` CHECK (`status` not in ('APPROVED','REVOKED') or `owner_approved_by` is not null and `owner_approved_at` is not null and `contract_approved_by` is not null and `contract_approved_at` is not null),
  CONSTRAINT `ck_eq_authorization_revoke` CHECK (`status` <> 'REVOKED' or `revoked_by` is not null and `revoked_at` is not null and char_length(trim(`revocation_reason`)) > 0),
  CONSTRAINT `ck_eq_authorization_reason` CHECK (char_length(trim(`reason`)) > 0 and `version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_contract_units`;
CREATE TABLE `eq_contract_units` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint(20) unsigned NOT NULL,
  `contract_branch_id` int(10) unsigned NOT NULL,
  `line_no` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  `asset_owner_branch_id` int(10) unsigned NOT NULL,
  `operator_mode` varchar(7) NOT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'DRAFT',
  `current_period_id` bigint(20) unsigned DEFAULT NULL,
  `actual_start` datetime DEFAULT NULL,
  `actual_end` datetime DEFAULT NULL,
  `snapshot` longtext NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `active_asset_id` int(10) unsigned GENERATED ALWAYS AS (case when `status` in ('DRAFT','CONFIRMED','ACTIVE') then `asset_id` else NULL end) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_unit_line` (`contract_id`,`line_no`),
  UNIQUE KEY `uq_eq_unit_contract` (`id`,`contract_id`),
  UNIQUE KEY `uq_eq_unit_branch` (`id`,`contract_branch_id`),
  UNIQUE KEY `uq_eq_unit_active_asset` (`contract_id`,`active_asset_id`),
  KEY `ix_eq_unit_asset` (`asset_id`,`status`),
  KEY `ix_eq_unit_state` (`contract_id`,`status`),
  KEY `fk_eq_unit_contract` (`contract_id`,`contract_branch_id`),
  KEY `fk_eq_unit_asset` (`asset_id`,`asset_owner_branch_id`),
  KEY `fk_eq_unit_current_period` (`current_period_id`,`id`),
  CONSTRAINT `fk_eq_unit_asset` FOREIGN KEY (`asset_id`, `asset_owner_branch_id`) REFERENCES `md_assets` (`id`, `branch_id`),
  CONSTRAINT `fk_eq_unit_contract` FOREIGN KEY (`contract_id`, `contract_branch_id`) REFERENCES `eq_contracts` (`id`, `branch_id`),
  CONSTRAINT `fk_eq_unit_current_period` FOREIGN KEY (`current_period_id`, `id`) REFERENCES `eq_unit_periods` (`id`, `contract_unit_id`),
  CONSTRAINT `ck_eq_unit_mode` CHECK (`operator_mode` in ('WITH','WITHOUT')),
  CONSTRAINT `ck_eq_unit_state` CHECK (`status` in ('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
  CONSTRAINT `ck_eq_unit_actual` CHECK (`actual_end` is null or `actual_start` is not null and `actual_end` >= `actual_start`),
  CONSTRAINT `ck_eq_unit_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_eq_unit_version` CHECK (`version` > 0 and `line_no` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_contracts`;
CREATE TABLE `eq_contracts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `internal_ref` varchar(80) NOT NULL,
  `official_number` varchar(80) DEFAULT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'DRAFT',
  `closure_kind` varchar(12) DEFAULT NULL,
  `project_address` varchar(1000) NOT NULL DEFAULT '',
  `snapshot` longtext NOT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_contract_ref` (`internal_ref`),
  UNIQUE KEY `uq_eq_contract_branch` (`id`,`branch_id`),
  UNIQUE KEY `uq_eq_contract_number` (`official_number`),
  KEY `ix_eq_contract_scope` (`branch_id`,`status`,`id`),
  KEY `ix_eq_contract_customer` (`customer_id`,`id`),
  KEY `fk_eq_contract_customer` (`customer_id`,`branch_id`),
  KEY `fk_eq_contract_creator` (`created_by`),
  CONSTRAINT `fk_eq_contract_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_eq_contract_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_contract_customer` FOREIGN KEY (`customer_id`, `branch_id`) REFERENCES `md_customers` (`id`, `branch_id`),
  CONSTRAINT `ck_eq_contract_status` CHECK (`status` in ('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
  CONSTRAINT `ck_eq_contract_closure` CHECK (`closure_kind` is null or `closure_kind` in ('NORMAL','EARLY')),
  CONSTRAINT `ck_eq_contract_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_eq_contract_version` CHECK (`version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_document_sequences`;
CREATE TABLE `eq_document_sequences` (
  `document_type` char(2) NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `document_year` smallint(5) unsigned NOT NULL,
  `last_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`document_type`,`branch_id`,`document_year`),
  KEY `fk_eq_sequence_branch` (`branch_id`),
  CONSTRAINT `fk_eq_sequence_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `ck_eq_sequence_type` CHECK (`document_type` in ('KS','BA')),
  CONSTRAINT `ck_eq_sequence_value` CHECK (`last_value` <= 999999 and `document_year` between 1000 and 9999)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_events`;
CREATE TABLE `eq_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint(20) unsigned NOT NULL,
  `contract_unit_id` bigint(20) unsigned DEFAULT NULL,
  `period_id` bigint(20) unsigned DEFAULT NULL,
  `operator_assignment_id` bigint(20) unsigned DEFAULT NULL,
  `handover_id` bigint(20) unsigned DEFAULT NULL,
  `timesheet_id` bigint(20) unsigned DEFAULT NULL,
  `timesheet_revision_id` bigint(20) unsigned DEFAULT NULL,
  `event_type` varchar(80) NOT NULL,
  `previous_state` varchar(20) DEFAULT NULL,
  `next_state` varchar(20) DEFAULT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `request_key` char(64) DEFAULT NULL,
  `detail` longtext NOT NULL,
  `occurred_at` datetime NOT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_eq_event_contract` (`contract_id`,`id`),
  KEY `ix_eq_event_unit` (`contract_unit_id`,`id`),
  KEY `ix_eq_event_ba` (`handover_id`,`id`),
  KEY `ix_eq_event_revision` (`timesheet_revision_id`,`id`),
  KEY `ix_eq_event_request` (`request_key`),
  KEY `fk_eq_event_contract` (`contract_id`,`branch_id`),
  KEY `fk_eq_event_unit` (`contract_unit_id`,`contract_id`),
  KEY `fk_eq_event_period` (`period_id`,`contract_unit_id`),
  KEY `fk_eq_event_operator` (`operator_assignment_id`,`contract_unit_id`),
  KEY `fk_eq_event_ba` (`handover_id`,`contract_id`),
  KEY `fk_eq_event_timesheet` (`timesheet_id`,`contract_unit_id`),
  KEY `fk_eq_event_revision` (`timesheet_revision_id`,`timesheet_id`),
  KEY `fk_eq_event_actor` (`actor_id`),
  CONSTRAINT `fk_eq_event_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_event_ba` FOREIGN KEY (`handover_id`, `contract_id`) REFERENCES `eq_handover_documents` (`id`, `contract_id`),
  CONSTRAINT `fk_eq_event_contract` FOREIGN KEY (`contract_id`, `branch_id`) REFERENCES `eq_contracts` (`id`, `branch_id`),
  CONSTRAINT `fk_eq_event_operator` FOREIGN KEY (`operator_assignment_id`, `contract_unit_id`) REFERENCES `eq_operator_assignments` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_event_period` FOREIGN KEY (`period_id`, `contract_unit_id`) REFERENCES `eq_unit_periods` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_event_revision` FOREIGN KEY (`timesheet_revision_id`, `timesheet_id`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`),
  CONSTRAINT `fk_eq_event_timesheet` FOREIGN KEY (`timesheet_id`, `contract_unit_id`) REFERENCES `eq_timesheets` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_event_unit` FOREIGN KEY (`contract_unit_id`, `contract_id`) REFERENCES `eq_contract_units` (`id`, `contract_id`),
  CONSTRAINT `ck_eq_event_detail` CHECK (json_valid(`detail`)),
  CONSTRAINT `ck_eq_event_context` CHECK ((`period_id` is null and `operator_assignment_id` is null and `timesheet_id` is null or `contract_unit_id` is not null) and (`timesheet_revision_id` is null or `timesheet_id` is not null))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_evidence`;
CREATE TABLE `eq_evidence` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `handover_unit_id` bigint(20) unsigned DEFAULT NULL,
  `timesheet_revision_id` bigint(20) unsigned DEFAULT NULL,
  `meter_correction_id` bigint(20) unsigned DEFAULT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `storage_key` varchar(100) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `size_bytes` bigint(20) unsigned NOT NULL,
  `sha256` char(64) NOT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_evidence_key` (`storage_key`),
  UNIQUE KEY `uq_eq_evidence_ba_hash` (`handover_unit_id`,`sha256`),
  UNIQUE KEY `uq_eq_evidence_revision_hash` (`timesheet_revision_id`,`sha256`),
  UNIQUE KEY `uq_eq_evidence_meter_hash` (`meter_correction_id`,`sha256`),
  UNIQUE KEY `uq_eq_evidence_meter` (`id`,`meter_correction_id`),
  KEY `fk_eq_evidence_actor` (`actor_id`),
  CONSTRAINT `fk_eq_evidence_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_evidence_ba` FOREIGN KEY (`handover_unit_id`) REFERENCES `eq_handover_units` (`id`),
  CONSTRAINT `fk_eq_evidence_meter` FOREIGN KEY (`meter_correction_id`) REFERENCES `eq_meter_corrections` (`id`),
  CONSTRAINT `fk_eq_evidence_revision` FOREIGN KEY (`timesheet_revision_id`) REFERENCES `eq_timesheet_revisions` (`id`),
  CONSTRAINT `ck_eq_evidence_target` CHECK ((`handover_unit_id` is not null) + (`timesheet_revision_id` is not null) + (`meter_correction_id` is not null) = 1),
  CONSTRAINT `ck_eq_evidence_size` CHECK (`size_bytes` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_handover_documents`;
CREATE TABLE `eq_handover_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_id` bigint(20) unsigned NOT NULL,
  `internal_ref` varchar(80) NOT NULL,
  `official_number` varchar(80) DEFAULT NULL,
  `document_type` varchar(8) NOT NULL,
  `scope_mode` varchar(8) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'DRAFT',
  `occurrence_at` datetime NOT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `correction_of_id` bigint(20) unsigned DEFAULT NULL,
  `correction_reason` varchar(2000) NOT NULL DEFAULT '',
  `created_by` int(10) unsigned NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_ba_ref` (`internal_ref`),
  UNIQUE KEY `uq_eq_ba_contract` (`id`,`contract_id`),
  UNIQUE KEY `uq_eq_ba_number` (`official_number`),
  KEY `ix_eq_ba_list` (`contract_id`,`document_type`,`status`,`occurrence_at`),
  KEY `fk_eq_ba_correction` (`correction_of_id`,`contract_id`),
  KEY `fk_eq_ba_creator` (`created_by`),
  CONSTRAINT `fk_eq_ba_contract` FOREIGN KEY (`contract_id`) REFERENCES `eq_contracts` (`id`),
  CONSTRAINT `fk_eq_ba_correction` FOREIGN KEY (`correction_of_id`, `contract_id`) REFERENCES `eq_handover_documents` (`id`, `contract_id`),
  CONSTRAINT `fk_eq_ba_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_eq_ba_type` CHECK (`document_type` in ('HANDOVER','RETURN')),
  CONSTRAINT `ck_eq_ba_scope` CHECK (`scope_mode` in ('ALL','SELECTED')),
  CONSTRAINT `ck_eq_ba_state` CHECK (`status` in ('DRAFT','CONFIRMED','CANCELLED')),
  CONSTRAINT `ck_eq_ba_correction` CHECK (`correction_of_id` is null or char_length(trim(`correction_reason`)) > 0),
  CONSTRAINT `ck_eq_ba_version` CHECK (`version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_handover_units`;
CREATE TABLE `eq_handover_units` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `handover_id` bigint(20) unsigned NOT NULL,
  `contract_id` bigint(20) unsigned NOT NULL,
  `contract_unit_id` bigint(20) unsigned NOT NULL,
  `condition_note` varchar(2000) NOT NULL,
  `hm_reading` decimal(12,3) DEFAULT NULL,
  `occurrence_at` datetime NOT NULL,
  `snapshot` longtext NOT NULL,
  `lifecycle_effect` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_ba_unit` (`handover_id`,`contract_unit_id`),
  UNIQUE KEY `uq_eq_ba_lifecycle` (`contract_unit_id`,`lifecycle_effect`),
  KEY `fk_eq_ba_unit_header` (`handover_id`,`contract_id`),
  KEY `fk_eq_ba_unit_detail` (`contract_unit_id`,`contract_id`),
  CONSTRAINT `fk_eq_ba_unit_detail` FOREIGN KEY (`contract_unit_id`, `contract_id`) REFERENCES `eq_contract_units` (`id`, `contract_id`),
  CONSTRAINT `fk_eq_ba_unit_header` FOREIGN KEY (`handover_id`, `contract_id`) REFERENCES `eq_handover_documents` (`id`, `contract_id`),
  CONSTRAINT `ck_eq_ba_unit_condition` CHECK (char_length(trim(`condition_note`)) > 0),
  CONSTRAINT `ck_eq_ba_unit_hm` CHECK (`hm_reading` is null or `hm_reading` >= 0),
  CONSTRAINT `ck_eq_ba_unit_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_eq_ba_unit_effect` CHECK (`lifecycle_effect` is null or `lifecycle_effect` in ('HANDOVER','RETURN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_meter_corrections`;
CREATE TABLE `eq_meter_corrections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timesheet_revision_id` bigint(20) unsigned NOT NULL,
  `correction_type` varchar(12) NOT NULL,
  `previous_reading` decimal(12,3) NOT NULL,
  `replacement_reading` decimal(12,3) NOT NULL,
  `reason` varchar(2000) NOT NULL,
  `requested_by` int(10) unsigned NOT NULL,
  `authorized_by` int(10) unsigned DEFAULT NULL,
  `authorized_at` datetime DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'REQUESTED',
  `evidence_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_meter_revision` (`timesheet_revision_id`),
  UNIQUE KEY `uq_eq_meter_target` (`id`,`timesheet_revision_id`),
  KEY `fk_eq_meter_requester` (`requested_by`),
  KEY `fk_eq_meter_authorizer` (`authorized_by`),
  KEY `fk_eq_meter_evidence` (`evidence_id`,`id`),
  CONSTRAINT `fk_eq_meter_authorizer` FOREIGN KEY (`authorized_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_meter_evidence` FOREIGN KEY (`evidence_id`, `id`) REFERENCES `eq_evidence` (`id`, `meter_correction_id`),
  CONSTRAINT `fk_eq_meter_requester` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_meter_revision` FOREIGN KEY (`timesheet_revision_id`) REFERENCES `eq_timesheet_revisions` (`id`),
  CONSTRAINT `ck_eq_meter_type` CHECK (`correction_type` in ('RESET','REPLACEMENT')),
  CONSTRAINT `ck_eq_meter_state` CHECK (`status` in ('REQUESTED','AUTHORIZED','REJECTED')),
  CONSTRAINT `ck_eq_meter_values` CHECK (`previous_reading` >= 0 and `replacement_reading` >= 0 and char_length(trim(`reason`)) > 0),
  CONSTRAINT `ck_eq_meter_authorized` CHECK (`status` <> 'AUTHORIZED' or `authorized_by` is not null and `authorized_at` is not null and `evidence_id` is not null)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_operator_assignments`;
CREATE TABLE `eq_operator_assignments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_unit_id` bigint(20) unsigned NOT NULL,
  `operator_id` int(10) unsigned NOT NULL,
  `operator_owner_branch_id` int(10) unsigned NOT NULL,
  `effective_account_id` int(10) unsigned DEFAULT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at_exclusive` datetime NOT NULL,
  `actual_start` datetime DEFAULT NULL,
  `actual_end` datetime DEFAULT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'DRAFT',
  `previous_assignment_id` bigint(20) unsigned DEFAULT NULL,
  `reason` varchar(2000) NOT NULL DEFAULT '',
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_operator_unit` (`id`,`contract_unit_id`),
  KEY `ix_eq_operator_schedule` (`operator_id`,`status`,`starts_at`,`ends_at_exclusive`),
  KEY `ix_eq_unit_operator_schedule` (`contract_unit_id`,`status`,`starts_at`,`ends_at_exclusive`),
  KEY `fk_eq_operator_personnel` (`operator_id`,`operator_owner_branch_id`),
  KEY `fk_eq_operator_account` (`effective_account_id`),
  KEY `fk_eq_operator_previous` (`previous_assignment_id`,`contract_unit_id`),
  CONSTRAINT `fk_eq_operator_account` FOREIGN KEY (`effective_account_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_operator_personnel` FOREIGN KEY (`operator_id`, `operator_owner_branch_id`) REFERENCES `md_personnel` (`id`, `branch_id`),
  CONSTRAINT `fk_eq_operator_previous` FOREIGN KEY (`previous_assignment_id`, `contract_unit_id`) REFERENCES `eq_operator_assignments` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_operator_unit` FOREIGN KEY (`contract_unit_id`) REFERENCES `eq_contract_units` (`id`),
  CONSTRAINT `ck_eq_operator_interval` CHECK (`starts_at` < `ends_at_exclusive`),
  CONSTRAINT `ck_eq_operator_state` CHECK (`status` in ('DRAFT','CONFIRMED','ACTIVE','COMPLETED','CANCELLED','TERMINATED')),
  CONSTRAINT `ck_eq_operator_actual` CHECK (`actual_end` is null or `actual_start` is not null and `actual_end` >= `actual_start`),
  CONSTRAINT `ck_eq_operator_version` CHECK (`version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_requests`;
CREATE TABLE `eq_requests` (
  `request_key` char(64) NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `action` varchar(80) NOT NULL,
  `resource_type` varchar(40) NOT NULL,
  `resource_id` bigint(20) unsigned DEFAULT NULL,
  `scope_branch_id` int(10) unsigned NOT NULL,
  `payload_hash` char(64) NOT NULL,
  `committed_result` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`request_key`),
  KEY `ix_eq_request_actor` (`actor_id`,`created_at`),
  KEY `fk_eq_request_branch` (`scope_branch_id`),
  CONSTRAINT `fk_eq_request_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_request_branch` FOREIGN KEY (`scope_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `ck_eq_request_result` CHECK (json_valid(`committed_result`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_timesheet_revisions`;
CREATE TABLE `eq_timesheet_revisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `timesheet_id` bigint(20) unsigned NOT NULL,
  `revision_no` int(10) unsigned NOT NULL,
  `previous_revision_id` bigint(20) unsigned DEFAULT NULL,
  `base_approved_revision_id` bigint(20) unsigned DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `submitted_by` int(10) unsigned DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `reason` varchar(2000) NOT NULL DEFAULT '',
  `work_note` varchar(2000) NOT NULL DEFAULT '',
  `hm_start` decimal(12,3) DEFAULT NULL,
  `hm_end` decimal(12,3) DEFAULT NULL,
  `snapshot` longtext NOT NULL,
  `content_hash` char(64) DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `pending_root_id` bigint(20) unsigned GENERATED ALWAYS AS (case when `status` in ('DRAFT','SUBMITTED') then `timesheet_id` else NULL end) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_revision_number` (`timesheet_id`,`revision_no`),
  UNIQUE KEY `uq_eq_revision_root` (`id`,`timesheet_id`),
  UNIQUE KEY `uq_eq_revision_author` (`id`,`timesheet_id`,`created_by`),
  UNIQUE KEY `uq_eq_revision_pending` (`pending_root_id`),
  KEY `ix_eq_revision_queue` (`status`,`submitted_at`,`id`),
  KEY `fk_eq_revision_previous` (`previous_revision_id`,`timesheet_id`),
  KEY `fk_eq_revision_base` (`base_approved_revision_id`,`timesheet_id`),
  KEY `fk_eq_revision_creator` (`created_by`),
  KEY `fk_eq_revision_submitter` (`submitted_by`),
  CONSTRAINT `fk_eq_revision_base` FOREIGN KEY (`base_approved_revision_id`, `timesheet_id`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`),
  CONSTRAINT `fk_eq_revision_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_revision_previous` FOREIGN KEY (`previous_revision_id`, `timesheet_id`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`),
  CONSTRAINT `fk_eq_revision_root` FOREIGN KEY (`timesheet_id`) REFERENCES `eq_timesheets` (`id`),
  CONSTRAINT `fk_eq_revision_submitter` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_eq_revision_status` CHECK (`status` in ('DRAFT','SUBMITTED','APPROVED','RETURNED','REJECTED')),
  CONSTRAINT `ck_eq_revision_hm` CHECK (`hm_start` is null and `hm_end` is null or `hm_start` is not null and `hm_end` is not null and `hm_start` >= 0 and `hm_end` >= `hm_start`),
  CONSTRAINT `ck_eq_revision_submission` CHECK (`status` = 'DRAFT' or `submitted_by` is not null and `submitted_at` is not null and `content_hash` is not null),
  CONSTRAINT `ck_eq_revision_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_eq_revision_version` CHECK (`revision_no` > 0 and `version` > 0),
  CONSTRAINT `ck_eq_revision_reason` CHECK (`previous_revision_id` is null or char_length(trim(`reason`)) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_timesheet_verifications`;
CREATE TABLE `eq_timesheet_verifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `revision_id` bigint(20) unsigned NOT NULL,
  `timesheet_id` bigint(20) unsigned NOT NULL,
  `root_created_by` int(10) unsigned NOT NULL,
  `revision_created_by` int(10) unsigned NOT NULL,
  `reviewer_id` int(10) unsigned NOT NULL,
  `decision` varchar(10) NOT NULL,
  `note` varchar(2000) NOT NULL DEFAULT '',
  `decided_at` datetime NOT NULL,
  `request_key` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_verification_revision` (`revision_id`),
  UNIQUE KEY `uq_eq_verification_request` (`request_key`),
  KEY `ix_eq_verification_actor` (`reviewer_id`,`decided_at`),
  KEY `fk_eq_verification_root` (`timesheet_id`,`root_created_by`),
  KEY `fk_eq_verification_revision` (`revision_id`,`timesheet_id`,`revision_created_by`),
  CONSTRAINT `fk_eq_verification_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_verification_revision` FOREIGN KEY (`revision_id`, `timesheet_id`, `revision_created_by`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`, `created_by`),
  CONSTRAINT `fk_eq_verification_root` FOREIGN KEY (`timesheet_id`, `root_created_by`) REFERENCES `eq_timesheets` (`id`, `root_created_by`),
  CONSTRAINT `ck_eq_verification_decision` CHECK (`decision` in ('APPROVED','RETURNED','REJECTED')),
  CONSTRAINT `ck_eq_verification_self` CHECK (`reviewer_id` <> `root_created_by` and `reviewer_id` <> `revision_created_by`),
  CONSTRAINT `ck_eq_verification_note` CHECK (`decision` = 'APPROVED' or char_length(trim(`note`)) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_timesheet_work_entries`;
CREATE TABLE `eq_timesheet_work_entries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `revision_id` bigint(20) unsigned NOT NULL,
  `line_no` int(10) unsigned NOT NULL,
  `starts_at` datetime NOT NULL,
  `ends_at_exclusive` datetime NOT NULL,
  `break_minutes` int(10) unsigned NOT NULL DEFAULT 0,
  `activity_note` varchar(2000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_work_line` (`revision_id`,`line_no`),
  KEY `ix_eq_work_interval` (`revision_id`,`starts_at`,`ends_at_exclusive`),
  CONSTRAINT `fk_eq_work_revision` FOREIGN KEY (`revision_id`) REFERENCES `eq_timesheet_revisions` (`id`),
  CONSTRAINT `ck_eq_work_interval` CHECK (`starts_at` < `ends_at_exclusive` and `line_no` > 0),
  CONSTRAINT `ck_eq_work_break` CHECK (timestampdiff(SECOND,`starts_at`,`ends_at_exclusive`) >= `break_minutes` * 60)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_timesheets`;
CREATE TABLE `eq_timesheets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_unit_id` bigint(20) unsigned NOT NULL,
  `operator_assignment_id` bigint(20) unsigned DEFAULT NULL,
  `work_date` date NOT NULL,
  `root_created_by` int(10) unsigned NOT NULL,
  `effective_approved_revision_id` bigint(20) unsigned DEFAULT NULL,
  `pending_revision_id` bigint(20) unsigned DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `assignment_scope` bigint(20) unsigned GENERATED ALWAYS AS (coalesce(`operator_assignment_id`,0)) STORED,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_timesheet_creator` (`id`,`root_created_by`),
  UNIQUE KEY `uq_eq_timesheet_unit` (`id`,`contract_unit_id`),
  UNIQUE KEY `uq_eq_timesheet_root` (`contract_unit_id`,`assignment_scope`,`work_date`),
  KEY `ix_eq_timesheet_date` (`contract_unit_id`,`work_date`),
  KEY `fk_eq_timesheet_assignment` (`operator_assignment_id`,`contract_unit_id`),
  KEY `fk_eq_timesheet_creator` (`root_created_by`),
  KEY `fk_eq_timesheet_effective` (`effective_approved_revision_id`,`id`),
  KEY `fk_eq_timesheet_pending` (`pending_revision_id`,`id`),
  CONSTRAINT `fk_eq_timesheet_assignment` FOREIGN KEY (`operator_assignment_id`, `contract_unit_id`) REFERENCES `eq_operator_assignments` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_timesheet_creator` FOREIGN KEY (`root_created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_timesheet_effective` FOREIGN KEY (`effective_approved_revision_id`, `id`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`),
  CONSTRAINT `fk_eq_timesheet_pending` FOREIGN KEY (`pending_revision_id`, `id`) REFERENCES `eq_timesheet_revisions` (`id`, `timesheet_id`),
  CONSTRAINT `fk_eq_timesheet_unit` FOREIGN KEY (`contract_unit_id`) REFERENCES `eq_contract_units` (`id`),
  CONSTRAINT `ck_eq_timesheet_version` CHECK (`version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_unit_periods`;
CREATE TABLE `eq_unit_periods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `contract_unit_id` bigint(20) unsigned NOT NULL,
  `revision_no` int(10) unsigned NOT NULL,
  `starts_on` date NOT NULL,
  `ends_on` date NOT NULL,
  `previous_period_id` bigint(20) unsigned DEFAULT NULL,
  `change_kind` varchar(12) NOT NULL,
  `effective_at` datetime DEFAULT NULL,
  `reason` varchar(2000) NOT NULL DEFAULT '',
  `actor_id` int(10) unsigned NOT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_eq_period_revision` (`contract_unit_id`,`revision_no`),
  UNIQUE KEY `uq_eq_period_unit` (`id`,`contract_unit_id`),
  KEY `ix_eq_period_dates` (`contract_unit_id`,`starts_on`,`ends_on`),
  KEY `fk_eq_period_previous` (`previous_period_id`,`contract_unit_id`),
  KEY `fk_eq_period_actor` (`actor_id`),
  CONSTRAINT `fk_eq_period_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_eq_period_previous` FOREIGN KEY (`previous_period_id`, `contract_unit_id`) REFERENCES `eq_unit_periods` (`id`, `contract_unit_id`),
  CONSTRAINT `fk_eq_period_unit` FOREIGN KEY (`contract_unit_id`) REFERENCES `eq_contract_units` (`id`),
  CONSTRAINT `ck_eq_period_dates` CHECK (`starts_on` <= `ends_on` and `revision_no` > 0),
  CONSTRAINT `ck_eq_period_kind` CHECK (`change_kind` in ('INITIAL','EXTENSION','EARLY_END')),
  CONSTRAINT `ck_eq_period_reason` CHECK (`change_kind` = 'INITIAL' or char_length(trim(`reason`)) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_claim_events`;
CREATE TABLE `exp_claim_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `claim_id` int(10) unsigned NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `previous_status` varchar(20) DEFAULT NULL,
  `next_status` varchar(20) NOT NULL,
  `note` varchar(2000) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_exp_claim_history` (`claim_id`,`id`),
  KEY `fk_exp_claim_event_actor` (`actor_id`),
  CONSTRAINT `fk_exp_claim_event_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_claim_event_claim` FOREIGN KEY (`claim_id`) REFERENCES `exp_claims` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_claims`;
CREATE TABLE `exp_claims` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dn_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `problem_type` varchar(60) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `reporter_name` varchar(150) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'REPORTED',
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_exp_claim_branch` (`branch_id`,`status`,`created_at`,`id`),
  KEY `ix_exp_claim_dn` (`dn_id`,`id`),
  KEY `fk_exp_claim_actor` (`created_by`),
  CONSTRAINT `fk_exp_claim_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_claim_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_claim_dn` FOREIGN KEY (`dn_id`) REFERENCES `exp_dns` (`id`),
  CONSTRAINT `ck_exp_claim_status` CHECK (`status` in ('REPORTED','REVIEWING','APPROVED','REJECTED','CLOSED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_dns`;
CREATE TABLE `exp_dns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(40) NOT NULL,
  `document_date` date NOT NULL,
  `route_id` int(10) unsigned NOT NULL,
  `origin_branch_id` int(10) unsigned NOT NULL,
  `destination_branch_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `sender_id` int(10) unsigned NOT NULL,
  `receiver_id` int(10) unsigned NOT NULL,
  `description` varchar(1000) NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `unit` varchar(60) NOT NULL,
  `weight` decimal(12,3) DEFAULT NULL,
  `volume` decimal(12,3) DEFAULT NULL,
  `note` varchar(1000) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT 'created',
  `snapshot` longtext NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `request_key` char(64) NOT NULL,
  `request_hash` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `official_number` varchar(80) DEFAULT NULL,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `current_branch_id` int(10) unsigned DEFAULT NULL,
  `current_location_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`),
  UNIQUE KEY `request_key` (`request_key`),
  UNIQUE KEY `official_number` (`official_number`),
  KEY `ix_exp_dn_origin` (`origin_branch_id`,`status`,`document_date`,`id`),
  KEY `ix_exp_dn_destination` (`destination_branch_id`,`status`,`document_date`,`id`),
  KEY `fk_exp_dn_route` (`route_id`,`origin_branch_id`),
  KEY `fk_exp_dn_customer` (`customer_id`,`origin_branch_id`),
  KEY `fk_exp_dn_sender` (`sender_id`,`origin_branch_id`),
  KEY `fk_exp_dn_receiver` (`receiver_id`,`destination_branch_id`),
  KEY `fk_exp_dn_actor` (`created_by`),
  KEY `fk_exp_dn_current_branch` (`current_branch_id`),
  KEY `fk_exp_dn_current_location` (`current_location_id`),
  CONSTRAINT `fk_exp_dn_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_dn_current_branch` FOREIGN KEY (`current_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_dn_current_location` FOREIGN KEY (`current_location_id`) REFERENCES `md_locations` (`id`),
  CONSTRAINT `fk_exp_dn_customer` FOREIGN KEY (`customer_id`, `origin_branch_id`) REFERENCES `md_customers` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_dn_destination` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_dn_origin` FOREIGN KEY (`origin_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_dn_receiver` FOREIGN KEY (`receiver_id`, `destination_branch_id`) REFERENCES `md_parties` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_dn_route` FOREIGN KEY (`route_id`, `origin_branch_id`) REFERENCES `md_routes` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_dn_sender` FOREIGN KEY (`sender_id`, `origin_branch_id`) REFERENCES `md_parties` (`id`, `branch_id`),
  CONSTRAINT `ck_exp_dn_quantity` CHECK (`quantity` > 0),
  CONSTRAINT `ck_exp_dn_weight` CHECK (`weight` is null or `weight` >= 0),
  CONSTRAINT `ck_exp_dn_volume` CHECK (`volume` is null or `volume` >= 0),
  CONSTRAINT `ck_exp_dn_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_exp_dn_status` CHECK (`status` in ('created','confirmed','departed','transit','arrived','received','completed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_events`;
CREATE TABLE `exp_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dn_id` int(10) unsigned DEFAULT NULL,
  `manifest_id` int(10) unsigned DEFAULT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `event_type` varchar(40) NOT NULL,
  `detail` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_exp_events_dn` (`dn_id`,`id`),
  KEY `ix_exp_events_manifest` (`manifest_id`,`id`),
  KEY `fk_exp_event_actor` (`actor_id`),
  KEY `fk_exp_event_branch` (`branch_id`),
  CONSTRAINT `fk_exp_event_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_event_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_event_dn` FOREIGN KEY (`dn_id`) REFERENCES `exp_dns` (`id`),
  CONSTRAINT `fk_exp_event_manifest` FOREIGN KEY (`manifest_id`) REFERENCES `exp_manifests` (`id`),
  CONSTRAINT `ck_exp_event_source` CHECK (`dn_id` is not null or `manifest_id` is not null),
  CONSTRAINT `ck_exp_event_json` CHECK (json_valid(`detail`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_evidence`;
CREATE TABLE `exp_evidence` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `claim_id` int(10) unsigned NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `storage_key` char(64) NOT NULL,
  `file_name` varchar(190) NOT NULL,
  `mime_type` varchar(60) NOT NULL,
  `file_size` int(10) unsigned NOT NULL,
  `sha256` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `storage_key` (`storage_key`),
  UNIQUE KEY `uq_exp_evidence_content` (`claim_id`,`sha256`),
  KEY `ix_exp_evidence_claim` (`claim_id`,`id`),
  KEY `fk_exp_evidence_actor` (`actor_id`),
  CONSTRAINT `fk_exp_evidence_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_evidence_claim` FOREIGN KEY (`claim_id`) REFERENCES `exp_claims` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_manifest_items`;
CREATE TABLE `exp_manifest_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manifest_id` int(10) unsigned NOT NULL,
  `dn_id` int(10) unsigned NOT NULL,
  `attached_by` int(10) unsigned NOT NULL,
  `attached_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `removed_at` timestamp NULL DEFAULT NULL,
  `active_dn_id` int(10) unsigned GENERATED ALWAYS AS (case when `removed_at` is null then `dn_id` else NULL end) STORED,
  `removed_by` int(10) unsigned DEFAULT NULL,
  `removal_reason` varchar(1000) DEFAULT NULL,
  `moved_to_manifest_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_exp_active_dn` (`active_dn_id`),
  KEY `ix_exp_membership` (`manifest_id`,`removed_at`,`dn_id`),
  KEY `fk_exp_item_dn` (`dn_id`),
  KEY `fk_exp_item_actor` (`attached_by`),
  KEY `fk_exp_item_removed_actor` (`removed_by`),
  KEY `fk_exp_item_move_target` (`moved_to_manifest_id`),
  CONSTRAINT `fk_exp_item_actor` FOREIGN KEY (`attached_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_item_dn` FOREIGN KEY (`dn_id`) REFERENCES `exp_dns` (`id`),
  CONSTRAINT `fk_exp_item_manifest` FOREIGN KEY (`manifest_id`) REFERENCES `exp_manifests` (`id`),
  CONSTRAINT `fk_exp_item_move_target` FOREIGN KEY (`moved_to_manifest_id`) REFERENCES `exp_manifests` (`id`),
  CONSTRAINT `fk_exp_item_removed_actor` FOREIGN KEY (`removed_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_manifests`;
CREATE TABLE `exp_manifests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(40) NOT NULL,
  `document_date` date NOT NULL,
  `route_id` int(10) unsigned NOT NULL,
  `origin_branch_id` int(10) unsigned NOT NULL,
  `destination_branch_id` int(10) unsigned NOT NULL,
  `vehicle_id` int(10) unsigned DEFAULT NULL,
  `driver_id` int(10) unsigned DEFAULT NULL,
  `note` varchar(1000) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `snapshot` longtext NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `request_key` char(64) NOT NULL,
  `request_hash` char(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `official_number` varchar(80) DEFAULT NULL,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `current_stop` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `number` (`number`),
  UNIQUE KEY `request_key` (`request_key`),
  UNIQUE KEY `official_number` (`official_number`),
  KEY `ix_exp_manifest_origin` (`origin_branch_id`,`status`,`document_date`,`id`),
  KEY `fk_exp_manifest_route` (`route_id`,`origin_branch_id`),
  KEY `fk_exp_manifest_destination` (`destination_branch_id`),
  KEY `fk_exp_manifest_vehicle` (`vehicle_id`,`origin_branch_id`),
  KEY `fk_exp_manifest_driver` (`driver_id`,`origin_branch_id`),
  KEY `fk_exp_manifest_actor` (`created_by`),
  CONSTRAINT `fk_exp_manifest_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_manifest_destination` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_manifest_driver` FOREIGN KEY (`driver_id`, `origin_branch_id`) REFERENCES `md_personnel` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_manifest_origin` FOREIGN KEY (`origin_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_manifest_route` FOREIGN KEY (`route_id`, `origin_branch_id`) REFERENCES `md_routes` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_manifest_vehicle` FOREIGN KEY (`vehicle_id`, `origin_branch_id`) REFERENCES `md_assets` (`id`, `branch_id`),
  CONSTRAINT `ck_exp_manifest_snapshot` CHECK (json_valid(`snapshot`)),
  CONSTRAINT `ck_exp_manifest_status` CHECK (`status` in ('draft','confirmed','departed','transit','completed','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_receipts`;
CREATE TABLE `exp_receipts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dn_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `recipient_name` varchar(150) NOT NULL,
  `quantity` decimal(12,3) NOT NULL,
  `condition_note` varchar(1000) NOT NULL,
  `received_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `dn_id` (`dn_id`),
  KEY `fk_exp_receipt_branch` (`branch_id`),
  KEY `fk_exp_receipt_actor` (`actor_id`),
  CONSTRAINT `fk_exp_receipt_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_receipt_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_exp_receipt_dn` FOREIGN KEY (`dn_id`) REFERENCES `exp_dns` (`id`),
  CONSTRAINT `ck_exp_receipt_quantity` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_requests`;
CREATE TABLE `exp_requests` (
  `request_key` char(64) NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `action` varchar(80) NOT NULL,
  `payload_hash` char(64) NOT NULL,
  `result` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`request_key`),
  KEY `fk_exp_request_actor` (`actor_id`),
  KEY `fk_exp_request_branch` (`branch_id`),
  CONSTRAINT `fk_exp_request_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_exp_request_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `ck_exp_request_result` CHECK (json_valid(`result`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_sequences`;
CREATE TABLE `exp_sequences` (
  `document_type` varchar(2) NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `document_year` smallint(5) unsigned NOT NULL,
  `last_value` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`document_type`,`branch_id`,`document_year`),
  KEY `fk_exp_sequence_branch` (`branch_id`),
  CONSTRAINT `fk_exp_sequence_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `ck_exp_sequence_type` CHECK (`document_type` in ('DN','MF')),
  CONSTRAINT `ck_exp_sequence_value` CHECK (`last_value` <= 999999)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `exp_trip_legs`;
CREATE TABLE `exp_trip_legs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manifest_id` int(10) unsigned NOT NULL,
  `position` int(10) unsigned NOT NULL,
  `route_id` int(10) unsigned NOT NULL,
  `origin_branch_id` int(10) unsigned NOT NULL,
  `destination_branch_id` int(10) unsigned NOT NULL,
  `origin_location_id` int(10) unsigned NOT NULL,
  `destination_location_id` int(10) unsigned NOT NULL,
  `snapshot` longtext NOT NULL,
  `arrived_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_exp_leg_position` (`manifest_id`,`position`),
  KEY `ix_exp_leg_origin` (`origin_branch_id`,`manifest_id`),
  KEY `ix_exp_leg_destination` (`destination_branch_id`,`manifest_id`),
  KEY `fk_exp_leg_route` (`route_id`,`origin_branch_id`),
  KEY `fk_exp_leg_origin` (`origin_location_id`,`origin_branch_id`),
  KEY `fk_exp_leg_destination` (`destination_location_id`,`destination_branch_id`),
  CONSTRAINT `fk_exp_leg_destination` FOREIGN KEY (`destination_location_id`, `destination_branch_id`) REFERENCES `md_locations` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_leg_manifest` FOREIGN KEY (`manifest_id`) REFERENCES `exp_manifests` (`id`),
  CONSTRAINT `fk_exp_leg_origin` FOREIGN KEY (`origin_location_id`, `origin_branch_id`) REFERENCES `md_locations` (`id`, `branch_id`),
  CONSTRAINT `fk_exp_leg_route` FOREIGN KEY (`route_id`, `origin_branch_id`) REFERENCES `md_routes` (`id`, `branch_id`),
  CONSTRAINT `ck_exp_leg_snapshot` CHECK (json_valid(`snapshot`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `login_attempts`;
CREATE TABLE `login_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_key` char(64) NOT NULL,
  `ip_key` char(64) NOT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_attempt_email` (`email_key`,`attempted_at`),
  KEY `ix_attempt_ip` (`ip_key`,`attempted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `login_attempts` (`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('1','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 19:32:18');
INSERT INTO `login_attempts` (`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('2','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 19:32:18');
DROP TABLE IF EXISTS `md_assets`;
CREATE TABLE `md_assets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `kind` varchar(12) NOT NULL,
  `identity` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL DEFAULT '',
  `brand` varchar(100) NOT NULL DEFAULT '',
  `model` varchar(100) NOT NULL DEFAULT '',
  `capacity` varchar(100) NOT NULL DEFAULT '',
  `condition_code` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  UNIQUE KEY `kind` (`kind`,`identity`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  CONSTRAINT `fk_md_assets_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`kind` in ('truck','equipment')),
  CONSTRAINT `CONSTRAINT_3` CHECK (`condition_code` is null or `condition_code` in ('ready','maintenance'))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_assets` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`kind`,`identity`,`category`,`brand`,`model`,`capacity`,`condition_code`) VALUES ('1','DEMO-TRUCK-01','Truk Operasional 01','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','truck','DEMO-TRUCK-01','Trucking','','','','ready');
INSERT INTO `md_assets` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`kind`,`identity`,`category`,`brand`,`model`,`capacity`,`condition_code`) VALUES ('2','DEMO-EQUIP-01','Excavator Operasional 01','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','equipment','DEMO-EQUIP-01','Excavator','','','','ready');
DROP TABLE IF EXISTS `md_categories`;
CREATE TABLE `md_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_categories` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-CAT','Kategori Umum','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
DROP TABLE IF EXISTS `md_customers`;
CREATE TABLE `md_customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `customer_type` varchar(20) NOT NULL,
  `address` varchar(500) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL DEFAULT '',
  `contact_name` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  CONSTRAINT `fk_md_customers_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`customer_type` in ('individual','company'))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_customers` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`customer_type`,`address`,`phone`,`email`,`contact_name`) VALUES ('1','DEMO-CUST-01','Pelanggan Nusantara','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','company','Alamat simulasi DEMO','','','');
DROP TABLE IF EXISTS `md_equipment_tariffs`;
CREATE TABLE `md_equipment_tariffs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  `period` varchar(12) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  KEY `fk_md_equipment_tariff_asset` (`asset_id`,`branch_id`),
  CONSTRAINT `fk_md_equipment_tariff_asset` FOREIGN KEY (`asset_id`, `branch_id`) REFERENCES `md_assets` (`id`, `branch_id`),
  CONSTRAINT `fk_md_equipment_tariffs_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`period` in ('hour','shift','month')),
  CONSTRAINT `CONSTRAINT_3` CHECK (`amount` is null or `amount` >= 0),
  CONSTRAINT `CONSTRAINT_4` CHECK (`valid_from` is null or `valid_until` is null or `valid_from` <= `valid_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `md_items`;
CREATE TABLE `md_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `category_id` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `fk_md_items_unit_id` (`unit_id`),
  KEY `category_id` (`category_id`,`unit_id`,`active`,`name`),
  CONSTRAINT `fk_md_items_category_id` FOREIGN KEY (`category_id`) REFERENCES `md_categories` (`id`),
  CONSTRAINT `fk_md_items_unit_id` FOREIGN KEY (`unit_id`) REFERENCES `md_units` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_items` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`category_id`,`unit_id`) VALUES ('1','DEMO-ITEM','Material Operasional','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','1');
DROP TABLE IF EXISTS `md_locations`;
CREATE TABLE `md_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `city` varchar(100) NOT NULL DEFAULT '',
  `province` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  CONSTRAINT `fk_md_locations_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_locations` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`city`,`province`) VALUES ('1','DEMO-LOC-A','Gudang Utama','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','Makassar','Sulawesi Selatan');
INSERT INTO `md_locations` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`city`,`province`) VALUES ('2','DEMO-LOC-B','Lokasi Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','Gowa','Sulawesi Selatan');
DROP TABLE IF EXISTS `md_parties`;
CREATE TABLE `md_parties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `company` varchar(150) NOT NULL DEFAULT '',
  `address` varchar(500) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `party_role` varchar(12) NOT NULL,
  `identity_hash` char(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  UNIQUE KEY `branch_id_2` (`branch_id`,`identity_hash`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  CONSTRAINT `fk_md_parties_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`party_role` in ('sender','receiver','both'))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_parties` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`company`,`address`,`phone`,`party_role`,`identity_hash`) VALUES ('1','DEMO-SENDER-01','Pengirim Nusantara','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','DEMO Logistics','','','sender','043d41af860ba9d8fced77a0986879eb4807c637d2ee07050e9425d2a5bf88dc');
INSERT INTO `md_parties` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`company`,`address`,`phone`,`party_role`,`identity_hash`) VALUES ('2','DEMO-RECEIVER-01','Penerima Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','DEMO Site','','','receiver','ef9455d3fb9922fc644aab1cd5ce2725b8eae604982a2ab371017bd0319b237c');
DROP TABLE IF EXISTS `md_personnel`;
CREATE TABLE `md_personnel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `kind` varchar(12) NOT NULL,
  `phone` varchar(30) NOT NULL DEFAULT '',
  `account_id` int(10) unsigned DEFAULT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  UNIQUE KEY `account_id` (`account_id`),
  KEY `branch_id` (`branch_id`,`kind`,`active`),
  CONSTRAINT `fk_md_personnel_account_id` FOREIGN KEY (`account_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_md_personnel_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`kind` in ('driver','operator')),
  CONSTRAINT `CONSTRAINT_3` CHECK (`account_id` is null and `name` is not null or `account_id` is not null and `name` is null)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_personnel` (`id`,`code`,`name`,`branch_id`,`kind`,`phone`,`account_id`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-DRIVER-01','Sopir Operasional','1','driver','',NULL,'1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
INSERT INTO `md_personnel` (`id`,`code`,`name`,`branch_id`,`kind`,`phone`,`account_id`,`active`,`version`,`created_at`,`updated_at`) VALUES ('2','DEMO-OPERATOR-01','Operator Alat Berat','1','operator','',NULL,'1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
DROP TABLE IF EXISTS `md_routes`;
CREATE TABLE `md_routes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `destination_branch_id` int(10) unsigned NOT NULL,
  `origin_location_id` int(10) unsigned NOT NULL,
  `destination_location_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  UNIQUE KEY `branch_id_2` (`branch_id`,`destination_branch_id`,`origin_location_id`,`destination_location_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  KEY `fk_md_route_destination_branch` (`destination_branch_id`),
  KEY `fk_md_route_origin_location` (`origin_location_id`,`branch_id`),
  KEY `fk_md_route_destination_location` (`destination_location_id`,`destination_branch_id`),
  CONSTRAINT `fk_md_route_destination_branch` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_md_route_destination_location` FOREIGN KEY (`destination_location_id`, `destination_branch_id`) REFERENCES `md_locations` (`id`, `branch_id`),
  CONSTRAINT `fk_md_route_origin_location` FOREIGN KEY (`origin_location_id`, `branch_id`) REFERENCES `md_locations` (`id`, `branch_id`),
  CONSTRAINT `fk_md_routes_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_routes` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`destination_branch_id`,`origin_location_id`,`destination_location_id`) VALUES ('1','DEMO-ROUTE-01','Rute Gudang - Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','1','1','2');
DROP TABLE IF EXISTS `md_suppliers`;
CREATE TABLE `md_suppliers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `address` varchar(500) NOT NULL DEFAULT '',
  `phone` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(190) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  CONSTRAINT `fk_md_suppliers_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `md_trucking_tariffs`;
CREATE TABLE `md_trucking_tariffs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `branch_id` int(10) unsigned NOT NULL,
  `service` varchar(12) NOT NULL,
  `route_id` int(10) unsigned DEFAULT NULL,
  `basis` varchar(150) NOT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_until` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `id` (`id`,`branch_id`),
  KEY `branch_id` (`branch_id`,`active`,`name`),
  KEY `fk_md_truck_tariff_route` (`route_id`,`branch_id`),
  CONSTRAINT `fk_md_truck_tariff_route` FOREIGN KEY (`route_id`, `branch_id`) REFERENCES `md_routes` (`id`, `branch_id`),
  CONSTRAINT `fk_md_trucking_tariffs_branch_id` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1)),
  CONSTRAINT `CONSTRAINT_2` CHECK (`service` in ('regular','charter','pickup')),
  CONSTRAINT `CONSTRAINT_3` CHECK (`amount` is null or `amount` >= 0),
  CONSTRAINT `CONSTRAINT_4` CHECK (`service` = 'pickup' and `route_id` is null or `service` in ('regular','charter') and `route_id` is not null),
  CONSTRAINT `CONSTRAINT_5` CHECK (`valid_from` is null or `valid_until` is null or `valid_from` <= `valid_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `md_units`;
CREATE TABLE `md_units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`active` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `md_units` (`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-UNIT','Unit','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('1','foundation.view','Lihat akses fondasi sendiri');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('2','users.view','Lihat pengguna');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('3','users.manage','Kelola pengguna');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('4','branches.view','Lihat cabang sesuai cakupan');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('5','branches.manage','Kelola cabang sesuai cakupan');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('6','roles.view','Lihat matriks role');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('7','audit.view','Lihat audit fondasi');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('9','master.customer.view','Lihat master Customer');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('10','master.customer.create','Tambah master Customer');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('11','master.customer.update','Ubah master Customer');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('17','master.party.view','Lihat master Pengirim & Penerima');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('18','master.party.create','Tambah master Pengirim & Penerima');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('19','master.party.update','Ubah master Pengirim & Penerima');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('24','master.location.view','Lihat master Lokasi');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('25','master.location.create','Tambah master Lokasi');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('26','master.location.update','Ubah master Lokasi');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('31','master.route.view','Lihat master Rute');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('32','master.route.create','Tambah master Rute');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('33','master.route.update','Ubah master Rute');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('38','master.trucking_tariff.view','Lihat master Tarif Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('39','master.trucking_tariff.create','Tambah master Tarif Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('40','master.trucking_tariff.update','Ubah master Tarif Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('43','master.equipment_tariff.view','Lihat master Tarif Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('44','master.equipment_tariff.create','Tambah master Tarif Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('45','master.equipment_tariff.update','Ubah master Tarif Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('48','master.vehicle.view','Lihat master Kendaraan Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('49','master.vehicle.create','Tambah master Kendaraan Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('50','master.vehicle.update','Ubah master Kendaraan Trucking');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('54','master.unit.view','Lihat master Unit Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('55','master.unit.create','Tambah master Unit Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('56','master.unit.update','Ubah master Unit Equipment');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('61','master.driver.view','Lihat master Driver');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('62','master.driver.create','Tambah master Driver');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('63','master.driver.update','Ubah master Driver');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('67','master.operator.view','Lihat master Operator');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('68','master.operator.create','Tambah master Operator');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('69','master.operator.update','Ubah master Operator');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('72','master.item.view','Lihat master Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('73','master.item.create','Tambah master Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('74','master.item.update','Ubah master Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('77','master.category.view','Lihat master Kategori Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('78','master.category.create','Tambah master Kategori Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('79','master.category.update','Ubah master Kategori Barang');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('82','master.uom.view','Lihat master Satuan');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('83','master.uom.create','Tambah master Satuan');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('84','master.uom.update','Ubah master Satuan');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('87','master.supplier.view','Lihat master Supplier');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('88','master.supplier.create','Tambah master Supplier');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('89','master.supplier.update','Ubah master Supplier');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('106','master.routes.view','Lihat Lokasi & Rute');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('117','master.assets.view','Lihat Kendaraan & Unit');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('124','master.personnel.view','Lihat Driver & Operator');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('129','master.catalog.view','Lihat Barang & Kategori');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('136','expedition.view','Lihat DN dan tracking internal');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('137','expedition.ship','Buat/ubah DN awal');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('138','expedition.manifest.view','Lihat manifest');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('139','expedition.manifest','Buat manifest draf dan susun DN');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('140','expedition.confirm','Konfirmasi DN dan nomor resmi');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('141','expedition.transit','Catat perjalanan dan posisi aktual');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('142','expedition.receive','Penerimaan utuh aktual');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('143','expedition.claim.view','Lihat klaim operasional');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('144','expedition.claim.report','Laporkan klaim dan bukti');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('145','expedition.claim.review','Periksa/putuskan/tutup klaim operasional');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('146','equipment.assignment.manage','Equipment: assignment.manage');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('147','equipment.contract.activate','Equipment: contract.activate');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('148','equipment.contract.cancel','Equipment: contract.cancel');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('149','equipment.contract.close','Equipment: contract.close');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('150','equipment.contract.confirm','Equipment: contract.confirm');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('151','equipment.contract.create','Equipment: contract.create');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('152','equipment.contract.extend','Equipment: contract.extend');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('153','equipment.contract.terminate','Equipment: contract.terminate');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('154','equipment.contract.update','Equipment: contract.update');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('155','equipment.contract.view','Equipment: contract.view');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('156','equipment.contract.view_own','Equipment: contract.view_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('157','equipment.cross_branch.approve','Equipment: cross_branch.approve');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('158','equipment.cross_branch.request','Equipment: cross_branch.request');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('159','equipment.evidence.add','Equipment: evidence.add');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('160','equipment.evidence.add_own','Equipment: evidence.add_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('161','equipment.evidence.view','Equipment: evidence.view');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('162','equipment.evidence.view_own','Equipment: evidence.view_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('163','equipment.handover.cancel','Equipment: handover.cancel');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('164','equipment.handover.confirm','Equipment: handover.confirm');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('165','equipment.handover.correct','Equipment: handover.correct');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('166','equipment.handover.create','Equipment: handover.create');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('167','equipment.handover.fact_correct','Equipment: handover.fact_correct');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('168','equipment.handover.update','Equipment: handover.update');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('169','equipment.handover.view','Equipment: handover.view');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('170','equipment.handover.view_own','Equipment: handover.view_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('171','equipment.meter.correct','Equipment: meter.correct');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('172','equipment.operator.relink','Equipment: operator.relink');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('173','equipment.recovery.close','Equipment: recovery.close');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('174','equipment.timesheet.create_own','Equipment: timesheet.create_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('175','equipment.timesheet.create_scoped','Equipment: timesheet.create_scoped');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('176','equipment.timesheet.revise_own','Equipment: timesheet.revise_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('177','equipment.timesheet.revise_scoped','Equipment: timesheet.revise_scoped');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('178','equipment.timesheet.revise_terminal','Equipment: timesheet.revise_terminal');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('179','equipment.timesheet.submit_own','Equipment: timesheet.submit_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('180','equipment.timesheet.submit_scoped','Equipment: timesheet.submit_scoped');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('181','equipment.timesheet.update_own','Equipment: timesheet.update_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('182','equipment.timesheet.update_scoped','Equipment: timesheet.update_scoped');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('183','equipment.timesheet.view_own','Equipment: timesheet.view_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('184','equipment.timesheet.view_scoped','Equipment: timesheet.view_scoped');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('185','equipment.unit.view','Equipment: unit.view');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('186','equipment.unit.view_own','Equipment: unit.view_own');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('187','equipment.verification.decide','Equipment: verification.decide');
INSERT INTO `permissions` (`id`,`code`,`name`) VALUES ('188','equipment.verification.view','Equipment: verification.view');
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions` (
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_permission` (`permission_id`),
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','2');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','3');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','4');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','5');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','6');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','7');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','10');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','11');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','17');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','18');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','19');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','24');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','25');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','26');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','31');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','32');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','33');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','38');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','39');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','40');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','43');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','44');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','45');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','48');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','49');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','50');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','54');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','55');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','56');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','61');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','62');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','63');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','67');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','68');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','69');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','72');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','73');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','74');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','77');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','78');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','79');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','82');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','83');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','84');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','87');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','88');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','89');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','106');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','124');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','129');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','136');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','137');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','138');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','139');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','140');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','141');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','142');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','143');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','144');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','145');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','146');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','147');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','148');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','149');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','150');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','151');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','152');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','153');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','154');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','155');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','158');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','159');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','161');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','163');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','164');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','166');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','168');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','169');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','175');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','177');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','180');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','182');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','184');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','185');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','187');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('1','188');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','4');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','17');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','24');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','31');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','38');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','43');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','48');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','54');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','61');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','67');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','72');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','77');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','82');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','87');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','106');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','124');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','129');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','136');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','138');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','143');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','155');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','161');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','169');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','184');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','185');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('2','188');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','17');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','24');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','31');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','38');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','48');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','61');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','106');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','124');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','136');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','137');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','138');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','140');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','143');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('3','144');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','17');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','24');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','31');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','48');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','61');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','106');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','124');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','136');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','138');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','139');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','141');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','143');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('4','144');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','17');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','24');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','31');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','106');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','136');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','138');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','142');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','143');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('5','144');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','43');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','54');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','67');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','124');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','146');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','147');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','148');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','149');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','150');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','151');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','154');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','155');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','158');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','159');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','161');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','163');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','164');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','166');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','168');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','169');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','175');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','177');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','180');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','182');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','184');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('6','185');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','54');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','156');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','160');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','162');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','170');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','174');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','176');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','179');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','181');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','183');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('7','186');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('8','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('8','9');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('8','87');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','1');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','54');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','72');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','77');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','82');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','87');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','117');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('9','129');
INSERT INTO `role_permissions` (`role_id`,`permission_id`) VALUES ('10','1');
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `roles` (`id`,`name`) VALUES ('5','Admin Penerima');
INSERT INTO `roles` (`id`,`name`) VALUES ('3','Admin Pengirim');
INSERT INTO `roles` (`id`,`name`) VALUES ('6','Admin Sewa');
INSERT INTO `roles` (`id`,`name`) VALUES ('4','Admin Transit');
INSERT INTO `roles` (`id`,`name`) VALUES ('1','Administrator');
INSERT INTO `roles` (`id`,`name`) VALUES ('10','Customer');
INSERT INTO `roles` (`id`,`name`) VALUES ('8','Finance');
INSERT INTO `roles` (`id`,`name`) VALUES ('9','Gudang');
INSERT INTO `roles` (`id`,`name`) VALUES ('7','Operator Alat Berat');
INSERT INTO `roles` (`id`,`name`) VALUES ('2','Owner');
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(80) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('001_foundation','2026-10-24 19:28:34');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('002_master_data','2026-10-24 19:28:35');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('003_trucking','2026-10-24 19:28:35');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('004_trucking_operations','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/01/4040f3449073/180bbbaad484504f701d9efcb5111be9','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/02/275ea1272c02/fdc145d771bc47f0640d4b06d1f18687','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/03/125dbe4c4e12/3d99059772d748d66d76361c3038751b','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/04/94e1bd4d49d8/4f5d3966d6f0da03a55d3061ade60ee5','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/05/842ebb13fc54/b41b59657ec902cff2a7bc14fe6ce8be','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/06/f4be9b7aa990/89a4fd2beff9b58a233c945992a9db8a','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/07/9d0c75b6289a/36b83ece5861f437035378a69c05cf57','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/08/80336218edcf/866a2a01d3a1a0a40ce2d0b6d82d208f','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/09/e089445a8c13/dcb1b08164dbe457cd447b9e28c3aea8','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/10/de25a9310f58/580a7068cbe038752efb88a57a20f2e9','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/11/e2fa2ab46f11/2fa46e859e54a457a6daa00ec73e1438','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/12/012bb4c1aaa3/45514d4c81ec32423739e143a39c0aaf','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/13/54bca51563ba/1267b970b07948dda73b7a7ae2be4ba1','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/14/10b6c2a4b4d3/c7927dbd94af09f03517fa8003a43675','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/15/929294e8ff5d/693fe5f9e350d0b0609dfd4f36c7a65c','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/16/e0ac2ccb38de/309ad98dd9d8ecbdd275b20aa4f49448','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/17/ef2cf42d8ad8/526c5a25ea1ffba55828cd64b1cecf6e','2026-10-24 19:28:38');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/18/a183e3164241/2a77e0cc72876666bfe30f6016c31010','2026-10-24 19:28:38');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/done/19/996828907767/5a14386826125aa9a0d01888ba98edba','2026-10-24 19:28:38');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/01/4040f3449073','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/02/275ea1272c02','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/03/125dbe4c4e12','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/04/94e1bd4d49d8','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/05/842ebb13fc54','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/06/f4be9b7aa990','2026-10-24 19:28:36');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/07/9d0c75b6289a','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/08/80336218edcf','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/09/e089445a8c13','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/10/de25a9310f58','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/11/e2fa2ab46f11','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/12/012bb4c1aaa3','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/13/54bca51563ba','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/14/10b6c2a4b4d3','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/15/929294e8ff5d','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/16/e0ac2ccb38de','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/17/ef2cf42d8ad8','2026-10-24 19:28:37');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/18/a183e3164241','2026-10-24 19:28:38');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_eq/start/19/996828907767','2026-10-24 19:28:38');
INSERT INTO `schema_migrations` (`version`,`applied_at`) VALUES ('005_equipment_operations','2026-10-24 19:28:38');
DROP TABLE IF EXISTS `user_branches`;
CREATE TABLE `user_branches` (
  `user_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`branch_id`),
  KEY `fk_ub_branch` (`branch_id`),
  CONSTRAINT `fk_ub_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_ub_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('1','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('2','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('3','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('4','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('5','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('6','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('7','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('8','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('9','1');
INSERT INTO `user_branches` (`user_id`,`branch_id`) VALUES ('10','1');
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `all_branches` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `auth_version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_users_role` (`role_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `ck_user_active` CHECK (`active` in (0,1)),
  CONSTRAINT `ck_user_global` CHECK (`all_branches` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('1','Admin Penerima','demo_admin_penerima@demo.invalid','$2y$10$u7lVBXb7CIol189DkAjH..6vGHj6OHiI2qa2nKCUVQQyPbS4b1ysm','5','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('2','Admin Pengirim','demo_admin_pengirim@demo.invalid','$2y$10$wfvTEibAExhwAFgq/XufV.70c9VEcM97UijSMS6ODFASzYoJsfjmy','3','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('3','Admin Sewa','demo_admin_sewa@demo.invalid','$2y$10$nujSis2vw68NCooQnNIFTOtSFFS6SnizOvxHz5jvztldHwcfm7Bau','6','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('4','Admin Transit','demo_admin_transit@demo.invalid','$2y$10$mg0j162sgMHOaoSocHfIfex11HQIoNs0vkVfzS6MD6xMFnKKxc2Uq','4','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('5','Administrator','demo_administrator@demo.invalid','$2y$10$fEVxYHZ1hS.qf/Awabcjeu9PB2Rq1IrRnVQq1jw2Civh2.kJsStWO','1','1','1','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('6','Customer','demo_customer@demo.invalid','$2y$10$Foh36grb3eMbsU8pMNhub.FY8SPhM3b.MZrmBt/6sUJWhcnC.4tri','10','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('7','Finance','demo_finance@demo.invalid','$2y$10$e4f1AGB/WA/6e48sFk2VVenoI/CCWUAxlnqo1aCxKivRbUkbo5uXy','8','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('8','Gudang','demo_gudang@demo.invalid','$2y$10$iIkmMsBaiwA7X25nD9YVZ.GTUAr0moPYWk3h8igs9cYnNzcRDrfwe','9','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('9','Operator Alat Berat','demo_operator_alat_berat@demo.invalid','$2y$10$wP0Cq0JzUjA1wX8c3yxIv.GzWmgjTKbVkLEFiv1/LSwAJXJgLSps2','7','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users` (`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('10','Owner','demo_owner@demo.invalid','$2y$10$XbrgWU7ohletu0hlRWU4MOHlR.e1LBSf1u2PR7eDWDwEOVtEpsv3C','2','1','0','1','2026-10-24 19:28:39');
SET FOREIGN_KEY_CHECKS=1;

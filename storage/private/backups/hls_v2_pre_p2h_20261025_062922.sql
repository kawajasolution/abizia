-- hls_v2 pre-P2H backup
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
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('1','1','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('2','2','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('3','3','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:06');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('4','4','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('5','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('6','6','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('7','7','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('8','8','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('9','9','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:09');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('10','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:09');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('11',NULL,'login_failed','auth',NULL,'[]','2026-10-24 19:32:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('12',NULL,'login_failed','auth',NULL,'[]','2026-10-24 19:32:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('13','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:22');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('14','1','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:27');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('15','2','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:27');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('16','3','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('17','4','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('18','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('19','6','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('20','7','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('21','8','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('22','9','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('23','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:32:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('24','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:36:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('25','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('26','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:39');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('27','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:40');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('28','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:41');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('29','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:43');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('30','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:40:44');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('31','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('32','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('33','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('34','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:19');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('35','10','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('36','5','login_succeeded','auth',NULL,'[]','2026-10-24 19:58:21');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('37','1','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('38','2','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:02');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('39','3','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:02');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('40','4','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:02');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('41','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('42','6','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('43','7','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('44','8','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('45','9','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('46','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('47','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('48','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('49','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('50','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('51','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('52','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:09:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('53','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:18:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('54','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:25');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('55','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:26');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('56','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('57','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('58','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('59','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:31');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('60','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:22:59');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('61','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:23:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('62','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:23:02');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('63','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:23:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('64','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:23:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('65','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:23:06');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('66','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('67','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('68','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('69','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:19');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('70','10','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('71','5','login_succeeded','auth',NULL,'[]','2026-10-24 20:32:21');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('72','10','session_invalidated','auth',NULL,'[]','2026-10-24 22:16:57');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('73','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:17:33');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('74','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:17:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('75','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:17:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('76','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:17:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('77','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:00');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('78','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('79','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:02');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('80','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('81','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('82','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:05');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('83','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('84','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('85','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('86','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:19');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('87','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('88','5','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:22');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('89','10','login_succeeded','auth',NULL,'[]','2026-10-24 22:24:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('90','10','session_invalidated','auth',NULL,'[]','2026-10-25 00:01:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('91',NULL,'login_failed','auth',NULL,'[]','2026-10-25 00:14:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('92',NULL,'login_failed','auth',NULL,'[]','2026-10-25 00:14:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('93','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:14:25');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('94','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:40');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('95','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:42');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('96','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:43');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('97','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:44');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('98','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:45');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('99','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:46');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('100','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:16:57');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('101','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:27');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('102','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('103','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('104','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('105','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('106','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:36');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('107','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:46');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('108','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:20:52');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('109','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:24:03');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('110','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:24:25');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('111','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:26:25');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('112','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:33');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('113','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('114','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:35');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('115','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:36');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('116','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:37');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('117','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:27:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('118','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('119','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('120','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('121','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('122','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('123','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:19');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('124','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:21');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('125','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:29:36');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('126','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:31:38');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('127','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('128','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:06');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('129','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('130','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('131','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:09');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('132','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:11');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('133','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:34:12');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('134','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:36:10');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('135','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:48');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('136','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('137','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:50');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('138','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:51');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('139','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:52');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('140','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:37:54');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('141','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:04');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('142','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:05');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('143','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('144','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('145','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:09');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('146','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:38:10');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('147','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:26');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('148','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:27');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('149','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('150','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('151','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:31');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('152','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('153','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:45');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('154','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:46');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('155','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:47');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('156','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:48');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('157','10','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('158','5','login_succeeded','auth',NULL,'[]','2026-10-25 00:39:50');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('159','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:14:11');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('160','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:14:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('161','7','finance_account_created','fin_accounts','1','{\"code\":\"KAS-UAT\"}','2026-10-25 01:14:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('162','7','finance_invoice_created','fin_invoices','1','{\"lines\":1,\"total\":10000000}','2026-10-25 01:14:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('163','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:14:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('164','7','finance_invoice_issued','fin_invoices','1','{\"number\":\"INV\\/DMO\\/2026\\/000001\"}','2026-10-25 01:14:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('165','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:14:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('166','7','finance_payment_posted','fin_payments','1','{\"invoice_id\":1,\"amount\":4000000}','2026-10-25 01:14:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('167','7','finance_payment_posted','fin_payments','2','{\"invoice_id\":1,\"amount\":6000000}','2026-10-25 01:14:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('168','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:14:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('169','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:26:11');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('170','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:28:10');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('171','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:32:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('172','7','finance_invoice_created','fin_invoices','2','{\"lines\":1,\"total\":100}','2026-10-25 01:32:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('173','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:34:25');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('174','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:37:45');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('175','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:37:54');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('176','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:47:40');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('177','7','finance_invoice_created','fin_invoices','3','{\"lines\":1,\"total\":100}','2026-10-25 01:47:40');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('178','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:47:48');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('179','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:47:52');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('180','7','finance_invoice_updated','fin_invoices','2','{\"total\":300,\"lines\":1}','2026-10-25 01:47:52');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('181','7','login_succeeded','auth',NULL,'[]','2026-10-25 01:47:56');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('182','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:48:00');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('183','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:55:56');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('184','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:55:57');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('185','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:58:41');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('186','10','login_succeeded','auth',NULL,'[]','2026-10-25 01:58:51');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('187','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:16');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('188','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:22');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('189','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('190','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:33');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('191','7','finance_invoice_updated','fin_invoices','2','{\"total\":300,\"lines\":1,\"invoice_date\":\"2026-10-01\",\"due_date\":\"2026-10-31\"}','2026-10-25 02:02:33');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('192','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('193','10','login_succeeded','auth',NULL,'[]','2026-10-25 02:02:49');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('194','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:05:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('195','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:07:05');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('196','7','finance_invoice_created','fin_invoices','4','{\"lines\":1,\"total\":6000000}','2026-10-25 02:07:05');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('197','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('198','7','finance_invoice_created','fin_invoices','5','{\"lines\":1,\"total\":6000000}','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('199','7','finance_invoice_created','fin_invoices','6','{\"lines\":1,\"total\":4000000}','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('200','7','finance_invoice_issued','fin_invoices','5','{\"number\":\"INV\\/DMO\\/2026\\/000005\"}','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('201','7','finance_invoice_issued','fin_invoices','6','{\"number\":\"INV\\/DMO\\/2026\\/000006\"}','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('202','7','finance_payment_posted','fin_payments','3','{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-MULTI-UJI-200714\"}','2026-10-25 02:07:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('203','10','login_succeeded','auth',NULL,'[]','2026-10-25 02:07:22');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('204','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:13:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('205','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:15:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('206','7','finance_invoice_created','fin_invoices','7','{\"lines\":1,\"total\":6000000}','2026-10-25 02:15:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('207','7','finance_invoice_created','fin_invoices','8','{\"lines\":1,\"total\":4000000}','2026-10-25 02:15:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('208','7','finance_invoice_issued','fin_invoices','7','{\"number\":\"INV\\/DMO\\/2026\\/000007\"}','2026-10-25 02:15:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('209','7','finance_invoice_issued','fin_invoices','8','{\"number\":\"INV\\/DMO\\/2026\\/000008\"}','2026-10-25 02:15:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('210','7','finance_payment_posted','fin_payments','4','{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-REV-UJI-201529\"}','2026-10-25 02:15:29');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('211','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:15:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('212','7','finance_invoice_created','fin_invoices','9','{\"lines\":1,\"total\":6000000}','2026-10-25 02:15:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('213','7','finance_invoice_created','fin_invoices','10','{\"lines\":1,\"total\":4000000}','2026-10-25 02:15:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('214','7','finance_invoice_issued','fin_invoices','9','{\"number\":\"INV\\/DMO\\/2026\\/000009\"}','2026-10-25 02:15:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('215','7','finance_invoice_issued','fin_invoices','10','{\"number\":\"INV\\/DMO\\/2026\\/000010\"}','2026-10-25 02:15:32');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('216','7','finance_payment_posted','fin_payments','5','{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-REV-UJI-201533\"}','2026-10-25 02:15:33');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('217','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:15:55');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('218','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:16:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('219','7','finance_payment_reversed','fin_payments','5','{\"reason\":\"Koreksi uji reversal\",\"amount\":\"7000000.00\"}','2026-10-25 02:16:08');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('220','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:17:35');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('221','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:19:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('222','10','logout','auth',NULL,'[]','2026-10-25 02:19:39');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('223',NULL,'login_failed','auth',NULL,'[]','2026-10-25 02:19:55');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('224',NULL,'login_failed','auth',NULL,'[]','2026-10-25 02:20:07');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('225',NULL,'login_failed','auth',NULL,'[]','2026-10-25 02:20:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('226',NULL,'login_failed','auth',NULL,'[]','2026-10-25 02:21:24');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('227','10','login_succeeded','auth',NULL,'[]','2026-10-25 02:22:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('228','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:25:01');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('229','10','login_succeeded','auth',NULL,'[]','2026-10-25 02:26:23');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('230','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:26:28');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('231','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:27:39');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('232','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:29:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('233','7','finance_category_created','fin_expense_categories','1','{\"code\":\"OPS\"}','2026-10-25 02:29:15');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('234','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:29:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('235','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:29:30');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('236','7','finance_expense_posted','fin_expenses','2','{\"amount\":100000,\"reference\":\"EXP-UJI-100K\"}','2026-10-25 02:29:31');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('237','7','login_succeeded','auth',NULL,'[]','2026-10-25 02:30:20');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('238','10','login_succeeded','auth',NULL,'[]','2026-10-25 02:39:17');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('239','10','session_invalidated','auth',NULL,'[]','2026-10-25 03:03:58');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('240','10','login_succeeded','auth',NULL,'[]','2026-10-25 03:04:09');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('241','10','session_invalidated','auth',NULL,'[]','2026-10-25 04:16:00');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('242','10','login_succeeded','auth',NULL,'[]','2026-10-25 04:16:18');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('243','10','session_invalidated','auth',NULL,'[]','2026-10-25 05:50:43');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('244',NULL,'login_failed','auth',NULL,'[]','2026-10-25 05:51:34');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('245',NULL,'login_failed','auth',NULL,'[]','2026-10-25 05:52:57');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('246',NULL,'login_failed','auth',NULL,'[]','2026-10-25 05:53:14');
INSERT INTO `audit_logs`(`id`,`actor_id`,`action`,`entity`,`entity_id`,`detail`,`created_at`) VALUES ('247','10','login_succeeded','auth',NULL,'[]','2026-10-25 05:53:42');
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
INSERT INTO `branches`(`id`,`code`,`name`,`address`,`active`,`city`,`province`,`phone`,`version`,`created_at`,`updated_at`) VALUES ('1','DMO','Kantor Pusat','Alamat kantor pusat','1','','','','1',NULL,'2026-10-24 19:58:08');
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
DROP TABLE IF EXISTS `eq_p2h_inspections`;
CREATE TABLE `eq_p2h_inspections` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `internal_ref` varchar(80) NOT NULL,
  `official_number` varchar(80) DEFAULT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  `operator_id` int(10) unsigned DEFAULT NULL,
  `inspected_at` datetime NOT NULL,
  `shift` varchar(40) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `meter_type` varchar(3) NOT NULL DEFAULT 'HM',
  `meter_reading` decimal(12,3) DEFAULT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'DRAFT',
  `fitness_status` varchar(16) DEFAULT NULL,
  `general_note` varchar(2000) NOT NULL DEFAULT '',
  `critical_finding` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) unsigned NOT NULL,
  `reviewed_by` int(10) unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_p2h_ref` (`internal_ref`),
  UNIQUE KEY `uq_p2h_daily` (`asset_id`,`inspected_at`,`shift`),
  UNIQUE KEY `uq_p2h_number` (`official_number`),
  KEY `ix_p2h_scope` (`branch_id`,`inspected_at`,`status`),
  KEY `fk_p2h_operator` (`operator_id`),
  KEY `fk_p2h_creator` (`created_by`),
  KEY `fk_p2h_reviewer` (`reviewed_by`),
  CONSTRAINT `fk_p2h_asset` FOREIGN KEY (`asset_id`) REFERENCES `md_assets` (`id`),
  CONSTRAINT `fk_p2h_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_p2h_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_p2h_operator` FOREIGN KEY (`operator_id`) REFERENCES `md_personnel` (`id`),
  CONSTRAINT `fk_p2h_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_p2h_meter` CHECK (`meter_reading` is null or `meter_reading` >= 0),
  CONSTRAINT `ck_p2h_status` CHECK (`status` in ('DRAFT','SUBMITTED','REVIEWED','RETURNED','CANCELLED')),
  CONSTRAINT `ck_p2h_fitness` CHECK (`fitness_status` is null or `fitness_status` in ('FIT_FOR_OPERATION','FIT_WITH_NOTES','HOLD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `eq_p2h_items`;
CREATE TABLE `eq_p2h_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inspection_id` bigint(20) unsigned NOT NULL,
  `category` varchar(80) NOT NULL,
  `item_code` varchar(80) NOT NULL,
  `item_label` varchar(255) NOT NULL,
  `result` varchar(12) NOT NULL,
  `severity` varchar(8) DEFAULT NULL,
  `note` varchar(2000) NOT NULL DEFAULT '',
  `follow_up` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_p2h_item` (`inspection_id`,`item_code`),
  KEY `ix_p2h_item_result` (`inspection_id`,`result`),
  CONSTRAINT `fk_p2h_item_header` FOREIGN KEY (`inspection_id`) REFERENCES `eq_p2h_inspections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ck_p2h_item_result` CHECK (`result` in ('BAIK','RUSAK','TIDAK_BERLAKU')),
  CONSTRAINT `ck_p2h_item_severity` CHECK (`severity` is null or `severity` in ('MINOR','MAJOR','CRITICAL'))
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
DROP TABLE IF EXISTS `eq_unit_holds`;
CREATE TABLE `eq_unit_holds` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `source_p2h_id` bigint(20) unsigned NOT NULL,
  `reason` varchar(2000) NOT NULL,
  `activated_by` int(10) unsigned NOT NULL,
  `activated_at` datetime NOT NULL,
  `released_by` int(10) unsigned DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `release_reason` varchar(2000) DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_p2h_hold_source` (`source_p2h_id`),
  KEY `ix_unit_hold_active` (`asset_id`,`branch_id`,`released_at`),
  KEY `fk_hold_branch` (`branch_id`),
  KEY `fk_hold_actor` (`activated_by`),
  KEY `fk_hold_release` (`released_by`),
  CONSTRAINT `fk_hold_actor` FOREIGN KEY (`activated_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_hold_asset` FOREIGN KEY (`asset_id`) REFERENCES `md_assets` (`id`),
  CONSTRAINT `fk_hold_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_hold_p2h` FOREIGN KEY (`source_p2h_id`) REFERENCES `eq_p2h_inspections` (`id`),
  CONSTRAINT `fk_hold_release` FOREIGN KEY (`released_by`) REFERENCES `users` (`id`)
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
DROP TABLE IF EXISTS `fin_accounts`;
CREATE TABLE `fin_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `code` varchar(40) NOT NULL,
  `name` varchar(160) NOT NULL,
  `account_type` enum('CASH','BANK') NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'IDR',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fin_account_branch_code` (`branch_id`,`code`),
  KEY `ix_fin_account_branch_active` (`branch_id`,`active`),
  CONSTRAINT `fk_fin_account_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_accounts`(`id`,`branch_id`,`code`,`name`,`account_type`,`currency`,`active`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('1','1','KAS-UAT','Kas UAT','CASH','IDR','1','1','7','2026-10-25 01:14:17','2026-10-25 01:14:17');
DROP TABLE IF EXISTS `fin_cash_ledger`;
CREATE TABLE `fin_cash_ledger` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `transaction_type` enum('OPENING','RECEIPT','PAYMENT','EXPENSE','TRANSFER_IN','TRANSFER_OUT','REVERSAL') NOT NULL,
  `reference_type` varchar(40) DEFAULT NULL,
  `reference_id` int(10) unsigned DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `debit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `credit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_fin_cash_scope` (`account_id`,`transaction_date`),
  KEY `fk_fin_cash_branch` (`branch_id`),
  CONSTRAINT `fk_fin_cash_account` FOREIGN KEY (`account_id`) REFERENCES `fin_accounts` (`id`),
  CONSTRAINT `fk_fin_cash_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('1','1','1','RECEIPT','PAYMENT','1','2026-10-25','4000000.00','0.00','Penerimaan invoice','7','2026-10-25 01:14:34');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('2','1','1','RECEIPT','PAYMENT','2','2026-10-25','6000000.00','0.00','Penerimaan invoice','7','2026-10-25 01:14:34');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('3','1','1','RECEIPT','PAYMENT','3','2026-10-25','7000000.00','0.00','Penerimaan pembayaran','7','2026-10-25 02:07:14');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('4','1','1','RECEIPT','PAYMENT','4','2026-10-25','7000000.00','0.00','Penerimaan pembayaran','7','2026-10-25 02:15:29');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('5','1','1','RECEIPT','PAYMENT','5','2026-10-25','7000000.00','0.00','Penerimaan pembayaran','7','2026-10-25 02:15:33');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('6','1','1','REVERSAL','PAYMENT','5','2026-10-25','0.00','7000000.00','Reversal: Koreksi uji reversal','7','2026-10-25 02:16:08');
INSERT INTO `fin_cash_ledger`(`id`,`branch_id`,`account_id`,`transaction_type`,`reference_type`,`reference_id`,`transaction_date`,`debit`,`credit`,`note`,`created_by`,`created_at`) VALUES ('7','1','1','EXPENSE','EXPENSE','2','2026-10-25','0.00','100000.00','EXP-UJI-100K','7','2026-10-25 02:29:31');
DROP TABLE IF EXISTS `fin_events`;
CREATE TABLE `fin_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(40) NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `previous_state` varchar(30) DEFAULT NULL,
  `next_state` varchar(30) DEFAULT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `request_key` char(64) NOT NULL,
  `detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`detail`)),
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fin_event_request` (`request_key`),
  KEY `ix_fin_event_entity` (`entity_type`,`entity_id`),
  KEY `fk_fin_event_actor` (`actor_id`),
  KEY `fk_fin_event_branch` (`branch_id`),
  CONSTRAINT `fk_fin_event_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_fin_event_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `fin_expense_categories`;
CREATE TABLE `fin_expense_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(40) NOT NULL,
  `name` varchar(160) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_expense_categories`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','OPS','Operasional Uji','1','1','2026-10-25 02:29:15','2026-10-25 02:29:15');
DROP TABLE IF EXISTS `fin_expenses`;
CREATE TABLE `fin_expenses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `category_id` int(10) unsigned NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `expense_date` date NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `status` enum('DRAFT','SUBMITTED','APPROVED','POSTED','REJECTED','VOID') NOT NULL DEFAULT 'DRAFT',
  `description` varchar(255) NOT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_fin_expense_scope` (`branch_id`,`status`,`expense_date`),
  KEY `fk_fin_expense_category` (`category_id`),
  KEY `fk_fin_expense_account` (`account_id`),
  CONSTRAINT `fk_fin_expense_account` FOREIGN KEY (`account_id`) REFERENCES `fin_accounts` (`id`),
  CONSTRAINT `fk_fin_expense_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_fin_expense_category` FOREIGN KEY (`category_id`) REFERENCES `fin_expense_categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_expenses`(`id`,`branch_id`,`category_id`,`account_id`,`expense_date`,`amount`,`status`,`description`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('2','1','1','1','2026-10-25','100000.00','POSTED','Pengujian','1','7','2026-10-25 02:29:31','2026-10-25 02:29:31');
DROP TABLE IF EXISTS `fin_invoice_lines`;
CREATE TABLE `fin_invoice_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` int(10) unsigned NOT NULL,
  `description` varchar(255) NOT NULL,
  `quantity` decimal(18,3) NOT NULL DEFAULT 1.000,
  `unit_price` decimal(18,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `source_type` varchar(40) DEFAULT NULL,
  `source_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_fin_line_invoice` (`invoice_id`),
  CONSTRAINT `fk_fin_line_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `fin_invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('1','1','Item A','1.000','10000000.00','10000000.00',NULL,NULL,'2026-10-25 01:14:17');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('3','3','Item A','1.000','100.00','100.00',NULL,NULL,'2026-10-25 01:47:40');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('5','2','Tanggal diuji','2.000','150.00','300.00',NULL,NULL,'2026-10-25 02:02:33');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('6','4','Invoice Uji A','1.000','6000000.00','6000000.00',NULL,NULL,'2026-10-25 02:07:05');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('7','5','Invoice Multi Uji','1.000','6000000.00','6000000.00',NULL,NULL,'2026-10-25 02:07:14');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('8','6','Invoice Multi Uji','1.000','4000000.00','4000000.00',NULL,NULL,'2026-10-25 02:07:14');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('9','7','Invoice Reversal Uji','1.000','6000000.00','6000000.00',NULL,NULL,'2026-10-25 02:15:28');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('10','8','Invoice Reversal Uji','1.000','4000000.00','4000000.00',NULL,NULL,'2026-10-25 02:15:28');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('11','9','Invoice Reversal Uji','1.000','6000000.00','6000000.00',NULL,NULL,'2026-10-25 02:15:32');
INSERT INTO `fin_invoice_lines`(`id`,`invoice_id`,`description`,`quantity`,`unit_price`,`line_total`,`source_type`,`source_id`,`created_at`) VALUES ('12','10','Invoice Reversal Uji','1.000','4000000.00','4000000.00',NULL,NULL,'2026-10-25 02:15:32');
DROP TABLE IF EXISTS `fin_invoices`;
CREATE TABLE `fin_invoices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `internal_ref` varchar(50) NOT NULL,
  `official_number` varchar(50) DEFAULT NULL,
  `status` enum('DRAFT','SUBMITTED','RETURNED','APPROVED','ISSUED','PARTIALLY_PAID','PAID','VOID') NOT NULL DEFAULT 'DRAFT',
  `invoice_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `internal_ref` (`internal_ref`),
  UNIQUE KEY `official_number` (`official_number`),
  KEY `ix_fin_invoice_scope` (`branch_id`,`status`,`invoice_date`),
  KEY `fk_fin_invoice_customer` (`customer_id`),
  CONSTRAINT `fk_fin_invoice_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_fin_invoice_customer` FOREIGN KEY (`customer_id`) REFERENCES `md_customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('1','1','1','INV-DRAFT-681950e387475b46','INV/DMO/2026/000001','PAID','2026-10-25','2026-11-24','10000000.00','0.00','0.00','10000000.00','4','7','2026-10-25 01:14:17','2026-10-25 01:14:34');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('2','1','1','INV-DRAFT-6885c26753741e48',NULL,'DRAFT','2026-10-01','2026-10-31','300.00','0.00','0.00','300.00','3','7','2026-10-25 01:32:29','2026-10-25 02:02:33');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('3','1','1','INV-DRAFT-193b9767dff1328f',NULL,'DRAFT','2026-10-25','2026-11-25','100.00','0.00','0.00','100.00','1','7','2026-10-25 01:47:40','2026-10-25 01:47:40');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('4','1','1','INV-DRAFT-8d22c9f36a2bbc2a',NULL,'DRAFT','2026-10-25','2026-11-25','6000000.00','0.00','0.00','6000000.00','1','7','2026-10-25 02:07:05','2026-10-25 02:07:05');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('5','1','1','INV-DRAFT-a33042f997ffbaaf','INV/DMO/2026/000005','PAID','2026-10-25','2026-11-25','6000000.00','0.00','0.00','6000000.00','3','7','2026-10-25 02:07:14','2026-10-25 02:07:14');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('6','1','1','INV-DRAFT-50b8c904fb23fa74','INV/DMO/2026/000006','PARTIALLY_PAID','2026-10-25','2026-11-25','4000000.00','0.00','0.00','4000000.00','3','7','2026-10-25 02:07:14','2026-10-25 02:07:14');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('7','1','1','INV-DRAFT-768cd77fc8e11709','INV/DMO/2026/000007','PAID','2026-10-25','2026-11-25','6000000.00','0.00','0.00','6000000.00','3','7','2026-10-25 02:15:28','2026-10-25 02:15:29');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('8','1','1','INV-DRAFT-589fdb409cbea8a7','INV/DMO/2026/000008','PARTIALLY_PAID','2026-10-25','2026-11-25','4000000.00','0.00','0.00','4000000.00','3','7','2026-10-25 02:15:28','2026-10-25 02:15:29');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('9','1','1','INV-DRAFT-ad0a773bfe95ec68','INV/DMO/2026/000009','ISSUED','2026-10-25','2026-11-25','6000000.00','0.00','0.00','6000000.00','4','7','2026-10-25 02:15:32','2026-10-25 02:16:08');
INSERT INTO `fin_invoices`(`id`,`branch_id`,`customer_id`,`internal_ref`,`official_number`,`status`,`invoice_date`,`due_date`,`subtotal`,`tax_amount`,`discount_amount`,`total_amount`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('10','1','1','INV-DRAFT-127b53d6b016d332','INV/DMO/2026/000010','ISSUED','2026-10-25','2026-11-25','4000000.00','0.00','0.00','4000000.00','4','7','2026-10-25 02:15:32','2026-10-25 02:16:08');
DROP TABLE IF EXISTS `fin_payment_allocations`;
CREATE TABLE `fin_payment_allocations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` int(10) unsigned NOT NULL,
  `invoice_id` int(10) unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fin_allocation` (`payment_id`,`invoice_id`),
  KEY `fk_fin_alloc_invoice` (`invoice_id`),
  CONSTRAINT `fk_fin_alloc_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `fin_invoices` (`id`),
  CONSTRAINT `fk_fin_alloc_payment` FOREIGN KEY (`payment_id`) REFERENCES `fin_payments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('1','1','1','4000000.00','2026-10-25 01:14:34');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('2','2','1','6000000.00','2026-10-25 01:14:34');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('3','3','5','6000000.00','2026-10-25 02:07:14');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('4','3','6','1000000.00','2026-10-25 02:07:14');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('5','4','7','6000000.00','2026-10-25 02:15:29');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('6','4','8','1000000.00','2026-10-25 02:15:29');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('7','5','9','6000000.00','2026-10-25 02:15:33');
INSERT INTO `fin_payment_allocations`(`id`,`payment_id`,`invoice_id`,`amount`,`created_at`) VALUES ('8','5','10','1000000.00','2026-10-25 02:15:33');
DROP TABLE IF EXISTS `fin_payments`;
CREATE TABLE `fin_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `payment_ref` varchar(50) NOT NULL,
  `payment_date` date NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `status` enum('DRAFT','POSTED','REVERSED') NOT NULL DEFAULT 'DRAFT',
  `note` varchar(255) DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_ref` (`payment_ref`),
  KEY `ix_fin_payment_scope` (`branch_id`,`payment_date`,`status`),
  KEY `fk_fin_payment_account` (`account_id`),
  CONSTRAINT `fk_fin_payment_account` FOREIGN KEY (`account_id`) REFERENCES `fin_accounts` (`id`),
  CONSTRAINT `fk_fin_payment_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `fin_payments`(`id`,`branch_id`,`payment_ref`,`payment_date`,`account_id`,`amount`,`status`,`note`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('1','1','PAY-d188918630bfbe52','2026-10-25','1','4000000.00','POSTED',NULL,'1','7','2026-10-25 01:14:34','2026-10-25 01:14:34');
INSERT INTO `fin_payments`(`id`,`branch_id`,`payment_ref`,`payment_date`,`account_id`,`amount`,`status`,`note`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('2','1','PAY-c131b7d12f8e3ff7','2026-10-25','1','6000000.00','POSTED',NULL,'1','7','2026-10-25 01:14:34','2026-10-25 01:14:34');
INSERT INTO `fin_payments`(`id`,`branch_id`,`payment_ref`,`payment_date`,`account_id`,`amount`,`status`,`note`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('3','1','PAY-MULTI-UJI-200714','2026-10-25','1','7000000.00','POSTED',NULL,'1','7','2026-10-25 02:07:14','2026-10-25 02:07:14');
INSERT INTO `fin_payments`(`id`,`branch_id`,`payment_ref`,`payment_date`,`account_id`,`amount`,`status`,`note`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('4','1','PAY-REV-UJI-201529','2026-10-25','1','7000000.00','POSTED',NULL,'1','7','2026-10-25 02:15:29','2026-10-25 02:15:29');
INSERT INTO `fin_payments`(`id`,`branch_id`,`payment_ref`,`payment_date`,`account_id`,`amount`,`status`,`note`,`version`,`created_by`,`created_at`,`updated_at`) VALUES ('5','1','PAY-REV-UJI-201533','2026-10-25','1','7000000.00','REVERSED',NULL,'2','7','2026-10-25 02:15:33','2026-10-25 02:16:08');
DROP TABLE IF EXISTS `fin_supplier_bill_lines`;
CREATE TABLE `fin_supplier_bill_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int(10) unsigned NOT NULL,
  `description` varchar(255) NOT NULL,
  `quantity` decimal(18,3) NOT NULL DEFAULT 1.000,
  `unit_price` decimal(18,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_fin_bill_line_bill` (`bill_id`),
  CONSTRAINT `fk_fin_bill_line_bill` FOREIGN KEY (`bill_id`) REFERENCES `fin_supplier_bills` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `fin_supplier_bills`;
CREATE TABLE `fin_supplier_bills` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `supplier_id` int(10) unsigned NOT NULL,
  `bill_ref` varchar(80) NOT NULL,
  `bill_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `status` enum('DRAFT','POSTED','SUBMITTED','VERIFIED','PARTIALLY_PAID','PAID','VOID') NOT NULL DEFAULT 'DRAFT',
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fin_bill_branch_ref` (`branch_id`,`bill_ref`),
  KEY `ix_fin_bill_scope` (`branch_id`,`status`,`due_date`),
  KEY `fk_fin_bill_supplier` (`supplier_id`),
  CONSTRAINT `fk_fin_bill_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_fin_bill_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `md_suppliers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `fin_supplier_payments`;
CREATE TABLE `fin_supplier_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bill_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `payment_ref` varchar(80) NOT NULL,
  `payment_date` date NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `status` enum('POSTED','REVERSED') NOT NULL DEFAULT 'POSTED',
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payment_ref` (`payment_ref`),
  KEY `fk_fsp_bill` (`bill_id`),
  KEY `fk_fsp_branch` (`branch_id`),
  KEY `fk_fsp_account` (`account_id`),
  CONSTRAINT `fk_fsp_account` FOREIGN KEY (`account_id`) REFERENCES `fin_accounts` (`id`),
  CONSTRAINT `fk_fsp_bill` FOREIGN KEY (`bill_id`) REFERENCES `fin_supplier_bills` (`id`),
  CONSTRAINT `fk_fsp_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_issue_lines`;
CREATE TABLE `inv_issue_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `issue_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `quantity` decimal(18,3) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_inv_issue_header` (`issue_id`),
  KEY `fk_inv_issue_item` (`item_id`),
  CONSTRAINT `fk_inv_issue_header` FOREIGN KEY (`issue_id`) REFERENCES `inv_issues` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inv_issue_item` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_issues`;
CREATE TABLE `inv_issues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `issue_ref` varchar(80) NOT NULL,
  `issue_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
  `reservation_id` int(10) unsigned DEFAULT NULL,
  `recipient` varchar(160) DEFAULT NULL,
  `document_ref` varchar(100) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('DRAFT','POSTED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `posted_by` int(10) unsigned DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `issue_ref` (`issue_ref`),
  KEY `ix_inv_issue_scope` (`branch_id`,`issue_date`,`status`),
  KEY `fk_inv_issue_warehouse` (`warehouse_id`),
  KEY `ix_inv_issue_reservation` (`reservation_id`),
  CONSTRAINT `fk_inv_issue_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_issue_reservation` FOREIGN KEY (`reservation_id`) REFERENCES `inv_reservations` (`id`),
  CONSTRAINT `fk_inv_issue_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_receipt_lines`;
CREATE TABLE `inv_receipt_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `receipt_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `quantity` decimal(18,3) NOT NULL,
  `unit_price` decimal(18,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_inv_receipt_line_header` (`receipt_id`),
  KEY `fk_inv_receipt_line_item` (`item_id`),
  CONSTRAINT `fk_inv_receipt_line_header` FOREIGN KEY (`receipt_id`) REFERENCES `inv_receipts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inv_receipt_line_item` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_receipts`;
CREATE TABLE `inv_receipts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `receipt_ref` varchar(80) NOT NULL,
  `receipt_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
  `supplier_id` int(10) unsigned DEFAULT NULL,
  `document_ref` varchar(100) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('DRAFT','POSTED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  `posted_by` int(10) unsigned DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receipt_ref` (`receipt_ref`),
  KEY `fk_inv_receipt_supplier` (`supplier_id`),
  KEY `ix_inv_receipt_scope` (`branch_id`,`receipt_date`,`status`),
  KEY `fk_inv_receipt_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_inv_receipt_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_receipt_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `md_suppliers` (`id`),
  CONSTRAINT `fk_inv_receipt_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_reservation_lines`;
CREATE TABLE `inv_reservation_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reservation_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `quantity_requested` decimal(18,3) NOT NULL,
  `quantity_reserved` decimal(18,3) NOT NULL,
  `quantity_fulfilled` decimal(18,3) NOT NULL DEFAULT 0.000,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inv_res_line` (`reservation_id`,`item_id`),
  KEY `fk_inv_res_line_item` (`item_id`),
  CONSTRAINT `fk_inv_res_line_header` FOREIGN KEY (`reservation_id`) REFERENCES `inv_reservations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inv_res_line_item` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`quantity_requested` > 0 and `quantity_reserved` > 0 and `quantity_fulfilled` >= 0 and `quantity_fulfilled` <= `quantity_reserved`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_reservations`;
CREATE TABLE `inv_reservations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `reservation_ref` varchar(80) NOT NULL,
  `reservation_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned NOT NULL,
  `need_ref` varchar(100) DEFAULT NULL,
  `need_type` varchar(80) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('DRAFT','RESERVED','FULFILLED','RELEASED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `reserved_at` datetime DEFAULT NULL,
  `released_at` datetime DEFAULT NULL,
  `fulfilled_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_ref` (`reservation_ref`),
  KEY `ix_inv_res_scope` (`branch_id`,`warehouse_id`,`status`,`reservation_date`),
  KEY `fk_inv_res_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_inv_res_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_res_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_stock_adjustment_lines`;
CREATE TABLE `inv_stock_adjustment_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `adjustment_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `quantity_change` decimal(18,3) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_adj_line_h` (`adjustment_id`),
  KEY `fk_adj_line_i` (`item_id`),
  CONSTRAINT `fk_adj_line_h` FOREIGN KEY (`adjustment_id`) REFERENCES `inv_stock_adjustments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_adj_line_i` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`quantity_change` <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_stock_adjustments`;
CREATE TABLE `inv_stock_adjustments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `adjustment_ref` varchar(80) NOT NULL,
  `adjustment_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned NOT NULL,
  `opname_id` int(10) unsigned DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `status` enum('DRAFT','SUBMITTED','APPROVED','POSTED','REJECTED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `approved_by` int(10) unsigned DEFAULT NULL,
  `posted_by` int(10) unsigned DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `adjustment_ref` (`adjustment_ref`),
  KEY `fk_adj_w` (`warehouse_id`),
  KEY `fk_adj_op` (`opname_id`),
  KEY `ix_adj_scope` (`branch_id`,`warehouse_id`,`status`,`adjustment_date`),
  CONSTRAINT `fk_adj_b` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_adj_op` FOREIGN KEY (`opname_id`) REFERENCES `inv_stock_opnames` (`id`),
  CONSTRAINT `fk_adj_w` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_stock_ledger`;
CREATE TABLE `inv_stock_ledger` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
  `quantity_change` decimal(18,3) NOT NULL,
  `transaction_type` varchar(30) NOT NULL,
  `reference_type` varchar(40) DEFAULT NULL,
  `reference_id` int(10) unsigned DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_inv_stock_scope` (`item_id`,`branch_id`,`transaction_date`),
  KEY `fk_inv_stock_branch` (`branch_id`),
  KEY `ix_inv_stock_warehouse` (`item_id`,`branch_id`,`warehouse_id`,`transaction_date`),
  KEY `fk_inv_stock_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_inv_stock_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_stock_item` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `fk_inv_stock_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_stock_opname_lines`;
CREATE TABLE `inv_stock_opname_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `opname_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `system_qty` decimal(18,3) NOT NULL,
  `physical_qty` decimal(18,3) NOT NULL,
  `variance_qty` decimal(18,3) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_op_item` (`opname_id`,`item_id`),
  KEY `fk_op_line_i` (`item_id`),
  CONSTRAINT `fk_op_line_h` FOREIGN KEY (`opname_id`) REFERENCES `inv_stock_opnames` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_op_line_i` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_stock_opnames`;
CREATE TABLE `inv_stock_opnames` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `opname_ref` varchar(80) NOT NULL,
  `opname_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('DRAFT','SUBMITTED','VERIFIED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `verified_by` int(10) unsigned DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opname_ref` (`opname_ref`),
  KEY `fk_op_wh` (`warehouse_id`),
  KEY `ix_op_scope` (`branch_id`,`warehouse_id`,`opname_date`,`status`),
  CONSTRAINT `fk_op_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_op_wh` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_transfer_lines`;
CREATE TABLE `inv_transfer_lines` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transfer_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `quantity` decimal(18,3) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_inv_transfer_line_h` (`transfer_id`),
  KEY `fk_inv_transfer_line_i` (`item_id`),
  CONSTRAINT `fk_inv_transfer_line_h` FOREIGN KEY (`transfer_id`) REFERENCES `inv_transfers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inv_transfer_line_i` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_transfers`;
CREATE TABLE `inv_transfers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transfer_ref` varchar(80) NOT NULL,
  `transfer_date` date NOT NULL,
  `source_branch_id` int(10) unsigned NOT NULL,
  `source_warehouse_id` int(10) unsigned NOT NULL,
  `destination_branch_id` int(10) unsigned NOT NULL,
  `destination_warehouse_id` int(10) unsigned NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` enum('DRAFT','SENT','RECEIVED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  `created_by` int(10) unsigned NOT NULL,
  `sent_by` int(10) unsigned DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `received_by` int(10) unsigned DEFAULT NULL,
  `received_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfer_ref` (`transfer_ref`),
  KEY `fk_inv_transfer_sb` (`source_branch_id`),
  KEY `fk_inv_transfer_db` (`destination_branch_id`),
  KEY `fk_inv_transfer_sw` (`source_warehouse_id`),
  KEY `fk_inv_transfer_dw` (`destination_warehouse_id`),
  KEY `ix_inv_transfer_status` (`status`,`transfer_date`),
  CONSTRAINT `fk_inv_transfer_db` FOREIGN KEY (`destination_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_transfer_dw` FOREIGN KEY (`destination_warehouse_id`) REFERENCES `inv_warehouses` (`id`),
  CONSTRAINT `fk_inv_transfer_sb` FOREIGN KEY (`source_branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_transfer_sw` FOREIGN KEY (`source_warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `inv_warehouses`;
CREATE TABLE `inv_warehouses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) unsigned NOT NULL,
  `code` varchar(40) NOT NULL,
  `name` varchar(150) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inv_wh_branch_code` (`branch_id`,`code`),
  KEY `ix_inv_wh_branch_active` (`branch_id`,`active`),
  CONSTRAINT `fk_inv_wh_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`)
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('1','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 19:32:18');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('2','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 19:32:18');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('3','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 00:14:01');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('4','9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 00:14:16');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('5','6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 02:19:55');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('6','6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 02:20:07');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('7','6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 02:20:20');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('8','6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 02:21:24');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('9','68cc612559b4159f9416f37a5933ffeeb9d09afdbc5e5470a57b4b0ab44bb49b','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 05:51:34');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('10','3be48a5f67554bc077ab2289bc4f0c85da589e9a2f4ca57f8e96a6112fdf15f9','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 05:52:57');
INSERT INTO `login_attempts`(`id`,`email_key`,`ip_key`,`attempted_at`) VALUES ('11','68cc612559b4159f9416f37a5933ffeeb9d09afdbc5e5470a57b4b0ab44bb49b','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-25 05:53:14');
DROP TABLE IF EXISTS `maintenance_pm_histories`;
CREATE TABLE `maintenance_pm_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_id` bigint(20) unsigned NOT NULL,
  `work_order_id` bigint(20) unsigned NOT NULL,
  `performed_on` date NOT NULL,
  `meter_value` decimal(14,3) DEFAULT NULL,
  `result` text DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pm_history_wo` (`schedule_id`,`work_order_id`),
  KEY `fk_pm_hist_wo` (`work_order_id`),
  KEY `fk_pm_hist_actor` (`created_by`),
  CONSTRAINT `fk_pm_hist_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_pm_hist_schedule` FOREIGN KEY (`schedule_id`) REFERENCES `maintenance_pm_schedules` (`id`),
  CONSTRAINT `fk_pm_hist_wo` FOREIGN KEY (`work_order_id`) REFERENCES `maintenance_work_orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `maintenance_pm_schedules`;
CREATE TABLE `maintenance_pm_schedules` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `schedule_code` varchar(80) NOT NULL,
  `schedule_name` varchar(160) NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  `service_type` varchar(160) NOT NULL,
  `basis` varchar(20) NOT NULL,
  `interval_value` decimal(14,3) NOT NULL,
  `initial_value` decimal(14,3) DEFAULT NULL,
  `next_target` decimal(14,3) DEFAULT NULL,
  `next_due_date` date DEFAULT NULL,
  `tolerance_value` decimal(14,3) NOT NULL DEFAULT 0.000,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `notes` text DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_pm_schedule_code` (`schedule_code`),
  KEY `ix_pm_scope` (`branch_id`,`asset_id`,`basis`,`active`),
  KEY `fk_pm_asset` (`asset_id`),
  KEY `fk_pm_creator` (`created_by`),
  CONSTRAINT `fk_pm_asset` FOREIGN KEY (`asset_id`) REFERENCES `md_assets` (`id`),
  CONSTRAINT `fk_pm_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_pm_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_pm_basis` CHECK (`basis` in ('HOUR_METER','KILOMETER','CALENDAR')),
  CONSTRAINT `ck_pm_interval` CHECK (`interval_value` > 0),
  CONSTRAINT `ck_pm_tolerance` CHECK (`tolerance_value` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `maintenance_work_order_activities`;
CREATE TABLE `maintenance_work_order_activities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint(20) unsigned NOT NULL,
  `actor_id` int(10) unsigned NOT NULL,
  `activity_type` varchar(30) NOT NULL,
  `diagnosis` text DEFAULT NULL,
  `action_taken` text DEFAULT NULL,
  `duration_minutes` int(10) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_mwo_activity` (`work_order_id`,`created_at`),
  KEY `fk_mwo_activity_actor` (`actor_id`),
  CONSTRAINT `fk_mwo_activity_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mwo_activity_wo` FOREIGN KEY (`work_order_id`) REFERENCES `maintenance_work_orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `maintenance_work_order_issue_links`;
CREATE TABLE `maintenance_work_order_issue_links` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint(20) unsigned NOT NULL,
  `issue_id` int(10) unsigned NOT NULL,
  `created_by` int(10) unsigned NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mwo_issue` (`work_order_id`,`issue_id`),
  KEY `fk_mwo_issue_issue` (`issue_id`),
  KEY `fk_mwo_issue_actor` (`created_by`),
  CONSTRAINT `fk_mwo_issue_actor` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mwo_issue_issue` FOREIGN KEY (`issue_id`) REFERENCES `inv_issues` (`id`),
  CONSTRAINT `fk_mwo_issue_wo` FOREIGN KEY (`work_order_id`) REFERENCES `maintenance_work_orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `maintenance_work_order_parts`;
CREATE TABLE `maintenance_work_order_parts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `work_order_id` bigint(20) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
  `quantity_required` decimal(14,3) NOT NULL,
  `quantity_issued` decimal(14,3) NOT NULL DEFAULT 0.000,
  `unit_name` varchar(80) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT 'REQUESTED',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_mwo_part` (`work_order_id`,`item_id`,`warehouse_id`),
  KEY `fk_mwo_part_item` (`item_id`),
  KEY `fk_mwo_part_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_mwo_part_item` FOREIGN KEY (`item_id`) REFERENCES `md_items` (`id`),
  CONSTRAINT `fk_mwo_part_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`),
  CONSTRAINT `fk_mwo_part_wo` FOREIGN KEY (`work_order_id`) REFERENCES `maintenance_work_orders` (`id`),
  CONSTRAINT `ck_mwo_part_qty` CHECK (`quantity_required` > 0 and `quantity_issued` >= 0 and `quantity_issued` <= `quantity_required`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `maintenance_work_orders`;
CREATE TABLE `maintenance_work_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `wo_number` varchar(80) NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  `source_p2h_id` bigint(20) unsigned DEFAULT NULL,
  `source_p2h_item_id` bigint(20) unsigned DEFAULT NULL,
  `source_hold_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(10) unsigned NOT NULL,
  `work_type` varchar(20) NOT NULL,
  `priority` varchar(10) NOT NULL DEFAULT 'NORMAL',
  `status` varchar(20) NOT NULL DEFAULT 'DRAFT',
  `location` varchar(255) NOT NULL DEFAULT '',
  `hm_km` decimal(12,3) DEFAULT NULL,
  `problem_description` text NOT NULL,
  `supervisor_id` int(10) unsigned DEFAULT NULL,
  `mechanic_id` int(10) unsigned DEFAULT NULL,
  `assigned_at` datetime DEFAULT NULL,
  `target_date` date DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `closed_at` datetime DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `repair_action` text DEFAULT NULL,
  `mechanic_notes` text DEFAULT NULL,
  `inspection_result` text DEFAULT NULL,
  `supervisor_notes` text DEFAULT NULL,
  `version` int(10) unsigned NOT NULL DEFAULT 1,
  `pm_schedule_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_maintenance_wo_number` (`wo_number`),
  KEY `ix_maintenance_wo_scope` (`branch_id`,`status`,`created_at`),
  KEY `ix_maintenance_wo_asset` (`asset_id`,`status`),
  KEY `fk_mwo_creator` (`created_by`),
  KEY `fk_mwo_supervisor` (`supervisor_id`),
  KEY `fk_mwo_mechanic` (`mechanic_id`),
  KEY `fk_mwo_p2h` (`source_p2h_id`),
  KEY `fk_mwo_hold` (`source_hold_id`),
  KEY `ix_mwo_pm_schedule` (`pm_schedule_id`),
  CONSTRAINT `fk_mwo_asset` FOREIGN KEY (`asset_id`) REFERENCES `md_assets` (`id`),
  CONSTRAINT `fk_mwo_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_mwo_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mwo_hold` FOREIGN KEY (`source_hold_id`) REFERENCES `eq_unit_holds` (`id`),
  CONSTRAINT `fk_mwo_mechanic` FOREIGN KEY (`mechanic_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_mwo_p2h` FOREIGN KEY (`source_p2h_id`) REFERENCES `eq_p2h_inspections` (`id`),
  CONSTRAINT `fk_mwo_pm_schedule` FOREIGN KEY (`pm_schedule_id`) REFERENCES `maintenance_pm_schedules` (`id`),
  CONSTRAINT `fk_mwo_supervisor` FOREIGN KEY (`supervisor_id`) REFERENCES `users` (`id`),
  CONSTRAINT `ck_mwo_type` CHECK (`work_type` in ('CORRECTIVE','PREVENTIVE','INSPECTION','EMERGENCY')),
  CONSTRAINT `ck_mwo_priority` CHECK (`priority` in ('LOW','NORMAL','HIGH','CRITICAL')),
  CONSTRAINT `ck_mwo_status` CHECK (`status` in ('DRAFT','OPEN','ASSIGNED','IN_PROGRESS','COMPLETED','VERIFIED','CLOSED','CANCELLED'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
INSERT INTO `md_assets`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`kind`,`identity`,`category`,`brand`,`model`,`capacity`,`condition_code`) VALUES ('1','DEMO-TRUCK-01','Truk Operasional 01','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','truck','DEMO-TRUCK-01','Trucking','','','','ready');
INSERT INTO `md_assets`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`kind`,`identity`,`category`,`brand`,`model`,`capacity`,`condition_code`) VALUES ('2','DEMO-EQUIP-01','Excavator Operasional 01','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','equipment','DEMO-EQUIP-01','Excavator','','','','ready');
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
INSERT INTO `md_categories`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-CAT','Kategori Umum','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
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
INSERT INTO `md_customers`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`customer_type`,`address`,`phone`,`email`,`contact_name`) VALUES ('1','DEMO-CUST-01','Pelanggan Nusantara','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','company','Alamat simulasi DEMO','','','');
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
INSERT INTO `md_items`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`category_id`,`unit_id`) VALUES ('1','DEMO-ITEM','Material Operasional','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','1');
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
INSERT INTO `md_locations`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`city`,`province`) VALUES ('1','DEMO-LOC-A','Gudang Utama','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','Makassar','Sulawesi Selatan');
INSERT INTO `md_locations`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`city`,`province`) VALUES ('2','DEMO-LOC-B','Lokasi Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','Gowa','Sulawesi Selatan');
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
INSERT INTO `md_parties`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`company`,`address`,`phone`,`party_role`,`identity_hash`) VALUES ('1','DEMO-SENDER-01','Pengirim Nusantara','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','DEMO Logistics','','','sender','043d41af860ba9d8fced77a0986879eb4807c637d2ee07050e9425d2a5bf88dc');
INSERT INTO `md_parties`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`company`,`address`,`phone`,`party_role`,`identity_hash`) VALUES ('2','DEMO-RECEIVER-01','Penerima Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','DEMO Site','','','receiver','ef9455d3fb9922fc644aab1cd5ce2725b8eae604982a2ab371017bd0319b237c');
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
INSERT INTO `md_personnel`(`id`,`code`,`name`,`branch_id`,`kind`,`phone`,`account_id`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-DRIVER-01','Sopir Operasional','1','driver','',NULL,'1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
INSERT INTO `md_personnel`(`id`,`code`,`name`,`branch_id`,`kind`,`phone`,`account_id`,`active`,`version`,`created_at`,`updated_at`) VALUES ('2','DEMO-OPERATOR-01','Operator Alat Berat','1','operator','',NULL,'1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
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
INSERT INTO `md_routes`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`,`branch_id`,`destination_branch_id`,`origin_location_id`,`destination_location_id`) VALUES ('1','DEMO-ROUTE-01','Rute Gudang - Proyek','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08','1','1','1','2');
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
INSERT INTO `md_units`(`id`,`code`,`name`,`active`,`version`,`created_at`,`updated_at`) VALUES ('1','DEMO-UNIT','Unit','1','1','2026-10-24 19:28:39','2026-10-24 19:58:08');
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('1','foundation.view','Lihat akses fondasi sendiri');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('2','users.view','Lihat pengguna');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('3','users.manage','Kelola pengguna');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('4','branches.view','Lihat cabang sesuai cakupan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('5','branches.manage','Kelola cabang sesuai cakupan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('6','roles.view','Lihat matriks role');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('7','audit.view','Lihat audit fondasi');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('9','master.customer.view','Lihat master Customer');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('10','master.customer.create','Tambah master Customer');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('11','master.customer.update','Ubah master Customer');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('17','master.party.view','Lihat master Pengirim & Penerima');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('18','master.party.create','Tambah master Pengirim & Penerima');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('19','master.party.update','Ubah master Pengirim & Penerima');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('24','master.location.view','Lihat master Lokasi');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('25','master.location.create','Tambah master Lokasi');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('26','master.location.update','Ubah master Lokasi');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('31','master.route.view','Lihat master Rute');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('32','master.route.create','Tambah master Rute');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('33','master.route.update','Ubah master Rute');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('38','master.trucking_tariff.view','Lihat master Tarif Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('39','master.trucking_tariff.create','Tambah master Tarif Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('40','master.trucking_tariff.update','Ubah master Tarif Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('43','master.equipment_tariff.view','Lihat master Tarif Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('44','master.equipment_tariff.create','Tambah master Tarif Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('45','master.equipment_tariff.update','Ubah master Tarif Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('48','master.vehicle.view','Lihat master Kendaraan Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('49','master.vehicle.create','Tambah master Kendaraan Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('50','master.vehicle.update','Ubah master Kendaraan Trucking');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('54','master.unit.view','Lihat master Unit Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('55','master.unit.create','Tambah master Unit Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('56','master.unit.update','Ubah master Unit Equipment');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('61','master.driver.view','Lihat master Driver');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('62','master.driver.create','Tambah master Driver');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('63','master.driver.update','Ubah master Driver');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('67','master.operator.view','Lihat master Operator');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('68','master.operator.create','Tambah master Operator');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('69','master.operator.update','Ubah master Operator');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('72','master.item.view','Lihat master Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('73','master.item.create','Tambah master Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('74','master.item.update','Ubah master Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('77','master.category.view','Lihat master Kategori Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('78','master.category.create','Tambah master Kategori Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('79','master.category.update','Ubah master Kategori Barang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('82','master.uom.view','Lihat master Satuan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('83','master.uom.create','Tambah master Satuan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('84','master.uom.update','Ubah master Satuan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('87','master.supplier.view','Lihat master Supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('88','master.supplier.create','Tambah master Supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('89','master.supplier.update','Ubah master Supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('106','master.routes.view','Lihat Lokasi & Rute');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('117','master.assets.view','Lihat Kendaraan & Unit');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('124','master.personnel.view','Lihat Driver & Operator');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('129','master.catalog.view','Lihat Barang & Kategori');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('136','expedition.view','Lihat DN dan tracking internal');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('137','expedition.ship','Buat/ubah DN awal');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('138','expedition.manifest.view','Lihat manifest');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('139','expedition.manifest','Buat manifest draf dan susun DN');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('140','expedition.confirm','Konfirmasi DN dan nomor resmi');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('141','expedition.transit','Catat perjalanan dan posisi aktual');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('142','expedition.receive','Penerimaan utuh aktual');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('143','expedition.claim.view','Lihat klaim operasional');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('144','expedition.claim.report','Laporkan klaim dan bukti');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('145','expedition.claim.review','Periksa/putuskan/tutup klaim operasional');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('146','equipment.assignment.manage','Equipment: assignment.manage');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('147','equipment.contract.activate','Equipment: contract.activate');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('148','equipment.contract.cancel','Equipment: contract.cancel');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('149','equipment.contract.close','Equipment: contract.close');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('150','equipment.contract.confirm','Equipment: contract.confirm');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('151','equipment.contract.create','Equipment: contract.create');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('152','equipment.contract.extend','Equipment: contract.extend');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('153','equipment.contract.terminate','Equipment: contract.terminate');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('154','equipment.contract.update','Equipment: contract.update');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('155','equipment.contract.view','Equipment: contract.view');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('156','equipment.contract.view_own','Equipment: contract.view_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('157','equipment.cross_branch.approve','Equipment: cross_branch.approve');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('158','equipment.cross_branch.request','Equipment: cross_branch.request');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('159','equipment.evidence.add','Equipment: evidence.add');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('160','equipment.evidence.add_own','Equipment: evidence.add_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('161','equipment.evidence.view','Equipment: evidence.view');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('162','equipment.evidence.view_own','Equipment: evidence.view_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('163','equipment.handover.cancel','Equipment: handover.cancel');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('164','equipment.handover.confirm','Equipment: handover.confirm');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('165','equipment.handover.correct','Equipment: handover.correct');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('166','equipment.handover.create','Equipment: handover.create');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('167','equipment.handover.fact_correct','Equipment: handover.fact_correct');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('168','equipment.handover.update','Equipment: handover.update');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('169','equipment.handover.view','Equipment: handover.view');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('170','equipment.handover.view_own','Equipment: handover.view_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('171','equipment.meter.correct','Equipment: meter.correct');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('172','equipment.operator.relink','Equipment: operator.relink');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('173','equipment.recovery.close','Equipment: recovery.close');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('174','equipment.timesheet.create_own','Equipment: timesheet.create_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('175','equipment.timesheet.create_scoped','Equipment: timesheet.create_scoped');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('176','equipment.timesheet.revise_own','Equipment: timesheet.revise_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('177','equipment.timesheet.revise_scoped','Equipment: timesheet.revise_scoped');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('178','equipment.timesheet.revise_terminal','Equipment: timesheet.revise_terminal');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('179','equipment.timesheet.submit_own','Equipment: timesheet.submit_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('180','equipment.timesheet.submit_scoped','Equipment: timesheet.submit_scoped');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('181','equipment.timesheet.update_own','Equipment: timesheet.update_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('182','equipment.timesheet.update_scoped','Equipment: timesheet.update_scoped');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('183','equipment.timesheet.view_own','Equipment: timesheet.view_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('184','equipment.timesheet.view_scoped','Equipment: timesheet.view_scoped');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('185','equipment.unit.view','Equipment: unit.view');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('186','equipment.unit.view_own','Equipment: unit.view_own');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('187','equipment.verification.decide','Equipment: verification.decide');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('188','equipment.verification.view','Equipment: verification.view');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('189','finance.account.view','Lihat rekening kas dan bank');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('190','finance.account.manage','Kelola rekening kas dan bank');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('191','finance.category.view','Lihat kategori pengeluaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('192','finance.category.manage','Kelola kategori pengeluaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('193','finance.invoice.view','Lihat invoice');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('194','finance.invoice.create','Buat draft invoice');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('195','finance.invoice.issue','Terbitkan invoice');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('196','finance.receivable.view','Lihat piutang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('197','finance.payment.create','Catat pembayaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('199','finance.invoice.edit','Edit draft invoice');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('200','finance.payment.view','Lihat pembayaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('201','finance.payment.reverse','Reverse pembayaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('202','finance.expense.view','Lihat pengeluaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('203','finance.expense.create','Catat pengeluaran');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('204','finance.payable.view','Lihat utang supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('205','finance.payable.create','Catat utang supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('206','finance.payable.post','Posting tagihan supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('207','finance.payable.pay','Bayar utang supplier');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('208','inventory.receipt.view','Lihat barang masuk');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('209','inventory.receipt.create','Buat barang masuk');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('210','inventory.receipt.post','Posting barang masuk');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('211','inventory.issue.view','Lihat barang keluar');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('212','inventory.issue.create','Buat barang keluar');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('213','inventory.issue.post','Posting barang keluar');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('214','inventory.warehouse.view','Lihat gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('215','inventory.warehouse.create','Tambah gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('216','inventory.warehouse.update','Ubah gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('217','inventory.transfer.view','Lihat transfer gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('218','inventory.transfer.create','Buat transfer gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('219','inventory.transfer.send','Kirim transfer gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('220','inventory.transfer.receive','Terima transfer gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('221','inventory.transfer.cancel','Batalkan transfer gudang');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('222','inventory.opname.view','Lihat stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('223','inventory.opname.create','Buat stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('224','inventory.opname.update','Ubah stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('225','inventory.opname.submit','Kirim stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('226','inventory.opname.verify','Verifikasi stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('227','inventory.opname.cancel','Batalkan stock opname');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('228','inventory.adjustment.view','Lihat penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('229','inventory.adjustment.create','Buat penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('230','inventory.adjustment.update','Ubah penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('231','inventory.adjustment.submit','Kirim penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('232','inventory.adjustment.approve','Setujui penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('233','inventory.adjustment.reject','Tolak penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('234','inventory.adjustment.post','Posting penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('235','inventory.adjustment.cancel','Batalkan penyesuaian stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('236','inventory.report.view','Lihat laporan persediaan');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('237','inventory.reservation.view','Lihat reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('238','inventory.reservation.create','Buat reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('239','inventory.reservation.reserve','Kunci reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('240','inventory.reservation.release','Lepas reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('241','inventory.reservation.fulfill','Penuhi reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('242','inventory.reservation.cancel','Batalkan reservasi stok');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('243','maintenance.wo.view','Lihat Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('244','maintenance.wo.create','Buat Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('245','maintenance.wo.assign','Tugaskan Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('246','maintenance.wo.update','Perbarui Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('247','maintenance.wo.verify','Verifikasi Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('248','maintenance.wo.close','Tutup Work Order');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('249','maintenance.pm.view','Lihat Jadwal Servis');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('250','maintenance.pm.create','Buat Jadwal Servis');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('251','maintenance.pm.update','Ubah Jadwal Servis');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('252','maintenance.pm.manage','Kelola Jadwal Servis');
INSERT INTO `permissions`(`id`,`code`,`name`) VALUES ('253','maintenance.pm.print','Cetak Jadwal Servis');
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions` (
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_permission` (`permission_id`),
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','2');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','3');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','4');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','5');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','6');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','7');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','10');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','11');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','17');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','18');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','19');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','24');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','25');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','26');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','31');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','32');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','33');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','38');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','39');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','40');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','43');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','44');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','45');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','48');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','49');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','50');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','54');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','55');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','56');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','61');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','62');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','63');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','67');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','68');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','69');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','72');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','73');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','74');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','77');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','78');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','79');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','82');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','83');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','84');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','87');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','88');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','89');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','106');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','124');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','129');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','136');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','137');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','138');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','139');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','140');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','141');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','142');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','143');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','144');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','145');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','146');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','147');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','148');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','149');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','150');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','151');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','152');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','153');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','154');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','155');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','158');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','159');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','161');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','163');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','164');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','166');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','168');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','169');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','175');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','177');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','180');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','182');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','184');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','185');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','187');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','188');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','243');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','244');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','245');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','246');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','247');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','248');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','249');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','250');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','251');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','252');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('1','253');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','4');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','17');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','24');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','31');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','38');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','43');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','48');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','54');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','61');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','67');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','72');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','77');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','82');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','87');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','106');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','124');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','129');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','136');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','138');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','143');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','155');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','161');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','169');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','184');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','185');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','188');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','189');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','191');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','193');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','196');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','200');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','202');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','204');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','208');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','211');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','214');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','217');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','222');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','228');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','236');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','237');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','243');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('2','249');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','17');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','24');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','31');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','38');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','48');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','61');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','106');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','124');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','136');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','137');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','138');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','140');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','143');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('3','144');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','17');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','24');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','31');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','48');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','61');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','106');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','124');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','136');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','138');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','139');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','141');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','143');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('4','144');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','17');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','24');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','31');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','106');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','136');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','138');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','142');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','143');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('5','144');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','43');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','54');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','67');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','124');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','146');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','147');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','148');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','149');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','150');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','151');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','154');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','155');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','158');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','159');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','161');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','163');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','164');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','166');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','168');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','169');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','175');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','177');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','180');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','182');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','184');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('6','185');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','54');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','156');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','160');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','162');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','170');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','174');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','176');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','179');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','181');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','183');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('7','186');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','9');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','87');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','189');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','190');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','191');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','192');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','193');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','194');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','195');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','196');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','197');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','199');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','200');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','202');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','203');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','204');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','205');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','206');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','207');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','208');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','211');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','217');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','222');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','228');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','236');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('8','237');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','1');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','54');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','72');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','77');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','82');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','87');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','117');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('9','129');
INSERT INTO `role_permissions`(`role_id`,`permission_id`) VALUES ('10','1');
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `roles`(`id`,`name`) VALUES ('5','Admin Penerima');
INSERT INTO `roles`(`id`,`name`) VALUES ('3','Admin Pengirim');
INSERT INTO `roles`(`id`,`name`) VALUES ('6','Admin Sewa');
INSERT INTO `roles`(`id`,`name`) VALUES ('4','Admin Transit');
INSERT INTO `roles`(`id`,`name`) VALUES ('1','Administrator');
INSERT INTO `roles`(`id`,`name`) VALUES ('10','Customer');
INSERT INTO `roles`(`id`,`name`) VALUES ('8','Finance');
INSERT INTO `roles`(`id`,`name`) VALUES ('9','Gudang');
INSERT INTO `roles`(`id`,`name`) VALUES ('7','Operator Alat Berat');
INSERT INTO `roles`(`id`,`name`) VALUES ('2','Owner');
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(80) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('001_foundation','2026-10-24 19:28:34');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('002_master_data','2026-10-24 19:28:35');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('003_trucking','2026-10-24 19:28:35');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('004_trucking_operations','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/01/4040f3449073/180bbbaad484504f701d9efcb5111be9','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/02/275ea1272c02/fdc145d771bc47f0640d4b06d1f18687','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/03/125dbe4c4e12/3d99059772d748d66d76361c3038751b','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/04/94e1bd4d49d8/4f5d3966d6f0da03a55d3061ade60ee5','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/05/842ebb13fc54/b41b59657ec902cff2a7bc14fe6ce8be','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/06/f4be9b7aa990/89a4fd2beff9b58a233c945992a9db8a','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/07/9d0c75b6289a/36b83ece5861f437035378a69c05cf57','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/08/80336218edcf/866a2a01d3a1a0a40ce2d0b6d82d208f','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/09/e089445a8c13/dcb1b08164dbe457cd447b9e28c3aea8','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/10/de25a9310f58/580a7068cbe038752efb88a57a20f2e9','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/11/e2fa2ab46f11/2fa46e859e54a457a6daa00ec73e1438','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/12/012bb4c1aaa3/45514d4c81ec32423739e143a39c0aaf','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/13/54bca51563ba/1267b970b07948dda73b7a7ae2be4ba1','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/14/10b6c2a4b4d3/c7927dbd94af09f03517fa8003a43675','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/15/929294e8ff5d/693fe5f9e350d0b0609dfd4f36c7a65c','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/16/e0ac2ccb38de/309ad98dd9d8ecbdd275b20aa4f49448','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/17/ef2cf42d8ad8/526c5a25ea1ffba55828cd64b1cecf6e','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/18/a183e3164241/2a77e0cc72876666bfe30f6016c31010','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/done/19/996828907767/5a14386826125aa9a0d01888ba98edba','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/01/4040f3449073','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/02/275ea1272c02','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/03/125dbe4c4e12','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/04/94e1bd4d49d8','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/05/842ebb13fc54','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/06/f4be9b7aa990','2026-10-24 19:28:36');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/07/9d0c75b6289a','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/08/80336218edcf','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/09/e089445a8c13','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/10/de25a9310f58','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/11/e2fa2ab46f11','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/12/012bb4c1aaa3','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/13/54bca51563ba','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/14/10b6c2a4b4d3','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/15/929294e8ff5d','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/16/e0ac2ccb38de','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/17/ef2cf42d8ad8','2026-10-24 19:28:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/18/a183e3164241','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_eq/start/19/996828907767','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('005_equipment_operations','2026-10-24 19:28:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('006_finance_foundation','2026-10-25 00:47:25');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('007_finance_permissions','2026-10-25 00:55:37');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('008_finance_invoice_permissions','2026-10-25 00:58:26');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('009_finance_receivables_permissions','2026-10-25 01:04:51');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('010_finance_invoice_edit_permission','2026-10-25 01:30:14');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('011_finance_owner_read_permissions','2026-10-25 01:34:21');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('012_finance_payment_view_permission','2026-10-25 01:37:35');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('013_finance_payment_reverse_permission','2026-10-25 02:13:27');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('014_finance_expense_permissions','2026-10-25 02:18:52');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('015_fin_supplier_payments','2026-10-25 02:39:02');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('016_finance_payable_permissions','2026-10-25 02:39:02');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('017_finance_payable_action_permissions','2026-10-25 04:11:27');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('018_fin_supplier_bill_posted','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('019_inventory_stock_ledger','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('020_inventory_receipts','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('021_inventory_issues','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('022_inventory_multi_warehouse','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('023_inventory_warehouse_permissions','2026-10-25 04:11:28');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('024_inventory_transfers','2026-10-25 04:20:30');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('025_inventory_transfer_cancel','2026-10-25 04:22:29');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('026_inventory_stock_opnames','2026-10-25 04:26:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('027_inventory_adjustments','2026-10-25 04:36:38');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('028_inventory_report_permission','2026-10-25 04:46:09');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('029_inventory_reservations','2026-10-25 05:05:07');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('030_equipment_p2h','2026-10-25 06:10:21');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('031_equipment_unit_holds','2026-10-25 06:10:21');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('032_maintenance_work_orders','2026-10-25 06:17:16');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('033_maintenance_work_order_issue_link','2026-10-25 06:20:39');
INSERT INTO `schema_migrations`(`version`,`applied_at`) VALUES ('034_maintenance_preventive','2026-10-25 06:26:53');
DROP TABLE IF EXISTS `user_branches`;
CREATE TABLE `user_branches` (
  `user_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`branch_id`),
  KEY `fk_ub_branch` (`branch_id`),
  CONSTRAINT `fk_ub_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_ub_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('1','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('2','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('3','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('4','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('5','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('6','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('7','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('8','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('9','1');
INSERT INTO `user_branches`(`user_id`,`branch_id`) VALUES ('10','1');
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
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('1','Admin Penerima','demo_admin_penerima@demo.invalid','$2y$10$u7lVBXb7CIol189DkAjH..6vGHj6OHiI2qa2nKCUVQQyPbS4b1ysm','5','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('2','Admin Pengirim','demo_admin_pengirim@demo.invalid','$2y$10$wfvTEibAExhwAFgq/XufV.70c9VEcM97UijSMS6ODFASzYoJsfjmy','3','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('3','Admin Sewa','demo_admin_sewa@demo.invalid','$2y$10$nujSis2vw68NCooQnNIFTOtSFFS6SnizOvxHz5jvztldHwcfm7Bau','6','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('4','Admin Transit','demo_admin_transit@demo.invalid','$2y$10$mg0j162sgMHOaoSocHfIfex11HQIoNs0vkVfzS6MD6xMFnKKxc2Uq','4','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('5','Administrator','demo_administrator@demo.invalid','$2y$10$fEVxYHZ1hS.qf/Awabcjeu9PB2Rq1IrRnVQq1jw2Civh2.kJsStWO','1','1','1','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('6','Customer','demo_customer@demo.invalid','$2y$10$Foh36grb3eMbsU8pMNhub.FY8SPhM3b.MZrmBt/6sUJWhcnC.4tri','10','1','0','1','2026-10-24 19:28:38');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('7','Finance','demo_finance@demo.invalid','$2y$10$e4f1AGB/WA/6e48sFk2VVenoI/CCWUAxlnqo1aCxKivRbUkbo5uXy','8','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('8','Gudang','demo_gudang@demo.invalid','$2y$10$iIkmMsBaiwA7X25nD9YVZ.GTUAr0moPYWk3h8igs9cYnNzcRDrfwe','9','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('9','Operator Alat Berat','demo_operator_alat_berat@demo.invalid','$2y$10$wP0Cq0JzUjA1wX8c3yxIv.GzWmgjTKbVkLEFiv1/LSwAJXJgLSps2','7','1','0','1','2026-10-24 19:28:39');
INSERT INTO `users`(`id`,`name`,`email`,`password_hash`,`role_id`,`active`,`all_branches`,`auth_version`,`created_at`) VALUES ('10','Owner','demo_owner@demo.invalid','$2y$10$XbrgWU7ohletu0hlRWU4MOHlR.e1LBSf1u2PR7eDWDwEOVtEpsv3C','2','1','0','1','2026-10-24 19:28:39');

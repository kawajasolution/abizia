-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: hls_v2
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,1,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:06'),(2,2,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:06'),(3,3,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:06'),(4,4,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:07'),(5,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:07'),(6,6,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:07'),(7,7,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:08'),(8,8,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:08'),(9,9,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:09'),(10,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:09'),(11,NULL,'login_failed','auth',NULL,'[]','2026-10-24 11:32:18'),(12,NULL,'login_failed','auth',NULL,'[]','2026-10-24 11:32:18'),(13,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:22'),(14,1,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:27'),(15,2,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:27'),(16,3,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:28'),(17,4,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:28'),(18,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:28'),(19,6,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:29'),(20,7,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:29'),(21,8,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:29'),(22,9,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:30'),(23,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:32:30'),(24,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:36:30'),(25,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:38'),(26,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:39'),(27,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:40'),(28,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:41'),(29,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:43'),(30,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:40:44'),(31,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:15'),(32,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:17'),(33,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:18'),(34,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:19'),(35,10,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:20'),(36,5,'login_succeeded','auth',NULL,'[]','2026-10-24 11:58:21'),(37,1,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:01'),(38,2,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:02'),(39,3,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:02'),(40,4,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:02'),(41,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:03'),(42,6,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:03'),(43,7,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:03'),(44,8,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:04'),(45,9,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:04'),(46,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:04'),(47,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:14'),(48,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:15'),(49,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:16'),(50,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:17'),(51,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:18'),(52,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:09:20'),(53,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:18:16'),(54,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:25'),(55,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:26'),(56,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:28'),(57,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:29'),(58,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:30'),(59,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:31'),(60,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:22:59'),(61,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:23:01'),(62,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:23:02'),(63,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:23:03'),(64,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:23:04'),(65,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:23:06'),(66,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:15'),(67,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:16'),(68,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:18'),(69,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:19'),(70,10,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:20'),(71,5,'login_succeeded','auth',NULL,'[]','2026-10-24 12:32:21'),(72,10,'session_invalidated','auth',NULL,'[]','2026-10-24 14:16:57'),(73,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:17:33'),(74,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:17:38'),(75,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:17:38'),(76,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:17:49'),(77,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:00'),(78,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:01'),(79,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:02'),(80,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:03'),(81,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:04'),(82,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:05'),(83,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:16'),(84,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:17'),(85,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:18'),(86,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:19'),(87,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:20'),(88,5,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:22'),(89,10,'login_succeeded','auth',NULL,'[]','2026-10-24 14:24:38'),(90,10,'session_invalidated','auth',NULL,'[]','2026-10-24 16:01:49'),(91,NULL,'login_failed','auth',NULL,'[]','2026-10-24 16:14:01'),(92,NULL,'login_failed','auth',NULL,'[]','2026-10-24 16:14:16'),(93,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:14:25'),(94,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:40'),(95,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:42'),(96,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:43'),(97,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:44'),(98,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:45'),(99,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:46'),(100,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:16:57'),(101,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:27'),(102,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:29'),(103,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:30'),(104,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:32'),(105,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:34'),(106,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:36'),(107,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:46'),(108,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:20:52'),(109,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:24:03'),(110,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:24:25'),(111,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:26:25'),(112,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:33'),(113,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:34'),(114,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:35'),(115,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:36'),(116,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:37'),(117,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:27:38'),(118,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:08'),(119,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:14'),(120,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:15'),(121,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:17'),(122,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:18'),(123,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:19'),(124,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:21'),(125,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:29:36'),(126,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:31:38'),(127,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:01'),(128,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:06'),(129,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:07'),(130,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:08'),(131,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:09'),(132,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:11'),(133,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:34:12'),(134,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:36:10'),(135,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:48'),(136,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:49'),(137,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:50'),(138,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:51'),(139,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:52'),(140,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:37:54'),(141,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:04'),(142,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:05'),(143,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:07'),(144,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:08'),(145,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:09'),(146,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:38:10'),(147,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:26'),(148,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:27'),(149,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:29'),(150,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:30'),(151,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:31'),(152,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:32'),(153,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:45'),(154,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:46'),(155,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:47'),(156,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:48'),(157,10,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:49'),(158,5,'login_succeeded','auth',NULL,'[]','2026-10-24 16:39:50'),(159,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:14:11'),(160,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:14:16'),(161,7,'finance_account_created','fin_accounts',1,'{\"code\":\"KAS-UAT\"}','2026-10-24 17:14:17'),(162,7,'finance_invoice_created','fin_invoices',1,'{\"lines\":1,\"total\":10000000}','2026-10-24 17:14:17'),(163,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:14:29'),(164,7,'finance_invoice_issued','fin_invoices',1,'{\"number\":\"INV\\/DMO\\/2026\\/000001\"}','2026-10-24 17:14:30'),(165,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:14:34'),(166,7,'finance_payment_posted','fin_payments',1,'{\"invoice_id\":1,\"amount\":4000000}','2026-10-24 17:14:34'),(167,7,'finance_payment_posted','fin_payments',2,'{\"invoice_id\":1,\"amount\":6000000}','2026-10-24 17:14:34'),(168,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:14:49'),(169,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:26:11'),(170,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:28:10'),(171,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:32:29'),(172,7,'finance_invoice_created','fin_invoices',2,'{\"lines\":1,\"total\":100}','2026-10-24 17:32:29'),(173,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:34:25'),(174,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:37:45'),(175,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:37:54'),(176,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:47:40'),(177,7,'finance_invoice_created','fin_invoices',3,'{\"lines\":1,\"total\":100}','2026-10-24 17:47:40'),(178,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:47:48'),(179,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:47:52'),(180,7,'finance_invoice_updated','fin_invoices',2,'{\"total\":300,\"lines\":1}','2026-10-24 17:47:52'),(181,7,'login_succeeded','auth',NULL,'[]','2026-10-24 17:47:56'),(182,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:48:00'),(183,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:55:56'),(184,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:55:57'),(185,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:58:41'),(186,10,'login_succeeded','auth',NULL,'[]','2026-10-24 17:58:51'),(187,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:16'),(188,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:22'),(189,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:28'),(190,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:33'),(191,7,'finance_invoice_updated','fin_invoices',2,'{\"total\":300,\"lines\":1,\"invoice_date\":\"2026-10-01\",\"due_date\":\"2026-10-31\"}','2026-10-24 18:02:33'),(192,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:49'),(193,10,'login_succeeded','auth',NULL,'[]','2026-10-24 18:02:49'),(194,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:05:08'),(195,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:07:05'),(196,7,'finance_invoice_created','fin_invoices',4,'{\"lines\":1,\"total\":6000000}','2026-10-24 18:07:05'),(197,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:07:14'),(198,7,'finance_invoice_created','fin_invoices',5,'{\"lines\":1,\"total\":6000000}','2026-10-24 18:07:14'),(199,7,'finance_invoice_created','fin_invoices',6,'{\"lines\":1,\"total\":4000000}','2026-10-24 18:07:14'),(200,7,'finance_invoice_issued','fin_invoices',5,'{\"number\":\"INV\\/DMO\\/2026\\/000005\"}','2026-10-24 18:07:14'),(201,7,'finance_invoice_issued','fin_invoices',6,'{\"number\":\"INV\\/DMO\\/2026\\/000006\"}','2026-10-24 18:07:14'),(202,7,'finance_payment_posted','fin_payments',3,'{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-MULTI-UJI-200714\"}','2026-10-24 18:07:14'),(203,10,'login_succeeded','auth',NULL,'[]','2026-10-24 18:07:22'),(204,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:13:34'),(205,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:15:28'),(206,7,'finance_invoice_created','fin_invoices',7,'{\"lines\":1,\"total\":6000000}','2026-10-24 18:15:28'),(207,7,'finance_invoice_created','fin_invoices',8,'{\"lines\":1,\"total\":4000000}','2026-10-24 18:15:28'),(208,7,'finance_invoice_issued','fin_invoices',7,'{\"number\":\"INV\\/DMO\\/2026\\/000007\"}','2026-10-24 18:15:28'),(209,7,'finance_invoice_issued','fin_invoices',8,'{\"number\":\"INV\\/DMO\\/2026\\/000008\"}','2026-10-24 18:15:29'),(210,7,'finance_payment_posted','fin_payments',4,'{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-REV-UJI-201529\"}','2026-10-24 18:15:29'),(211,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:15:32'),(212,7,'finance_invoice_created','fin_invoices',9,'{\"lines\":1,\"total\":6000000}','2026-10-24 18:15:32'),(213,7,'finance_invoice_created','fin_invoices',10,'{\"lines\":1,\"total\":4000000}','2026-10-24 18:15:32'),(214,7,'finance_invoice_issued','fin_invoices',9,'{\"number\":\"INV\\/DMO\\/2026\\/000009\"}','2026-10-24 18:15:32'),(215,7,'finance_invoice_issued','fin_invoices',10,'{\"number\":\"INV\\/DMO\\/2026\\/000010\"}','2026-10-24 18:15:32'),(216,7,'finance_payment_posted','fin_payments',5,'{\"allocations\":2,\"amount\":7000000,\"payment_ref\":\"PAY-REV-UJI-201533\"}','2026-10-24 18:15:33'),(217,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:15:55'),(218,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:16:08'),(219,7,'finance_payment_reversed','fin_payments',5,'{\"reason\":\"Koreksi uji reversal\",\"amount\":\"7000000.00\"}','2026-10-24 18:16:08'),(220,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:17:35'),(221,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:19:01'),(222,10,'logout','auth',NULL,'[]','2026-10-24 18:19:39'),(223,NULL,'login_failed','auth',NULL,'[]','2026-10-24 18:19:55'),(224,NULL,'login_failed','auth',NULL,'[]','2026-10-24 18:20:07'),(225,NULL,'login_failed','auth',NULL,'[]','2026-10-24 18:20:20'),(226,NULL,'login_failed','auth',NULL,'[]','2026-10-24 18:21:24'),(227,10,'login_succeeded','auth',NULL,'[]','2026-10-24 18:22:15'),(228,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:25:01'),(229,10,'login_succeeded','auth',NULL,'[]','2026-10-24 18:26:23'),(230,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:26:28'),(231,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:27:39'),(232,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:29:15'),(233,7,'finance_category_created','fin_expense_categories',1,'{\"code\":\"OPS\"}','2026-10-24 18:29:15'),(234,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:29:20'),(235,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:29:30'),(236,7,'finance_expense_posted','fin_expenses',2,'{\"amount\":100000,\"reference\":\"EXP-UJI-100K\"}','2026-10-24 18:29:31'),(237,7,'login_succeeded','auth',NULL,'[]','2026-10-24 18:30:20'),(238,10,'login_succeeded','auth',NULL,'[]','2026-10-24 18:39:17'),(239,10,'session_invalidated','auth',NULL,'[]','2026-10-24 19:03:58'),(240,10,'login_succeeded','auth',NULL,'[]','2026-10-24 19:04:09'),(241,10,'session_invalidated','auth',NULL,'[]','2026-10-24 20:16:00'),(242,10,'login_succeeded','auth',NULL,'[]','2026-10-24 20:16:18');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'DMO','Kantor Pusat','Alamat kantor pusat',1,'','','',1,NULL,'2026-10-24 11:58:08');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_branch_authorizations`
--

DROP TABLE IF EXISTS `eq_branch_authorizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_branch_authorizations`
--

LOCK TABLES `eq_branch_authorizations` WRITE;
/*!40000 ALTER TABLE `eq_branch_authorizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_branch_authorizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_contract_units`
--

DROP TABLE IF EXISTS `eq_contract_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_contract_units`
--

LOCK TABLES `eq_contract_units` WRITE;
/*!40000 ALTER TABLE `eq_contract_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_contract_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_contracts`
--

DROP TABLE IF EXISTS `eq_contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_contracts`
--

LOCK TABLES `eq_contracts` WRITE;
/*!40000 ALTER TABLE `eq_contracts` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_document_sequences`
--

DROP TABLE IF EXISTS `eq_document_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_document_sequences`
--

LOCK TABLES `eq_document_sequences` WRITE;
/*!40000 ALTER TABLE `eq_document_sequences` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_document_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_events`
--

DROP TABLE IF EXISTS `eq_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_events`
--

LOCK TABLES `eq_events` WRITE;
/*!40000 ALTER TABLE `eq_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_evidence`
--

DROP TABLE IF EXISTS `eq_evidence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_evidence`
--

LOCK TABLES `eq_evidence` WRITE;
/*!40000 ALTER TABLE `eq_evidence` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_evidence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_handover_documents`
--

DROP TABLE IF EXISTS `eq_handover_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_handover_documents`
--

LOCK TABLES `eq_handover_documents` WRITE;
/*!40000 ALTER TABLE `eq_handover_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_handover_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_handover_units`
--

DROP TABLE IF EXISTS `eq_handover_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_handover_units`
--

LOCK TABLES `eq_handover_units` WRITE;
/*!40000 ALTER TABLE `eq_handover_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_handover_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_meter_corrections`
--

DROP TABLE IF EXISTS `eq_meter_corrections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_meter_corrections`
--

LOCK TABLES `eq_meter_corrections` WRITE;
/*!40000 ALTER TABLE `eq_meter_corrections` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_meter_corrections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_operator_assignments`
--

DROP TABLE IF EXISTS `eq_operator_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_operator_assignments`
--

LOCK TABLES `eq_operator_assignments` WRITE;
/*!40000 ALTER TABLE `eq_operator_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_operator_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_requests`
--

DROP TABLE IF EXISTS `eq_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_requests`
--

LOCK TABLES `eq_requests` WRITE;
/*!40000 ALTER TABLE `eq_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_timesheet_revisions`
--

DROP TABLE IF EXISTS `eq_timesheet_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_timesheet_revisions`
--

LOCK TABLES `eq_timesheet_revisions` WRITE;
/*!40000 ALTER TABLE `eq_timesheet_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_timesheet_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_timesheet_verifications`
--

DROP TABLE IF EXISTS `eq_timesheet_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_timesheet_verifications`
--

LOCK TABLES `eq_timesheet_verifications` WRITE;
/*!40000 ALTER TABLE `eq_timesheet_verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_timesheet_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_timesheet_work_entries`
--

DROP TABLE IF EXISTS `eq_timesheet_work_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_timesheet_work_entries`
--

LOCK TABLES `eq_timesheet_work_entries` WRITE;
/*!40000 ALTER TABLE `eq_timesheet_work_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_timesheet_work_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_timesheets`
--

DROP TABLE IF EXISTS `eq_timesheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_timesheets`
--

LOCK TABLES `eq_timesheets` WRITE;
/*!40000 ALTER TABLE `eq_timesheets` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_timesheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eq_unit_periods`
--

DROP TABLE IF EXISTS `eq_unit_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eq_unit_periods`
--

LOCK TABLES `eq_unit_periods` WRITE;
/*!40000 ALTER TABLE `eq_unit_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `eq_unit_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_claim_events`
--

DROP TABLE IF EXISTS `exp_claim_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_claim_events`
--

LOCK TABLES `exp_claim_events` WRITE;
/*!40000 ALTER TABLE `exp_claim_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_claim_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_claims`
--

DROP TABLE IF EXISTS `exp_claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_claims`
--

LOCK TABLES `exp_claims` WRITE;
/*!40000 ALTER TABLE `exp_claims` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_dns`
--

DROP TABLE IF EXISTS `exp_dns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_dns`
--

LOCK TABLES `exp_dns` WRITE;
/*!40000 ALTER TABLE `exp_dns` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_dns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_events`
--

DROP TABLE IF EXISTS `exp_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_events`
--

LOCK TABLES `exp_events` WRITE;
/*!40000 ALTER TABLE `exp_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_evidence`
--

DROP TABLE IF EXISTS `exp_evidence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_evidence`
--

LOCK TABLES `exp_evidence` WRITE;
/*!40000 ALTER TABLE `exp_evidence` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_evidence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_manifest_items`
--

DROP TABLE IF EXISTS `exp_manifest_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_manifest_items`
--

LOCK TABLES `exp_manifest_items` WRITE;
/*!40000 ALTER TABLE `exp_manifest_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_manifest_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_manifests`
--

DROP TABLE IF EXISTS `exp_manifests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_manifests`
--

LOCK TABLES `exp_manifests` WRITE;
/*!40000 ALTER TABLE `exp_manifests` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_manifests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_receipts`
--

DROP TABLE IF EXISTS `exp_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_receipts`
--

LOCK TABLES `exp_receipts` WRITE;
/*!40000 ALTER TABLE `exp_receipts` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_requests`
--

DROP TABLE IF EXISTS `exp_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_requests`
--

LOCK TABLES `exp_requests` WRITE;
/*!40000 ALTER TABLE `exp_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_sequences`
--

DROP TABLE IF EXISTS `exp_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_sequences`
--

LOCK TABLES `exp_sequences` WRITE;
/*!40000 ALTER TABLE `exp_sequences` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exp_trip_legs`
--

DROP TABLE IF EXISTS `exp_trip_legs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exp_trip_legs`
--

LOCK TABLES `exp_trip_legs` WRITE;
/*!40000 ALTER TABLE `exp_trip_legs` DISABLE KEYS */;
/*!40000 ALTER TABLE `exp_trip_legs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_accounts`
--

DROP TABLE IF EXISTS `fin_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_accounts`
--

LOCK TABLES `fin_accounts` WRITE;
/*!40000 ALTER TABLE `fin_accounts` DISABLE KEYS */;
INSERT INTO `fin_accounts` VALUES (1,1,'KAS-UAT','Kas UAT','CASH','IDR',1,1,7,'2026-10-25 01:14:17','2026-10-25 01:14:17');
/*!40000 ALTER TABLE `fin_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_cash_ledger`
--

DROP TABLE IF EXISTS `fin_cash_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_cash_ledger`
--

LOCK TABLES `fin_cash_ledger` WRITE;
/*!40000 ALTER TABLE `fin_cash_ledger` DISABLE KEYS */;
INSERT INTO `fin_cash_ledger` VALUES (1,1,1,'RECEIPT','PAYMENT',1,'2026-10-25',4000000.00,0.00,'Penerimaan invoice',7,'2026-10-25 01:14:34'),(2,1,1,'RECEIPT','PAYMENT',2,'2026-10-25',6000000.00,0.00,'Penerimaan invoice',7,'2026-10-25 01:14:34'),(3,1,1,'RECEIPT','PAYMENT',3,'2026-10-25',7000000.00,0.00,'Penerimaan pembayaran',7,'2026-10-25 02:07:14'),(4,1,1,'RECEIPT','PAYMENT',4,'2026-10-25',7000000.00,0.00,'Penerimaan pembayaran',7,'2026-10-25 02:15:29'),(5,1,1,'RECEIPT','PAYMENT',5,'2026-10-25',7000000.00,0.00,'Penerimaan pembayaran',7,'2026-10-25 02:15:33'),(6,1,1,'REVERSAL','PAYMENT',5,'2026-10-25',0.00,7000000.00,'Reversal: Koreksi uji reversal',7,'2026-10-25 02:16:08'),(7,1,1,'EXPENSE','EXPENSE',2,'2026-10-25',0.00,100000.00,'EXP-UJI-100K',7,'2026-10-25 02:29:31');
/*!40000 ALTER TABLE `fin_cash_ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_events`
--

DROP TABLE IF EXISTS `fin_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_events`
--

LOCK TABLES `fin_events` WRITE;
/*!40000 ALTER TABLE `fin_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_expense_categories`
--

DROP TABLE IF EXISTS `fin_expense_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_expense_categories`
--

LOCK TABLES `fin_expense_categories` WRITE;
/*!40000 ALTER TABLE `fin_expense_categories` DISABLE KEYS */;
INSERT INTO `fin_expense_categories` VALUES (1,'OPS','Operasional Uji',1,1,'2026-10-25 02:29:15','2026-10-25 02:29:15');
/*!40000 ALTER TABLE `fin_expense_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_expenses`
--

DROP TABLE IF EXISTS `fin_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_expenses`
--

LOCK TABLES `fin_expenses` WRITE;
/*!40000 ALTER TABLE `fin_expenses` DISABLE KEYS */;
INSERT INTO `fin_expenses` VALUES (2,1,1,1,'2026-10-25',100000.00,'POSTED','Pengujian',1,7,'2026-10-25 02:29:31','2026-10-25 02:29:31');
/*!40000 ALTER TABLE `fin_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_invoice_lines`
--

DROP TABLE IF EXISTS `fin_invoice_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_invoice_lines`
--

LOCK TABLES `fin_invoice_lines` WRITE;
/*!40000 ALTER TABLE `fin_invoice_lines` DISABLE KEYS */;
INSERT INTO `fin_invoice_lines` VALUES (1,1,'Item A',1.000,10000000.00,10000000.00,NULL,NULL,'2026-10-25 01:14:17'),(3,3,'Item A',1.000,100.00,100.00,NULL,NULL,'2026-10-25 01:47:40'),(5,2,'Tanggal diuji',2.000,150.00,300.00,NULL,NULL,'2026-10-25 02:02:33'),(6,4,'Invoice Uji A',1.000,6000000.00,6000000.00,NULL,NULL,'2026-10-25 02:07:05'),(7,5,'Invoice Multi Uji',1.000,6000000.00,6000000.00,NULL,NULL,'2026-10-25 02:07:14'),(8,6,'Invoice Multi Uji',1.000,4000000.00,4000000.00,NULL,NULL,'2026-10-25 02:07:14'),(9,7,'Invoice Reversal Uji',1.000,6000000.00,6000000.00,NULL,NULL,'2026-10-25 02:15:28'),(10,8,'Invoice Reversal Uji',1.000,4000000.00,4000000.00,NULL,NULL,'2026-10-25 02:15:28'),(11,9,'Invoice Reversal Uji',1.000,6000000.00,6000000.00,NULL,NULL,'2026-10-25 02:15:32'),(12,10,'Invoice Reversal Uji',1.000,4000000.00,4000000.00,NULL,NULL,'2026-10-25 02:15:32');
/*!40000 ALTER TABLE `fin_invoice_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_invoices`
--

DROP TABLE IF EXISTS `fin_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_invoices`
--

LOCK TABLES `fin_invoices` WRITE;
/*!40000 ALTER TABLE `fin_invoices` DISABLE KEYS */;
INSERT INTO `fin_invoices` VALUES (1,1,1,'INV-DRAFT-681950e387475b46','INV/DMO/2026/000001','PAID','2026-10-25','2026-11-24',10000000.00,0.00,0.00,10000000.00,4,7,'2026-10-25 01:14:17','2026-10-25 01:14:34'),(2,1,1,'INV-DRAFT-6885c26753741e48',NULL,'DRAFT','2026-10-01','2026-10-31',300.00,0.00,0.00,300.00,3,7,'2026-10-25 01:32:29','2026-10-25 02:02:33'),(3,1,1,'INV-DRAFT-193b9767dff1328f',NULL,'DRAFT','2026-10-25','2026-11-25',100.00,0.00,0.00,100.00,1,7,'2026-10-25 01:47:40','2026-10-25 01:47:40'),(4,1,1,'INV-DRAFT-8d22c9f36a2bbc2a',NULL,'DRAFT','2026-10-25','2026-11-25',6000000.00,0.00,0.00,6000000.00,1,7,'2026-10-25 02:07:05','2026-10-25 02:07:05'),(5,1,1,'INV-DRAFT-a33042f997ffbaaf','INV/DMO/2026/000005','PAID','2026-10-25','2026-11-25',6000000.00,0.00,0.00,6000000.00,3,7,'2026-10-25 02:07:14','2026-10-25 02:07:14'),(6,1,1,'INV-DRAFT-50b8c904fb23fa74','INV/DMO/2026/000006','PARTIALLY_PAID','2026-10-25','2026-11-25',4000000.00,0.00,0.00,4000000.00,3,7,'2026-10-25 02:07:14','2026-10-25 02:07:14'),(7,1,1,'INV-DRAFT-768cd77fc8e11709','INV/DMO/2026/000007','PAID','2026-10-25','2026-11-25',6000000.00,0.00,0.00,6000000.00,3,7,'2026-10-25 02:15:28','2026-10-25 02:15:29'),(8,1,1,'INV-DRAFT-589fdb409cbea8a7','INV/DMO/2026/000008','PARTIALLY_PAID','2026-10-25','2026-11-25',4000000.00,0.00,0.00,4000000.00,3,7,'2026-10-25 02:15:28','2026-10-25 02:15:29'),(9,1,1,'INV-DRAFT-ad0a773bfe95ec68','INV/DMO/2026/000009','ISSUED','2026-10-25','2026-11-25',6000000.00,0.00,0.00,6000000.00,4,7,'2026-10-25 02:15:32','2026-10-25 02:16:08'),(10,1,1,'INV-DRAFT-127b53d6b016d332','INV/DMO/2026/000010','ISSUED','2026-10-25','2026-11-25',4000000.00,0.00,0.00,4000000.00,4,7,'2026-10-25 02:15:32','2026-10-25 02:16:08');
/*!40000 ALTER TABLE `fin_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_payment_allocations`
--

DROP TABLE IF EXISTS `fin_payment_allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_payment_allocations`
--

LOCK TABLES `fin_payment_allocations` WRITE;
/*!40000 ALTER TABLE `fin_payment_allocations` DISABLE KEYS */;
INSERT INTO `fin_payment_allocations` VALUES (1,1,1,4000000.00,'2026-10-25 01:14:34'),(2,2,1,6000000.00,'2026-10-25 01:14:34'),(3,3,5,6000000.00,'2026-10-25 02:07:14'),(4,3,6,1000000.00,'2026-10-25 02:07:14'),(5,4,7,6000000.00,'2026-10-25 02:15:29'),(6,4,8,1000000.00,'2026-10-25 02:15:29'),(7,5,9,6000000.00,'2026-10-25 02:15:33'),(8,5,10,1000000.00,'2026-10-25 02:15:33');
/*!40000 ALTER TABLE `fin_payment_allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_payments`
--

DROP TABLE IF EXISTS `fin_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_payments`
--

LOCK TABLES `fin_payments` WRITE;
/*!40000 ALTER TABLE `fin_payments` DISABLE KEYS */;
INSERT INTO `fin_payments` VALUES (1,1,'PAY-d188918630bfbe52','2026-10-25',1,4000000.00,'POSTED',NULL,1,7,'2026-10-25 01:14:34','2026-10-25 01:14:34'),(2,1,'PAY-c131b7d12f8e3ff7','2026-10-25',1,6000000.00,'POSTED',NULL,1,7,'2026-10-25 01:14:34','2026-10-25 01:14:34'),(3,1,'PAY-MULTI-UJI-200714','2026-10-25',1,7000000.00,'POSTED',NULL,1,7,'2026-10-25 02:07:14','2026-10-25 02:07:14'),(4,1,'PAY-REV-UJI-201529','2026-10-25',1,7000000.00,'POSTED',NULL,1,7,'2026-10-25 02:15:29','2026-10-25 02:15:29'),(5,1,'PAY-REV-UJI-201533','2026-10-25',1,7000000.00,'REVERSED',NULL,2,7,'2026-10-25 02:15:33','2026-10-25 02:16:08');
/*!40000 ALTER TABLE `fin_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_supplier_bill_lines`
--

DROP TABLE IF EXISTS `fin_supplier_bill_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_supplier_bill_lines`
--

LOCK TABLES `fin_supplier_bill_lines` WRITE;
/*!40000 ALTER TABLE `fin_supplier_bill_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_supplier_bill_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_supplier_bills`
--

DROP TABLE IF EXISTS `fin_supplier_bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_supplier_bills`
--

LOCK TABLES `fin_supplier_bills` WRITE;
/*!40000 ALTER TABLE `fin_supplier_bills` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_supplier_bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fin_supplier_payments`
--

DROP TABLE IF EXISTS `fin_supplier_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fin_supplier_payments`
--

LOCK TABLES `fin_supplier_payments` WRITE;
/*!40000 ALTER TABLE `fin_supplier_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `fin_supplier_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_issue_lines`
--

DROP TABLE IF EXISTS `inv_issue_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_issue_lines`
--

LOCK TABLES `inv_issue_lines` WRITE;
/*!40000 ALTER TABLE `inv_issue_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_issue_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_issues`
--

DROP TABLE IF EXISTS `inv_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inv_issues` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `issue_ref` varchar(80) NOT NULL,
  `issue_date` date NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  `warehouse_id` int(10) unsigned DEFAULT NULL,
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
  CONSTRAINT `fk_inv_issue_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_inv_issue_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `inv_warehouses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_issues`
--

LOCK TABLES `inv_issues` WRITE;
/*!40000 ALTER TABLE `inv_issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_receipt_lines`
--

DROP TABLE IF EXISTS `inv_receipt_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_receipt_lines`
--

LOCK TABLES `inv_receipt_lines` WRITE;
/*!40000 ALTER TABLE `inv_receipt_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_receipt_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_receipts`
--

DROP TABLE IF EXISTS `inv_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_receipts`
--

LOCK TABLES `inv_receipts` WRITE;
/*!40000 ALTER TABLE `inv_receipts` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_stock_ledger`
--

DROP TABLE IF EXISTS `inv_stock_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_stock_ledger`
--

LOCK TABLES `inv_stock_ledger` WRITE;
/*!40000 ALTER TABLE `inv_stock_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_stock_ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_transfer_lines`
--

DROP TABLE IF EXISTS `inv_transfer_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_transfer_lines`
--

LOCK TABLES `inv_transfer_lines` WRITE;
/*!40000 ALTER TABLE `inv_transfer_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_transfer_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_transfers`
--

DROP TABLE IF EXISTS `inv_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_transfers`
--

LOCK TABLES `inv_transfers` WRITE;
/*!40000 ALTER TABLE `inv_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inv_warehouses`
--

DROP TABLE IF EXISTS `inv_warehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inv_warehouses`
--

LOCK TABLES `inv_warehouses` WRITE;
/*!40000 ALTER TABLE `inv_warehouses` DISABLE KEYS */;
/*!40000 ALTER TABLE `inv_warehouses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_attempts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_key` char(64) NOT NULL,
  `ip_key` char(64) NOT NULL,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `ix_attempt_email` (`email_key`,`attempted_at`),
  KEY `ix_attempt_ip` (`ip_key`,`attempted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES (1,'9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 11:32:18'),(2,'9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3','2026-10-24 11:32:18'),(3,'9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 16:14:01'),(4,'9b57674da443383a020543845aad048ccd918cfc2d2a9e77d7db910dbb9aceaa','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 16:14:16'),(5,'6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 18:19:55'),(6,'6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 18:20:07'),(7,'6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 18:20:20'),(8,'6820279e4bb9ed02b8e99c5589e9d71f7faf6f1a31aeb0151d8ca915ca3007f0','12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0','2026-10-24 18:21:24');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_assets`
--

DROP TABLE IF EXISTS `md_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_assets`
--

LOCK TABLES `md_assets` WRITE;
/*!40000 ALTER TABLE `md_assets` DISABLE KEYS */;
INSERT INTO `md_assets` VALUES (1,'DEMO-TRUCK-01','Truk Operasional 01',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'truck','DEMO-TRUCK-01','Trucking','','','','ready'),(2,'DEMO-EQUIP-01','Excavator Operasional 01',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'equipment','DEMO-EQUIP-01','Excavator','','','','ready');
/*!40000 ALTER TABLE `md_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_categories`
--

DROP TABLE IF EXISTS `md_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_categories`
--

LOCK TABLES `md_categories` WRITE;
/*!40000 ALTER TABLE `md_categories` DISABLE KEYS */;
INSERT INTO `md_categories` VALUES (1,'DEMO-CAT','Kategori Umum',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08');
/*!40000 ALTER TABLE `md_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_customers`
--

DROP TABLE IF EXISTS `md_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_customers`
--

LOCK TABLES `md_customers` WRITE;
/*!40000 ALTER TABLE `md_customers` DISABLE KEYS */;
INSERT INTO `md_customers` VALUES (1,'DEMO-CUST-01','Pelanggan Nusantara',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'company','Alamat simulasi DEMO','','','');
/*!40000 ALTER TABLE `md_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_equipment_tariffs`
--

DROP TABLE IF EXISTS `md_equipment_tariffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_equipment_tariffs`
--

LOCK TABLES `md_equipment_tariffs` WRITE;
/*!40000 ALTER TABLE `md_equipment_tariffs` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_equipment_tariffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_items`
--

DROP TABLE IF EXISTS `md_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_items`
--

LOCK TABLES `md_items` WRITE;
/*!40000 ALTER TABLE `md_items` DISABLE KEYS */;
INSERT INTO `md_items` VALUES (1,'DEMO-ITEM','Material Operasional',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,1);
/*!40000 ALTER TABLE `md_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_locations`
--

DROP TABLE IF EXISTS `md_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_locations`
--

LOCK TABLES `md_locations` WRITE;
/*!40000 ALTER TABLE `md_locations` DISABLE KEYS */;
INSERT INTO `md_locations` VALUES (1,'DEMO-LOC-A','Gudang Utama',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'Makassar','Sulawesi Selatan'),(2,'DEMO-LOC-B','Lokasi Proyek',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'Gowa','Sulawesi Selatan');
/*!40000 ALTER TABLE `md_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_parties`
--

DROP TABLE IF EXISTS `md_parties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_parties`
--

LOCK TABLES `md_parties` WRITE;
/*!40000 ALTER TABLE `md_parties` DISABLE KEYS */;
INSERT INTO `md_parties` VALUES (1,'DEMO-SENDER-01','Pengirim Nusantara',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'DEMO Logistics','','','sender','043d41af860ba9d8fced77a0986879eb4807c637d2ee07050e9425d2a5bf88dc'),(2,'DEMO-RECEIVER-01','Penerima Proyek',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,'DEMO Site','','','receiver','ef9455d3fb9922fc644aab1cd5ce2725b8eae604982a2ab371017bd0319b237c');
/*!40000 ALTER TABLE `md_parties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_personnel`
--

DROP TABLE IF EXISTS `md_personnel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_personnel`
--

LOCK TABLES `md_personnel` WRITE;
/*!40000 ALTER TABLE `md_personnel` DISABLE KEYS */;
INSERT INTO `md_personnel` VALUES (1,'DEMO-DRIVER-01','Sopir Operasional',1,'driver','',NULL,1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08'),(2,'DEMO-OPERATOR-01','Operator Alat Berat',1,'operator','',NULL,1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08');
/*!40000 ALTER TABLE `md_personnel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_routes`
--

DROP TABLE IF EXISTS `md_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_routes`
--

LOCK TABLES `md_routes` WRITE;
/*!40000 ALTER TABLE `md_routes` DISABLE KEYS */;
INSERT INTO `md_routes` VALUES (1,'DEMO-ROUTE-01','Rute Gudang - Proyek',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08',1,1,1,2);
/*!40000 ALTER TABLE `md_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_suppliers`
--

DROP TABLE IF EXISTS `md_suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_suppliers`
--

LOCK TABLES `md_suppliers` WRITE;
/*!40000 ALTER TABLE `md_suppliers` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_trucking_tariffs`
--

DROP TABLE IF EXISTS `md_trucking_tariffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_trucking_tariffs`
--

LOCK TABLES `md_trucking_tariffs` WRITE;
/*!40000 ALTER TABLE `md_trucking_tariffs` DISABLE KEYS */;
/*!40000 ALTER TABLE `md_trucking_tariffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `md_units`
--

DROP TABLE IF EXISTS `md_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `md_units`
--

LOCK TABLES `md_units` WRITE;
/*!40000 ALTER TABLE `md_units` DISABLE KEYS */;
INSERT INTO `md_units` VALUES (1,'DEMO-UNIT','Unit',1,1,'2026-10-24 11:28:39','2026-10-24 11:58:08');
/*!40000 ALTER TABLE `md_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'foundation.view','Lihat akses fondasi sendiri'),(2,'users.view','Lihat pengguna'),(3,'users.manage','Kelola pengguna'),(4,'branches.view','Lihat cabang sesuai cakupan'),(5,'branches.manage','Kelola cabang sesuai cakupan'),(6,'roles.view','Lihat matriks role'),(7,'audit.view','Lihat audit fondasi'),(9,'master.customer.view','Lihat master Customer'),(10,'master.customer.create','Tambah master Customer'),(11,'master.customer.update','Ubah master Customer'),(17,'master.party.view','Lihat master Pengirim & Penerima'),(18,'master.party.create','Tambah master Pengirim & Penerima'),(19,'master.party.update','Ubah master Pengirim & Penerima'),(24,'master.location.view','Lihat master Lokasi'),(25,'master.location.create','Tambah master Lokasi'),(26,'master.location.update','Ubah master Lokasi'),(31,'master.route.view','Lihat master Rute'),(32,'master.route.create','Tambah master Rute'),(33,'master.route.update','Ubah master Rute'),(38,'master.trucking_tariff.view','Lihat master Tarif Trucking'),(39,'master.trucking_tariff.create','Tambah master Tarif Trucking'),(40,'master.trucking_tariff.update','Ubah master Tarif Trucking'),(43,'master.equipment_tariff.view','Lihat master Tarif Equipment'),(44,'master.equipment_tariff.create','Tambah master Tarif Equipment'),(45,'master.equipment_tariff.update','Ubah master Tarif Equipment'),(48,'master.vehicle.view','Lihat master Kendaraan Trucking'),(49,'master.vehicle.create','Tambah master Kendaraan Trucking'),(50,'master.vehicle.update','Ubah master Kendaraan Trucking'),(54,'master.unit.view','Lihat master Unit Equipment'),(55,'master.unit.create','Tambah master Unit Equipment'),(56,'master.unit.update','Ubah master Unit Equipment'),(61,'master.driver.view','Lihat master Driver'),(62,'master.driver.create','Tambah master Driver'),(63,'master.driver.update','Ubah master Driver'),(67,'master.operator.view','Lihat master Operator'),(68,'master.operator.create','Tambah master Operator'),(69,'master.operator.update','Ubah master Operator'),(72,'master.item.view','Lihat master Barang'),(73,'master.item.create','Tambah master Barang'),(74,'master.item.update','Ubah master Barang'),(77,'master.category.view','Lihat master Kategori Barang'),(78,'master.category.create','Tambah master Kategori Barang'),(79,'master.category.update','Ubah master Kategori Barang'),(82,'master.uom.view','Lihat master Satuan'),(83,'master.uom.create','Tambah master Satuan'),(84,'master.uom.update','Ubah master Satuan'),(87,'master.supplier.view','Lihat master Supplier'),(88,'master.supplier.create','Tambah master Supplier'),(89,'master.supplier.update','Ubah master Supplier'),(106,'master.routes.view','Lihat Lokasi & Rute'),(117,'master.assets.view','Lihat Kendaraan & Unit'),(124,'master.personnel.view','Lihat Driver & Operator'),(129,'master.catalog.view','Lihat Barang & Kategori'),(136,'expedition.view','Lihat DN dan tracking internal'),(137,'expedition.ship','Buat/ubah DN awal'),(138,'expedition.manifest.view','Lihat manifest'),(139,'expedition.manifest','Buat manifest draf dan susun DN'),(140,'expedition.confirm','Konfirmasi DN dan nomor resmi'),(141,'expedition.transit','Catat perjalanan dan posisi aktual'),(142,'expedition.receive','Penerimaan utuh aktual'),(143,'expedition.claim.view','Lihat klaim operasional'),(144,'expedition.claim.report','Laporkan klaim dan bukti'),(145,'expedition.claim.review','Periksa/putuskan/tutup klaim operasional'),(146,'equipment.assignment.manage','Equipment: assignment.manage'),(147,'equipment.contract.activate','Equipment: contract.activate'),(148,'equipment.contract.cancel','Equipment: contract.cancel'),(149,'equipment.contract.close','Equipment: contract.close'),(150,'equipment.contract.confirm','Equipment: contract.confirm'),(151,'equipment.contract.create','Equipment: contract.create'),(152,'equipment.contract.extend','Equipment: contract.extend'),(153,'equipment.contract.terminate','Equipment: contract.terminate'),(154,'equipment.contract.update','Equipment: contract.update'),(155,'equipment.contract.view','Equipment: contract.view'),(156,'equipment.contract.view_own','Equipment: contract.view_own'),(157,'equipment.cross_branch.approve','Equipment: cross_branch.approve'),(158,'equipment.cross_branch.request','Equipment: cross_branch.request'),(159,'equipment.evidence.add','Equipment: evidence.add'),(160,'equipment.evidence.add_own','Equipment: evidence.add_own'),(161,'equipment.evidence.view','Equipment: evidence.view'),(162,'equipment.evidence.view_own','Equipment: evidence.view_own'),(163,'equipment.handover.cancel','Equipment: handover.cancel'),(164,'equipment.handover.confirm','Equipment: handover.confirm'),(165,'equipment.handover.correct','Equipment: handover.correct'),(166,'equipment.handover.create','Equipment: handover.create'),(167,'equipment.handover.fact_correct','Equipment: handover.fact_correct'),(168,'equipment.handover.update','Equipment: handover.update'),(169,'equipment.handover.view','Equipment: handover.view'),(170,'equipment.handover.view_own','Equipment: handover.view_own'),(171,'equipment.meter.correct','Equipment: meter.correct'),(172,'equipment.operator.relink','Equipment: operator.relink'),(173,'equipment.recovery.close','Equipment: recovery.close'),(174,'equipment.timesheet.create_own','Equipment: timesheet.create_own'),(175,'equipment.timesheet.create_scoped','Equipment: timesheet.create_scoped'),(176,'equipment.timesheet.revise_own','Equipment: timesheet.revise_own'),(177,'equipment.timesheet.revise_scoped','Equipment: timesheet.revise_scoped'),(178,'equipment.timesheet.revise_terminal','Equipment: timesheet.revise_terminal'),(179,'equipment.timesheet.submit_own','Equipment: timesheet.submit_own'),(180,'equipment.timesheet.submit_scoped','Equipment: timesheet.submit_scoped'),(181,'equipment.timesheet.update_own','Equipment: timesheet.update_own'),(182,'equipment.timesheet.update_scoped','Equipment: timesheet.update_scoped'),(183,'equipment.timesheet.view_own','Equipment: timesheet.view_own'),(184,'equipment.timesheet.view_scoped','Equipment: timesheet.view_scoped'),(185,'equipment.unit.view','Equipment: unit.view'),(186,'equipment.unit.view_own','Equipment: unit.view_own'),(187,'equipment.verification.decide','Equipment: verification.decide'),(188,'equipment.verification.view','Equipment: verification.view'),(189,'finance.account.view','Lihat rekening kas dan bank'),(190,'finance.account.manage','Kelola rekening kas dan bank'),(191,'finance.category.view','Lihat kategori pengeluaran'),(192,'finance.category.manage','Kelola kategori pengeluaran'),(193,'finance.invoice.view','Lihat invoice'),(194,'finance.invoice.create','Buat draft invoice'),(195,'finance.invoice.issue','Terbitkan invoice'),(196,'finance.receivable.view','Lihat piutang'),(197,'finance.payment.create','Catat pembayaran'),(199,'finance.invoice.edit','Edit draft invoice'),(200,'finance.payment.view','Lihat pembayaran'),(201,'finance.payment.reverse','Reverse pembayaran'),(202,'finance.expense.view','Lihat pengeluaran'),(203,'finance.expense.create','Catat pengeluaran'),(204,'finance.payable.view','Lihat utang supplier'),(205,'finance.payable.create','Catat utang supplier'),(206,'finance.payable.post','Posting tagihan supplier'),(207,'finance.payable.pay','Bayar utang supplier'),(208,'inventory.receipt.view','Lihat barang masuk'),(209,'inventory.receipt.create','Buat barang masuk'),(210,'inventory.receipt.post','Posting barang masuk'),(211,'inventory.issue.view','Lihat barang keluar'),(212,'inventory.issue.create','Buat barang keluar'),(213,'inventory.issue.post','Posting barang keluar'),(214,'inventory.warehouse.view','Lihat gudang'),(215,'inventory.warehouse.create','Tambah gudang'),(216,'inventory.warehouse.update','Ubah gudang'),(217,'inventory.transfer.view','Lihat transfer gudang'),(218,'inventory.transfer.create','Buat transfer gudang'),(219,'inventory.transfer.send','Kirim transfer gudang'),(220,'inventory.transfer.receive','Terima transfer gudang');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_permissions` (
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_permission` (`permission_id`),
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,9),(1,10),(1,11),(1,17),(1,18),(1,19),(1,24),(1,25),(1,26),(1,31),(1,32),(1,33),(1,38),(1,39),(1,40),(1,43),(1,44),(1,45),(1,48),(1,49),(1,50),(1,54),(1,55),(1,56),(1,61),(1,62),(1,63),(1,67),(1,68),(1,69),(1,72),(1,73),(1,74),(1,77),(1,78),(1,79),(1,82),(1,83),(1,84),(1,87),(1,88),(1,89),(1,106),(1,117),(1,124),(1,129),(1,136),(1,137),(1,138),(1,139),(1,140),(1,141),(1,142),(1,143),(1,144),(1,145),(1,146),(1,147),(1,148),(1,149),(1,150),(1,151),(1,152),(1,153),(1,154),(1,155),(1,158),(1,159),(1,161),(1,163),(1,164),(1,166),(1,168),(1,169),(1,175),(1,177),(1,180),(1,182),(1,184),(1,185),(1,187),(1,188),(2,1),(2,4),(2,9),(2,17),(2,24),(2,31),(2,38),(2,43),(2,48),(2,54),(2,61),(2,67),(2,72),(2,77),(2,82),(2,87),(2,106),(2,117),(2,124),(2,129),(2,136),(2,138),(2,143),(2,155),(2,161),(2,169),(2,184),(2,185),(2,188),(2,189),(2,191),(2,193),(2,196),(2,200),(2,202),(2,204),(2,208),(2,211),(2,214),(2,217),(3,1),(3,9),(3,17),(3,24),(3,31),(3,38),(3,48),(3,61),(3,106),(3,117),(3,124),(3,136),(3,137),(3,138),(3,140),(3,143),(3,144),(4,1),(4,17),(4,24),(4,31),(4,48),(4,61),(4,106),(4,117),(4,124),(4,136),(4,138),(4,139),(4,141),(4,143),(4,144),(5,1),(5,9),(5,17),(5,24),(5,31),(5,106),(5,136),(5,138),(5,142),(5,143),(5,144),(6,1),(6,9),(6,43),(6,54),(6,67),(6,117),(6,124),(6,146),(6,147),(6,148),(6,149),(6,150),(6,151),(6,154),(6,155),(6,158),(6,159),(6,161),(6,163),(6,164),(6,166),(6,168),(6,169),(6,175),(6,177),(6,180),(6,182),(6,184),(6,185),(7,1),(7,54),(7,117),(7,156),(7,160),(7,162),(7,170),(7,174),(7,176),(7,179),(7,181),(7,183),(7,186),(8,1),(8,9),(8,87),(8,189),(8,190),(8,191),(8,192),(8,193),(8,194),(8,195),(8,196),(8,197),(8,199),(8,200),(8,202),(8,203),(8,204),(8,205),(8,206),(8,207),(8,208),(8,211),(8,217),(9,1),(9,54),(9,72),(9,77),(9,82),(9,87),(9,117),(9,129),(10,1);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (5,'Admin Penerima'),(3,'Admin Pengirim'),(6,'Admin Sewa'),(4,'Admin Transit'),(1,'Administrator'),(10,'Customer'),(8,'Finance'),(9,'Gudang'),(7,'Operator Alat Berat'),(2,'Owner');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(80) NOT NULL,
  `applied_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('001_foundation','2026-10-24 11:28:34'),('002_master_data','2026-10-24 11:28:35'),('003_trucking','2026-10-24 11:28:35'),('004_trucking_operations','2026-10-24 11:28:36'),('005_eq/done/01/4040f3449073/180bbbaad484504f701d9efcb5111be9','2026-10-24 11:28:36'),('005_eq/done/02/275ea1272c02/fdc145d771bc47f0640d4b06d1f18687','2026-10-24 11:28:36'),('005_eq/done/03/125dbe4c4e12/3d99059772d748d66d76361c3038751b','2026-10-24 11:28:36'),('005_eq/done/04/94e1bd4d49d8/4f5d3966d6f0da03a55d3061ade60ee5','2026-10-24 11:28:36'),('005_eq/done/05/842ebb13fc54/b41b59657ec902cff2a7bc14fe6ce8be','2026-10-24 11:28:36'),('005_eq/done/06/f4be9b7aa990/89a4fd2beff9b58a233c945992a9db8a','2026-10-24 11:28:37'),('005_eq/done/07/9d0c75b6289a/36b83ece5861f437035378a69c05cf57','2026-10-24 11:28:37'),('005_eq/done/08/80336218edcf/866a2a01d3a1a0a40ce2d0b6d82d208f','2026-10-24 11:28:37'),('005_eq/done/09/e089445a8c13/dcb1b08164dbe457cd447b9e28c3aea8','2026-10-24 11:28:37'),('005_eq/done/10/de25a9310f58/580a7068cbe038752efb88a57a20f2e9','2026-10-24 11:28:37'),('005_eq/done/11/e2fa2ab46f11/2fa46e859e54a457a6daa00ec73e1438','2026-10-24 11:28:37'),('005_eq/done/12/012bb4c1aaa3/45514d4c81ec32423739e143a39c0aaf','2026-10-24 11:28:37'),('005_eq/done/13/54bca51563ba/1267b970b07948dda73b7a7ae2be4ba1','2026-10-24 11:28:37'),('005_eq/done/14/10b6c2a4b4d3/c7927dbd94af09f03517fa8003a43675','2026-10-24 11:28:37'),('005_eq/done/15/929294e8ff5d/693fe5f9e350d0b0609dfd4f36c7a65c','2026-10-24 11:28:37'),('005_eq/done/16/e0ac2ccb38de/309ad98dd9d8ecbdd275b20aa4f49448','2026-10-24 11:28:37'),('005_eq/done/17/ef2cf42d8ad8/526c5a25ea1ffba55828cd64b1cecf6e','2026-10-24 11:28:38'),('005_eq/done/18/a183e3164241/2a77e0cc72876666bfe30f6016c31010','2026-10-24 11:28:38'),('005_eq/done/19/996828907767/5a14386826125aa9a0d01888ba98edba','2026-10-24 11:28:38'),('005_eq/start/01/4040f3449073','2026-10-24 11:28:36'),('005_eq/start/02/275ea1272c02','2026-10-24 11:28:36'),('005_eq/start/03/125dbe4c4e12','2026-10-24 11:28:36'),('005_eq/start/04/94e1bd4d49d8','2026-10-24 11:28:36'),('005_eq/start/05/842ebb13fc54','2026-10-24 11:28:36'),('005_eq/start/06/f4be9b7aa990','2026-10-24 11:28:36'),('005_eq/start/07/9d0c75b6289a','2026-10-24 11:28:37'),('005_eq/start/08/80336218edcf','2026-10-24 11:28:37'),('005_eq/start/09/e089445a8c13','2026-10-24 11:28:37'),('005_eq/start/10/de25a9310f58','2026-10-24 11:28:37'),('005_eq/start/11/e2fa2ab46f11','2026-10-24 11:28:37'),('005_eq/start/12/012bb4c1aaa3','2026-10-24 11:28:37'),('005_eq/start/13/54bca51563ba','2026-10-24 11:28:37'),('005_eq/start/14/10b6c2a4b4d3','2026-10-24 11:28:37'),('005_eq/start/15/929294e8ff5d','2026-10-24 11:28:37'),('005_eq/start/16/e0ac2ccb38de','2026-10-24 11:28:37'),('005_eq/start/17/ef2cf42d8ad8','2026-10-24 11:28:37'),('005_eq/start/18/a183e3164241','2026-10-24 11:28:38'),('005_eq/start/19/996828907767','2026-10-24 11:28:38'),('005_equipment_operations','2026-10-24 11:28:38'),('006_finance_foundation','2026-10-24 16:47:25'),('007_finance_permissions','2026-10-24 16:55:37'),('008_finance_invoice_permissions','2026-10-24 16:58:26'),('009_finance_receivables_permissions','2026-10-24 17:04:51'),('010_finance_invoice_edit_permission','2026-10-24 17:30:14'),('011_finance_owner_read_permissions','2026-10-24 17:34:21'),('012_finance_payment_view_permission','2026-10-24 17:37:35'),('013_finance_payment_reverse_permission','2026-10-24 18:13:27'),('014_finance_expense_permissions','2026-10-24 18:18:52'),('015_fin_supplier_payments','2026-10-24 18:39:02'),('016_finance_payable_permissions','2026-10-24 18:39:02'),('017_finance_payable_action_permissions','2026-10-24 20:11:27'),('018_fin_supplier_bill_posted','2026-10-24 20:11:28'),('019_inventory_stock_ledger','2026-10-24 20:11:28'),('020_inventory_receipts','2026-10-24 20:11:28'),('021_inventory_issues','2026-10-24 20:11:28'),('022_inventory_multi_warehouse','2026-10-24 20:11:28'),('023_inventory_warehouse_permissions','2026-10-24 20:11:28'),('024_inventory_transfers','2026-10-24 20:20:30');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_branches`
--

DROP TABLE IF EXISTS `user_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_branches` (
  `user_id` int(10) unsigned NOT NULL,
  `branch_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`branch_id`),
  KEY `fk_ub_branch` (`branch_id`),
  CONSTRAINT `fk_ub_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`),
  CONSTRAINT `fk_ub_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_branches`
--

LOCK TABLES `user_branches` WRITE;
/*!40000 ALTER TABLE `user_branches` DISABLE KEYS */;
INSERT INTO `user_branches` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1);
/*!40000 ALTER TABLE `user_branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin Penerima','demo_admin_penerima@demo.invalid','$2y$10$u7lVBXb7CIol189DkAjH..6vGHj6OHiI2qa2nKCUVQQyPbS4b1ysm',5,1,0,1,'2026-10-24 11:28:38'),(2,'Admin Pengirim','demo_admin_pengirim@demo.invalid','$2y$10$wfvTEibAExhwAFgq/XufV.70c9VEcM97UijSMS6ODFASzYoJsfjmy',3,1,0,1,'2026-10-24 11:28:38'),(3,'Admin Sewa','demo_admin_sewa@demo.invalid','$2y$10$nujSis2vw68NCooQnNIFTOtSFFS6SnizOvxHz5jvztldHwcfm7Bau',6,1,0,1,'2026-10-24 11:28:38'),(4,'Admin Transit','demo_admin_transit@demo.invalid','$2y$10$mg0j162sgMHOaoSocHfIfex11HQIoNs0vkVfzS6MD6xMFnKKxc2Uq',4,1,0,1,'2026-10-24 11:28:38'),(5,'Administrator','demo_administrator@demo.invalid','$2y$10$fEVxYHZ1hS.qf/Awabcjeu9PB2Rq1IrRnVQq1jw2Civh2.kJsStWO',1,1,1,1,'2026-10-24 11:28:38'),(6,'Customer','demo_customer@demo.invalid','$2y$10$Foh36grb3eMbsU8pMNhub.FY8SPhM3b.MZrmBt/6sUJWhcnC.4tri',10,1,0,1,'2026-10-24 11:28:38'),(7,'Finance','demo_finance@demo.invalid','$2y$10$e4f1AGB/WA/6e48sFk2VVenoI/CCWUAxlnqo1aCxKivRbUkbo5uXy',8,1,0,1,'2026-10-24 11:28:39'),(8,'Gudang','demo_gudang@demo.invalid','$2y$10$iIkmMsBaiwA7X25nD9YVZ.GTUAr0moPYWk3h8igs9cYnNzcRDrfwe',9,1,0,1,'2026-10-24 11:28:39'),(9,'Operator Alat Berat','demo_operator_alat_berat@demo.invalid','$2y$10$wP0Cq0JzUjA1wX8c3yxIv.GzWmgjTKbVkLEFiv1/LSwAJXJgLSps2',7,1,0,1,'2026-10-24 11:28:39'),(10,'Owner','demo_owner@demo.invalid','$2y$10$XbrgWU7ohletu0hlRWU4MOHlR.e1LBSf1u2PR7eDWDwEOVtEpsv3C',2,1,0,1,'2026-10-24 11:28:39');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-25  4:22:29

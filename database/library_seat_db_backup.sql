-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: library_seat_db
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
-- Table structure for table `attendances`
--

DROP TABLE IF EXISTS `attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `booking_id` bigint(20) unsigned DEFAULT NULL,
  `check_in_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `check_out_at` timestamp NULL DEFAULT NULL,
  `duration_minutes` int(11) NOT NULL DEFAULT 0,
  `date` date NOT NULL,
  `status` enum('checked_in','checked_out') NOT NULL DEFAULT 'checked_in',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendances_user_id_foreign` (`user_id`),
  KEY `attendances_library_id_foreign` (`library_id`),
  KEY `attendances_booking_id_foreign` (`booking_id`),
  KEY `attendances_date_index` (`date`),
  CONSTRAINT `attendances_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `attendances_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `attendances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendances`
--

LOCK TABLES `attendances` WRITE;
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
INSERT INTO `attendances` VALUES (1,3,1,1,'2026-11-14 05:44:38','2026-11-14 08:44:38',180,'2026-11-14','checked_out','2026-11-14 09:44:38','2026-11-14 09:44:38'),(2,3,1,1,'2026-11-14 08:59:38',NULL,0,'2026-11-14','checked_in','2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `seat_id` bigint(20) unsigned NOT NULL,
  `pass_code` varchar(255) NOT NULL,
  `shift` enum('morning','evening','full_day') NOT NULL,
  `booking_date` date NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','completed','cancelled') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bookings_pass_code_unique` (`pass_code`),
  KEY `bookings_user_id_foreign` (`user_id`),
  KEY `bookings_seat_id_foreign` (`seat_id`),
  CONSTRAINT `bookings_seat_id_foreign` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,3,3,'LIB-PASS-001','morning','2026-11-14',NULL,'active','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,4,4,'LIB-PASS-002','full_day','2026-11-14',NULL,'active','2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
INSERT INTO `cache` VALUES ('laravel-cache-boost:mcp:database-schema:mysql::0:0:0:0','a:2:{s:6:\"engine\";s:5:\"mysql\";s:6:\"tables\";a:25:{s:11:\"attendances\";a:5:{s:7:\"columns\";a:11:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"booking_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:11:\"check_in_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:12:\"check_out_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:16:\"duration_minutes\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:4:\"date\";a:1:{s:4:\"type\";s:4:\"date\";}s:6:\"status\";a:1:{s:4:\"type\";s:32:\"enum(\'checked_in\',\'checked_out\')\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:5:{s:30:\"attendances_booking_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"booking_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:22:\"attendances_date_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:4:\"date\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:30:\"attendances_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:27:\"attendances_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:3:{i:0;a:7:{s:4:\"name\";s:30:\"attendances_booking_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"booking_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:8:\"bookings\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:1;a:7:{s:4:\"name\";s:30:\"attendances_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:2;a:7:{s:4:\"name\";s:27:\"attendances_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:8:\"bookings\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"seat_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:9:\"pass_code\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"shift\";a:1:{s:4:\"type\";s:36:\"enum(\'morning\',\'evening\',\'full_day\')\";}s:12:\"booking_date\";a:1:{s:4:\"type\";s:4:\"date\";}s:10:\"expires_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:6:\"status\";a:1:{s:4:\"type\";s:38:\"enum(\'active\',\'completed\',\'cancelled\')\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:4:{s:25:\"bookings_pass_code_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:9:\"pass_code\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:24:\"bookings_seat_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:24:\"bookings_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:2:{i:0;a:7:{s:4:\"name\";s:24:\"bookings_seat_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"seats\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:1;a:7:{s:4:\"name\";s:24:\"bookings_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:5:\"cache\";a:5:{s:7:\"columns\";a:3:{s:3:\"key\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"value\";a:1:{s:4:\"type\";s:10:\"mediumtext\";}s:10:\"expiration\";a:1:{s:4:\"type\";s:10:\"bigint(20)\";}}s:7:\"indexes\";a:2:{s:22:\"cache_expiration_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"expiration\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:3:\"key\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:11:\"cache_locks\";a:5:{s:7:\"columns\";a:3:{s:3:\"key\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"owner\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"expiration\";a:1:{s:4:\"type\";s:10:\"bigint(20)\";}}s:7:\"indexes\";a:2:{s:28:\"cache_locks_expiration_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"expiration\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:3:\"key\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:10:\"complaints\";a:5:{s:7:\"columns\";a:11:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"seat_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:8:\"category\";a:1:{s:4:\"type\";s:103:\"enum(\'cleanliness\',\'noise\',\'ac_cooler\',\'wifi\',\'charging_point\',\'water\',\'washroom\',\'seat_issue\',\'other\')\";}s:7:\"subject\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:11:\"description\";a:1:{s:4:\"type\";s:4:\"text\";}s:6:\"status\";a:1:{s:4:\"type\";s:49:\"enum(\'pending\',\'in_progress\',\'resolved\',\'closed\')\";}s:12:\"admin_remark\";a:1:{s:4:\"type\";s:4:\"text\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:4:{s:29:\"complaints_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:26:\"complaints_seat_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:26:\"complaints_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:3:{i:0;a:7:{s:4:\"name\";s:29:\"complaints_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:1;a:7:{s:4:\"name\";s:26:\"complaints_seat_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"seats\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:2;a:7:{s:4:\"name\";s:26:\"complaints_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:10:\"facilities\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:8:\"category\";a:1:{s:4:\"type\";s:95:\"enum(\'wifi\',\'charging\',\'locker\',\'ac_cooler\',\'water\',\'washroom_gents\',\'washroom_ladies\',\'other\')\";}s:6:\"status\";a:1:{s:4:\"type\";s:55:\"enum(\'available\',\'limited\',\'unavailable\',\'maintenance\')\";}s:7:\"details\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"icon\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:15:\"last_checked_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:2:{s:29:\"facilities_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:1:{i:0;a:7:{s:4:\"name\";s:29:\"facilities_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:11:\"failed_jobs\";a:5:{s:7:\"columns\";a:7:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"uuid\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"connection\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"queue\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"payload\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:9:\"exception\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:9:\"failed_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:3:{s:44:\"failed_jobs_connection_queue_failed_at_index\";a:4:{s:7:\"columns\";a:3:{i:0;s:10:\"connection\";i:1;s:5:\"queue\";i:2;s:9:\"failed_at\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:23:\"failed_jobs_uuid_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:4:\"uuid\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:4:\"jobs\";a:5:{s:7:\"columns\";a:7:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"queue\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"payload\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:8:\"attempts\";a:1:{s:4:\"type\";s:20:\"smallint(5) unsigned\";}s:11:\"reserved_at\";a:1:{s:4:\"type\";s:16:\"int(10) unsigned\";}s:12:\"available_at\";a:1:{s:4:\"type\";s:16:\"int(10) unsigned\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:16:\"int(10) unsigned\";}}s:7:\"indexes\";a:2:{s:16:\"jobs_queue_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"queue\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:11:\"job_batches\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"total_jobs\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:12:\"pending_jobs\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:11:\"failed_jobs\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:14:\"failed_job_ids\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:7:\"options\";a:1:{s:4:\"type\";s:10:\"mediumtext\";}s:12:\"cancelled_at\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:11:\"finished_at\";a:1:{s:4:\"type\";s:7:\"int(11)\";}}s:7:\"indexes\";a:1:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:9:\"libraries\";a:5:{s:7:\"columns\";a:21:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"slug\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"image\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"address\";a:1:{s:4:\"type\";s:4:\"text\";}s:4:\"city\";a:1:{s:4:\"type\";s:12:\"varchar(100)\";}s:5:\"state\";a:1:{s:4:\"type\";s:12:\"varchar(100)\";}s:7:\"pincode\";a:1:{s:4:\"type\";s:11:\"varchar(20)\";}s:8:\"latitude\";a:1:{s:4:\"type\";s:13:\"decimal(10,7)\";}s:9:\"longitude\";a:1:{s:4:\"type\";s:13:\"decimal(10,7)\";}s:5:\"phone\";a:1:{s:4:\"type\";s:11:\"varchar(25)\";}s:5:\"email\";a:1:{s:4:\"type\";s:12:\"varchar(150)\";}s:11:\"description\";a:1:{s:4:\"type\";s:4:\"text\";}s:9:\"amenities\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:11:\"total_seats\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:16:\"registration_fee\";a:1:{s:4:\"type\";s:13:\"decimal(10,2)\";}s:14:\"payment_status\";a:1:{s:4:\"type\";s:30:\"enum(\'unpaid\',\'paid\',\'waived\')\";}s:6:\"status\";a:1:{s:4:\"type\";s:44:\"enum(\'pending_payment\',\'active\',\'suspended\')\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:3:{s:21:\"libraries_slug_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:4:\"slug\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:25:\"libraries_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:1:{i:0;a:7:{s:4:\"name\";s:25:\"libraries_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:1:{i:0;O:8:\"stdClass\":2:{s:15:\"CONSTRAINT_NAME\";s:9:\"amenities\";s:12:\"CHECK_CLAUSE\";s:23:\"json_valid(`amenities`)\";}}}s:10:\"migrations\";a:5:{s:7:\"columns\";a:3:{s:2:\"id\";a:1:{s:4:\"type\";s:16:\"int(10) unsigned\";}s:9:\"migration\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"batch\";a:1:{s:4:\"type\";s:7:\"int(11)\";}}s:7:\"indexes\";a:1:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:7:\"notices\";a:5:{s:7:\"columns\";a:9:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"title\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"content\";a:1:{s:4:\"type\";s:4:\"text\";}s:4:\"type\";a:1:{s:4:\"type\";s:45:\"enum(\'rule\',\'notice\',\'announcement\',\'timing\')\";}s:8:\"priority\";a:1:{s:4:\"type\";s:35:\"enum(\'normal\',\'important\',\'urgent\')\";}s:9:\"is_active\";a:1:{s:4:\"type\";s:10:\"tinyint(1)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:2:{s:26:\"notices_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:1:{i:0;a:7:{s:4:\"name\";s:26:\"notices_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:13:\"notifications\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"title\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"message\";a:1:{s:4:\"type\";s:4:\"text\";}s:4:\"type\";a:1:{s:4:\"type\";s:93:\"enum(\'fee_reminder\',\'pending_payment\',\'vacant_seat\',\'smart_vacancy_alert\',\'notice\',\'general\')\";}s:5:\"badge\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"data\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:7:\"is_read\";a:1:{s:4:\"type\";s:10:\"tinyint(1)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:2:{s:29:\"notifications_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:1:{i:0;a:7:{s:4:\"name\";s:29:\"notifications_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:1:{i:0;O:8:\"stdClass\":2:{s:15:\"CONSTRAINT_NAME\";s:4:\"data\";s:12:\"CHECK_CLAUSE\";s:18:\"json_valid(`data`)\";}}}s:4:\"otps\";a:5:{s:7:\"columns\";a:8:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"email\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:3:\"otp\";a:1:{s:4:\"type\";s:11:\"varchar(10)\";}s:4:\"type\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"expires_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:11:\"is_verified\";a:1:{s:4:\"type\";s:10:\"tinyint(1)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:2:{s:16:\"otps_email_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"email\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:21:\"password_reset_tokens\";a:5:{s:7:\"columns\";a:3:{s:5:\"email\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"token\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:1:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"email\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:8:\"payments\";a:5:{s:7:\"columns\";a:15:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"booking_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"plan_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:12:\"collected_by\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:6:\"amount\";a:1:{s:4:\"type\";s:13:\"decimal(10,2)\";}s:4:\"type\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:8:\"currency\";a:1:{s:4:\"type\";s:11:\"varchar(10)\";}s:14:\"payment_method\";a:1:{s:4:\"type\";s:59:\"enum(\'cash\',\'upi\',\'online_razorpay\',\'online_stripe\',\'card\')\";}s:14:\"transaction_id\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:6:\"status\";a:1:{s:4:\"type\";s:47:\"enum(\'completed\',\'pending\',\'failed\',\'refunded\')\";}s:5:\"notes\";a:1:{s:4:\"type\";s:4:\"text\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:7:{s:27:\"payments_booking_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"booking_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"payments_collected_by_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:12:\"collected_by\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:27:\"payments_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:24:\"payments_plan_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"plan_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:30:\"payments_transaction_id_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:14:\"transaction_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:24:\"payments_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:5:{i:0;a:7:{s:4:\"name\";s:27:\"payments_booking_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"booking_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:8:\"bookings\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:1;a:7:{s:4:\"name\";s:29:\"payments_collected_by_foreign\";s:7:\"columns\";a:1:{i:0;s:12:\"collected_by\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:2;a:7:{s:4:\"name\";s:27:\"payments_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:3;a:7:{s:4:\"name\";s:24:\"payments_plan_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"plan_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"plans\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:4;a:7:{s:4:\"name\";s:24:\"payments_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:22:\"personal_access_tokens\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:14:\"tokenable_type\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:12:\"tokenable_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:4:\"text\";}s:5:\"token\";a:1:{s:4:\"type\";s:11:\"varchar(64)\";}s:9:\"abilities\";a:1:{s:4:\"type\";s:4:\"text\";}s:12:\"last_used_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"expires_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:4:{s:39:\"personal_access_tokens_expires_at_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"expires_at\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:56:\"personal_access_tokens_tokenable_type_tokenable_id_index\";a:4:{s:7:\"columns\";a:2:{i:0;s:14:\"tokenable_type\";i:1;s:12:\"tokenable_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:35:\"personal_access_tokens_token_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"token\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:5:\"plans\";a:5:{s:7:\"columns\";a:9:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"price\";a:1:{s:4:\"type\";s:13:\"decimal(10,2)\";}s:13:\"duration_days\";a:1:{s:4:\"type\";s:7:\"int(11)\";}s:5:\"shift\";a:1:{s:4:\"type\";s:42:\"enum(\'morning\',\'evening\',\'full_day\',\'all\')\";}s:11:\"description\";a:1:{s:4:\"type\";s:4:\"text\";}s:9:\"is_active\";a:1:{s:4:\"type\";s:10:\"tinyint(1)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:1:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:5:\"seats\";a:5:{s:7:\"columns\";a:7:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"zone_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:11:\"seat_number\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:6:\"status\";a:1:{s:4:\"type\";s:53:\"enum(\'available\',\'occupied\',\'reserved\',\'maintenance\')\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:3:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:24:\"seats_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:21:\"seats_zone_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"zone_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:2:{i:0;a:7:{s:4:\"name\";s:24:\"seats_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:1;a:7:{s:4:\"name\";s:21:\"seats_zone_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"zone_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"zones\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:8:\"sessions\";a:5:{s:7:\"columns\";a:6:{s:2:\"id\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"ip_address\";a:1:{s:4:\"type\";s:11:\"varchar(45)\";}s:10:\"user_agent\";a:1:{s:4:\"type\";s:4:\"text\";}s:7:\"payload\";a:1:{s:4:\"type\";s:8:\"longtext\";}s:13:\"last_activity\";a:1:{s:4:\"type\";s:7:\"int(11)\";}}s:7:\"indexes\";a:3:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:28:\"sessions_last_activity_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:13:\"last_activity\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:22:\"sessions_user_id_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:20:\"smart_vacancy_alerts\";a:5:{s:7:\"columns\";a:12:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"seat_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"shift\";a:1:{s:4:\"type\";s:36:\"enum(\'morning\',\'evening\',\'full_day\')\";}s:10:\"alert_date\";a:1:{s:4:\"type\";s:4:\"date\";}s:5:\"title\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:7:\"message\";a:1:{s:4:\"type\";s:4:\"text\";}s:10:\"expires_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:6:\"status\";a:1:{s:4:\"type\";s:34:\"enum(\'active\',\'claimed\',\'expired\')\";}s:10:\"claimed_by\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:5:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:37:\"smart_vacancy_alerts_alert_date_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"alert_date\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:39:\"smart_vacancy_alerts_claimed_by_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"claimed_by\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:39:\"smart_vacancy_alerts_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:36:\"smart_vacancy_alerts_seat_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:3:{i:0;a:7:{s:4:\"name\";s:39:\"smart_vacancy_alerts_claimed_by_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"claimed_by\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:1;a:7:{s:4:\"name\";s:39:\"smart_vacancy_alerts_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:2;a:7:{s:4:\"name\";s:36:\"smart_vacancy_alerts_seat_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"seats\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:13:\"subscriptions\";a:5:{s:7:\"columns\";a:11:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"plan_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"seat_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"start_date\";a:1:{s:4:\"type\";s:4:\"date\";}s:8:\"end_date\";a:1:{s:4:\"type\";s:4:\"date\";}s:6:\"status\";a:1:{s:4:\"type\";s:54:\"enum(\'active\',\'expired\',\'cancelled\',\'pending_payment\')\";}s:10:\"auto_renew\";a:1:{s:4:\"type\";s:10:\"tinyint(1)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:5:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:32:\"subscriptions_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"subscriptions_plan_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"plan_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"subscriptions_seat_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"subscriptions_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:4:{i:0;a:7:{s:4:\"name\";s:32:\"subscriptions_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:1;a:7:{s:4:\"name\";s:29:\"subscriptions_plan_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"plan_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"plans\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:2;a:7:{s:4:\"name\";s:29:\"subscriptions_seat_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"seats\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:3;a:7:{s:4:\"name\";s:29:\"subscriptions_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:5:\"users\";a:5:{s:7:\"columns\";a:13:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"email\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:9:\"google_id\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:6:\"avatar\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:5:\"phone\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:8:\"password\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"role\";a:1:{s:4:\"type\";s:47:\"enum(\'admin\',\'staff\',\'manager\',\'member\',\'user\')\";}s:6:\"status\";a:1:{s:4:\"type\";s:24:\"enum(\'active\',\'blocked\')\";}s:17:\"email_verified_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:14:\"remember_token\";a:1:{s:4:\"type\";s:12:\"varchar(100)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:4:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:18:\"users_email_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"email\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:22:\"users_google_id_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:9:\"google_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}s:18:\"users_phone_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:5:\"phone\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:13:\"waiting_lists\";a:5:{s:7:\"columns\";a:10:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"user_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:10:\"library_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"zone_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:7:\"seat_id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:5:\"shift\";a:1:{s:4:\"type\";s:42:\"enum(\'morning\',\'evening\',\'full_day\',\'any\')\";}s:12:\"desired_date\";a:1:{s:4:\"type\";s:4:\"date\";}s:6:\"status\";a:1:{s:4:\"type\";s:50:\"enum(\'waiting\',\'notified\',\'fulfilled\',\'cancelled\')\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:6:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:32:\"waiting_lists_desired_date_index\";a:4:{s:7:\"columns\";a:1:{i:0;s:12:\"desired_date\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:32:\"waiting_lists_library_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"waiting_lists_seat_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"waiting_lists_user_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}s:29:\"waiting_lists_zone_id_foreign\";a:4:{s:7:\"columns\";a:1:{i:0;s:7:\"zone_id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:0;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:4:{i:0;a:7:{s:4:\"name\";s:32:\"waiting_lists_library_id_foreign\";s:7:\"columns\";a:1:{i:0;s:10:\"library_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:9:\"libraries\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:1;a:7:{s:4:\"name\";s:29:\"waiting_lists_seat_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"seat_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"seats\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}i:2;a:7:{s:4:\"name\";s:29:\"waiting_lists_user_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"user_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"users\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:7:\"cascade\";}i:3;a:7:{s:4:\"name\";s:29:\"waiting_lists_zone_id_foreign\";s:7:\"columns\";a:1:{i:0;s:7:\"zone_id\";}s:14:\"foreign_schema\";s:15:\"library_seat_db\";s:13:\"foreign_table\";s:5:\"zones\";s:15:\"foreign_columns\";a:1:{i:0;s:2:\"id\";}s:9:\"on_update\";s:8:\"restrict\";s:9:\"on_delete\";s:8:\"set null\";}}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}s:5:\"zones\";a:5:{s:7:\"columns\";a:5:{s:2:\"id\";a:1:{s:4:\"type\";s:19:\"bigint(20) unsigned\";}s:4:\"name\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:4:\"code\";a:1:{s:4:\"type\";s:12:\"varchar(255)\";}s:10:\"created_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}s:10:\"updated_at\";a:1:{s:4:\"type\";s:9:\"timestamp\";}}s:7:\"indexes\";a:2:{s:7:\"primary\";a:4:{s:7:\"columns\";a:1:{i:0;s:2:\"id\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:1;}s:17:\"zones_code_unique\";a:4:{s:7:\"columns\";a:1:{i:0;s:4:\"code\";}s:4:\"type\";s:5:\"btree\";s:9:\"is_unique\";b:1;s:10:\"is_primary\";b:0;}}s:12:\"foreign_keys\";a:0:{}s:8:\"triggers\";a:0:{}s:17:\"check_constraints\";a:0:{}}}}',1794727989),('laravel-cache-roster:project:v3:09a4ddb1d1eb425f81c108a45c739706','O:26:\"Laravel\\Roster\\ProjectScan\":8:{s:8:\"basePath\";s:40:\"C:\\Users\\Sanket Chauthe\\library_backend\\\";s:3:\"php\";O:35:\"Laravel\\Roster\\Ecosystems\\Ecosystem\":2:{s:9:\"\0*\0byName\";a:117:{s:10:\"brick/math\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:10:\"brick/math\";s:10:\"\0*\0version\";s:5:\"1.0.0\";s:9:\"\0*\0source\";E:43:\"Laravel\\Roster\\Enums\\PackageSource:Composer\";s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:57:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\brick\\math\";}s:31:\"carbonphp/carbon-doctrine-types\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:31:\"carbonphp/carbon-doctrine-types\";s:10:\"\0*\0version\";s:5:\"3.2.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:78:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\carbonphp\\carbon-doctrine-types\";}s:23:\"dflydev/dot-access-data\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:23:\"dflydev/dot-access-data\";s:10:\"\0*\0version\";s:5:\"3.0.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\dflydev\\dot-access-data\";}s:18:\"doctrine/inflector\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:18:\"doctrine/inflector\";s:10:\"\0*\0version\";s:5:\"2.1.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:65:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\doctrine\\inflector\";}s:14:\"doctrine/lexer\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"doctrine/lexer\";s:10:\"\0*\0version\";s:5:\"3.0.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\doctrine\\lexer\";}s:29:\"dragonmantank/cron-expression\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:29:\"dragonmantank/cron-expression\";s:10:\"\0*\0version\";s:5:\"3.6.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:76:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\dragonmantank\\cron-expression\";}s:23:\"egulias/email-validator\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:23:\"egulias/email-validator\";s:10:\"\0*\0version\";s:5:\"4.0.4\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\egulias\\email-validator\";}s:18:\"fruitcake/php-cors\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:18:\"fruitcake/php-cors\";s:10:\"\0*\0version\";s:5:\"1.4.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:65:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\fruitcake\\php-cors\";}s:27:\"graham-campbell/result-type\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:27:\"graham-campbell/result-type\";s:10:\"\0*\0version\";s:5:\"1.2.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:74:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\graham-campbell\\result-type\";}s:17:\"guzzlehttp/guzzle\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"guzzlehttp/guzzle\";s:10:\"\0*\0version\";s:5:\"8.5.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\guzzlehttp\\guzzle\";}s:19:\"guzzlehttp/promises\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"guzzlehttp/promises\";s:10:\"\0*\0version\";s:5:\"3.1.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\guzzlehttp\\promises\";}s:15:\"guzzlehttp/psr7\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"guzzlehttp/psr7\";s:10:\"\0*\0version\";s:5:\"3.4.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\guzzlehttp\\psr7\";}s:23:\"guzzlehttp/uri-template\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:23:\"guzzlehttp/uri-template\";s:10:\"\0*\0version\";s:5:\"2.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\guzzlehttp\\uri-template\";}s:17:\"laravel/framework\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"laravel/framework\";s:10:\"\0*\0version\";s:7:\"13.42.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^13.17\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\framework\";}s:15:\"laravel/prompts\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"laravel/prompts\";s:10:\"\0*\0version\";s:6:\"0.3.27\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\prompts\";}s:15:\"laravel/sanctum\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"laravel/sanctum\";s:10:\"\0*\0version\";s:5:\"4.4.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:4:\"^4.0\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\sanctum\";}s:28:\"laravel/serializable-closure\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:28:\"laravel/serializable-closure\";s:10:\"\0*\0version\";s:5:\"2.2.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:75:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\serializable-closure\";}s:14:\"laravel/tinker\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"laravel/tinker\";s:10:\"\0*\0version\";s:5:\"3.1.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:4:\"^3.0\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\tinker\";}s:17:\"league/commonmark\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"league/commonmark\";s:10:\"\0*\0version\";s:6:\"2.10.7\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\commonmark\";}s:13:\"league/config\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:13:\"league/config\";s:10:\"\0*\0version\";s:5:\"1.2.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:60:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\config\";}s:16:\"league/flysystem\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"league/flysystem\";s:10:\"\0*\0version\";s:6:\"3.36.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\flysystem\";}s:22:\"league/flysystem-local\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"league/flysystem-local\";s:10:\"\0*\0version\";s:6:\"3.35.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\flysystem-local\";}s:26:\"league/mime-type-detection\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:26:\"league/mime-type-detection\";s:10:\"\0*\0version\";s:6:\"1.17.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:73:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\mime-type-detection\";}s:10:\"league/uri\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:10:\"league/uri\";s:10:\"\0*\0version\";s:6:\"7.10.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:57:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\uri\";}s:21:\"league/uri-interfaces\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"league/uri-interfaces\";s:10:\"\0*\0version\";s:6:\"7.10.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\league\\uri-interfaces\";}s:15:\"monolog/monolog\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"monolog/monolog\";s:10:\"\0*\0version\";s:6:\"3.12.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\monolog\\monolog\";}s:13:\"nesbot/carbon\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:13:\"nesbot/carbon\";s:10:\"\0*\0version\";s:6:\"3.15.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:60:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nesbot\\carbon\";}s:12:\"nette/schema\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"nette/schema\";s:10:\"\0*\0version\";s:5:\"1.4.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:59:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nette\\schema\";}s:11:\"nette/utils\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"nette/utils\";s:10:\"\0*\0version\";s:5:\"4.1.6\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nette\\utils\";}s:16:\"nikic/php-parser\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"nikic/php-parser\";s:10:\"\0*\0version\";s:5:\"5.9.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nikic\\php-parser\";}s:19:\"nunomaduro/termwind\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"nunomaduro/termwind\";s:10:\"\0*\0version\";s:5:\"2.4.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nunomaduro\\termwind\";}s:19:\"phpoption/phpoption\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"phpoption/phpoption\";s:10:\"\0*\0version\";s:6:\"1.10.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpoption\\phpoption\";}s:9:\"psr/clock\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:9:\"psr/clock\";s:10:\"\0*\0version\";s:5:\"1.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:56:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\clock\";}s:13:\"psr/container\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:13:\"psr/container\";s:10:\"\0*\0version\";s:5:\"2.0.2\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:60:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\container\";}s:20:\"psr/event-dispatcher\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"psr/event-dispatcher\";s:10:\"\0*\0version\";s:5:\"1.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\event-dispatcher\";}s:15:\"psr/http-client\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"psr/http-client\";s:10:\"\0*\0version\";s:5:\"1.0.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\http-client\";}s:16:\"psr/http-factory\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"psr/http-factory\";s:10:\"\0*\0version\";s:5:\"1.1.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\http-factory\";}s:16:\"psr/http-message\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"psr/http-message\";s:10:\"\0*\0version\";s:3:\"2.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\http-message\";}s:7:\"psr/log\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:7:\"psr/log\";s:10:\"\0*\0version\";s:5:\"3.0.2\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:54:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\log\";}s:16:\"psr/simple-cache\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"psr/simple-cache\";s:10:\"\0*\0version\";s:5:\"3.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psr\\simple-cache\";}s:9:\"psy/psysh\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:9:\"psy/psysh\";s:10:\"\0*\0version\";s:7:\"0.12.24\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:56:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\psy\\psysh\";}s:17:\"ramsey/collection\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"ramsey/collection\";s:10:\"\0*\0version\";s:5:\"2.1.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\ramsey\\collection\";}s:11:\"ramsey/uuid\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"ramsey/uuid\";s:10:\"\0*\0version\";s:6:\"4.10.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\ramsey\\uuid\";}s:13:\"symfony/clock\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:13:\"symfony/clock\";s:10:\"\0*\0version\";s:6:\"7.4.21\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:60:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\clock\";}s:15:\"symfony/console\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"symfony/console\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\console\";}s:20:\"symfony/css-selector\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"symfony/css-selector\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\css-selector\";}s:29:\"symfony/deprecation-contracts\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:29:\"symfony/deprecation-contracts\";s:10:\"\0*\0version\";s:5:\"3.8.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:76:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\deprecation-contracts\";}s:21:\"symfony/error-handler\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"symfony/error-handler\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\error-handler\";}s:24:\"symfony/event-dispatcher\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:24:\"symfony/event-dispatcher\";s:10:\"\0*\0version\";s:6:\"7.4.17\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:71:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\event-dispatcher\";}s:34:\"symfony/event-dispatcher-contracts\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:34:\"symfony/event-dispatcher-contracts\";s:10:\"\0*\0version\";s:5:\"3.8.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:81:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\event-dispatcher-contracts\";}s:14:\"symfony/finder\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"symfony/finder\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\finder\";}s:23:\"symfony/http-foundation\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:23:\"symfony/http-foundation\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\http-foundation\";}s:19:\"symfony/http-kernel\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"symfony/http-kernel\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\http-kernel\";}s:14:\"symfony/mailer\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"symfony/mailer\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\mailer\";}s:12:\"symfony/mime\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"symfony/mime\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:59:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\mime\";}s:22:\"symfony/polyfill-ctype\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-ctype\";s:10:\"\0*\0version\";s:6:\"1.37.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-ctype\";}s:30:\"symfony/polyfill-intl-grapheme\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:30:\"symfony/polyfill-intl-grapheme\";s:10:\"\0*\0version\";s:6:\"1.43.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:77:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-intl-grapheme\";}s:25:\"symfony/polyfill-intl-idn\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"symfony/polyfill-intl-idn\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-intl-idn\";}s:32:\"symfony/polyfill-intl-normalizer\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:32:\"symfony/polyfill-intl-normalizer\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:79:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-intl-normalizer\";}s:25:\"symfony/polyfill-mbstring\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"symfony/polyfill-mbstring\";s:10:\"\0*\0version\";s:6:\"1.43.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-mbstring\";}s:22:\"symfony/polyfill-php80\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php80\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php80\";}s:22:\"symfony/polyfill-php82\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php82\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php82\";}s:22:\"symfony/polyfill-php83\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php83\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php83\";}s:22:\"symfony/polyfill-php84\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php84\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php84\";}s:22:\"symfony/polyfill-php85\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php85\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php85\";}s:22:\"symfony/polyfill-php86\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"symfony/polyfill-php86\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-php86\";}s:21:\"symfony/polyfill-time\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"symfony/polyfill-time\";s:10:\"\0*\0version\";s:6:\"1.42.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-time\";}s:21:\"symfony/polyfill-uuid\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"symfony/polyfill-uuid\";s:10:\"\0*\0version\";s:6:\"1.43.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\polyfill-uuid\";}s:15:\"symfony/process\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"symfony/process\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\process\";}s:15:\"symfony/routing\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"symfony/routing\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\routing\";}s:25:\"symfony/service-contracts\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"symfony/service-contracts\";s:10:\"\0*\0version\";s:5:\"3.8.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\service-contracts\";}s:14:\"symfony/string\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"symfony/string\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\string\";}s:19:\"symfony/translation\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"symfony/translation\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\translation\";}s:29:\"symfony/translation-contracts\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:29:\"symfony/translation-contracts\";s:10:\"\0*\0version\";s:5:\"3.8.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:76:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\translation-contracts\";}s:11:\"symfony/uid\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"symfony/uid\";s:10:\"\0*\0version\";s:6:\"7.4.21\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\uid\";}s:18:\"symfony/var-dumper\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:18:\"symfony/var-dumper\";s:10:\"\0*\0version\";s:6:\"7.4.22\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:65:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\var-dumper\";}s:33:\"tijsverkoyen/css-to-inline-styles\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:33:\"tijsverkoyen/css-to-inline-styles\";s:10:\"\0*\0version\";s:5:\"2.4.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:80:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\tijsverkoyen\\css-to-inline-styles\";}s:16:\"vlucas/phpdotenv\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"vlucas/phpdotenv\";s:10:\"\0*\0version\";s:5:\"5.8.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\vlucas\\phpdotenv\";}s:19:\"voku/portable-ascii\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"voku/portable-ascii\";s:10:\"\0*\0version\";s:5:\"2.1.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\voku\\portable-ascii\";}s:15:\"composer/semver\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"composer/semver\";s:10:\"\0*\0version\";s:5:\"3.6.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\composer\\semver\";}s:14:\"fakerphp/faker\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"fakerphp/faker\";s:10:\"\0*\0version\";s:6:\"1.24.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:5:\"^1.23\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\fakerphp\\faker\";}s:11:\"filp/whoops\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"filp/whoops\";s:10:\"\0*\0version\";s:6:\"2.19.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\filp\\whoops\";}s:21:\"hamcrest/hamcrest-php\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"hamcrest/hamcrest-php\";s:10:\"\0*\0version\";s:5:\"3.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\hamcrest\\hamcrest-php\";}s:22:\"laravel/agent-detector\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"laravel/agent-detector\";s:10:\"\0*\0version\";s:5:\"2.0.5\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\agent-detector\";}s:13:\"laravel/boost\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:13:\"laravel/boost\";s:10:\"\0*\0version\";s:6:\"2.10.4\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:5:\"^2.10\";s:7:\"\0*\0path\";s:60:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\boost\";}s:11:\"laravel/mcp\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"laravel/mcp\";s:10:\"\0*\0version\";s:5:\"1.2.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\mcp\";}s:12:\"laravel/pail\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"laravel/pail\";s:10:\"\0*\0version\";s:5:\"1.3.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^1.2.5\";s:7:\"\0*\0path\";s:59:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\pail\";}s:11:\"laravel/pao\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"laravel/pao\";s:10:\"\0*\0version\";s:5:\"1.1.5\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^1.0.6\";s:7:\"\0*\0path\";s:58:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\pao\";}s:12:\"laravel/pint\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"laravel/pint\";s:10:\"\0*\0version\";s:6:\"1.32.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:5:\"^1.27\";s:7:\"\0*\0path\";s:59:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\pint\";}s:14:\"laravel/roster\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"laravel/roster\";s:10:\"\0*\0version\";s:5:\"1.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\laravel\\roster\";}s:15:\"mockery/mockery\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"mockery/mockery\";s:10:\"\0*\0version\";s:6:\"1.6.15\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:4:\"^1.6\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\mockery\\mockery\";}s:17:\"myclabs/deep-copy\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"myclabs/deep-copy\";s:10:\"\0*\0version\";s:6:\"1.14.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\myclabs\\deep-copy\";}s:20:\"nunomaduro/collision\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"nunomaduro/collision\";s:10:\"\0*\0version\";s:5:\"8.9.6\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:4:\"^8.6\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\nunomaduro\\collision\";}s:16:\"phar-io/manifest\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:16:\"phar-io/manifest\";s:10:\"\0*\0version\";s:5:\"2.0.4\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:63:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phar-io\\manifest\";}s:15:\"phar-io/version\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"phar-io/version\";s:10:\"\0*\0version\";s:5:\"3.2.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phar-io\\version\";}s:25:\"phpunit/php-code-coverage\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"phpunit/php-code-coverage\";s:10:\"\0*\0version\";s:6:\"12.5.8\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\php-code-coverage\";}s:25:\"phpunit/php-file-iterator\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"phpunit/php-file-iterator\";s:10:\"\0*\0version\";s:5:\"6.0.2\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\php-file-iterator\";}s:19:\"phpunit/php-invoker\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"phpunit/php-invoker\";s:10:\"\0*\0version\";s:5:\"6.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:66:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\php-invoker\";}s:25:\"phpunit/php-text-template\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:25:\"phpunit/php-text-template\";s:10:\"\0*\0version\";s:5:\"5.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\php-text-template\";}s:17:\"phpunit/php-timer\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"phpunit/php-timer\";s:10:\"\0*\0version\";s:5:\"8.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\php-timer\";}s:15:\"phpunit/phpunit\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:15:\"phpunit/phpunit\";s:10:\"\0*\0version\";s:7:\"12.5.44\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:8:\"^12.5.12\";s:7:\"\0*\0path\";s:62:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\phpunit\\phpunit\";}s:20:\"sebastian/cli-parser\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"sebastian/cli-parser\";s:10:\"\0*\0version\";s:5:\"4.2.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\cli-parser\";}s:20:\"sebastian/comparator\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"sebastian/comparator\";s:10:\"\0*\0version\";s:5:\"7.1.8\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\comparator\";}s:20:\"sebastian/complexity\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:20:\"sebastian/complexity\";s:10:\"\0*\0version\";s:5:\"5.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:67:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\complexity\";}s:14:\"sebastian/diff\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"sebastian/diff\";s:10:\"\0*\0version\";s:5:\"7.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\diff\";}s:21:\"sebastian/environment\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:21:\"sebastian/environment\";s:10:\"\0*\0version\";s:5:\"8.1.2\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:68:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\environment\";}s:18:\"sebastian/exporter\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:18:\"sebastian/exporter\";s:10:\"\0*\0version\";s:5:\"7.0.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:65:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\exporter\";}s:22:\"sebastian/global-state\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:22:\"sebastian/global-state\";s:10:\"\0*\0version\";s:5:\"8.0.3\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:69:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\global-state\";}s:23:\"sebastian/lines-of-code\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:23:\"sebastian/lines-of-code\";s:10:\"\0*\0version\";s:5:\"4.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\lines-of-code\";}s:27:\"sebastian/object-enumerator\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:27:\"sebastian/object-enumerator\";s:10:\"\0*\0version\";s:5:\"7.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:74:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\object-enumerator\";}s:26:\"sebastian/object-reflector\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:26:\"sebastian/object-reflector\";s:10:\"\0*\0version\";s:5:\"5.0.0\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:73:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\object-reflector\";}s:27:\"sebastian/recursion-context\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:27:\"sebastian/recursion-context\";s:10:\"\0*\0version\";s:5:\"7.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:74:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\recursion-context\";}s:14:\"sebastian/type\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:14:\"sebastian/type\";s:10:\"\0*\0version\";s:5:\"6.0.4\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:61:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\type\";}s:17:\"sebastian/version\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"sebastian/version\";s:10:\"\0*\0version\";s:5:\"6.0.2\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\sebastian\\version\";}s:28:\"staabm/side-effects-detector\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:28:\"staabm/side-effects-detector\";s:10:\"\0*\0version\";s:5:\"1.0.5\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:75:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\staabm\\side-effects-detector\";}s:12:\"symfony/yaml\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"symfony/yaml\";s:10:\"\0*\0version\";s:6:\"7.4.23\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:59:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\symfony\\yaml\";}s:17:\"theseer/tokenizer\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"theseer/tokenizer\";s:10:\"\0*\0version\";s:5:\"2.0.1\";s:9:\"\0*\0source\";r:8;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:0;s:13:\"\0*\0constraint\";s:0:\"\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\vendor\\theseer\\tokenizer\";}}s:11:\"\0*\0packages\";O:32:\"Laravel\\Roster\\PackageCollection\":2:{s:8:\"\0*\0items\";a:117:{i:0;r:5;i:1;r:13;i:2;r:21;i:3;r:29;i:4;r:37;i:5;r:45;i:6;r:53;i:7;r:61;i:8;r:69;i:9;r:77;i:10;r:85;i:11;r:93;i:12;r:101;i:13;r:109;i:14;r:117;i:15;r:125;i:16;r:133;i:17;r:141;i:18;r:149;i:19;r:157;i:20;r:165;i:21;r:173;i:22;r:181;i:23;r:189;i:24;r:197;i:25;r:205;i:26;r:213;i:27;r:221;i:28;r:229;i:29;r:237;i:30;r:245;i:31;r:253;i:32;r:261;i:33;r:269;i:34;r:277;i:35;r:285;i:36;r:293;i:37;r:301;i:38;r:309;i:39;r:317;i:40;r:325;i:41;r:333;i:42;r:341;i:43;r:349;i:44;r:357;i:45;r:365;i:46;r:373;i:47;r:381;i:48;r:389;i:49;r:397;i:50;r:405;i:51;r:413;i:52;r:421;i:53;r:429;i:54;r:437;i:55;r:445;i:56;r:453;i:57;r:461;i:58;r:469;i:59;r:477;i:60;r:485;i:61;r:493;i:62;r:501;i:63;r:509;i:64;r:517;i:65;r:525;i:66;r:533;i:67;r:541;i:68;r:549;i:69;r:557;i:70;r:565;i:71;r:573;i:72;r:581;i:73;r:589;i:74;r:597;i:75;r:605;i:76;r:613;i:77;r:621;i:78;r:629;i:79;r:637;i:80;r:645;i:81;r:653;i:82;r:661;i:83;r:669;i:84;r:677;i:85;r:685;i:86;r:693;i:87;r:701;i:88;r:709;i:89;r:717;i:90;r:725;i:91;r:733;i:92;r:741;i:93;r:749;i:94;r:757;i:95;r:765;i:96;r:773;i:97;r:781;i:98;r:789;i:99;r:797;i:100;r:805;i:101;r:813;i:102;r:821;i:103;r:829;i:104;r:837;i:105;r:845;i:106;r:853;i:107;r:861;i:108;r:869;i:109;r:877;i:110;r:885;i:111;r:893;i:112;r:901;i:113;r:909;i:114;r:917;i:115;r:925;i:116;r:933;}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}}s:2:\"js\";O:37:\"Laravel\\Roster\\Ecosystems\\JsEcosystem\":3:{s:9:\"\0*\0byName\";a:6:{s:17:\"@tailwindcss/vite\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:17:\"@tailwindcss/vite\";s:10:\"\0*\0version\";s:5:\"4.0.0\";s:9:\"\0*\0source\";E:38:\"Laravel\\Roster\\Enums\\PackageSource:Npm\";s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^4.0.0\";s:7:\"\0*\0path\";s:70:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\@tailwindcss\\vite\";}s:12:\"concurrently\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:12:\"concurrently\";s:10:\"\0*\0version\";s:6:\"10.0.3\";s:9:\"\0*\0source\";r:1066;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:7:\"^10.0.3\";s:7:\"\0*\0path\";s:65:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\concurrently\";}s:19:\"laravel-vite-plugin\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:19:\"laravel-vite-plugin\";s:10:\"\0*\0version\";s:3:\"3.1\";s:9:\"\0*\0source\";r:1066;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:4:\"^3.1\";s:7:\"\0*\0path\";s:72:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\laravel-vite-plugin\";}s:11:\"tailwindcss\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:11:\"tailwindcss\";s:10:\"\0*\0version\";s:5:\"4.0.0\";s:9:\"\0*\0source\";r:1066;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^4.0.0\";s:7:\"\0*\0path\";s:64:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\tailwindcss\";}s:4:\"vite\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:4:\"vite\";s:10:\"\0*\0version\";s:5:\"8.0.0\";s:9:\"\0*\0source\";r:1066;s:6:\"\0*\0dev\";b:1;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^8.0.0\";s:7:\"\0*\0path\";s:57:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\vite\";}s:18:\"@laravel/multiplex\";O:22:\"Laravel\\Roster\\Package\":7:{s:7:\"\0*\0name\";s:18:\"@laravel/multiplex\";s:10:\"\0*\0version\";s:5:\"0.4.1\";s:9:\"\0*\0source\";r:1066;s:6:\"\0*\0dev\";b:0;s:9:\"\0*\0direct\";b:1;s:13:\"\0*\0constraint\";s:6:\"^0.4.1\";s:7:\"\0*\0path\";s:71:\"C:\\Users\\Sanket Chauthe\\library_backend\\node_modules\\@laravel\\multiplex\";}}s:11:\"\0*\0packages\";O:32:\"Laravel\\Roster\\PackageCollection\":2:{s:8:\"\0*\0items\";a:6:{i:0;r:1063;i:1;r:1071;i:2;r:1079;i:3;r:1087;i:4;r:1095;i:5;r:1103;}s:28:\"\0*\0escapeWhenCastingToString\";b:0;}s:17:\"\0*\0packageManager\";N;}s:6:\"stacks\";O:30:\"Laravel\\Roster\\Support\\EnumSet\":1:{s:8:\"\0*\0cases\";a:1:{i:0;E:30:\"Laravel\\Roster\\Enums\\Stack:Api\";}}s:21:\"browserTestFrameworks\";O:30:\"Laravel\\Roster\\Support\\EnumSet\":1:{s:8:\"\0*\0cases\";a:0:{}}s:9:\"frontends\";O:30:\"Laravel\\Roster\\Support\\EnumSet\":1:{s:8:\"\0*\0cases\";a:0:{}}s:6:\"agents\";O:30:\"Laravel\\Roster\\Support\\EnumSet\":1:{s:8:\"\0*\0cases\";a:2:{i:0;E:37:\"Laravel\\Roster\\Enums\\Agent:ClaudeCode\";i:1;E:32:\"Laravel\\Roster\\Enums\\Agent:Codex\";}}s:7:\"editors\";O:30:\"Laravel\\Roster\\Support\\EnumSet\":1:{s:8:\"\0*\0cases\";a:0:{}}}',1794731060);
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaints`
--

DROP TABLE IF EXISTS `complaints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `complaints` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `seat_id` bigint(20) unsigned DEFAULT NULL,
  `category` enum('cleanliness','noise','ac_cooler','wifi','charging_point','water','washroom','seat_issue','other') NOT NULL DEFAULT 'other',
  `subject` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `status` enum('pending','in_progress','resolved','closed') NOT NULL DEFAULT 'pending',
  `admin_remark` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `complaints_user_id_foreign` (`user_id`),
  KEY `complaints_library_id_foreign` (`library_id`),
  KEY `complaints_seat_id_foreign` (`seat_id`),
  CONSTRAINT `complaints_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `complaints_seat_id_foreign` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`) ON DELETE SET NULL,
  CONSTRAINT `complaints_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaints`
--

LOCK TABLES `complaints` WRITE;
/*!40000 ALTER TABLE `complaints` DISABLE KEYS */;
INSERT INTO `complaints` VALUES (1,3,1,3,'ac_cooler','AC Temperature too low near desk G-03','The AC vent right above seat G-03 is blowing directly. Kindly adjust temperature to 24°C.','resolved','AC vent deflector adjusted and temperature set to 23°C.','2026-11-14 09:44:38','2026-11-14 09:44:38'),(2,4,1,4,'wifi','Intermittent Wi-Fi on 2nd Floor','Speed dropped below 10 Mbps around 3 PM today.','in_progress','Network engineer is resetting the second floor access point.','2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `complaints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facilities`
--

DROP TABLE IF EXISTS `facilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `facilities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `category` enum('wifi','charging','locker','ac_cooler','water','washroom_gents','washroom_ladies','other') NOT NULL,
  `status` enum('available','limited','unavailable','maintenance') NOT NULL DEFAULT 'available',
  `details` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `last_checked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `facilities_library_id_foreign` (`library_id`),
  CONSTRAINT `facilities_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facilities`
--

LOCK TABLES `facilities` WRITE;
/*!40000 ALTER TABLE `facilities` DISABLE KEYS */;
INSERT INTO `facilities` VALUES (1,1,'High-Speed Wi-Fi','wifi','available','150 Mbps Fiber (Dual Band 5GHz & 2.4GHz)','wifi','2026-11-14 09:44:37','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,1,'Charging Points','charging','available','Universal socket available at all individual study desks','zap','2026-11-14 09:44:37','2026-11-14 09:44:37','2026-11-14 09:44:37'),(3,1,'Personal Lockers','locker','available','18 of 24 Lockers Available for allotment','lock','2026-11-14 09:44:38','2026-11-14 09:44:38','2026-11-14 09:44:38'),(4,1,'AC & Air Cooling','ac_cooler','available','Central Air Conditioners active (22°C maintained)','wind','2026-11-14 09:44:38','2026-11-14 09:44:38','2026-11-14 09:44:38'),(5,1,'Drinking Water / Aqua','water','available','Aquaguard RO filtered cold and regular drinking water','droplet','2026-11-14 09:44:38','2026-11-14 09:44:38','2026-11-14 09:44:38'),(6,1,'Washroom (Gents)','washroom_gents','available','Hygienic and sanitized regularly (Last checked 25m ago)','user','2026-11-14 09:44:38','2026-11-14 09:44:38','2026-11-14 09:44:38'),(7,1,'Washroom (Ladies)','washroom_ladies','available','Clean, sanitized, and well-maintained','user-check','2026-11-14 09:44:38','2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `facilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `libraries`
--

DROP TABLE IF EXISTS `libraries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `libraries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `gallery` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gallery`)),
  `address` text NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pincode` varchar(20) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `amenities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`amenities`)),
  `operating_hours` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`operating_hours`)),
  `total_seats` int(11) NOT NULL DEFAULT 0,
  `registration_fee` decimal(10,2) NOT NULL DEFAULT 999.00,
  `payment_status` enum('unpaid','paid','waived') NOT NULL DEFAULT 'unpaid',
  `status` enum('pending_payment','active','suspended') NOT NULL DEFAULT 'pending_payment',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `libraries_slug_unique` (`slug`),
  KEY `libraries_user_id_foreign` (`user_id`),
  CONSTRAINT `libraries_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libraries`
--

LOCK TABLES `libraries` WRITE;
/*!40000 ALTER TABLE `libraries` DISABLE KEYS */;
INSERT INTO `libraries` VALUES (1,6,'Apex Central Study Hub','apex-central-study-hub',NULL,NULL,'402 Prestige Point, Shukrawar Peth','Pune','Maharashtra','411002',NULL,NULL,'9822001122','contact@apexcentral.in','Premium air-conditioned study hall with high-speed WiFi and individual ergonomic seating.','[\"High Speed WiFi\",\"Air Conditioned\",\"Power Outlets\",\"RO Water Dispenser\",\"CCTV Security\"]',NULL,60,499.00,'paid','active','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,7,'Study Haven Reading Room','study-haven-reading-room',NULL,NULL,'12 Near Modern College, Shivajinagar','Pune','Maharashtra','411005',NULL,NULL,'9822003344','info@studyhaven.in','Dedicated silent reading room designed for UPSC and competitive exam aspirants.','[\"Silent Zones\",\"Newspaper Desk\",\"Lockers\",\"Power Sockets\"]',NULL,40,499.00,'unpaid','pending_payment','2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `libraries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_10_29_000001_create_library_seats_tables',1),(5,'2026_10_29_000002_create_plans_and_payments_tables',1),(6,'2026_10_29_160444_create_personal_access_tokens_table',1),(7,'2026_10_31_000001_create_libraries_and_otps_tables',1),(8,'2026_11_14_150844_create_library_advanced_features_tables',1),(9,'2026_11_15_073457_add_gallery_and_operating_hours_to_libraries_table',2);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notices`
--

DROP TABLE IF EXISTS `notices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `type` enum('rule','notice','announcement','timing') NOT NULL DEFAULT 'notice',
  `priority` enum('normal','important','urgent') NOT NULL DEFAULT 'normal',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notices_library_id_foreign` (`library_id`),
  CONSTRAINT `notices_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notices`
--

LOCK TABLES `notices` WRITE;
/*!40000 ALTER TABLE `notices` DISABLE KEYS */;
INSERT INTO `notices` VALUES (1,1,'Strict Silence in Study Halls','Pin-drop silence must be maintained in the study hall at all times. Whispering and discussions are prohibited.','rule','important',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(2,1,'Mobile Phones Must Be on Silent','All phone calls must be attended outside the study area in the designated balcony zone.','rule','important',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(3,1,'Clean Desk & Waste Disposal','Please clear all papers and bottles into dustbins before leaving your desk.','rule','normal',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(4,1,'No Food / Beverages in Study Hall','Snacks and lunch are only allowed in the student cafeteria / breakout lounge.','rule','normal',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(5,1,'Operating Hours Notice','Morning Slot: 8:00 AM - 2:00 PM | Evening Slot: 2:00 PM - 8:00 PM | Full Day: 8:00 AM - 10:00 PM.','timing','important',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(6,1,'Campus High-Speed Wi-Fi Upgraded','We upgraded to 150 Mbps fiber broadband. Log in with your registered phone number.','notice','normal',1,'2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `notices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('fee_reminder','pending_payment','vacant_seat','smart_vacancy_alert','notice','general') NOT NULL DEFAULT 'general',
  `badge` varchar(255) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_user_id_foreign` (`user_id`),
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,4,'Fee Reminder: 3 Days Left','Reminder: Only 3 days left before your 3 Months Prime Pass subscription expires. Renew to retain your desk.','fee_reminder','Reminder','{\"days_remaining\":3,\"plan_name\":\"3 Months Prime Pass\"}',0,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(2,3,'Library Seat Available!','Seat G-01 is now available! Book within 5 minutes.','smart_vacancy_alert','New','{\"seat_number\":\"G-01\",\"booking_window_minutes\":5}',0,'2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otps`
--

DROP TABLE IF EXISTS `otps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `otps` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `otp` varchar(10) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'registration',
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `otps_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otps`
--

LOCK TABLES `otps` WRITE;
/*!40000 ALTER TABLE `otps` DISABLE KEYS */;
/*!40000 ALTER TABLE `otps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `booking_id` bigint(20) unsigned DEFAULT NULL,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `plan_id` bigint(20) unsigned DEFAULT NULL,
  `collected_by` bigint(20) unsigned DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'seat_booking',
  `currency` varchar(10) NOT NULL DEFAULT 'INR',
  `payment_method` enum('cash','upi','online_razorpay','online_stripe','card') NOT NULL DEFAULT 'cash',
  `transaction_id` varchar(255) DEFAULT NULL,
  `status` enum('completed','pending','failed','refunded') NOT NULL DEFAULT 'completed',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `payments_transaction_id_unique` (`transaction_id`),
  KEY `payments_user_id_foreign` (`user_id`),
  KEY `payments_booking_id_foreign` (`booking_id`),
  KEY `payments_plan_id_foreign` (`plan_id`),
  KEY `payments_collected_by_foreign` (`collected_by`),
  KEY `payments_library_id_foreign` (`library_id`),
  CONSTRAINT `payments_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payments_collected_by_foreign` FOREIGN KEY (`collected_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payments_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payments_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE SET NULL,
  CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,3,1,NULL,1,1,80.00,'seat_booking','INR','cash','TXN-CASH-1001','completed','Counter cash payment paid to reception.','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,4,NULL,NULL,3,1,150.00,'seat_booking','INR','upi','UPI-9822334455@okaxis-01','completed','Direct QR scan UPI payment.','2026-11-14 09:44:37','2026-11-14 09:44:37'),(3,5,NULL,NULL,4,NULL,2200.00,'seat_booking','INR','online_razorpay','pay_rzp_f59bf7857804a2','completed','Online payment via Razorpay checkout.','2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plans`
--

DROP TABLE IF EXISTS `plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration_days` int(11) NOT NULL DEFAULT 1,
  `shift` enum('morning','evening','full_day','all') NOT NULL DEFAULT 'morning',
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plans`
--

LOCK TABLES `plans` WRITE;
/*!40000 ALTER TABLE `plans` DISABLE KEYS */;
INSERT INTO `plans` VALUES (1,'Morning Shift Pass (8 AM - 2 PM)',80.00,1,'morning','Single day entry for the silent study morning slot.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,'Evening Shift Pass (2 PM - 8 PM)',80.00,1,'evening','Single day entry for the evening slot.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(3,'Full Day Study Pass (8 AM - 8 PM)',150.00,1,'full_day','Full access with high speed WiFi and power socket.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(4,'1 Month Regular Pass (30 Days)',2000.00,30,'all','Dedicated seat access with AC, high-speed Wi-Fi, and locker for 1 Month.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(5,'3 Months Prime Pass (90 Days)',5400.00,90,'all','Popular quarterly pack with free locker allocation and priority seat selection.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(6,'6 Months Executive Pass (180 Days)',9900.00,180,'all','Half-yearly pass tailored for competitive exam preparation with complimentary locker.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(7,'1 Year VIP Annual Pass (365 Days)',18000.00,365,'all','Ultimate 1-Year unlimited access pass with permanent seat reservation.',1,'2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats`
--

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `zone_id` bigint(20) unsigned DEFAULT NULL,
  `seat_number` varchar(255) NOT NULL,
  `status` enum('available','occupied','reserved','maintenance') NOT NULL DEFAULT 'available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `seats_zone_id_foreign` (`zone_id`),
  KEY `seats_library_id_foreign` (`library_id`),
  CONSTRAINT `seats_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `seats_zone_id_foreign` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seats`
--

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` VALUES (1,1,1,'G-01','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,1,1,'G-02','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(3,1,1,'G-03','reserved','2026-11-14 09:44:37','2026-11-14 09:44:37'),(4,1,1,'G-04','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(5,1,1,'G-05','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(6,1,1,'G-06','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(7,1,1,'G-07','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(8,1,1,'G-08','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(9,1,1,'G-09','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(10,1,1,'G-10','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(11,1,2,'F-01','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(12,1,2,'F-02','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(13,1,2,'F-03','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(14,1,2,'F-04','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(15,1,2,'F-05','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(16,1,2,'F-06','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(17,1,2,'F-07','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(18,1,2,'F-08','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(19,1,2,'F-09','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(20,1,2,'F-10','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(21,1,3,'D-01','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(22,1,3,'D-02','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(23,1,3,'D-03','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(24,1,3,'D-04','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(25,1,3,'D-05','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(26,1,3,'D-06','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(27,1,3,'D-07','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(28,1,3,'D-08','occupied','2026-11-14 09:44:37','2026-11-14 09:44:37'),(29,1,3,'D-09','available','2026-11-14 09:44:37','2026-11-14 09:44:37'),(30,1,3,'D-10','available','2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES ('rwasOrQa955s1pvONVYrFTJbZPwFZpZyfnqSJhoz',2,'127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36','eyJfdG9rZW4iOiJMWld5YkhXTjFOT0JGanBwZ05oU3RLbmpFVDFCTnJMWGNTVkRSaVh2IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9hZG1pblwvYm9va2luZ3MiLCJyb3V0ZSI6ImFkbWluLmJvb2tpbmdzIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfSwibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiOjIsInBhc3N3b3JkX2hhc2hfd2ViIjoiOGQ2OWVkMmI4ODY3ODYxNjQyNTgyMjJiZmJjNzdkNDcwNDhhZDk4N2Y5MjcwM2JlZTJkNTMxYThlYzAyMzY0OSJ9',1794670423);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `smart_vacancy_alerts`
--

DROP TABLE IF EXISTS `smart_vacancy_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smart_vacancy_alerts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `seat_id` bigint(20) unsigned NOT NULL,
  `shift` enum('morning','evening','full_day') NOT NULL DEFAULT 'full_day',
  `alert_date` date NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT 'Library Seat Available!',
  `message` text NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','claimed','expired') NOT NULL DEFAULT 'active',
  `claimed_by` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `smart_vacancy_alerts_library_id_foreign` (`library_id`),
  KEY `smart_vacancy_alerts_seat_id_foreign` (`seat_id`),
  KEY `smart_vacancy_alerts_claimed_by_foreign` (`claimed_by`),
  KEY `smart_vacancy_alerts_alert_date_index` (`alert_date`),
  CONSTRAINT `smart_vacancy_alerts_claimed_by_foreign` FOREIGN KEY (`claimed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `smart_vacancy_alerts_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `smart_vacancy_alerts_seat_id_foreign` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smart_vacancy_alerts`
--

LOCK TABLES `smart_vacancy_alerts` WRITE;
/*!40000 ALTER TABLE `smart_vacancy_alerts` DISABLE KEYS */;
INSERT INTO `smart_vacancy_alerts` VALUES (1,1,1,'full_day','2026-11-14','Library Seat Available!','Seat G-01 is now available! Book within 5 minutes.','2026-11-14 09:49:38','active',NULL,'2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `smart_vacancy_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `plan_id` bigint(20) unsigned NOT NULL,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `seat_id` bigint(20) unsigned DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('active','expired','cancelled','pending_payment') NOT NULL DEFAULT 'active',
  `auto_renew` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptions_user_id_foreign` (`user_id`),
  KEY `subscriptions_plan_id_foreign` (`plan_id`),
  KEY `subscriptions_library_id_foreign` (`library_id`),
  KEY `subscriptions_seat_id_foreign` (`seat_id`),
  CONSTRAINT `subscriptions_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `subscriptions_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subscriptions_seat_id_foreign` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`) ON DELETE SET NULL,
  CONSTRAINT `subscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (1,3,4,1,3,'2026-10-25','2026-11-24','active',1,'2026-11-14 09:44:38','2026-11-14 09:44:38'),(2,4,5,1,4,'2026-08-19','2026-11-17','active',0,'2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','staff','manager','member','user') NOT NULL DEFAULT 'member',
  `status` enum('active','blocked') NOT NULL DEFAULT 'active',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_phone_unique` (`phone`),
  UNIQUE KEY `users_google_id_unique` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Library Staff','staff@library.com',NULL,NULL,'9876543210','$2y$12$fUv0yjn8K.jdwq1jm2dLC.a8gnY8tC/FSllo/zcmY94SXQ9RQymc.','staff','active',NULL,NULL,'2026-11-14 09:44:35','2026-11-14 09:44:35'),(2,'Library Admin','admin@library.com',NULL,NULL,'9876543211','$2y$12$pMpK6oWVpHUhNZFkx8G4IO0Xj7d27sV4SsYLfLS9mWSI2Y9wnAN1S','admin','active',NULL,NULL,'2026-11-14 09:44:36','2026-11-14 09:44:36'),(3,'John Doe','member@library.com',NULL,NULL,'9123456780','$2y$12$OJfgVGeIZJL7mvOuWw8OyOpsKm4hj1Xor5l9sIGje805ubtpP4aNC','member','active',NULL,NULL,'2026-11-14 09:44:36','2026-11-14 09:44:36'),(4,'Priya Sharma','priya@example.com',NULL,NULL,'9822334455','$2y$12$IxHOmda9D8v07/YC58QssORcuTzTWSlYiNXYQRxsYAg7la0GBWCCS','member','active',NULL,NULL,'2026-11-14 09:44:36','2026-11-14 09:44:36'),(5,'Rahul Verma','rahul@example.com',NULL,NULL,'9811223344','$2y$12$bUIkW4505vWIe8HWCP7hu.Nva17JwXPHKyGjnjYfXGajBDu2bU4Ju','member','active',NULL,NULL,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(6,'Vikram Malhotra','manager@library.com',NULL,NULL,'9822001122','$2y$12$zGuiR5FawrGwe8j/Lbz7vufk5kxI9X4pVFZiJgkJ4MtrGBscMQrBK','manager','active',NULL,NULL,'2026-11-14 09:44:37','2026-11-14 09:44:37'),(7,'Sunil Deshmukh','sunil@studyhaven.in',NULL,NULL,'9822003344','$2y$12$/pn/lcm1RspZQ3K1idTj7ezUbsEy.UXcIjDsYPJRrBw5sa4E6AAu6','manager','active',NULL,NULL,'2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waiting_lists`
--

DROP TABLE IF EXISTS `waiting_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waiting_lists` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `library_id` bigint(20) unsigned DEFAULT NULL,
  `zone_id` bigint(20) unsigned DEFAULT NULL,
  `seat_id` bigint(20) unsigned DEFAULT NULL,
  `shift` enum('morning','evening','full_day','any') NOT NULL DEFAULT 'full_day',
  `desired_date` date NOT NULL,
  `status` enum('waiting','notified','fulfilled','cancelled') NOT NULL DEFAULT 'waiting',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `waiting_lists_user_id_foreign` (`user_id`),
  KEY `waiting_lists_library_id_foreign` (`library_id`),
  KEY `waiting_lists_zone_id_foreign` (`zone_id`),
  KEY `waiting_lists_seat_id_foreign` (`seat_id`),
  KEY `waiting_lists_desired_date_index` (`desired_date`),
  CONSTRAINT `waiting_lists_library_id_foreign` FOREIGN KEY (`library_id`) REFERENCES `libraries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `waiting_lists_seat_id_foreign` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`) ON DELETE SET NULL,
  CONSTRAINT `waiting_lists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `waiting_lists_zone_id_foreign` FOREIGN KEY (`zone_id`) REFERENCES `zones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiting_lists`
--

LOCK TABLES `waiting_lists` WRITE;
/*!40000 ALTER TABLE `waiting_lists` DISABLE KEYS */;
INSERT INTO `waiting_lists` VALUES (1,5,1,NULL,NULL,'morning','2026-11-14','waiting','2026-11-14 09:44:38','2026-11-14 09:44:38');
/*!40000 ALTER TABLE `waiting_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zones`
--

DROP TABLE IF EXISTS `zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zones_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zones`
--

LOCK TABLES `zones` WRITE;
/*!40000 ALTER TABLE `zones` DISABLE KEYS */;
INSERT INTO `zones` VALUES (1,'Ground Floor - Silent Zone','GF-SZ','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,'First Floor - AC Hall','FF-AC','2026-11-14 09:44:37','2026-11-14 09:44:37'),(3,'Second Floor - Discussion Hall','SF-DH','2026-11-14 09:44:37','2026-11-14 09:44:37');
/*!40000 ALTER TABLE `zones` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-15 13:10:07

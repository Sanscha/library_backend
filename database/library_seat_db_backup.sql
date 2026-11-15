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
INSERT INTO `libraries` VALUES (1,6,'Apex Central Study Hub','apex-central-study-hub',NULL,'402 Prestige Point, Shukrawar Peth','Pune','Maharashtra','411002',NULL,NULL,'9822001122','contact@apexcentral.in','Premium air-conditioned study hall with high-speed WiFi and individual ergonomic seating.','[\"High Speed WiFi\",\"Air Conditioned\",\"Power Outlets\",\"RO Water Dispenser\",\"CCTV Security\"]',60,499.00,'paid','active','2026-11-14 09:44:37','2026-11-14 09:44:37'),(2,7,'Study Haven Reading Room','study-haven-reading-room',NULL,'12 Near Modern College, Shivajinagar','Pune','Maharashtra','411005',NULL,NULL,'9822003344','info@studyhaven.in','Dedicated silent reading room designed for UPSC and competitive exam aspirants.','[\"Silent Zones\",\"Newspaper Desk\",\"Lockers\",\"Power Sockets\"]',40,499.00,'unpaid','pending_payment','2026-11-14 09:44:37','2026-11-14 09:44:37');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_10_29_000001_create_library_seats_tables',1),(5,'2026_10_29_000002_create_plans_and_payments_tables',1),(6,'2026_10_29_160444_create_personal_access_tokens_table',1),(7,'2026_10_31_000001_create_libraries_and_otps_tables',1),(8,'2026_11_14_150844_create_library_advanced_features_tables',1);
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

-- Dump completed on 2026-11-15 12:13:55

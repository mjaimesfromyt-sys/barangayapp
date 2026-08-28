-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.3 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for barangayapp
CREATE DATABASE IF NOT EXISTS `barangayapp` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `barangayapp`;

-- Dumping structure for table barangayapp.announcements
CREATE TABLE IF NOT EXISTS `announcements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL DEFAULT '1',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `announcements_created_by_foreign` (`created_by`),
  KEY `announcements_is_published_published_at_index` (`is_published`,`published_at`),
  CONSTRAINT `announcements_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.announcements: ~1 rows (approximately)
INSERT INTO `announcements` (`id`, `title`, `body`, `category`, `is_published`, `is_pinned`, `published_at`, `created_by`, `created_at`, `updated_at`) VALUES
	(1, 'Releasing Senior Citizen hunorariom', 'Please be at the San Jose Covered Court for the releasing of Senior Citizen hunorariom', 'Notice', 1, 1, '2026-08-25 08:58:58', 1, '2026-08-25 08:58:36', '2026-08-25 08:58:58');

-- Dumping structure for table barangayapp.bookings
CREATE TABLE IF NOT EXISTS `bookings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `facility_id` bigint unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `admin_remarks` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_user_id_foreign` (`user_id`),
  KEY `bookings_facility_id_foreign` (`facility_id`),
  KEY `bookings_reviewed_by_foreign` (`reviewed_by`),
  CONSTRAINT `bookings_facility_id_foreign` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.bookings: ~1 rows (approximately)
INSERT INTO `bookings` (`id`, `user_id`, `facility_id`, `start_date`, `end_date`, `start_time`, `end_time`, `purpose`, `status`, `reviewed_by`, `admin_remarks`, `created_at`, `updated_at`) VALUES
	(1, 2, 4, '2026-08-25', '2026-08-25', '16:55:00', '20:00:00', 'Basketball', 'approved', 1, NULL, '2026-08-25 08:55:58', '2026-08-25 08:56:29');

-- Dumping structure for table barangayapp.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.cache: ~0 rows (approximately)

-- Dumping structure for table barangayapp.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.cache_locks: ~0 rows (approximately)

-- Dumping structure for table barangayapp.document_requests
CREATE TABLE IF NOT EXISTS `document_requests` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `transaction_type_id` bigint unsigned NOT NULL,
  `claim_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','validated','claimed','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_remarks` text COLLATE utf8mb4_unicode_ci,
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `validated_at` timestamp NULL DEFAULT NULL,
  `claimed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_requests_claim_code_unique` (`claim_code`),
  KEY `document_requests_user_id_foreign` (`user_id`),
  KEY `document_requests_transaction_type_id_foreign` (`transaction_type_id`),
  KEY `document_requests_reviewed_by_foreign` (`reviewed_by`),
  CONSTRAINT `document_requests_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `document_requests_transaction_type_id_foreign` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `document_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.document_requests: ~1 rows (approximately)
INSERT INTO `document_requests` (`id`, `user_id`, `transaction_type_id`, `claim_code`, `purpose`, `status`, `admin_remarks`, `reviewed_by`, `validated_at`, `claimed_at`, `created_at`, `updated_at`) VALUES
	(1, 2, 3, 'BRGY-2026-0001', 'passport', 'claimed', NULL, 1, '2026-08-25 08:51:53', '2026-08-25 09:02:35', '2026-08-25 08:50:52', '2026-08-25 09:02:35');

-- Dumping structure for table barangayapp.equipment
CREATE TABLE IF NOT EXISTS `equipment` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `total_stock` int unsigned NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `equipment_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.equipment: ~2 rows (approximately)
INSERT INTO `equipment` (`id`, `name`, `description`, `total_stock`, `is_active`, `created_at`, `updated_at`) VALUES
	(1, 'Tent', 'Temporary shelter for outdoor events, gatherings, and community activities.', 2, 1, '2026-08-23 05:13:44', '2026-08-23 05:13:44'),
	(2, 'Chairs', 'Seating equipment available for meetings, programs, and community events.', 200, 1, '2026-08-23 05:14:06', '2026-08-23 05:14:06'),
	(3, 'Tables', 'Tables available for meetings, events, food service, and other barangay activities.', 10, 1, '2026-08-23 05:14:28', '2026-08-23 05:14:28');

-- Dumping structure for table barangayapp.equipment_rentals
CREATE TABLE IF NOT EXISTS `equipment_rentals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `purpose` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected','released','returned') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `reviewed_by` bigint unsigned DEFAULT NULL,
  `admin_remarks` text COLLATE utf8mb4_unicode_ci,
  `released_at` timestamp NULL DEFAULT NULL,
  `returned_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `equipment_rentals_user_id_foreign` (`user_id`),
  KEY `equipment_rentals_reviewed_by_foreign` (`reviewed_by`),
  CONSTRAINT `equipment_rentals_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `equipment_rentals_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.equipment_rentals: ~1 rows (approximately)
INSERT INTO `equipment_rentals` (`id`, `user_id`, `start_date`, `end_date`, `purpose`, `status`, `reviewed_by`, `admin_remarks`, `released_at`, `returned_at`, `created_at`, `updated_at`) VALUES
	(1, 2, '2026-08-26', '2026-08-27', 'Birthday', 'returned', 1, NULL, '2026-08-23 05:32:46', '2026-08-25 08:54:21', '2026-08-23 05:32:00', '2026-08-25 08:54:21');

-- Dumping structure for table barangayapp.equipment_rental_items
CREATE TABLE IF NOT EXISTS `equipment_rental_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `equipment_rental_id` bigint unsigned NOT NULL,
  `equipment_id` bigint unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `equipment_rental_items_equipment_rental_id_equipment_id_unique` (`equipment_rental_id`,`equipment_id`),
  KEY `equipment_rental_items_equipment_id_foreign` (`equipment_id`),
  CONSTRAINT `equipment_rental_items_equipment_id_foreign` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `equipment_rental_items_equipment_rental_id_foreign` FOREIGN KEY (`equipment_rental_id`) REFERENCES `equipment_rentals` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.equipment_rental_items: ~2 rows (approximately)
INSERT INTO `equipment_rental_items` (`id`, `equipment_rental_id`, `equipment_id`, `quantity`, `created_at`, `updated_at`) VALUES
	(1, 1, 2, 20, '2026-08-23 05:32:00', '2026-08-23 05:32:00'),
	(2, 1, 3, 10, '2026-08-23 05:32:00', '2026-08-23 05:32:00'),
	(3, 1, 1, 2, '2026-08-23 05:32:00', '2026-08-23 05:32:00');

-- Dumping structure for table barangayapp.events
CREATE TABLE IF NOT EXISTS `events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `facility_id` bigint unsigned DEFAULT NULL,
  `blocks_facility` tinyint(1) NOT NULL DEFAULT '0',
  `created_by` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_facility_id_foreign` (`facility_id`),
  KEY `events_created_by_foreign` (`created_by`),
  CONSTRAINT `events_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `events_facility_id_foreign` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.events: ~1 rows (approximately)
INSERT INTO `events` (`id`, `title`, `description`, `start_date`, `end_date`, `start_time`, `end_time`, `facility_id`, `blocks_facility`, `created_by`, `created_at`, `updated_at`) VALUES
	(1, 'Beauty Contest Bibini San Joose', 'Beauty pageant for 18-25 years old.', '2026-08-31', '2026-08-31', '07:00:00', '23:00:00', 2, 1, 1, '2026-08-25 09:01:08', '2026-08-25 09:01:08');

-- Dumping structure for table barangayapp.facilities
CREATE TABLE IF NOT EXISTS `facilities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `capacity` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.facilities: ~4 rows (approximately)
INSERT INTO `facilities` (`id`, `name`, `description`, `capacity`, `is_active`, `created_at`, `updated_at`) VALUES
	(1, 'Barangay Hall', 'Office for barangay administration and public services.', 50, 1, '2026-08-23 05:11:29', '2026-08-23 05:11:29'),
	(2, 'Barangay Covered Court', 'Used for sports, events, and community activities.', 200, 1, '2026-08-23 05:11:53', '2026-08-23 05:11:53'),
	(3, 'Barangay Evacuation Center', 'Temporary shelter during emergencies and disasters.', 200, 1, '2026-08-23 05:12:16', '2026-08-23 05:12:16'),
	(4, 'Barangay Basketball Court', 'Sports and recreational facility.', 200, 1, '2026-08-23 05:12:38', '2026-08-23 05:12:38');

-- Dumping structure for table barangayapp.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.failed_jobs: ~0 rows (approximately)

-- Dumping structure for table barangayapp.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.jobs: ~0 rows (approximately)

-- Dumping structure for table barangayapp.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.job_batches: ~0 rows (approximately)

-- Dumping structure for table barangayapp.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.migrations: ~0 rows (approximately)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2026_06_08_143901_add_role_fields_to_users_table', 1),
	(5, '2026_06_09_045915_create_facilities_table', 1),
	(6, '2026_06_09_045952_create_bookings_table', 1),
	(7, '2026_06_09_063527_convert_bookings_to_date_range', 1),
	(8, '2026_06_10_070555_add_resident_type_to_users', 1),
	(9, '2026_06_10_070654_normalize_user_status_values', 1),
	(10, '2026_06_11_035618_refine_users_registration_fields', 1),
	(11, '2026_06_11_065431_drop_legacy_name_column_from_users', 1),
	(12, '2026_06_11_133225_create_transaction_types_table', 1),
	(13, '2026_06_11_133249_create_requirements_table', 1),
	(14, '2026_06_22_014144_create_events_table', 1),
	(15, '2026_06_23_055739_create_document_requests_table', 1),
	(16, '2026_07_28_000000_create_announcements_table', 1),
	(17, '2026_08_23_000001_create_equipment_tables', 1);

-- Dumping structure for table barangayapp.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table barangayapp.requirements
CREATE TABLE IF NOT EXISTS `requirements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `transaction_type_id` bigint unsigned NOT NULL,
  `item` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `requirements_transaction_type_id_foreign` (`transaction_type_id`),
  CONSTRAINT `requirements_transaction_type_id_foreign` FOREIGN KEY (`transaction_type_id`) REFERENCES `transaction_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.requirements: ~5 rows (approximately)
INSERT INTO `requirements` (`id`, `transaction_type_id`, `item`, `created_at`, `updated_at`) VALUES
	(1, 1, '2 Valid ID\'s', '2026-08-23 05:07:59', '2026-08-23 05:07:59'),
	(2, 2, 'Valid Government-Issued ID', '2026-08-23 05:09:22', '2026-08-23 05:09:22'),
	(3, 2, 'DTI/SEC Registration', '2026-08-23 05:09:28', '2026-08-23 05:09:28'),
	(5, 2, 'Barangay Clearance', '2026-08-23 05:09:46', '2026-08-23 05:09:46'),
	(6, 3, '1 Valid ID', '2026-08-25 08:51:30', '2026-08-25 08:51:30');

-- Dumping structure for table barangayapp.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.sessions: ~2 rows (approximately)
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
	('0Kqt5Xx2pbKxjK4rl53KD6e3zZU3DihRTSFaWYhD', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiI5ODVQaVdNdmtRTGplWDl2RmlFcm5GNEJIZDZwdHloMDJMU2V5U0xnIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9yZXF1ZXN0cyIsInJvdXRlIjoicmVxdWVzdHMuaW5kZXgifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6Mn0=', 1787648537),
	('C5Pedbym38Z3W7trI8NQlPwRoq9F5aqCpWsrVpcF', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJlSE13THhCdlFNaWFXZDdDSVpOMEFBUzlPNWpUNjczTHpDSkthWTByIiwiX2ZsYXNoIjp7Im5ldyI6W10sIm9sZCI6W119LCJfcHJldmlvdXMiOnsidXJsIjoiaHR0cDpcL1wvMTI3LjAuMC4xOjgwMDBcL2FkbWluXC9yZW50YWxzIiwicm91dGUiOiJhZG1pbi5yZW50YWxzLmluZGV4In0sImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjoxfQ==', 1787648572);

-- Dumping structure for table barangayapp.transaction_types
CREATE TABLE IF NOT EXISTS `transaction_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `requires_residency` tinyint(1) NOT NULL DEFAULT '1',
  `fee` decimal(8,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.transaction_types: ~3 rows (approximately)
INSERT INTO `transaction_types` (`id`, `name`, `description`, `requires_residency`, `fee`, `is_active`, `created_at`, `updated_at`) VALUES
	(1, 'Barangay Clearance', 'A certificate confirming a resident’s identity, residency, and good standing in the barangay.', 1, 50.00, 1, '2026-08-23 05:07:26', '2026-08-23 05:07:26'),
	(2, 'Barangay Business Permit', 'A permit issued by the barangay authorizing a business to operate within the barangay and confirming compliance with local barangay requirements.', 0, 500.00, 1, '2026-08-23 05:09:08', '2026-08-23 05:09:08'),
	(3, 'Community Tax Certificate (Cedula)', 'A certificate issued to individuals or businesses as proof of payment of the community tax.', 1, 20.00, 1, '2026-08-23 05:10:39', '2026-08-23 05:15:00');

-- Dumping structure for table barangayapp.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `suffix` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('admin','resident','official') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'resident',
  `status` enum('pending','active','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `resident_type` enum('resident','non_resident') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by` bigint unsigned DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `contact_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `purok` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `declared_type` enum('resident','non_resident') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_verified_by_foreign` (`verified_by`),
  CONSTRAINT `users_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table barangayapp.users: ~2 rows (approximately)
INSERT INTO `users` (`id`, `first_name`, `middle_name`, `last_name`, `suffix`, `email`, `role`, `status`, `resident_type`, `verified_at`, `verified_by`, `rejection_reason`, `contact_no`, `address`, `purok`, `declared_type`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'Patricia', NULL, 'Deresas', NULL, 'patricia@mdaworks.com', 'admin', 'active', 'resident', '2026-08-23 05:05:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '$2y$12$R65yVfTGrLhhChV4PfBHeOfPG5.h71NZ5B8CEu1RF9X9reWVo1OI2', NULL, '2026-08-23 05:05:23', '2026-08-23 05:05:23'),
	(2, 'Jason', NULL, 'Butas', NULL, 'jasonbutas@gmail.com', 'resident', 'active', 'resident', '2026-08-23 05:31:05', 1, NULL, '09519055506', '16 Fairway St, Frankston  VIC 3199', '1', 'resident', NULL, '$2y$12$FRa2gwJFyVO8IMC6rXk.auYaBm4iZsJINsjoU196EyYfZRc9HQRo2', NULL, '2026-08-23 05:22:31', '2026-08-23 05:31:05');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

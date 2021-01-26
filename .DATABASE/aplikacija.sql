/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

DROP DATABASE IF EXISTS `aplikacija`;
CREATE DATABASE IF NOT EXISTS `aplikacija` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `aplikacija`;

DROP TABLE IF EXISTS `administrator`;
CREATE TABLE IF NOT EXISTS `administrator` (
  `administrator_id` int unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `password_hash` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`administrator_id`),
  UNIQUE KEY `uq_administrator_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `administrator`;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` (`administrator_id`, `username`, `password_hash`) VALUES
	(3, 'P Peric', 'AC4617DA53E646CCE8B7A184C64201378ECC84190BD39E368BF775E277BF4F20D0B67322A4854F8E26C8B49F35D777834AE2B82F8E2852B7677B488872BC4647'),
	(8, 'mmilic', '3D78FA33DA6FF21CD813E5F79354B027A2EFFD8DFBC6BB4F33E3792F8EF95E63C0F42247CCFAE83F5E3BAABCDDCC0887290C2476B474F2D2E72EF1BE6ABAD1C5'),
	(9, 'admin', '52D228DE17AC90DA4F7D20CE7DCB3A0E3C0B0A49B86E35FA6559F90E67185C83AA202521CD9578D48DBED8CD9BC55E32E4A56ED850A0CD9A95CB44268A8A8D36'),
	(11, 'alex', '35F319CA1DFC9689F5A33631C8F93ED7C3120EE7AFA05B1672C7DF7B71F63A6753DEF5FD3AC9DB2EAF90CCAB6BFF31A486B51C7095FF958D228102B84EFD7736'),
	(12, 'AlexAdmin007', 'B5E111C082F167D58866CF675DB3A3AE1EAC78DC15AF059E294D96EABC244B36F26AD889A19E7108F864DE2F40D3048BBBFA7276D0D8EF1DFD565BC440CE11FD');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;

DROP TABLE IF EXISTS `article`;
CREATE TABLE IF NOT EXISTS `article` (
  `article_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `category_id` int unsigned NOT NULL DEFAULT '0',
  `excerpt` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `description` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `status` enum('aviable','visible','hidden') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'aviable',
  `is_promoted` tinyint unsigned NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`article_id`),
  KEY `fk_article_category_id` (`category_id`),
  CONSTRAINT `fk_article_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article`;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` (`article_id`, `name`, `category_id`, `excerpt`, `description`, `status`, `is_promoted`, `created_at`) VALUES
	(1, 'ACME HDD 512GB', 7, 'Kratak opis', 'Detaljan opis', 'aviable', 0, '2020-12-15 12:48:10'),
	(2, '1024GB', 7, 'Novi kratki tekst...', 'Novi duzi tekst...', 'visible', 1, '2020-12-16 12:12:34'),
	(3, 'ACME HDD11 1TB', 7, 'Neki kratak tekst', 'Neki malo duzi tekst o proizvodu', 'aviable', 0, '2020-12-16 12:16:54'),
	(5, 'ACME HDD11 1TB', 7, 'Neki kratak tekst', 'Neki malo duzi tekst o proizvodu', 'aviable', 0, '2020-12-16 12:21:41'),
	(6, 'ACME HDD11 1TB', 7, 'Neki kratak tekst', 'Neki malo duzi tekst o proizvodu', 'aviable', 0, '2020-12-16 12:22:17'),
	(7, 'ACME HDD11 1TB', 7, 'Neki kratak tekst', 'Neki malo duzi tekst o proizvodu', 'aviable', 0, '2020-12-16 12:24:08'),
	(8, 'ACME 512GB', 7, 'Kratak tekst', 'Duzi tekst o proizvodu', 'aviable', 0, '2020-12-16 12:25:29'),
	(9, 'ACME 3344', 3, 'Laptop kratki opis', 'Laptop dosta duzi opis ', 'aviable', 0, '2020-12-30 16:18:27');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;

DROP TABLE IF EXISTS `article_feature`;
CREATE TABLE IF NOT EXISTS `article_feature` (
  `article_feature_id` int unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int unsigned NOT NULL DEFAULT '0',
  `feature_id` int unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`article_feature_id`),
  UNIQUE KEY `uq_article_feature_article_id_feature_id` (`article_id`,`feature_id`),
  KEY `fk_article_feature_feature_id` (`feature_id`),
  CONSTRAINT `fk_article_feature_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_article_feature_feature_id` FOREIGN KEY (`feature_id`) REFERENCES `feature` (`feature_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article_feature`;
/*!40000 ALTER TABLE `article_feature` DISABLE KEYS */;
INSERT INTO `article_feature` (`article_feature_id`, `article_id`, `feature_id`, `value`) VALUES
	(1, 1, 1, '512GB'),
	(2, 1, 2, 'SATA3'),
	(3, 1, 4, 'SSD'),
	(6, 3, 1, '1TB'),
	(8, 5, 1, '1TB'),
	(9, 9, 9, '15.6"'),
	(10, 6, 1, '1TB'),
	(12, 7, 1, '1TB'),
	(13, 8, 1, '512'),
	(14, 8, 4, 'SSD'),
	(17, 2, 1, '1024gbblabla'),
	(18, 2, 2, 'SATA 3.0'),
	(20, 9, 11, 'Bez OS');
/*!40000 ALTER TABLE `article_feature` ENABLE KEYS */;

DROP TABLE IF EXISTS `article_price`;
CREATE TABLE IF NOT EXISTS `article_price` (
  `article_price_id` int unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int unsigned NOT NULL DEFAULT '0',
  `price` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`article_price_id`),
  KEY `fk_article_price_article_id` (`article_id`),
  CONSTRAINT `fk_article_price_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `article_price`;
/*!40000 ALTER TABLE `article_price` DISABLE KEYS */;
INSERT INTO `article_price` (`article_price_id`, `article_id`, `price`, `created_at`) VALUES
	(1, 1, 45.00, '2020-12-15 13:03:51'),
	(2, 1, 43.56, '2020-12-15 13:04:05'),
	(3, 2, 56.89, '2020-12-16 12:12:34'),
	(5, 5, 56.89, '2020-12-16 12:21:41'),
	(6, 6, 56.89, '2020-12-16 12:22:17'),
	(7, 7, 56.89, '2020-12-16 12:24:08'),
	(8, 8, 36.89, '2020-12-16 12:25:29'),
	(9, 2, 57.11, '2020-12-23 12:03:58'),
	(10, 9, 340.00, '2020-12-30 16:33:24');
/*!40000 ALTER TABLE `article_price` ENABLE KEYS */;

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `cart_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  KEY `fk_cart_user_id` (`user_id`),
  CONSTRAINT `fk_cart_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `cart`;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` (`cart_id`, `user_id`, `created_at`) VALUES
	(1, 1, '2020-12-28 15:57:13'),
	(2, 1, '2020-12-28 16:04:06'),
	(3, 1, '2020-12-30 10:50:56'),
	(4, 1, '2020-12-30 10:54:02'),
	(5, 1, '2020-12-30 10:56:18'),
	(6, 12, '2021-01-14 13:21:14'),
	(7, 12, '2021-01-14 13:26:56'),
	(8, 12, '2021-01-15 15:19:00'),
	(9, 12, '2021-01-15 15:20:10'),
	(10, 12, '2021-01-15 15:26:12'),
	(11, 12, '2021-01-15 15:28:50'),
	(12, 12, '2021-01-15 15:48:40'),
	(13, 12, '2021-01-15 15:49:22'),
	(14, 12, '2021-01-15 15:49:31');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;

DROP TABLE IF EXISTS `cart_article`;
CREATE TABLE IF NOT EXISTS `cart_article` (
  `cart_article_id` int unsigned NOT NULL AUTO_INCREMENT,
  `cart_id` int unsigned NOT NULL DEFAULT '0',
  `article_id` int unsigned NOT NULL DEFAULT '0',
  `quantity` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`cart_article_id`),
  UNIQUE KEY `uq_cart_article_cart_id_article_id` (`cart_id`,`article_id`),
  KEY `fk_cart_article_article_id` (`article_id`),
  CONSTRAINT `fk_cart_article_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_article_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `cart_article`;
/*!40000 ALTER TABLE `cart_article` DISABLE KEYS */;
INSERT INTO `cart_article` (`cart_article_id`, `cart_id`, `article_id`, `quantity`) VALUES
	(1, 1, 1, 4),
	(2, 1, 2, 2),
	(4, 3, 2, 2),
	(5, 4, 2, 2),
	(6, 5, 2, 1),
	(7, 6, 9, 1),
	(8, 6, 1, 2),
	(9, 7, 1, 2),
	(10, 7, 9, 1),
	(11, 8, 9, 1),
	(12, 9, 9, 1),
	(13, 10, 9, 1),
	(14, 11, 9, 1),
	(15, 12, 9, 1),
	(16, 13, 9, 1);
/*!40000 ALTER TABLE `cart_article` ENABLE KEYS */;

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `category_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `image_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `parent__category_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uq_category_name` (`name`),
  UNIQUE KEY `uq_category_image_path` (`image_path`),
  KEY `fk_category_parent__category_id` (`parent__category_id`),
  CONSTRAINT `fk_category_parent__category_id` FOREIGN KEY (`parent__category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `category`;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`category_id`, `name`, `image_path`, `parent__category_id`) VALUES
	(1, 'Računarske komponente', 'assets/pc.jpg', NULL),
	(2, 'Kućna elektronika', 'assets/home.jpg', NULL),
	(3, 'Laptop računari', 'assets/pc/laptop.jpg', 1),
	(4, 'Memorijski mediji', 'assets/pc/memory.jpg', 1),
	(7, 'Hard diskovi', 'assets/pc/memory/hdd.jpg', 4);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;

DROP TABLE IF EXISTS `feature`;
CREATE TABLE IF NOT EXISTS `feature` (
  `feature_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `category_id` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`feature_id`),
  UNIQUE KEY `uq_feature_name_category_id` (`name`,`category_id`),
  KEY `fk_feature_category_id` (`category_id`),
  CONSTRAINT `fk_feature_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `feature`;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
INSERT INTO `feature` (`feature_id`, `name`, `category_id`) VALUES
	(9, 'Dijagonala ekrana', 3),
	(1, 'Kapacitet', 7),
	(5, 'Napon', 2),
	(11, 'Operativni sistem', 3),
	(7, 'Proizdođač', 2),
	(8, 'Proizdođač', 3),
	(6, 'Snaga', 2),
	(4, 'Tehnologija', 7),
	(2, 'Tip', 7);
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `order_id` int unsigned NOT NULL AUTO_INCREMENT,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cart_id` int unsigned NOT NULL DEFAULT '0',
  `status` enum('rejected','accepted','shipped','pending') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uq_order_cart_id` (`cart_id`),
  CONSTRAINT `fk_order_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `order`;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` (`order_id`, `created_at`, `cart_id`, `status`) VALUES
	(1, '2020-12-28 16:03:51', 1, 'shipped'),
	(4, '2020-12-30 10:53:12', 3, 'pending'),
	(5, '2020-12-30 10:54:27', 4, 'pending'),
	(6, '2020-12-30 10:56:51', 5, 'pending'),
	(7, '2021-01-14 13:26:30', 6, 'pending'),
	(8, '2021-01-14 13:28:02', 7, 'pending'),
	(9, '2021-01-15 15:19:08', 8, 'pending'),
	(10, '2021-01-15 15:20:15', 9, 'accepted'),
	(11, '2021-01-15 15:26:22', 10, 'pending'),
	(12, '2021-01-15 15:28:56', 11, 'pending'),
	(13, '2021-01-15 15:48:49', 12, 'pending'),
	(14, '2021-01-15 15:49:30', 13, 'rejected');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;

DROP TABLE IF EXISTS `photo`;
CREATE TABLE IF NOT EXISTS `photo` (
  `photo_id` int unsigned NOT NULL AUTO_INCREMENT,
  `article_id` int unsigned NOT NULL,
  `photo_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`photo_id`),
  UNIQUE KEY `uq_photo_photo_path` (`photo_path`),
  KEY `fk_photo_article_id` (`article_id`),
  CONSTRAINT `fk_photo_article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`article_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `photo`;
/*!40000 ALTER TABLE `photo` DISABLE KEYS */;
INSERT INTO `photo` (`photo_id`, `article_id`, `photo_path`) VALUES
	(8, 2, '20201225-6442854328-kit.jpg');
/*!40000 ALTER TABLE `photo` ENABLE KEYS */;

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `password_hash` varchar(128) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `forename` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `surename` varchar(64) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `phone_number` varchar(24) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `postal_address` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_user_email` (`email`),
  UNIQUE KEY `uq_user_phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DELETE FROM `user`;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`user_id`, `email`, `password_hash`, `forename`, `surename`, `phone_number`, `postal_address`) VALUES
	(1, 'test@test.rs', 'DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F', 'Pera', 'Peric', '+3816312345678', 'Nepoznata'),
	(3, 'test12@test.rs', 'C70B5DD9EBFB6F51D09D4132B7170C9D20750A7852F00680F65658F0310E810056E6763C34C9A00B0E940076F54495C169FC2302CCEB312039271C43469507DC', 'Milan', 'Milanovic', '+38111300000', 'Nova adresa, Novi Sad'),
	(12, 'sale-alex@test.com', '60403C79BF4F544622D30090AA4D57B6F4903A85540F88335D7628D196135CF2A4FB871B433195300CD0BA6F98600C9A5CBBF5C45ABB183B10210574A8AF3761', 'sale', 'alex', '+38111300001', 'Nova adresa, Novi Sad'),
	(13, 'sale_user@test.rs', '90E75A8087D201994EF21099A7913F18497CBBB8D43CE2379245FC010308674C6880540350599E8DAD72353339BAC2D0355B6E048BF563FA13C559EEA4774B9B', 'sale', 'sasa', '+381631234568', 'Nepoznata bb');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

DROP TABLE IF EXISTS `user_token`;
CREATE TABLE IF NOT EXISTS `user_token` (
  `user_token_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `token` text NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_valid` tinyint unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_token_id`),
  KEY `fk_user_token_user_id` (`user_id`),
  CONSTRAINT `fk_user_token_user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `user_token`;
/*!40000 ALTER TABLE `user_token` DISABLE KEYS */;
INSERT INTO `user_token` (`user_token_id`, `user_id`, `created_at`, `token`, `expires_at`, `is_valid`) VALUES
	(1, 13, '2021-01-21 11:21:22', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsImlkIjoxMywiaWRlbnRpdHkiOiJzYWxlX3VzZXJAdGVzdC5ycyIsImV4cCI6MTYxMzkwMjg4Mi40NjUsImlwIjoiOjoxIiwidWEiOiJQb3N0bWFuUnVudGltZS83LjI2LjgiLCJpYXQiOjE2MTEyMjQ0ODJ9.xrVuOuOFvlRKovAk4yUUnv96f6X2xik5lsv3PY9jlMY', '2021-02-21 10:21:22', 1);
/*!40000 ALTER TABLE `user_token` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: aits
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance_history`
--

DROP TABLE IF EXISTS `attendance_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `employee_id` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` enum('Present','Delayed','On Leave','Absent') NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `employee_id` (`employee_id`),
  KEY `idx_attendance_history_tenant` (`tenant_id`),
  CONSTRAINT `attendance_history_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_attendance_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_history`
--

LOCK TABLES `attendance_history` WRITE;
/*!40000 ALTER TABLE `attendance_history` DISABLE KEYS */;
INSERT INTO `attendance_history` VALUES (71,1,'AITS001','2026-03-12','Manual entry - Delayed','Delayed','2026-03-12 05:25:15'),(72,1,'AITS001','2026-03-14','Manual entry - Delayed','Delayed','2026-03-14 07:31:10'),(73,NULL,'AITS004','2026-03-22','Face verification - Delayed','Delayed','2026-03-22 15:54:39'),(74,NULL,'AITS004','2026-03-22','Face verified attendance - Delayed','Delayed','2026-03-22 15:54:39'),(75,1,'AITS004','2026-03-22',' dynamic, versatile, and full-service Digital Marketing, Web Application, Android & IOS, AI/ML, iOT/ Embedded Development agency that doesn\'t rely on gimmicks or smoke and mirrors to earn clients. We ','On Leave','2026-03-22 16:05:40'),(76,1,'AITS004','2026-03-23',' dynamic, versatile, and full-service Digital Marketing, Web Application, Android & IOS, AI/ML, iOT/ Embedded Development agency that doesn\'t rely on gimmicks or smoke and mirrors to earn clients. We ','On Leave','2026-03-22 16:05:40'),(77,1,'AITS004','2026-03-24',' dynamic, versatile, and full-service Digital Marketing, Web Application, Android & IOS, AI/ML, iOT/ Embedded Development agency that doesn\'t rely on gimmicks or smoke and mirrors to earn clients. We ','On Leave','2026-03-22 16:05:40'),(78,1,'AITS004','2026-03-25',' dynamic, versatile, and full-service Digital Marketing, Web Application, Android & IOS, AI/ML, iOT/ Embedded Development agency that doesn\'t rely on gimmicks or smoke and mirrors to earn clients. We ','On Leave','2026-03-22 16:05:40'),(79,NULL,'AITS001','2026-04-02','Manual entry - Present','Present','2026-04-02 04:12:44'),(80,NULL,'AITS001','2026-04-04','Manual entry - Delayed','Delayed','2026-04-04 10:16:43'),(81,NULL,'AITS001','2026-04-06','Manual entry - Delayed','Delayed','2026-04-06 05:03:57'),(82,1,'AITS001','2026-04-07','sdtfyguhijo','On Leave','2026-04-07 06:10:48'),(83,1,'AITS001','2026-04-08','sdtfyguhijo','On Leave','2026-04-07 06:10:48'),(84,NULL,'AITS001','2026-04-07','Manual entry - Delayed','Delayed','2026-04-07 07:33:37'),(85,NULL,'AITS003','2026-04-07','Manual entry - Delayed','Delayed','2026-04-07 07:34:06'),(86,NULL,'AITS003','2026-04-08','Delayed - Regular attendance','Delayed','2026-04-08 05:26:32'),(87,1,'AITS001','2026-04-10','dfsddfa','On Leave','2026-04-09 07:47:15');
/*!40000 ALTER TABLE `attendance_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_documents`
--

DROP TABLE IF EXISTS `client_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `client_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('contract','proposal','report','other') DEFAULT 'other',
  `file_path` varchar(500) DEFAULT NULL,
  `upload_date` date DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `idx_client_docs_tenant` (`tenant_id`),
  CONSTRAINT `client_documents_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_client_docs_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_documents`
--

LOCK TABLES `client_documents` WRITE;
/*!40000 ALTER TABLE `client_documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_interactions`
--

DROP TABLE IF EXISTS `client_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_interactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `client_id` int NOT NULL,
  `type` enum('meeting','call','email') NOT NULL,
  `date` date NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `participants` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `idx_client_interactions_tenant` (`tenant_id`),
  CONSTRAINT `client_interactions_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_client_interactions_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_interactions`
--

LOCK TABLES `client_interactions` WRITE;
/*!40000 ALTER TABLE `client_interactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client_projects`
--

DROP TABLE IF EXISTS `client_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client_projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `client_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('planned','in-progress','completed','on-hold') DEFAULT 'planned',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `idx_client_projects_tenant` (`tenant_id`),
  CONSTRAINT `client_projects_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_client_projects_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_projects`
--

LOCK TABLES `client_projects` WRITE;
/*!40000 ALTER TABLE `client_projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `client_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `industry` varchar(100) DEFAULT NULL,
  `contact_person` varchar(255) NOT NULL,
  `contact_email` varchar(255) NOT NULL,
  `contact_phone` varchar(50) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `assigned_manager` varchar(255) DEFAULT NULL,
  `status` enum('active','prospective','inactive') DEFAULT 'prospective',
  `founded_year` varchar(10) DEFAULT NULL,
  `employees_count` int DEFAULT NULL,
  `revenue` varchar(50) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `notes` text,
  `preferred_contact` enum('email','phone','meeting') DEFAULT 'email',
  `follow_up_frequency` enum('daily','weekly','bi-weekly','monthly','quarterly') DEFAULT 'weekly',
  `next_follow_up` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_clients_tenant` (`tenant_id`),
  CONSTRAINT `fk_clients_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES (8,1,'DELL','Technology','Biil Zukerburg','BillBurg@gmail.com','8984398432','Earth','Aniruddha Manmode','active','',0,'','','','email','weekly',NULL,'2026-03-22 16:18:11','2026-03-22 16:18:11');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_enrollments`
--

DROP TABLE IF EXISTS `course_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_enrollments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `enrollment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('enrolled','completed','dropped') DEFAULT 'enrolled',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_enrollment` (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  KEY `idx_course_enrollments_tenant` (`tenant_id`),
  CONSTRAINT `course_enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `course_enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_course_enrollments_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_enrollments`
--

LOCK TABLES `course_enrollments` WRITE;
/*!40000 ALTER TABLE `course_enrollments` DISABLE KEYS */;
INSERT INTO `course_enrollments` VALUES (11,1,18,6,'2026-02-27 07:39:09','enrolled');
/*!40000 ALTER TABLE `course_enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `course_name` varchar(255) NOT NULL,
  `course_code` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `instructor` varchar(255) DEFAULT NULL,
  `level` enum('Beginner','Intermediate','Advanced') DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `schedule` text,
  `status` enum('open','closed','cancelled') DEFAULT 'open',
  `description` text,
  `enrolled_students` int DEFAULT '0',
  `max_students` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_course_code_per_tenant` (`tenant_id`,`course_code`),
  KEY `department_id` (`department_id`),
  KEY `idx_courses_tenant` (`tenant_id`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_courses_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (6,1,'c++','c1',NULL,NULL,NULL,NULL,NULL,'open',NULL,0,NULL,NULL,NULL,'2026-02-27 07:38:47','2026-03-19 04:21:05');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_reports`
--

DROP TABLE IF EXISTS `daily_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `task_id` int NOT NULL,
  `date` date NOT NULL,
  `status` varchar(50) DEFAULT 'In Progress',
  `hours_spent` decimal(5,2) DEFAULT '0.00',
  `comments` text,
  `next_steps` text,
  `blockers` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_daily_report` (`task_id`,`date`),
  KEY `fk_daily_reports_tenant` (`tenant_id`),
  KEY `idx_employee_date` (`employee_id`,`date`),
  CONSTRAINT `fk_daily_reports_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_reports`
--

LOCK TABLES `daily_reports` WRITE;
/*!40000 ALTER TABLE `daily_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_challan_history`
--

DROP TABLE IF EXISTS `delivery_challan_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_challan_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `challan_id` int NOT NULL,
  `date` date NOT NULL,
  `action` varchar(100) NOT NULL,
  `user` varchar(100) NOT NULL,
  `follow_up` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_challan_id` (`challan_id`),
  KEY `idx_date` (`date`),
  KEY `idx_delivery_history_tenant` (`tenant_id`),
  CONSTRAINT `delivery_challan_history_ibfk_1` FOREIGN KEY (`challan_id`) REFERENCES `delivery_challans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_delivery_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_challan_history`
--

LOCK TABLES `delivery_challan_history` WRITE;
/*!40000 ALTER TABLE `delivery_challan_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_challan_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_challan_items`
--

DROP TABLE IF EXISTS `delivery_challan_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_challan_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `challan_id` int NOT NULL,
  `sr_no` int NOT NULL,
  `description` text NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '1.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_challan_id` (`challan_id`),
  KEY `idx_delivery_items_tenant` (`tenant_id`),
  CONSTRAINT `delivery_challan_items_ibfk_1` FOREIGN KEY (`challan_id`) REFERENCES `delivery_challans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_delivery_items_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_challan_items`
--

LOCK TABLES `delivery_challan_items` WRITE;
/*!40000 ALTER TABLE `delivery_challan_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_challan_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_challans`
--

DROP TABLE IF EXISTS `delivery_challans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_challans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `challan_no` varchar(50) NOT NULL,
  `challan_date` date NOT NULL,
  `destination` varchar(255) NOT NULL,
  `dispatched_through` varchar(100) DEFAULT 'By Hand',
  `to_address` text NOT NULL,
  `from_address` text,
  `contact_info` text,
  `payment_info` varchar(100) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `challan_no` (`challan_no`),
  KEY `idx_challan_date` (`challan_date`),
  KEY `idx_destination` (`destination`),
  KEY `idx_challan_no` (`challan_no`),
  KEY `idx_delivery_challans_tenant` (`tenant_id`),
  CONSTRAINT `fk_delivery_challans_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_challans`
--

LOCK TABLES `delivery_challans` WRITE;
/*!40000 ALTER TABLE `delivery_challans` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_challans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `manager` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_departments_tenant` (`tenant_id`),
  CONSTRAINT `fk_departments_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (13,1,'IT','Creating Apps, WebApplication and Webpages','Aniruddha Manmode','2026-03-16 07:19:58','2026-03-19 04:21:05'),(14,1,'IT & Development','Hello','Aniruddha Manmode','2026-03-22 16:16:04','2026-03-22 16:16:04'),(15,1,'lala company','ertyuil','Jubeda ff','2026-03-31 07:08:53','2026-03-31 07:08:53');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_departments`
--

DROP TABLE IF EXISTS `employee_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(50) NOT NULL,
  `department_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_employee_department` (`employee_id`,`department_id`),
  KEY `department_id` (`department_id`),
  KEY `tenant_id` (`tenant_id`),
  CONSTRAINT `employee_departments_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_departments_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_departments_ibfk_3` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_departments`
--

LOCK TABLES `employee_departments` WRITE;
/*!40000 ALTER TABLE `employee_departments` DISABLE KEYS */;
INSERT INTO `employee_departments` VALUES (1,'AITS001',13,1,'2026-04-06 04:51:52'),(2,'AITS001',14,1,'2026-04-06 04:51:52'),(3,'AITS001',15,1,'2026-04-06 04:51:52'),(4,'AITS004',13,1,'2026-04-06 04:54:17'),(5,'AITS014',14,1,'2026-04-06 04:54:30'),(6,'AITS0010',15,1,'2026-04-06 04:54:52'),(7,'AITS003',14,1,'2026-04-08 05:16:51'),(8,'AITS015',14,1,'2026-04-10 06:22:01'),(9,'AITS015',15,1,'2026-04-10 06:22:01');
/*!40000 ALTER TABLE `employee_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_details` (
  `id` varchar(20) NOT NULL,
  `tenant_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `department_id` int DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `joining_date` date DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text,
  `emergency_contact` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `bank_account_number` varchar(50) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `pan_number` varchar(20) DEFAULT NULL,
  `aadhar_number` varchar(20) DEFAULT NULL,
  `face_encoding` longtext,
  `status` enum('active','inactive') DEFAULT 'active',
  `default_shift_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `department_id` (`department_id`),
  KEY `fk_employee_default_shift` (`default_shift_id`),
  KEY `idx_employee_details_tenant` (`tenant_id`),
  CONSTRAINT `employee_details_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `employee_details_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_employee_default_shift` FOREIGN KEY (`default_shift_id`) REFERENCES `tb_shifts` (`shift_id`),
  CONSTRAINT `fk_employee_details_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_details`
--

LOCK TABLES `employee_details` WRITE;
/*!40000 ALTER TABLE `employee_details` DISABLE KEYS */;
INSERT INTO `employee_details` VALUES ('AITS001',1,76,13,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-27 07:36:14','2026-04-07 07:35:40',NULL,NULL,NULL,NULL,'{\"enrolled\":true,\"employeeId\":\"AITS001\",\"timestamp\":\"2026-04-07T07:35:40.753Z\",\"encoding\":[-0.17278049886226654,0.13398568332195282,0.05870278179645538,-0.09759622067213058,-0.11318417638540268,-0.08826745301485062,-0.02535662241280079,-0.10432595014572144,0.19437961280345917,-0.12223919481039047,0.18412648141384125,-0.06285037845373154,-0.17600233852863312,-0.09323553740978241,-0.05494880676269531,0.17963282763957977,-0.10970261693000793,-0.10039952397346497,-0.052245739847421646,-0.07453099638223648,0.07233573496341705,0.0031194938346743584,0.0607626810669899,0.14093002676963806,-0.1412346363067627,-0.3848152458667755,-0.10583717375993729,-0.09227342158555984,-0.06829173862934113,-0.10559262335300446,0.018883168697357178,0.11575023829936981,-0.2005184292793274,-0.0853508859872818,-0.048751719295978546,0.05371257662773132,0.01212562620639801,-0.019074847921729088,0.17037321627140045,0.013960909098386765,-0.22615382075309753,-0.1479494869709015,0.09053127467632294,0.2918829023838043,0.17589156329631805,-0.014063011854887009,0.03649826720356941,-0.0662115216255188,0.07344969362020493,-0.19788511097431183,-0.005952254869043827,0.13381598889827728,-0.013546658679842949,0.05146932974457741,0.03934008255600929,-0.05581064894795418,0.05586520582437515,0.049701377749443054,-0.18783444166183472,-0.0478261299431324,0.03557440638542175,-0.10456971824169159,-0.10642324388027191,-0.0520254448056221,0.29599711298942566,0.13513316214084625,-0.09322138130664825,-0.11478991061449051,0.21011801064014435,-0.15631811320781708,-0.03169022127985954,0.044753387570381165,-0.14664195477962494,-0.1587790995836258,-0.3559618294239044,-0.012089477851986885,0.363131582736969,0.15152183175086975,-0.1265132576227188,0.07959175109863281,-0.17069406807422638,-0.008568438701331615,0.053032584488391876,0.14110690355300903,-0.031078219413757324,0.1102142408490181,-0.025225097313523293,0.1145363301038742,0.13122710585594177,-0.034024935215711594,-0.024931775406003,0.24244359135627747,0.03874717280268669,0.01502135768532753,0.0385933555662632,0.04878360405564308,-0.11663537472486496,-0.013751796446740627,-0.1758967936038971,0.011049194261431694,0.06711121648550034,0.02144341543316841,0.03264792263507843,0.1263704001903534,-0.21111436188220978,0.13424524664878845,0.048418883234262466,-0.03997061401605606,-0.026749208569526672,0.0049943746998906136,-0.10174981504678726,-0.1297813057899475,0.10528969764709473,-0.16529026627540588,0.1081807091832161,0.14077404141426086,-0.005186005029827356,0.16595758497714996,0.08315380662679672,0.08125968277454376,-0.015595904551446438,-0.08704729378223419,-0.08890147507190704,0.030025668442249298,0.1285233050584793,-0.05006067454814911,0.0512695387005806,0.002987000858411193],\"encodingVersion\":\"1.0\"}','active',9),('AITS0010',1,88,15,'Software Developer',NULL,'2026-03-09',NULL,NULL,NULL,'2026-03-23 06:31:06','2026-04-06 04:54:52',NULL,NULL,NULL,NULL,NULL,'active',NULL),('AITS003',1,79,14,NULL,NULL,'2025-10-01','2004-01-09',NULL,NULL,'2026-03-16 07:05:02','2026-04-09 05:54:58',NULL,NULL,NULL,NULL,'{\"enrolled\":true,\"employeeId\":\"AITS003\",\"timestamp\":\"2026-04-09T05:54:58.711Z\",\"encoding\":[-0.18093852698802948,0.13750788569450378,0.0768272802233696,-0.10690995305776596,-0.11416886001825333,-0.10150580108165741,-0.03708409145474434,-0.11160847544670105,0.19697295129299164,-0.12941230833530426,0.17496319115161896,-0.05122951790690422,-0.17878276109695435,-0.09575425833463669,-0.015507903881371021,0.18119804561138153,-0.1313284933567047,-0.12944461405277252,-0.04283158853650093,-0.06948401033878326,0.08177950233221054,0.007352391257882118,0.04612578824162483,0.17817898094654083,-0.1570940762758255,-0.3947737514972687,-0.09859441220760345,-0.1154722273349762,-0.06498782336711884,-0.11298777163028717,-0.015584789216518402,0.0882469043135643,-0.2339937686920166,-0.08140268921852112,-0.0652833878993988,0.10892197489738464,0.006434397306293249,-0.03367392346262932,0.1514260470867157,0.018066566437482834,-0.24646598100662231,-0.11409587413072586,0.07118231803178787,0.2581939101219177,0.1875021606683731,-0.010434990748763084,0.04544970020651817,-0.05232055112719536,0.06880675256252289,-0.20248432457447052,-0.0023285909555852413,0.1352614462375641,-0.01462695375084877,0.04070986062288284,0.030581403523683548,-0.10682930797338486,0.04397501051425934,0.012982037849724293,-0.18110892176628113,-0.04960649460554123,0.04290621355175972,-0.12353740632534027,-0.09088301658630371,-0.03771748021245003,0.30166929960250854,0.11024463176727295,-0.08515167236328125,-0.09264089912176132,0.22307319939136505,-0.16233913600444794,-0.028667040169239044,0.05027473345398903,-0.1472523957490921,-0.152143657207489,-0.3537546396255493,0.01298902090638876,0.4120129942893982,0.13769151270389557,-0.13344405591487885,0.10036924481391907,-0.1956891268491745,-0.004084152635186911,0.032779332250356674,0.125592902302742,-0.020670844241976738,0.12603166699409485,-0.05973031371831894,0.13143163919448853,0.1485144942998886,-0.01928091235458851,0.007610312197357416,0.2379816323518753,0.04325539991259575,0.04476787894964218,0.06186472624540329,0.03295047953724861,-0.11120209097862244,-0.029990267008543015,-0.1713324934244156,0.013645405881106853,0.04711681231856346,-0.006638689897954464,0.0059203291311860085,0.11884547770023346,-0.22273394465446472,0.12227559089660645,0.0664689689874649,-0.07104447484016418,-0.04409525915980339,0.04665249213576317,-0.13677442073822021,-0.14619563519954681,0.11552400141954422,-0.18007440865039825,0.12018153816461563,0.1696872115135193,0.008236531168222427,0.18105140328407288,0.08460585027933121,0.09562879800796509,-0.03179667517542839,-0.09221433848142624,-0.10724536329507828,0.022515594959259033,0.14002183079719543,-0.043212950229644775,0.06605936586856842,0.027706198394298553],\"encodingVersion\":\"1.0\"}','active',NULL),('AITS004',1,80,13,'Manager',NULL,NULL,NULL,NULL,NULL,'2026-03-16 07:06:45','2026-04-06 04:54:17',NULL,NULL,NULL,NULL,'{\"enrolled\":true,\"employeeId\":\"AITS004\",\"timestamp\":\"2026-03-22T15:50:50.716Z\",\"encoding\":[-0.1318303346633911,0.11292099207639694,0.05681673437356949,-0.09025653451681137,0.034520070999860764,0.02745535597205162,-0.018931137397885323,-0.05320015549659729,0.19409382343292236,-0.1332515925168991,0.21052436530590057,0.01870122365653515,-0.13922692835330963,-0.17059724032878876,-0.02806260623037815,0.093653604388237,-0.10297437757253647,-0.2248658388853073,-0.04176170751452446,-0.12585997581481934,-0.013428326696157455,0.004016770049929619,0.004300632048398256,0.01475477498024702,-0.1781102567911148,-0.4054567217826843,-0.10813724994659424,-0.14010827243328094,-0.024110794067382812,-0.05795692279934883,0.02159912697970867,0.04212021827697754,-0.2442382574081421,-0.03807060047984123,-0.02204802818596363,0.09494569897651672,0.03150355443358421,0.029886718839406967,0.1658019721508026,0.05521169677376747,-0.1049332544207573,-0.03940765559673309,0.053810544312000275,0.3157542049884796,0.12350692600011826,0.03137781098484993,-0.016302717849612236,0.02485298365354538,0.05226536840200424,-0.17708779871463776,0.14523163437843323,0.10737016797065735,0.136855810880661,0.07545356452465057,0.0733722373843193,-0.052382487803697586,0.013846524059772491,0.014618647284805775,-0.16435903310775757,0.05140688270330429,-0.026024293154478073,-0.0708102285861969,-0.10210863500833511,0.0005945797893218696,0.27704381942749023,0.1562155783176422,-0.078584223985672,-0.168326273560524,0.20587123930454254,-0.12596242129802704,-0.02730000577867031,0.034586165100336075,-0.08818541467189789,-0.0965290293097496,-0.2640390396118164,0.16386504471302032,0.3770250082015991,0.14001472294330597,-0.1800575703382492,0.044188205152750015,-0.11570849269628525,-0.0498150959610939,0.04404439032077789,0.04400535672903061,-0.11977566033601761,0.06522815674543381,-0.05888001248240471,0.045555051416158676,0.19251422584056854,0.061789371073246,-0.13773758709430695,0.15947453677654266,-0.059659022837877274,0.05617965757846832,0.06830790638923645,-0.016373245045542717,-0.08021195232868195,0.01064580399543047,-0.1715966910123825,-0.02404111623764038,0.07009512931108475,-0.013114884495735168,-0.05343589931726456,0.13451440632343292,-0.14478729665279388,0.09187715500593185,0.009089741855859756,-0.07324523478746414,0.004942759405821562,0.13319113850593567,-0.1665022075176239,-0.1507394164800644,0.1062278151512146,-0.20956726372241974,0.16785356402397156,0.1324484497308731,0.05046164244413376,0.15936432778835297,0.1558144986629486,0.04469671845436096,0.05200033262372017,-0.02459099516272545,-0.13366073369979858,-0.0653105154633522,0.09501859545707703,-0.007547044660896063,0.06721186637878418,0.04272669181227684],\"encodingVersion\":\"1.0\"}','active',NULL),('AITS011',1,99,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-27 05:14:03','2026-03-27 05:14:03',NULL,NULL,NULL,NULL,NULL,'active',NULL),('AITS012',1,101,NULL,NULL,NULL,'2026-03-31',NULL,NULL,NULL,'2026-03-31 07:06:00','2026-03-31 07:06:00',NULL,NULL,NULL,NULL,NULL,'active',NULL),('AITS013',1,102,NULL,'manager',NULL,'2026-03-24',NULL,NULL,NULL,'2026-03-31 07:08:03','2026-04-07 07:36:45',NULL,NULL,NULL,NULL,'{\"enrolled\":true,\"employeeId\":\"AITS013\",\"timestamp\":\"2026-04-07T07:36:45.517Z\",\"encoding\":[-0.16534706950187683,0.1130746603012085,0.03628949075937271,-0.09316935390233994,-0.11086566746234894,-0.061466071754693985,-0.026562655344605446,-0.10224438458681107,0.18661022186279297,-0.15959356725215912,0.16940884292125702,-0.07423162460327148,-0.18968333303928375,-0.09647702425718307,-0.04365110769867897,0.176690012216568,-0.0950712338089943,-0.1301390528678894,-0.050240255892276764,-0.06398047506809235,0.07701706141233444,0.0032183777075260878,0.047039683908224106,0.15894715487957,-0.16330508887767792,-0.39444348216056824,-0.10145886242389679,-0.09831552952528,-0.0780704990029335,-0.10231834650039673,-0.0010946927359327674,0.09832784533500671,-0.22007834911346436,-0.08817775547504425,-0.04655415564775467,0.07891057431697845,0.0018166740192100406,-0.01852607913315296,0.16314055025577545,0.02302122302353382,-0.23847627639770508,-0.1356937140226364,0.09239920973777771,0.28423988819122314,0.1758272349834442,-0.005178930703550577,0.033654313534498215,-0.06237201392650604,0.05592773109674454,-0.21849988400936127,0.01231249887496233,0.13683532178401947,-0.02093934640288353,0.06693067401647568,0.04310675710439682,-0.05883412808179855,0.059606652706861496,0.04562601447105408,-0.175863578915596,-0.02823960967361927,0.038662273436784744,-0.09847653657197952,-0.08156681060791016,-0.04039986804127693,0.3135741651058197,0.11572868376970291,-0.09271332621574402,-0.12203177809715271,0.21480637788772583,-0.18046869337558746,-0.04464945197105408,0.04878508672118187,-0.13537509739398956,-0.16238608956336975,-0.3618740439414978,0.009897529147565365,0.3824670910835266,0.178913414478302,-0.11395224928855896,0.1065802276134491,-0.17014169692993164,-0.012367386370897293,0.057406965643167496,0.14437375962734222,-0.007570709567517042,0.1072298064827919,-0.016018811613321304,0.11515505611896515,0.1475076675415039,-0.010928641073405743,-0.02982655167579651,0.24609825015068054,0.0260988287627697,0.009304795414209366,0.06989535689353943,0.04999387264251709,-0.12303396314382553,-0.02571098506450653,-0.16562488675117493,0.006061667576432228,0.06270758807659149,0.00365229113958776,0.037521034479141235,0.13766273856163025,-0.21078258752822876,0.1419638842344284,0.016258420422673225,-0.04684805870056152,-0.009374283254146576,0.03772055357694626,-0.1254149079322815,-0.1319805383682251,0.1004505380988121,-0.1879720538854599,0.1149265468120575,0.13899128139019012,0.012636857107281685,0.16267327964305878,0.10289227217435837,0.09305905550718307,-0.006305885035544634,-0.06987780332565308,-0.11284416913986206,0.010141123086214066,0.12677110731601715,-0.04999638348817825,0.069383904337883,0.013465184718370438],\"encodingVersion\":\"1.0\"}','active',NULL),('AITS014',1,103,14,NULL,NULL,NULL,NULL,NULL,NULL,'2026-03-31 08:13:17','2026-04-06 04:54:30',NULL,NULL,NULL,NULL,NULL,'active',NULL),('AITS015',1,104,14,'manager',NULL,NULL,NULL,NULL,NULL,'2026-04-10 06:22:01','2026-04-10 06:22:01',NULL,NULL,NULL,NULL,NULL,'active',NULL);
/*!40000 ALTER TABLE `employee_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_categories`
--

DROP TABLE IF EXISTS `expense_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `limit_amount` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_expense_categories_tenant` (`tenant_id`),
  CONSTRAINT `fk_expense_categories_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_categories`
--

LOCK TABLES `expense_categories` WRITE;
/*!40000 ALTER TABLE `expense_categories` DISABLE KEYS */;
INSERT INTO `expense_categories` VALUES (9,1,'Travel',NULL,50000.00,'2026-04-03 09:43:19'),(10,1,'Food & Meals',NULL,5000.00,'2026-04-03 09:43:19'),(11,1,'Office Supplies',NULL,5000.00,'2026-04-03 09:43:19'),(12,1,'Software',NULL,25000.00,'2026-04-03 09:43:19'),(13,1,'Hardware',NULL,100000.00,'2026-04-03 09:43:19'),(14,1,'Training',NULL,30000.00,'2026-04-03 09:43:19'),(15,1,'Client Entertainment',NULL,15000.00,'2026-04-03 09:43:19'),(16,1,'Internet & Communication',NULL,5000.00,'2026-04-03 09:43:19'),(17,1,'Marketing',NULL,50000.00,'2026-04-03 09:43:19'),(18,1,'Other',NULL,NULL,'2026-04-03 09:43:19');
/*!40000 ALTER TABLE `expense_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `category_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `receipt_url` varchar(500) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `payment_status` enum('paid','pending','cancelled') DEFAULT 'pending',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_by` int DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `category_id` (`category_id`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_expenses_tenant` (`tenant_id`),
  CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `expenses_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `expense_categories` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `expenses_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_expenses_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
INSERT INTO `expenses` VALUES (36,1,76,18,5000.00,'nothing',NULL,NULL,'approved','paid','2026-04-03 09:47:00',3,'2026-04-03 09:54:10','2026-04-03 09:47:00','2026-04-03 10:38:34'),(37,1,76,18,100.00,'testing',NULL,NULL,'pending','paid','2026-04-03 10:00:52',NULL,NULL,'2026-04-03 10:00:52','2026-04-03 11:27:21'),(38,1,76,15,100.00,'aa','/uploads/expenses/expense_1775212993511_Screenshot 2026-02-11 212655.png',NULL,'pending','cancelled','2026-04-03 10:43:13',NULL,NULL,'2026-04-03 10:43:13','2026-04-03 11:21:39'),(39,1,3,15,1500.00,'ertfyguhijo',NULL,NULL,'pending','paid','2026-04-06 07:18:59',NULL,NULL,'2026-04-06 07:18:59','2026-04-06 07:19:18'),(40,1,76,15,420.00,'dfgefsdfsdfsfsa','/uploads/expenses/expense_1775721403734_class_diagram.png',NULL,'pending','paid','2026-04-09 07:56:43',NULL,NULL,'2026-04-09 07:56:43','2026-04-09 07:57:14'),(41,1,79,15,1500.00,'dfsadfsfsaafedaefa',NULL,NULL,'pending','pending','2026-04-10 03:53:33',NULL,NULL,'2026-04-10 03:53:33','2026-04-10 03:53:33');
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `experience_letters`
--

DROP TABLE IF EXISTS `experience_letters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `experience_letters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `employee_id` varchar(50) NOT NULL,
  `ref_number` varchar(100) DEFAULT NULL,
  `date_of_issue` date NOT NULL,
  `date_of_joining` date NOT NULL,
  `last_working_day` date NOT NULL,
  `designation` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `employment_type` enum('Full-time','Part-time','Contract','Internship') NOT NULL,
  `custom_note` text,
  `letter_url` varchar(500) NOT NULL,
  `generated_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_el_user` (`generated_by`),
  KEY `idx_experience_letters_tenant` (`tenant_id`),
  KEY `idx_experience_letters_employee` (`employee_id`),
  CONSTRAINT `fk_el_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_el_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_el_user` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `experience_letters`
--

LOCK TABLES `experience_letters` WRITE;
/*!40000 ALTER TABLE `experience_letters` DISABLE KEYS */;
INSERT INTO `experience_letters` VALUES (40,1,'AITS001','EXP-2026-0004','2026-04-06','2026-02-01','2026-04-30','cx','cx','Full-time',NULL,'/uploads/branding/1/letters/experience/EXP-1775469904704-631365185.pdf',3,'2026-04-06 10:05:05','2026-04-06 10:05:05'),(41,1,'AITS001','EXP-2026-0002','2026-04-07','2026-04-30','2026-06-30','sedfghj','ghjk','Full-time',NULL,'/uploads/branding/1/letters/experience/EXP-1775535179272-129650168.pdf',3,'2026-04-07 04:12:59','2026-04-07 04:12:59'),(42,1,'AITS003','EXP-2026-0003','2026-04-08','2025-10-01','2026-06-30','kijuhy','iuyg','Full-time',NULL,'/uploads/branding/1/letters/experience/EXP-1775625685852-278557108.pdf',3,'2026-04-08 05:21:25','2026-04-08 05:21:25'),(43,1,'AITS001','EXP-2026-0004','2026-04-09','2026-04-09','2026-06-30','asdfg','sdfg','Full-time','sfg','/uploads/branding/1/letters/experience/EXP-1775716949520-73874327.pdf',3,'2026-04-09 06:42:29','2026-04-09 06:42:29');
/*!40000 ALTER TABLE `experience_letters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gst_details`
--

DROP TABLE IF EXISTS `gst_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gst_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `invoice_id` int DEFAULT NULL,
  `tax_type` enum('CGST','SGST','IGST') DEFAULT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `idx_gst_tenant` (`tenant_id`),
  CONSTRAINT `fk_gst_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `gst_details_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gst_details`
--

LOCK TABLES `gst_details` WRITE;
/*!40000 ALTER TABLE `gst_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `gst_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `increment_letters`
--

DROP TABLE IF EXISTS `increment_letters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `increment_letters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `employee_id` varchar(50) NOT NULL,
  `ref_number` varchar(100) DEFAULT NULL,
  `date_of_issue` date NOT NULL,
  `effective_date` date NOT NULL,
  `previous_ctc` decimal(15,2) NOT NULL,
  `revised_ctc` decimal(15,2) NOT NULL,
  `increment_percentage` decimal(5,2) GENERATED ALWAYS AS (round((((`revised_ctc` - `previous_ctc`) / `previous_ctc`) * 100),2)) STORED,
  `currency` varchar(10) NOT NULL DEFAULT 'INR',
  `designation` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `performance_note` text,
  `letter_url` varchar(500) NOT NULL,
  `generated_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_il_user` (`generated_by`),
  KEY `idx_increment_letters_tenant` (`tenant_id`),
  KEY `idx_increment_letters_employee` (`employee_id`),
  CONSTRAINT `fk_il_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_il_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_il_user` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `increment_letters`
--

LOCK TABLES `increment_letters` WRITE;
/*!40000 ALTER TABLE `increment_letters` DISABLE KEYS */;
INSERT INTO `increment_letters` (`id`, `tenant_id`, `employee_id`, `ref_number`, `date_of_issue`, `effective_date`, `previous_ctc`, `revised_ctc`, `currency`, `designation`, `department`, `performance_note`, `letter_url`, `generated_by`, `created_at`, `updated_at`) VALUES (5,1,'AITS001','INC-2026-0003','2026-04-06','2026-06-26',8520.00,9652.00,'INR','','',NULL,'/uploads/branding/1/letters/increment/INC-1775470347397-704809330.pdf',3,'2026-04-06 10:12:27','2026-04-06 10:12:27'),(6,1,'AITS001','INC-2026-0002','2026-04-07','2026-05-31',963852.00,741852.00,'INR','','',NULL,'/uploads/branding/1/letters/increment/INC-1775535145032-345598791.pdf',3,'2026-04-07 04:12:25','2026-04-07 04:12:25'),(7,1,'AITS003','INC-2026-0003','2026-04-08','2026-04-30',8741.00,9874.00,'INR','','',NULL,'/uploads/branding/1/letters/increment/INC-1775625715823-726555605.pdf',3,'2026-04-08 05:21:55','2026-04-08 05:21:55'),(8,1,'AITS001','INC-2026-0004','2026-04-09','2026-05-30',98741.00,74100.00,'INR','','','hgfd','/uploads/branding/1/letters/increment/INC-1775716982132-998788010.pdf',3,'2026-04-09 06:43:02','2026-04-09 06:43:02');
/*!40000 ALTER TABLE `increment_letters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internship_applications`
--

DROP TABLE IF EXISTS `internship_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internship_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `internship_id` int DEFAULT NULL,
  `application_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('applied','shortlisted','accepted','rejected') DEFAULT 'applied',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `internship_id` (`internship_id`),
  KEY `idx_internship_apps_tenant` (`tenant_id`),
  CONSTRAINT `fk_internship_apps_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `internship_applications_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `internship_applications_ibfk_2` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internship_applications`
--

LOCK TABLES `internship_applications` WRITE;
/*!40000 ALTER TABLE `internship_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `internship_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internship_tasks`
--

DROP TABLE IF EXISTS `internship_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internship_tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `internship_id` int NOT NULL,
  `task` varchar(255) NOT NULL,
  `assigned_to` int DEFAULT NULL,
  `status` enum('not-started','in-progress','completed') DEFAULT 'not-started',
  `description` text,
  `due_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `internship_id` (`internship_id`),
  KEY `assigned_to` (`assigned_to`),
  KEY `idx_internship_tasks_tenant` (`tenant_id`),
  CONSTRAINT `fk_internship_tasks_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `internship_tasks_ibfk_1` FOREIGN KEY (`internship_id`) REFERENCES `internships` (`id`) ON DELETE CASCADE,
  CONSTRAINT `internship_tasks_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `students` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internship_tasks`
--

LOCK TABLES `internship_tasks` WRITE;
/*!40000 ALTER TABLE `internship_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `internship_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internships`
--

DROP TABLE IF EXISTS `internships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `internships` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `program_name` varchar(255) NOT NULL,
  `department_id` int DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `positions` int DEFAULT NULL,
  `filled_positions` int DEFAULT '0',
  `status` enum('open','full','closed') DEFAULT 'open',
  `description` text,
  `requirements` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `idx_internships_tenant` (`tenant_id`),
  CONSTRAINT `fk_internships_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `internships_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internships`
--

LOCK TABLES `internships` WRITE;
/*!40000 ALTER TABLE `internships` DISABLE KEYS */;
/*!40000 ALTER TABLE `internships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_history`
--

DROP TABLE IF EXISTS `invoice_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `invoice_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `user` varchar(100) DEFAULT NULL,
  `follow_up` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `idx_invoice_history_tenant` (`tenant_id`),
  CONSTRAINT `fk_invoice_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_history_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_history`
--

LOCK TABLES `invoice_history` WRITE;
/*!40000 ALTER TABLE `invoice_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_items`
--

DROP TABLE IF EXISTS `invoice_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `invoice_id` int DEFAULT NULL,
  `sr_no` int DEFAULT NULL,
  `description` text,
  `hsn_code` varchar(50) DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `rate` decimal(15,2) DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `idx_invoice_items_tenant` (`tenant_id`),
  CONSTRAINT `fk_invoice_items_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_items`
--

LOCK TABLES `invoice_items` WRITE;
/*!40000 ALTER TABLE `invoice_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoice_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `invoice_no` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `ref_no` varchar(100) DEFAULT NULL,
  `buyer_gstin` varchar(15) DEFAULT NULL,
  `buyer_code` varchar(50) DEFAULT NULL,
  `party_address` text,
  `total_before_discount` decimal(15,2) DEFAULT '0.00',
  `round_off` decimal(15,2) DEFAULT '0.00',
  `total_after_tax` decimal(15,2) DEFAULT '0.00',
  `status` enum('draft','sent','paid','cancelled') DEFAULT 'draft',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `service_bank_details` json DEFAULT NULL,
  `service_gst_details` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_no` (`invoice_no`),
  KEY `idx_invoices_tenant` (`tenant_id`),
  CONSTRAINT `fk_invoices_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_requests`
--

DROP TABLE IF EXISTS `leave_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_requests` (
  `leave_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `employee_id` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `approved_by` varchar(20) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`leave_id`),
  KEY `employee_id` (`employee_id`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_leave_requests_tenant` (`tenant_id`),
  CONSTRAINT `fk_leave_requests_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_requests_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `leave_requests_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `employee_details` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_requests`
--

LOCK TABLES `leave_requests` WRITE;
/*!40000 ALTER TABLE `leave_requests` DISABLE KEYS */;
INSERT INTO `leave_requests` VALUES (15,1,'AITS004',' dynamic, versatile, and full-service Digital Marketing, Web Application, Android & IOS, AI/ML, iOT/ Embedded Development agency that doesn\'t rely on gimmicks or smoke and mirrors to earn clients. We ','2026-03-22','2026-03-25','Approved',NULL,'2026-03-22 21:35:40','2026-03-22 15:55:04','2026-03-22 16:05:40'),(16,1,'AITS001','sdtfyguhijo','2026-04-07','2026-04-08','Approved',NULL,'2026-04-07 11:40:48','2026-04-07 06:09:21','2026-04-07 06:10:48'),(17,1,'AITS001','dfsddfa','2026-04-10','2026-04-10','Approved',NULL,'2026-04-09 13:17:15','2026-04-09 07:46:44','2026-04-09 07:47:15');
/*!40000 ALTER TABLE `leave_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `type` enum('info','warning','success','error') DEFAULT 'info',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `is_read_index` (`is_read`),
  KEY `idx_notifications_tenant` (`tenant_id`),
  CONSTRAINT `fk_notifications_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offer_letters`
--

DROP TABLE IF EXISTS `offer_letters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offer_letters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `form_data` json NOT NULL,
  `issue_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`),
  CONSTRAINT `offer_letters_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offer_letters`
--

LOCK TABLES `offer_letters` WRITE;
/*!40000 ALTER TABLE `offer_letters` DISABLE KEYS */;
INSERT INTO `offer_letters` VALUES (1,82,'{\"ctc\": \"250000\", \"email\": \"rohan1234@gmail.com\", \"phone\": \"1236547890\", \"address\": \"Ahmednagar\", \"fullName\": \"Rohan  Kumar\", \"issueDate\": \"2026-03-19\", \"ctcInWords\": \"two lack\", \"salutation\": \"Mr.\", \"designation\": \"Frontend dev\", \"joiningDate\": \"2026-04-25\"}','2026-03-19','2026-03-19 10:09:12','2026-03-19 10:09:12'),(2,81,'{\"ctc\": \"800000\", \"email\": \"smad200@gmail.com\", \"phone\": \"08793740825\", \"address\": \"Ahmednagar, Maharashtra, 414001\", \"fullName\": \"Samad Shaikh\", \"issueDate\": \"2026-03-22\", \"ctcInWords\": \"Eight Lack\", \"salutation\": \"Mr.\", \"designation\": \"Full Stack Developer\", \"joiningDate\": \"2026-03-01\"}','2026-03-22','2026-03-19 10:45:48','2026-03-22 10:44:26'),(7,80,'{\"ctc\": \"96000\", \"email\": \"aniruddha.aits@gmail.com\", \"phone\": \"+918830681554\", \"address\": \"Kaslit Kalshi, very important.\", \"fullName\": \"Aniruddha Manmode\", \"issueDate\": \"2026-03-22\", \"ctcInWords\": \"Ninty six thousand\", \"salutation\": \"Mr.\", \"designation\": \"Manager\", \"joiningDate\": \"2026-03-24\"}','2026-03-22','2026-03-22 15:58:26','2026-03-22 15:58:26'),(8,88,'{\"ctc\": \"250000\", \"email\": \"arshanshaikh200@gmail.com\", \"phone\": \"8793740825\", \"address\": \"\", \"fullName\": \"Arshan Shaikh\", \"issueDate\": \"2026-03-23\", \"ctcInWords\": \"twenty five lack\", \"salutation\": \"Mr.\", \"designation\": \"Software Developer\", \"joiningDate\": \"2026-03-09\"}','2026-03-23','2026-03-23 09:32:22','2026-03-23 09:39:36'),(10,76,'{\"ctc\": \"9739\", \"email\": \"jubeda.aits@gmail.com\", \"phone\": \"9874563210\", \"address\": \"sdfh\", \"fullName\": \"jubeda shaikh\", \"issueDate\": \"2026-04-09\", \"ctcInWords\": \"Nine Thousand Seven Hundred and Thirty Nine\", \"salutation\": \"Mr.\", \"designation\": \"employee\", \"joiningDate\": \"2026-04-02\"}','2026-04-09','2026-04-06 06:45:59','2026-04-09 06:40:48'),(11,79,'{\"ctc\": \"47844\", \"email\": \"asifa.aits0010@gmail.com\", \"phone\": \"9284027990\", \"address\": \"sdfgyhujk\", \"fullName\": \"Asifa Sarkar\", \"issueDate\": \"2026-04-08\", \"ctcInWords\": \"Forty Seven Thousand Eight Hundred and Forty Four\", \"salutation\": \"Mr.\", \"designation\": \"employee\", \"joiningDate\": \"2025-10-01\"}','2026-04-08','2026-04-08 05:20:17','2026-04-08 05:20:17');
/*!40000 ALTER TABLE `offer_letters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_history`
--

DROP TABLE IF EXISTS `project_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `project_id` int NOT NULL,
  `date` date NOT NULL,
  `action` varchar(255) NOT NULL,
  `user` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`),
  KEY `idx_project_history_tenant` (`tenant_id`),
  CONSTRAINT `fk_project_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_history_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_history`
--

LOCK TABLES `project_history` WRITE;
/*!40000 ALTER TABLE `project_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_phases`
--

DROP TABLE IF EXISTS `project_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_phases` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_id` int NOT NULL,
  `tenant_id` int NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `status` enum('Not Started','In Progress','Review','Completed','On Hold') NOT NULL DEFAULT 'Not Started',
  `progress` int DEFAULT '0',
  `comments` text,
  `documents` json DEFAULT NULL,
  `phase_order` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `project_id` (`project_id`,`phase_order`),
  CONSTRAINT `project_phases_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_phases`
--

LOCK TABLES `project_phases` WRITE;
/*!40000 ALTER TABLE `project_phases` DISABLE KEYS */;
INSERT INTO `project_phases` VALUES (85,27,1,'Planning','Not Started',0,'','[]',1,'2026-03-27 07:32:18','2026-03-27 07:32:18'),(86,27,1,'Design','Not Started',0,'','[]',2,'2026-03-27 07:32:18','2026-03-27 07:32:18'),(87,27,1,'Development','Not Started',0,'','[]',3,'2026-03-27 07:32:18','2026-03-27 07:32:18'),(88,27,1,'Testing','Not Started',0,'','[]',4,'2026-03-27 07:32:18','2026-03-27 07:32:18'),(89,27,1,'Deployment','Not Started',0,'','[]',5,'2026-03-27 07:32:18','2026-03-27 07:32:18'),(120,34,1,'Planning','Not Started',0,'','[]',1,'2026-04-02 10:52:34','2026-04-02 10:52:34'),(121,34,1,'Design','Not Started',0,'','[]',2,'2026-04-02 10:52:34','2026-04-02 10:52:34'),(122,34,1,'Development','Not Started',0,'','[]',3,'2026-04-02 10:52:34','2026-04-02 10:52:34'),(123,34,1,'Testing','Not Started',0,'','[]',4,'2026-04-02 10:52:34','2026-04-02 10:52:34'),(124,34,1,'Deployment','Not Started',0,'','[]',5,'2026-04-02 10:52:34','2026-04-02 10:52:34'),(125,35,1,'Planning','Not Started',0,'','[]',1,'2026-04-06 04:17:15','2026-04-06 04:17:15'),(126,35,1,'Design','Not Started',0,'','[]',2,'2026-04-06 04:17:15','2026-04-06 04:17:15'),(127,35,1,'Development','Not Started',0,'','[]',3,'2026-04-06 04:17:15','2026-04-06 04:17:15'),(128,35,1,'Testing','Not Started',0,'','[]',4,'2026-04-06 04:17:15','2026-04-06 04:17:15'),(129,35,1,'Deployment','Not Started',0,'','[]',5,'2026-04-06 04:17:15','2026-04-06 04:17:15'),(130,36,1,'Planning','Not Started',0,'','[]',1,'2026-04-09 09:04:53','2026-04-09 09:04:53'),(131,36,1,'Design','Not Started',0,'','[]',2,'2026-04-09 09:04:53','2026-04-09 09:04:53'),(132,36,1,'Development','Not Started',0,'','[]',3,'2026-04-09 09:04:53','2026-04-09 09:04:53'),(133,36,1,'Testing','Not Started',0,'','[]',4,'2026-04-09 09:04:53','2026-04-09 09:04:53'),(134,36,1,'Deployment','Not Started',0,'','[]',5,'2026-04-09 09:04:53','2026-04-09 09:04:53'),(135,37,1,'Planning','Not Started',0,'','[]',1,'2026-04-10 06:17:45','2026-04-10 06:17:45'),(136,37,1,'Design','Not Started',0,'','[]',2,'2026-04-10 06:17:45','2026-04-10 06:17:45'),(137,37,1,'Development','Not Started',0,'','[]',3,'2026-04-10 06:17:45','2026-04-10 06:17:45'),(138,37,1,'Testing','Not Started',0,'','[]',4,'2026-04-10 06:17:45','2026-04-10 06:17:45'),(139,37,1,'Deployment','Not Started',0,'','[]',5,'2026-04-10 06:17:45','2026-04-10 06:17:45');
/*!40000 ALTER TABLE `project_phases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_tasks`
--

DROP TABLE IF EXISTS `project_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project_tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `project_id` int DEFAULT NULL,
  `task_name` varchar(200) NOT NULL,
  `task_description` text,
  `assigned_to_employee_id` int DEFAULT NULL,
  `assigned_by_id` int DEFAULT NULL,
  `status` enum('pending','in_progress','review','completed','blocked') DEFAULT 'pending',
  `priority` enum('high','medium','low') DEFAULT 'medium',
  `start_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `progress` int DEFAULT '0',
  `estimated_hours` decimal(5,2) DEFAULT NULL,
  `actual_hours` decimal(5,2) DEFAULT '0.00',
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tasks_project` (`project_id`),
  KEY `idx_tasks_assigned_to` (`assigned_to_employee_id`),
  KEY `idx_tasks_assigned_by` (`assigned_by_id`),
  KEY `idx_tasks_status` (`status`),
  KEY `idx_tasks_priority` (`priority`),
  KEY `idx_tasks_due_date` (`due_date`),
  KEY `idx_tasks_progress` (`progress`),
  CONSTRAINT `project_tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  CONSTRAINT `project_tasks_ibfk_2` FOREIGN KEY (`assigned_to_employee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `project_tasks_ibfk_3` FOREIGN KEY (`assigned_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_tasks`
--

LOCK TABLES `project_tasks` WRITE;
/*!40000 ALTER TABLE `project_tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `project_code` varchar(50) DEFAULT NULL,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `department` varchar(100) NOT NULL,
  `manager` varchar(255) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `current_phase` varchar(100) DEFAULT NULL,
  `progress` int DEFAULT '0',
  `status` varchar(50) NOT NULL DEFAULT 'On Track',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_projects_tenant` (`tenant_id`),
  CONSTRAINT `fk_projects_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (27,NULL,1,'Eseel_Propack','','IT & Development','jubeda shaikh','2026-04-07','2026-04-09','Requirement Specification',0,'Delayed','2026-03-27 07:32:18','2026-04-02 05:42:48'),(34,NULL,1,'workdesk','','IT & Development','jubeda shaikh','2026-04-02','2026-06-30','Planning',0,'On Track','2026-04-02 10:52:34','2026-04-02 10:52:34'),(35,NULL,1,'Eseel_Propack12','','IT','aa bb',NULL,NULL,'System Design',0,'On Track','2026-04-06 04:17:15','2026-04-06 05:52:51'),(36,NULL,1,'frontednd development teamm','hutyrew3qw','IT & Development','jubeda shaikh','2026-04-09','2026-05-09','Requirement Specification',0,'On Track','2026-04-09 09:04:53','2026-04-09 09:04:53'),(37,NULL,1,'Eseel_Propack123','','IT & Development','jubeda shaikh','2026-04-10','2026-05-30','Planning',0,'At Risk','2026-04-10 06:17:45','2026-04-10 06:17:45');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotation_gst_details`
--

DROP TABLE IF EXISTS `quotation_gst_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_gst_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `quotation_id` int DEFAULT NULL,
  `tax_type` enum('CGST','SGST','IGST') DEFAULT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quotation_id` (`quotation_id`),
  KEY `idx_quotation_gst_tenant` (`tenant_id`),
  CONSTRAINT `fk_quotation_gst_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotation_gst_details_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotation_gst_details`
--

LOCK TABLES `quotation_gst_details` WRITE;
/*!40000 ALTER TABLE `quotation_gst_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_gst_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotation_history`
--

DROP TABLE IF EXISTS `quotation_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `quotation_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `user` varchar(100) DEFAULT NULL,
  `follow_up` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `quotation_id` (`quotation_id`),
  KEY `idx_quotation_history_tenant` (`tenant_id`),
  CONSTRAINT `fk_quotation_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotation_history_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotation_history`
--

LOCK TABLES `quotation_history` WRITE;
/*!40000 ALTER TABLE `quotation_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotation_items`
--

DROP TABLE IF EXISTS `quotation_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotation_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `quotation_id` int DEFAULT NULL,
  `sr_no` int DEFAULT NULL,
  `description` text,
  `quantity` decimal(10,2) DEFAULT NULL,
  `rate` decimal(15,2) DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `quotation_id` (`quotation_id`),
  KEY `idx_quotation_items_tenant` (`tenant_id`),
  CONSTRAINT `fk_quotation_items_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `quotation_items_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotation_items`
--

LOCK TABLES `quotation_items` WRITE;
/*!40000 ALTER TABLE `quotation_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotation_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotations`
--

DROP TABLE IF EXISTS `quotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `quotation_no` varchar(50) NOT NULL,
  `quotation_date` date NOT NULL,
  `ref_no` varchar(100) DEFAULT NULL,
  `buyer_gstin` varchar(15) DEFAULT NULL,
  `buyer_code` varchar(50) DEFAULT NULL,
  `party_address` text,
  `total_before_discount` decimal(15,2) DEFAULT '0.00',
  `discount` decimal(15,2) DEFAULT '0.00',
  `round_off` decimal(15,2) DEFAULT '0.00',
  `total_after_tax` decimal(15,2) DEFAULT '0.00',
  `status` enum('draft','sent','accepted','rejected','expired') DEFAULT 'draft',
  `valid_until` date DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `service_bank_details` json DEFAULT NULL,
  `service_gst_details` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `quotation_no` (`quotation_no`),
  KEY `idx_quotations_tenant` (`tenant_id`),
  CONSTRAINT `fk_quotations_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotations`
--

LOCK TABLES `quotations` WRITE;
/*!40000 ALTER TABLE `quotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `date_generated` datetime NOT NULL,
  `description` text NOT NULL,
  `generated_by` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `generated_by` (`generated_by`),
  KEY `idx_reports_tenant` (`tenant_id`),
  CONSTRAINT `fk_reports_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (18,1,'2026-03-22 00:00:00','Working',80,'2026-03-22 15:55:20','2026-03-22 15:55:20'),(25,1,'2026-04-06 10:59:15','testing',76,'2026-04-06 05:29:16','2026-04-06 05:35:25'),(26,1,'2026-04-09 12:33:10','ertfyguiopl[;',76,'2026-04-09 07:03:10','2026-04-09 07:03:10');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resignation_requests`
--

DROP TABLE IF EXISTS `resignation_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resignation_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `employee_id` varchar(50) NOT NULL,
  `requested_last_day` date NOT NULL,
  `reason` text NOT NULL,
  `additional_note` text,
  `status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `hr_note` text,
  `rejection_reason` text,
  `accepted_last_day` date DEFAULT NULL,
  `letter_url` varchar(500) DEFAULT NULL,
  `letter_generated_at` datetime DEFAULT NULL,
  `ref_number` varchar(100) DEFAULT NULL,
  `reviewed_by` int DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_rr_reviewer` (`reviewed_by`),
  KEY `idx_resignation_requests_tenant` (`tenant_id`),
  KEY `idx_resignation_requests_employee` (`employee_id`),
  KEY `idx_resignation_requests_status` (`status`),
  CONSTRAINT `fk_resignation_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rr_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rr_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_rr_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resignation_requests`
--

LOCK TABLES `resignation_requests` WRITE;
/*!40000 ALTER TABLE `resignation_requests` DISABLE KEYS */;
INSERT INTO `resignation_requests` VALUES (3,1,'AITS0010','2026-03-23','i am checking',NULL,'rejected',NULL,'no',NULL,NULL,NULL,'RES-2026-0001',NULL,NULL,'2026-03-23 10:45:35','2026-03-23 10:52:23'),(4,1,'AITS0010','2026-03-23','i am checking',NULL,'rejected',NULL,'h',NULL,NULL,NULL,'RES-2026-0002',NULL,NULL,'2026-03-23 10:59:07','2026-03-23 11:14:36'),(5,1,'AITS0010','2026-03-23','i am cheking ',NULL,'rejected',NULL,'dcfgh',NULL,NULL,NULL,'RES-2026-0003',NULL,NULL,'2026-03-23 11:16:45','2026-04-06 05:51:42'),(6,1,'AITS001','2026-04-08','kjfkljklsdf',NULL,'accepted','hgfdsa',NULL,'2026-04-07','/uploads/branding/1/letters/resignation/6_1775536599418.pdf','2026-04-07 10:06:39','RES-2026-0004',NULL,NULL,'2026-04-06 05:43:17','2026-04-07 04:36:39'),(7,1,'AITS003','2026-04-09','esdrtfgyhujiko',NULL,'accepted','ertgyhujikol',NULL,'2026-04-08','/uploads/branding/1/letters/resignation/7_1775625142038.pdf','2026-04-08 10:42:22','RES-2026-0005',NULL,NULL,'2026-04-08 05:11:52','2026-04-08 05:12:22');
/*!40000 ALTER TABLE `resignation_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_role_per_tenant` (`tenant_id`,`name`),
  KEY `idx_roles_tenant` (`tenant_id`),
  CONSTRAINT `fk_roles_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,1,'admin','Full system administrator with all permissions','2025-10-13 07:33:50'),(2,1,'hr','Manager with limited administrative privileges','2025-10-13 07:33:50'),(3,1,'employee','Trainer or support staff','2025-10-13 07:33:50'),(4,1,'student','Learner user','2025-10-13 07:33:50'),(9,3,'admin','Tenant Administrator','2026-03-19 04:31:20'),(10,3,'hr','Sub Administrator / HR','2026-03-19 04:31:20'),(11,3,'employee','Employee','2026-03-19 04:31:20'),(12,3,'student','Student','2026-03-19 04:31:20'),(13,4,'admin','Tenant Administrator','2026-03-19 04:36:12'),(14,4,'hr','Sub Administrator / HR','2026-03-19 04:36:12'),(15,4,'employee','Employee','2026-03-19 04:36:12'),(16,4,'student','Student','2026-03-19 04:36:12'),(17,6,'admin','Tenant Administrator','2026-03-19 05:25:58'),(18,6,'hr','Sub Administrator / HR','2026-03-19 05:25:58'),(19,6,'employee','Employee','2026-03-19 05:25:58'),(20,6,'student','Student','2026-03-19 05:25:58'),(21,7,'admin','Tenant Administrator','2026-03-19 05:26:27'),(22,7,'hr','Sub Administrator / HR','2026-03-19 05:26:27'),(23,7,'employee','Employee','2026-03-19 05:26:27'),(24,7,'student','Student','2026-03-19 05:26:27'),(25,8,'admin','Tenant Administrator','2026-03-19 05:26:28'),(26,8,'hr','Sub Administrator / HR','2026-03-19 05:26:28'),(27,8,'employee','Employee','2026-03-19 05:26:28'),(28,8,'student','Student','2026-03-19 05:26:28'),(29,9,'admin','Tenant Administrator','2026-03-20 06:21:03'),(30,9,'hr','Sub Administrator / HR','2026-03-20 06:21:03'),(31,9,'employee','Employee','2026-03-20 06:21:03'),(32,9,'student','Student','2026-03-20 06:21:03');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary_records`
--

DROP TABLE IF EXISTS `salary_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary_records` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT '1',
  `employee_id` varchar(20) NOT NULL,
  `department_id` int NOT NULL,
  `basic_salary` decimal(10,2) NOT NULL,
  `allowances` json NOT NULL,
  `deductions` json NOT NULL,
  `net_salary` decimal(10,2) NOT NULL,
  `payment_date` date DEFAULT NULL,
  `month` varchar(20) NOT NULL,
  `year` varchar(4) NOT NULL,
  `payment_frequency` enum('Monthly','Biweekly','Weekly') DEFAULT 'Monthly',
  `status` enum('pending','paid') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `attendance_summary` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `idx_salary_employee` (`employee_id`),
  KEY `idx_salary_period` (`month`,`year`),
  KEY `idx_salary_status` (`status`),
  CONSTRAINT `salary_records_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `salary_records_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary_records`
--

LOCK TABLES `salary_records` WRITE;
/*!40000 ALTER TABLE `salary_records` DISABLE KEYS */;
INSERT INTO `salary_records` VALUES (6,1,'AITS0021',13,1000.00,'{\"hra\": 499, \"medical\": 500, \"special\": 500, \"transport\": 500}','{\"tax\": 0, \"provident_fund\": 0, \"professional_tax\": 0}',2999.00,'2026-03-22','March','2026','Monthly','paid','2026-03-22 17:33:21','2026-03-22 17:33:21',NULL),(7,1,'AITS0032',13,50000.00,'{\"hra\": 4999, \"medical\": 500, \"special\": 998, \"transport\": 500}','{\"tax\": 0, \"provident_fund\": 0, \"professional_tax\": 0}',56997.00,'2026-03-22','March','2026','Monthly','paid','2026-03-22 17:47:33','2026-03-22 17:47:33',NULL),(8,1,'AITS0032',13,50000.00,'{\"hra\": 5000, \"medical\": 5000, \"special\": 4999, \"transport\": 5000}','{\"tax\": 0, \"provident_fund\": 0, \"professional_tax\": 0}',69999.00,'2026-03-22','April','2026','Monthly','paid','2026-03-22 17:53:20','2026-03-22 17:53:20',NULL),(44,1,'AITS004',13,7410.00,'{\"hra\": 7410, \"medical\": 452, \"special\": 40, \"transport\": 852}','{\"tax\": 741, \"provident_fund\": 741, \"professional_tax\": 85}',14597.00,'2026-04-09','April','2026','Monthly','paid','2026-04-09 06:41:49','2026-04-09 06:41:49',NULL),(45,1,'AITS003',14,7500.00,'{\"hra\": 0, \"medical\": 0, \"special\": 0, \"transport\": 0}','{\"tax\": 0, \"loan\": 0, \"insurance\": 0, \"provident_fund\": 0}',7500.00,'2026-04-09','April','2026','Monthly','pending','2026-04-09 07:18:42','2026-04-09 07:18:42',NULL),(46,1,'AITS001',13,7500.00,'{\"hra\": 0, \"medical\": 0, \"special\": 0, \"transport\": 0}','{\"tax\": 0, \"loan\": 0, \"insurance\": 0, \"provident_fund\": 0, \"attendance_deduction\": 125}',7375.00,'2026-04-09','April','2026','Monthly','pending','2026-04-09 07:42:58','2026-04-09 07:42:58',NULL);
/*!40000 ALTER TABLE `salary_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_history`
--

DROP TABLE IF EXISTS `service_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `service_id` int DEFAULT NULL,
  `date` date NOT NULL,
  `action` varchar(255) NOT NULL,
  `user` varchar(100) NOT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `service_id` (`service_id`),
  KEY `idx_service_history_tenant` (`tenant_id`),
  CONSTRAINT `fk_service_history_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_history_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_history`
--

LOCK TABLES `service_history` WRITE;
/*!40000 ALTER TABLE `service_history` DISABLE KEYS */;
INSERT INTO `service_history` VALUES (27,NULL,13,'2026-03-22','Service created','Admin',NULL,'2026-03-22 16:16:28');
/*!40000 ALTER TABLE `service_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_settings`
--

DROP TABLE IF EXISTS `service_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `setting_type` enum('bank','gst') NOT NULL,
  `account_holder` varchar(255) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `ifsc_code` varchar(20) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `account_type` varchar(50) DEFAULT NULL,
  `gstin` varchar(20) DEFAULT NULL,
  `pan_number` varchar(20) DEFAULT NULL,
  `hsn_code` varchar(20) DEFAULT NULL,
  `tax_rate` decimal(5,2) DEFAULT NULL,
  `is_gst_applicable` tinyint(1) DEFAULT '1',
  `sgst_rate` decimal(5,2) DEFAULT NULL,
  `cgst_rate` decimal(5,2) DEFAULT NULL,
  `igst_rate` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_service_settings_tenant` (`tenant_id`),
  CONSTRAINT `fk_service_settings_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_settings`
--

LOCK TABLES `service_settings` WRITE;
/*!40000 ALTER TABLE `service_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_status`
--

DROP TABLE IF EXISTS `service_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_service_status_per_tenant` (`tenant_id`,`name`),
  KEY `idx_service_status_tenant` (`tenant_id`),
  CONSTRAINT `fk_service_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_status`
--

LOCK TABLES `service_status` WRITE;
/*!40000 ALTER TABLE `service_status` DISABLE KEYS */;
INSERT INTO `service_status` VALUES (1,1,'Active','Service is currently active and ongoing','2025-11-04 05:43:36'),(2,1,'Scheduled','Service is scheduled for future','2025-11-04 05:43:36'),(3,1,'Completed','Service has been completed','2025-11-04 05:43:36'),(4,1,'Cancelled','Service has been cancelled','2025-11-04 05:43:36');
/*!40000 ALTER TABLE `service_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_team_members`
--

DROP TABLE IF EXISTS `service_team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_team_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `service_id` int DEFAULT NULL,
  `employee_id` varchar(20) DEFAULT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_service_employee` (`service_id`,`employee_id`),
  KEY `employee_id` (`employee_id`),
  KEY `idx_service_team_tenant` (`tenant_id`),
  CONSTRAINT `fk_service_team_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_team_members_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_team_members_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_team_members`
--

LOCK TABLES `service_team_members` WRITE;
/*!40000 ALTER TABLE `service_team_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_service_type_per_tenant` (`tenant_id`,`name`),
  KEY `idx_service_types_tenant` (`tenant_id`),
  CONSTRAINT `fk_service_types_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1,1,'Product','Product development and delivery services','2025-11-04 05:43:36','2026-03-19 04:21:05'),(2,1,'Consulting','Professional consulting services','2025-11-04 05:43:36','2026-03-19 04:21:05'),(3,1,'Support','Technical and customer support services','2025-11-04 05:43:36','2026-03-19 04:21:05'),(4,1,'Training','Employee and client training programs','2025-11-04 05:43:36','2026-03-19 04:21:05'),(5,1,'Maintenance','System maintenance and support','2025-11-04 05:43:36','2026-03-19 04:21:05');
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `service_name` varchar(255) NOT NULL,
  `service_type_id` int DEFAULT NULL,
  `description` text,
  `assigned_department_id` int DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `service_manager_id` varchar(20) DEFAULT NULL,
  `scheduled_date` date DEFAULT NULL,
  `scheduled_time` time DEFAULT NULL,
  `progress` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `service_type_id` (`service_type_id`),
  KEY `assigned_department_id` (`assigned_department_id`),
  KEY `status_id` (`status_id`),
  KEY `service_manager_id` (`service_manager_id`),
  KEY `idx_services_tenant` (`tenant_id`),
  CONSTRAINT `fk_services_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`),
  CONSTRAINT `services_ibfk_2` FOREIGN KEY (`assigned_department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `services_ibfk_3` FOREIGN KEY (`status_id`) REFERENCES `service_status` (`id`),
  CONSTRAINT `services_ibfk_4` FOREIGN KEY (`service_manager_id`) REFERENCES `employee_details` (`id`),
  CONSTRAINT `services_chk_1` CHECK (((`progress` >= 0) and (`progress` <= 100)))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (13,1,'Digital Marketing',5,NULL,NULL,1,'AITS004','2026-03-22','22:46:00',0,'2026-03-22 16:16:28','2026-03-22 16:16:28');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_attendance`
--

DROP TABLE IF EXISTS `student_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `student_id` int NOT NULL,
  `attendance_date` date NOT NULL,
  `check_in_time` time DEFAULT NULL,
  `check_out_time` time DEFAULT NULL,
  `total_hours` decimal(5,2) DEFAULT '0.00',
  `status` enum('present','absent','late','excused','half_day') DEFAULT 'present',
  `attendance_type` enum('manual','qr_scan','biometric','mobile') DEFAULT 'mobile',
  `remarks` varchar(255) DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_attendance_date` (`student_id`,`attendance_date`),
  KEY `course_id` (`course_id`),
  KEY `idx_student_attendance_date` (`attendance_date`),
  KEY `idx_student_attendance_status` (`student_id`,`status`),
  KEY `idx_student_attendance_tenant` (`tenant_id`),
  CONSTRAINT `fk_student_attendance_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_attendance_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_attendance`
--

LOCK TABLES `student_attendance` WRITE;
/*!40000 ALTER TABLE `student_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `student_attendance_summary`
--

DROP TABLE IF EXISTS `student_attendance_summary`;
/*!50001 DROP VIEW IF EXISTS `student_attendance_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `student_attendance_summary` AS SELECT 
 1 AS `tenant_id`,
 1 AS `student_id`,
 1 AS `month_year`,
 1 AS `total_days`,
 1 AS `present_days`,
 1 AS `absent_days`,
 1 AS `late_days`,
 1 AS `excused_days`,
 1 AS `half_days`,
 1 AS `attendance_percentage`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `student_daily_attendance_summary`
--

DROP TABLE IF EXISTS `student_daily_attendance_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_daily_attendance_summary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `summary_date` date NOT NULL,
  `total_students` int DEFAULT '0',
  `present_count` int DEFAULT '0',
  `absent_count` int DEFAULT '0',
  `late_count` int DEFAULT '0',
  `attendance_percentage` decimal(5,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_summary_per_tenant` (`tenant_id`,`summary_date`),
  KEY `idx_student_summary_date` (`summary_date`),
  KEY `idx_student_summary_tenant` (`tenant_id`),
  CONSTRAINT `fk_student_summary_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_daily_attendance_summary`
--

LOCK TABLES `student_daily_attendance_summary` WRITE;
/*!40000 ALTER TABLE `student_daily_attendance_summary` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_daily_attendance_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` enum('active','inactive','graduated') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `batch_timing` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `year` varchar(50) DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `address` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_student_email_per_tenant` (`tenant_id`,`email`),
  KEY `user_id` (`user_id`),
  KEY `course_id` (`course_id`),
  KEY `idx_students_tenant` (`tenant_id`),
  CONSTRAINT `fk_students_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `students_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `students_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (18,1,'student','.','student@gmail.com',NULL,'active','2026-02-27 07:39:09','2026-03-19 04:21:05',77,NULL,NULL,6,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suggested_positions`
--

DROP TABLE IF EXISTS `suggested_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suggested_positions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_position_per_tenant` (`tenant_id`,`name`),
  KEY `idx_suggested_positions_tenant` (`tenant_id`),
  CONSTRAINT `fk_suggested_positions_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suggested_positions`
--

LOCK TABLES `suggested_positions` WRITE;
/*!40000 ALTER TABLE `suggested_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `suggested_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `super_admins`
--

DROP TABLE IF EXISTS `super_admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `super_admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `super_admins`
--

LOCK TABLES `super_admins` WRITE;
/*!40000 ALTER TABLE `super_admins` DISABLE KEYS */;
INSERT INTO `super_admins` VALUES (1,'Super','Admin','superadmin@workdesk.com','$2a$10$lyvq1x./HKaSzm2FT2uS3OSh.OOQ.aLG03mWlPDRNNLwksmzxqjAm',1,'2026-03-19 04:21:05','2026-03-19 05:35:56');
/*!40000 ALTER TABLE `super_admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_assignees`
--

DROP TABLE IF EXISTS `task_assignees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_assignees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `assigned_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_task_employee` (`task_id`,`employee_id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_employee_id` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_assignees`
--

LOCK TABLES `task_assignees` WRITE;
/*!40000 ALTER TABLE `task_assignees` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_assignees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_comments`
--

DROP TABLE IF EXISTS `task_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `task_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `employee_name` varchar(255) DEFAULT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `task_comments_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `task_comments_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_comments`
--

LOCK TABLES `task_comments` WRITE;
/*!40000 ALTER TABLE `task_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `project_id` int NOT NULL,
  `team_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `priority` enum('High','Medium','Low') DEFAULT 'Medium',
  `status` enum('To-Do','In Progress','Ready for Review','Completed','Blocked','Cancelled') DEFAULT 'To-Do',
  `progress` int DEFAULT '0',
  `estimated_hours` decimal(5,2) DEFAULT '0.00',
  `actual_hours` decimal(5,2) DEFAULT '0.00',
  `assigned_to_team_lead` int DEFAULT NULL,
  `assigned_to_member` varchar(20) DEFAULT NULL,
  `assigned_by` int DEFAULT NULL,
  `assigned_by_name` varchar(255) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `completed_date` date DEFAULT NULL,
  `accepted` tinyint(1) DEFAULT '0',
  `accepted_date` datetime DEFAULT NULL,
  `review_status` enum('Not Reviewed','Approved','Rejected','Needs Rework') DEFAULT 'Not Reviewed',
  `review_comments` text,
  `review_date` datetime DEFAULT NULL,
  `reviewed_by` int DEFAULT NULL,
  `blocked_reason` text,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `remarks` text,
  PRIMARY KEY (`id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `idx_project` (`project_id`),
  KEY `idx_assigned_member` (`assigned_to_member`),
  CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks`
--

LOCK TABLES `tasks` WRITE;
/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
INSERT INTO `tasks` VALUES (27,1,27,36,'jhkjhkjhdkldkjdljd',NULL,'Medium','In Progress',50,0.00,0.00,NULL,'80',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed','dddd',NULL,NULL,NULL,NULL,'2026-04-02 10:51:43','2026-04-02 11:24:24',NULL),(28,1,34,37,'dfd','','High','In Progress',50,0.00,0.00,NULL,'80',76,'jubeda shaikh','2026-04-25',NULL,NULL,0,NULL,'Approved','n',NULL,NULL,NULL,NULL,'2026-04-02 11:11:27','2026-04-10 06:13:57','yes'),(29,1,27,20,'jhkjhkjhk',NULL,'Medium','To-Do',0,0.00,0.00,NULL,'79',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed',NULL,NULL,NULL,NULL,NULL,'2026-04-02 11:25:00','2026-04-02 11:25:00',NULL),(30,1,27,20,'jhkjhkjhk','kjkjlkjkljlkjlkjkl','Medium','In Progress',50,0.00,0.00,NULL,'76',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed','jhjkhjk',NULL,NULL,NULL,NULL,'2026-04-02 11:25:00','2026-04-02 11:25:27',NULL),(31,1,36,43,'jhkjhkjh',NULL,'Medium','Cancelled',0,0.00,0.00,NULL,'101',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed',NULL,NULL,NULL,NULL,NULL,'2026-04-09 10:46:22','2026-04-10 06:13:27',NULL),(32,1,36,43,'jhkjhkjh',NULL,'Medium','Cancelled',56,0.00,0.00,NULL,'80',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Approved','hjk',NULL,NULL,NULL,NULL,'2026-04-09 10:46:23','2026-04-10 05:49:48',NULL),(33,1,27,44,'wasedrftgyhujikol','fjsdfskfjsdlkjsdlkjsdlkjsd','Medium','To-Do',0,0.00,0.00,NULL,'79',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed',NULL,NULL,NULL,NULL,NULL,'2026-04-09 10:47:53','2026-04-10 04:09:59',NULL),(34,1,34,37,'fhgghjpok',NULL,'Medium','Cancelled',0,0.00,0.00,NULL,'76',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed',NULL,NULL,NULL,NULL,NULL,'2026-04-09 10:57:06','2026-04-10 05:54:08',NULL),(35,1,34,37,'fhgghjpok',NULL,'Medium','Cancelled',0,0.00,0.00,NULL,'101',76,'jubeda shaikh',NULL,NULL,NULL,0,NULL,'Not Reviewed',NULL,NULL,NULL,NULL,NULL,'2026-04-09 10:57:06','2026-04-10 05:54:14',NULL);
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_attendance`
--

DROP TABLE IF EXISTS `tb_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_attendance` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `employee_id` varchar(20) NOT NULL,
  `shift_id` int NOT NULL,
  `date` date NOT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `status` enum('Present','Delayed','On Leave','Absent','Pending','Half Day') DEFAULT 'Pending',
  `approved_by` varchar(20) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_half_day` tinyint(1) DEFAULT '0',
  `is_late` tinyint(1) DEFAULT '0',
  `late_minutes` int DEFAULT '0',
  `late_streak` int DEFAULT '0',
  `worked_hours` decimal(5,2) DEFAULT '0.00',
  `scheduled_check_in` time DEFAULT NULL,
  `grace_period_minutes` int DEFAULT '15',
  `should_deduct_salary` tinyint(1) DEFAULT '0' COMMENT 'Flag to indicate if salary should be deducted for this attendance',
  `deduction_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'Amount to deduct from salary',
  `deduction_reason` varchar(255) DEFAULT NULL COMMENT 'Reason for salary deduction',
  PRIMARY KEY (`attendance_id`),
  UNIQUE KEY `unique_employee_date` (`employee_id`,`date`),
  KEY `shift_id` (`shift_id`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_attendance_tenant` (`tenant_id`),
  CONSTRAINT `fk_attendance_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tb_attendance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tb_attendance_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `tb_shifts` (`shift_id`) ON DELETE RESTRICT,
  CONSTRAINT `tb_attendance_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `employee_details` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_attendance`
--

LOCK TABLES `tb_attendance` WRITE;
/*!40000 ALTER TABLE `tb_attendance` DISABLE KEYS */;
INSERT INTO `tb_attendance` VALUES (51,1,'AITS001',9,'2026-03-12','2026-03-12 10:55:15',NULL,'Delayed',NULL,NULL,'Manual entry at 10:55:14 AM','2026-03-12 05:25:15','2026-03-19 04:21:05',0,0,0,0,0.00,NULL,15,0,0.00,NULL),(53,1,'AITS001',9,'2026-03-14','2026-03-14 13:01:11','2026-03-14 13:01:35','Delayed',NULL,NULL,'Manual entry at 1:01:10 PM','2026-03-14 07:31:10','2026-03-19 04:21:05',0,0,0,0,0.00,NULL,15,0,0.00,NULL),(54,NULL,'AITS004',9,'2026-03-22','2026-03-22 21:24:39',NULL,'Delayed',NULL,NULL,'Face verified (92.5 confidence)','2026-03-22 15:54:39','2026-03-22 15:54:39',0,0,0,0,0.00,NULL,15,0,0.00,NULL),(55,NULL,'AITS001',9,'2026-04-02','2026-04-02 09:42:44',NULL,'Present',NULL,NULL,'Manual entry at 9:42:44 AM','2026-04-02 04:12:44','2026-04-08 10:41:25',0,0,0,0,0.00,NULL,15,0,0.00,NULL),(56,NULL,'AITS001',9,'2026-04-04','2026-04-04 15:46:43',NULL,'Delayed',NULL,NULL,'Manual entry at 3:46:43 PM','2026-04-04 10:16:43','2026-04-08 10:41:25',0,0,0,1,0.00,NULL,15,0,0.00,NULL),(57,NULL,'AITS001',9,'2026-04-06','2026-04-06 10:33:58',NULL,'Delayed',NULL,NULL,'Manual entry at 10:33:57 AM','2026-04-06 05:03:57','2026-04-08 10:41:25',0,0,0,1,0.00,NULL,15,0,0.00,NULL),(58,NULL,'AITS001',9,'2026-04-07','2026-04-07 13:03:38',NULL,'Delayed',NULL,NULL,'Manual entry at 1:03:37 PM','2026-04-07 07:33:37','2026-04-08 10:41:25',0,0,0,2,0.00,NULL,15,0,0.00,NULL),(59,NULL,'AITS003',9,'2026-04-07','2026-04-07 13:04:07',NULL,'Delayed',NULL,NULL,'Manual entry at 1:04:06 PM','2026-04-07 07:34:06','2026-04-07 07:34:06',0,0,0,0,0.00,NULL,15,0,0.00,NULL),(60,NULL,'AITS003',9,'2026-04-08','2026-04-08 10:56:32',NULL,'Delayed',NULL,NULL,'Manual entry at 10:56:32 AM','2026-04-08 05:26:32','2026-04-08 05:26:32',0,1,87,0,0.00,NULL,15,0,0.00,NULL),(61,1,'AITS001',9,'2026-04-08','2026-04-08 11:46:20','2026-04-08 12:32:57','Half Day',NULL,NULL,'Manual entry at 11:46:20 AM','2026-04-08 06:16:20','2026-04-08 07:02:56',1,1,136,0,0.78,NULL,15,0,0.00,NULL),(70,1,'AITS001',9,'2026-04-09','2026-04-09 11:59:32',NULL,'Delayed',NULL,NULL,'Face verified check-in (90.8% confidence)','2026-04-09 06:29:31','2026-04-09 06:29:31',0,1,150,1,0.00,'09:30:00',20,0,0.00,NULL),(71,1,'AITS003',9,'2026-04-10','2026-04-10 09:23:03',NULL,'Present',NULL,NULL,'','2026-04-10 03:53:05','2026-04-10 03:53:05',0,0,0,0,0.00,'09:30:00',20,0,0.00,NULL);
/*!40000 ALTER TABLE `tb_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_employee_shifts`
--

DROP TABLE IF EXISTS `tb_employee_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_employee_shifts` (
  `emp_shift_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `employee_id` varchar(20) NOT NULL,
  `shift_id` int NOT NULL,
  `assigned_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`emp_shift_id`),
  UNIQUE KEY `unique_employee_shift_date` (`employee_id`,`shift_id`,`assigned_date`),
  KEY `shift_id` (`shift_id`),
  KEY `idx_emp_shifts_tenant` (`tenant_id`),
  CONSTRAINT `fk_emp_shifts_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tb_employee_shifts_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee_details` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tb_employee_shifts_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `tb_shifts` (`shift_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_employee_shifts`
--

LOCK TABLES `tb_employee_shifts` WRITE;
/*!40000 ALTER TABLE `tb_employee_shifts` DISABLE KEYS */;
INSERT INTO `tb_employee_shifts` VALUES (183,1,'AITS001',9,'2026-03-12','2026-03-12 05:24:48','2026-03-19 04:21:05'),(185,1,'AITS001',9,'2026-03-14','2026-03-14 07:31:10','2026-03-19 04:21:05'),(186,1,'AITS001',9,'2026-03-16','2026-03-16 06:39:23','2026-03-19 04:21:05'),(188,NULL,'AITS004',9,'2026-03-22','2026-03-22 15:54:39','2026-03-22 15:54:39'),(189,NULL,'AITS001',9,'2026-03-22','2026-03-22 15:59:12','2026-03-22 15:59:12'),(191,NULL,'AITS003',9,'2026-03-22','2026-03-22 15:59:12','2026-03-22 15:59:12'),(195,NULL,'AITS001',9,'2026-03-28','2026-03-28 04:14:25','2026-03-28 04:14:25'),(196,NULL,'AITS0010',9,'2026-03-28','2026-03-28 04:14:25','2026-03-28 04:14:25'),(197,NULL,'AITS003',9,'2026-03-28','2026-03-28 04:14:25','2026-03-28 04:14:25'),(198,NULL,'AITS004',9,'2026-03-28','2026-03-28 04:14:25','2026-03-28 04:14:25'),(199,NULL,'AITS011',9,'2026-03-28','2026-03-28 04:14:25','2026-03-28 04:14:25'),(200,NULL,'AITS001',9,'2026-04-02','2026-04-02 04:12:43','2026-04-02 04:12:43'),(201,NULL,'AITS001',9,'2026-04-04','2026-04-04 10:16:43','2026-04-04 10:16:43'),(202,NULL,'AITS001',9,'2026-04-06','2026-04-06 05:03:57','2026-04-06 05:03:57'),(203,NULL,'AITS0010',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(204,NULL,'AITS003',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(205,NULL,'AITS004',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(206,NULL,'AITS011',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(207,NULL,'AITS012',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(208,NULL,'AITS013',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(209,NULL,'AITS014',9,'2026-04-06','2026-04-06 07:24:07','2026-04-06 07:24:07'),(250,NULL,'AITS014',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(251,NULL,'AITS004',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(252,NULL,'AITS012',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(253,NULL,'AITS0010',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(254,NULL,'AITS003',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(255,NULL,'AITS011',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(256,NULL,'AITS013',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(257,NULL,'AITS001',9,'2026-04-07','2026-04-07 07:31:47','2026-04-07 07:31:47'),(258,NULL,'AITS001',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(259,NULL,'AITS0010',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(260,NULL,'AITS003',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(261,NULL,'AITS004',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(262,NULL,'AITS011',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(263,NULL,'AITS012',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(264,NULL,'AITS013',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36'),(265,NULL,'AITS014',9,'2026-04-09','2026-04-09 04:46:36','2026-04-09 04:46:36');
/*!40000 ALTER TABLE `tb_employee_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_shifts`
--

DROP TABLE IF EXISTS `tb_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_shifts` (
  `shift_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `shift_name` varchar(100) NOT NULL,
  `check_in_time` time NOT NULL,
  `check_out_time` time NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_default` tinyint(1) DEFAULT '0',
  `grace_period_minutes` int DEFAULT '15',
  PRIMARY KEY (`shift_id`),
  KEY `idx_shifts_tenant` (`tenant_id`),
  CONSTRAINT `fk_shifts_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_shifts`
--

LOCK TABLES `tb_shifts` WRITE;
/*!40000 ALTER TABLE `tb_shifts` DISABLE KEYS */;
INSERT INTO `tb_shifts` VALUES (9,1,'testing','09:30:00','17:00:00','2026-03-12 05:24:48','2026-04-07 07:31:47',1,20);
/*!40000 ALTER TABLE `tb_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_members`
--

DROP TABLE IF EXISTS `team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `team_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `role_in_team` varchar(100) DEFAULT 'Member',
  `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `left_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_team_member` (`team_id`,`employee_id`,`is_active`),
  KEY `idx_team_id` (`team_id`),
  KEY `idx_employee_id` (`employee_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `team_members_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `team_members_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_members`
--

LOCK TABLES `team_members` WRITE;
/*!40000 ALTER TABLE `team_members` DISABLE KEYS */;
INSERT INTO `team_members` VALUES (16,1,19,79,'Member','2026-03-31 07:45:25',NULL,1),(17,1,19,76,'Member','2026-03-31 07:45:25',NULL,1),(18,1,20,79,'Member','2026-03-31 07:47:48',NULL,1),(19,1,20,76,'Member','2026-03-31 07:47:48',NULL,1),(22,1,22,103,'Member','2026-03-31 11:48:02',NULL,1),(23,1,22,88,'Member','2026-03-31 11:48:02',NULL,1),(24,1,22,76,'Member','2026-03-31 11:48:02',NULL,1),(25,1,22,79,'Member','2026-03-31 11:48:02',NULL,1),(28,1,36,80,'Member','2026-04-02 06:01:51',NULL,1),(29,1,36,79,'Member','2026-04-02 06:01:51',NULL,1),(30,1,36,102,'Member','2026-04-02 06:01:51',NULL,1),(31,1,37,101,'Member','2026-04-02 11:11:04',NULL,1),(32,1,37,80,'Member','2026-04-02 11:11:04',NULL,1),(33,1,37,76,'Member','2026-04-02 11:11:04',NULL,1),(34,1,38,88,'Member','2026-04-03 07:23:34',NULL,1),(35,1,38,101,'Member','2026-04-03 07:23:34',NULL,1),(36,1,38,79,'Member','2026-04-03 07:23:34',NULL,1),(37,1,39,103,'Member','2026-04-06 09:42:03',NULL,1),(38,1,39,102,'Member','2026-04-06 09:42:03',NULL,1),(39,1,40,80,'Member','2026-04-08 04:40:35',NULL,1),(40,1,40,101,'Member','2026-04-08 04:40:35',NULL,1),(41,1,40,76,'Member','2026-04-08 04:40:35',NULL,1),(42,1,41,101,'Member','2026-04-09 09:19:29',NULL,1),(43,1,41,88,'Member','2026-04-09 09:19:29',NULL,1),(44,1,41,79,'Member','2026-04-09 09:19:29',NULL,1),(45,1,41,99,'Member','2026-04-09 09:19:29',NULL,1),(46,1,42,79,'Member','2026-04-09 09:30:11',NULL,1),(47,1,42,88,'Member','2026-04-09 09:30:11',NULL,1),(48,1,42,101,'Member','2026-04-09 09:30:11',NULL,1),(49,1,42,80,'Member','2026-04-09 09:30:11',NULL,1),(50,1,43,101,'Member','2026-04-09 10:31:03',NULL,1),(51,1,43,80,'Member','2026-04-09 10:31:03',NULL,1),(52,1,43,88,'Member','2026-04-09 10:31:03',NULL,1),(53,1,44,79,'Member','2026-04-09 10:47:20',NULL,1),(54,1,45,103,'Member','2026-04-10 05:33:43',NULL,1),(55,1,45,80,'Member','2026-04-10 05:33:43',NULL,1),(56,1,45,101,'Member','2026-04-10 05:33:43',NULL,1),(57,1,45,79,'Member','2026-04-10 05:33:43',NULL,1),(58,1,46,80,'Member','2026-04-10 05:59:21',NULL,1),(59,1,46,101,'Member','2026-04-10 05:59:21',NULL,1),(60,1,46,88,'Member','2026-04-10 05:59:21',NULL,1),(61,1,47,80,'Member','2026-04-10 06:00:26',NULL,1),(62,1,47,101,'Member','2026-04-10 06:00:26',NULL,1);
/*!40000 ALTER TABLE `team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `project_id` int NOT NULL,
  `team_lead_id` int DEFAULT NULL,
  `description` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_status` (`status`),
  KEY `team_lead_id` (`team_lead_id`),
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `teams_ibfk_2` FOREIGN KEY (`team_lead_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (19,1,'frontend team',27,NULL,'testing','Inactive','2026-03-31 07:45:25','2026-04-10 06:12:08'),(20,1,'frontednd development team',27,NULL,NULL,'Active','2026-03-31 07:47:48','2026-03-31 07:47:48'),(22,1,'frontednd development teamm',27,NULL,NULL,'Inactive','2026-03-31 11:48:02','2026-04-10 06:12:13'),(23,1,'ahmednagar ',27,NULL,NULL,'Inactive','2026-04-01 07:11:25','2026-04-10 06:12:17'),(26,1,'aa',27,NULL,NULL,'Inactive','2026-04-01 07:28:11','2026-04-10 06:12:22'),(27,1,'ahmednagar',27,NULL,NULL,'Inactive','2026-04-01 07:32:23','2026-04-10 06:12:26'),(28,1,'frontend',27,NULL,NULL,'Inactive','2026-04-01 07:35:31','2026-04-10 06:12:33'),(36,1,'workdesk',27,NULL,NULL,'Inactive','2026-04-02 06:01:51','2026-04-10 06:12:43'),(37,1,'sddas',34,NULL,NULL,'Inactive','2026-04-02 11:11:04','2026-04-10 06:12:39'),(38,1,'ff',34,NULL,NULL,'Inactive','2026-04-03 07:23:34','2026-04-10 06:12:59'),(39,1,'Eseel_Propack',34,NULL,NULL,'Active','2026-04-06 09:42:03','2026-04-06 09:42:03'),(40,1,'frontend',34,NULL,NULL,'Inactive','2026-04-08 04:40:35','2026-04-10 06:12:49'),(41,1,'frontednd development teamm',36,NULL,'tgyhujikolp;[','Inactive','2026-04-09 09:19:29','2026-04-10 06:12:53'),(42,1,'sdfgfdsfsfsdaf',36,NULL,NULL,'Inactive','2026-04-09 09:30:11','2026-04-10 06:13:15'),(43,1,'sdfghhgffjkjhgf',36,NULL,NULL,'Inactive','2026-04-09 10:31:03','2026-04-10 06:13:04'),(44,1,'fffffffff',27,NULL,NULL,'Inactive','2026-04-09 10:47:20','2026-04-10 06:13:09'),(45,1,'gjkl;',36,NULL,NULL,'Inactive','2026-04-10 05:33:43','2026-04-10 06:12:00'),(46,1,'hjkl;\'',36,NULL,NULL,'Inactive','2026-04-10 05:59:21','2026-04-10 06:02:38'),(47,1,'lklj',36,NULL,NULL,'Inactive','2026-04-10 06:00:26','2026-04-10 06:02:32');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenant_branding`
--

DROP TABLE IF EXISTS `tenant_branding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant_branding` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `hr_name` varchar(255) DEFAULT NULL,
  `hr_designation` varchar(255) DEFAULT NULL,
  `company_address` text,
  `company_email` varchar(255) DEFAULT NULL,
  `company_website` varchar(255) DEFAULT NULL,
  `logo_url` text,
  `signature_url` text,
  `stamp_url` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tenant_id` (`tenant_id`),
  KEY `idx_tenant_branding_tenant` (`tenant_id`),
  CONSTRAINT `fk_tb_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant_branding`
--

LOCK TABLES `tenant_branding` WRITE;
/*!40000 ALTER TABLE `tenant_branding` DISABLE KEYS */;
INSERT INTO `tenant_branding` VALUES (1,1,'Arham IT Solution 123','Imran Shaikh','Founder & CEO','Ahmednagar, Maharashtra, 414001\nAhmednagar, Maharashtra, 414001\nSaudagar Furniture','info@arhamitsolution.in','https://arhamitsolution.in','/uploads/branding/1/company_logo.png','/uploads/branding/1/hr_signature.jpg','/uploads/branding/1/company_stamp.png','2026-03-23 07:06:52','2026-03-23 07:26:42');
/*!40000 ALTER TABLE `tenant_branding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `logo_url` varchar(500) DEFAULT NULL,
  `subscription_plan` enum('free','basic','premium','enterprise') DEFAULT 'free',
  `is_active` tinyint(1) DEFAULT '1',
  `max_employees` int DEFAULT '10',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES (1,'Arham IT Solutions','arham-it','admin@arhamitsolutions.com',NULL,NULL,NULL,'free',1,10,'2026-03-19 04:20:46','2026-03-19 04:20:46'),(3,'Kosque Technolabs','kosque-technolabs','superadmin@workdesk.com','+91 812320365',NULL,NULL,'premium',1,10,'2026-03-19 04:31:20','2026-03-19 05:25:14'),(4,'entgra','entgra','entgra@gmail.com','+91 234343284',NULL,NULL,'premium',1,10,'2026-03-19 04:36:12','2026-03-19 04:36:12'),(6,'Test Tenant','test-tenant-1773897958402','company@test-tenant-1773897958402.com',NULL,NULL,NULL,'free',1,10,'2026-03-19 05:25:58','2026-03-19 05:25:58'),(7,'Tenant A','tenant-a-1773897987745','company@tenant-a-1773897987745.com',NULL,NULL,NULL,'free',1,10,'2026-03-19 05:26:27','2026-03-19 05:26:27'),(8,'Tenant B','tenant-b-1773897987998','company@tenant-b-1773897987998.com',NULL,NULL,NULL,'free',1,10,'2026-03-19 05:26:28','2026-03-19 05:26:28'),(9,'Microsoft','microsoft','micro@gmail.com','+91 54665465531',NULL,NULL,'premium',1,100,'2026-03-20 06:21:03','2026-03-20 06:21:03');
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int DEFAULT NULL,
  `role_id` int NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  KEY `idx_users_tenant` (`tenant_id`),
  CONSTRAINT `fk_users_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (3,1,1,'Arham','Admin','admin@arhamitsolutions.com','$2a$10$VvUy/GeJbd9f6/F6Li8KAevlzRBolNLtbwosD0KrGD4psmkt/Sv6m','+1234567890',NULL,1,'2025-10-28 12:41:05','2026-03-19 04:21:05'),(76,1,3,'jubeda','shaikh','jubeda.aits@gmail.com','$2a$10$YfeUG16xGHyMYTzl5dDASe8sjvOkNmWL.qKcEH0cpzJwht2JPfTxS',NULL,NULL,1,'2026-02-27 07:36:14','2026-03-19 04:21:05'),(77,1,4,'student','.','student@gmail.com','$2a$10$eQ7UZO7CDcdB639UIiS1BeIbUBbQjyVzPSdeyLNZLTw1RfoiCdVE2',NULL,NULL,1,'2026-02-27 07:39:09','2026-03-19 04:21:05'),(79,1,3,'Asifa','Sarkar','asifa.aits0010@gmail.com','$2a$10$RVE44SUDxcmEXZTS18US2OTrHE29YnEEvtUBafKU4E.UNbagVlim2','9284027990',NULL,1,'2026-03-16 07:05:02','2026-03-30 05:54:32'),(80,1,3,'Aniruddha','Manmode','aniruddha.aits@gmail.com','$2a$10$pBO2uep8e16DjpMR.H99Eetm6gyTF7I7GGsspnExV9QP3630s94V2','+918830681554',NULL,1,'2026-03-16 07:06:45','2026-03-22 15:20:55'),(82,3,9,'Aniruddha','Manmode','aniruddhamanmode@gmail.com','$2a$10$3CxNO8a4WdYd8hBj6DnJheLCjH46v176jc7snSz6FXewpnE4pW4B.',NULL,NULL,1,'2026-03-19 04:31:20','2026-03-19 04:31:20'),(83,4,13,'test','user','test@gmail.com','$2a$10$MI5PlBhHYY8SIJ1GxsuT4.t.igwUA0MmGiowZXRoUzcS8lCQFT/wu',NULL,NULL,1,'2026-03-19 04:36:12','2026-03-19 04:36:12'),(84,6,17,'Test','Admin','admin@test-tenant-1773897958402.com','$2a$10$hCPF751hZ0vINpCK5YV41Op7AH4bOJxIZNqP6O7ZieeNnCF96BMWC',NULL,NULL,1,'2026-03-19 05:25:58','2026-03-19 05:25:58'),(85,7,21,'Test','Admin','admin@tenant-a-1773897987745.com','$2a$10$m4kPaOVHX/bGWRucRKuCvuy4Z1y5DazD6clseyEnC2u6rRUL4W9z2',NULL,NULL,1,'2026-03-19 05:26:27','2026-03-19 05:26:27'),(86,8,25,'Test','Admin','admin@tenant-b-1773897987998.com','$2a$10$WfrxxG8pGYecmaReoxIjoOcpiIYEtMXKA37sZ5SJKn5Gq6z1CESoS',NULL,NULL,1,'2026-03-19 05:26:28','2026-03-19 05:26:28'),(87,9,29,'Bill','Gates','bill@gmail.com','$2a$10$NRKkplINpSMr7/rMYUdTgOt63xN9Fo/ptJB21GGHHnybrK1umWaFy',NULL,NULL,1,'2026-03-20 06:21:03','2026-03-20 06:21:03'),(88,1,2,'Arshan','Shaikh','arshanshaikh200@gmail.com','$2a$10$oYurddKGgc.IpCijQJmFf.meEYNC7n0gz8Ox2ffm3mrr3MOcrRXwe','8793740825',NULL,1,'2026-03-23 06:31:06','2026-03-26 07:58:28'),(99,1,2,'H','R','hr6@gmail.com','$2a$10$XigZmdnnTArfAHzIY0X.PuX0jNkmUYRiuhyZz9aWVtumhyjooxbce',NULL,NULL,1,'2026-03-27 05:14:03','2026-03-27 05:15:59'),(101,1,2,'Aniruddha','Manmode','aniruddha123.aits@gmail.com',NULL,'9874563210',NULL,1,'2026-03-31 07:06:00','2026-03-31 07:06:00'),(102,1,1,'Jubeda','ff','jubeda.hr@gmail.com',NULL,'123456789',NULL,1,'2026-03-31 07:08:03','2026-04-09 06:25:45'),(103,1,3,'aa','bb','ab@gamil.com',NULL,NULL,NULL,1,'2026-03-31 08:13:17','2026-03-31 08:13:17'),(104,1,3,'Jubeda','Shaikh','jubeda1233.aits@gmail.com','$2a$10$pCseHQoyUnO2xH1Evl7pYO8hsj5icTBTNx1i9S/fL5pAkjk6dbLFK',NULL,NULL,1,'2026-04-10 06:22:01','2026-04-10 06:22:01');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `student_attendance_summary`
--

/*!50001 DROP VIEW IF EXISTS `student_attendance_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `student_attendance_summary` AS select `sa`.`tenant_id` AS `tenant_id`,`sa`.`student_id` AS `student_id`,date_format(`sa`.`attendance_date`,'%Y-%m') AS `month_year`,count(0) AS `total_days`,sum((case when (`sa`.`status` = 'present') then 1 else 0 end)) AS `present_days`,sum((case when (`sa`.`status` = 'absent') then 1 else 0 end)) AS `absent_days`,sum((case when (`sa`.`status` = 'late') then 1 else 0 end)) AS `late_days`,sum((case when (`sa`.`status` = 'excused') then 1 else 0 end)) AS `excused_days`,sum((case when (`sa`.`status` = 'half_day') then 1 else 0 end)) AS `half_days`,round(((sum((case when (`sa`.`status` in ('present','late','half_day')) then 1 else 0 end)) * 100.0) / count(0)),2) AS `attendance_percentage` from `student_attendance` `sa` group by `sa`.`tenant_id`,`sa`.`student_id`,date_format(`sa`.`attendance_date`,'%Y-%m') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-10 13:03:04

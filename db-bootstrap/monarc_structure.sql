-- MySQL dump 10.19  Distrib 10.3.39-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: monarc_dev_iso27002_common
-- ------------------------------------------------------
-- Server version	10.3.39-MariaDB-0+deb10u2

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
-- Table structure for table `amvs`
--

DROP TABLE IF EXISTS `amvs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amvs` (
  `uuid` char(36) NOT NULL,
  `vulnerability_id` char(36) NOT NULL,
  `threat_id` char(36) NOT NULL,
  `asset_id` char(36) NOT NULL,
  `position` int(11) DEFAULT 1,
  `status` int(11) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`uuid`),
  KEY `asset_id` (`asset_id`),
  KEY `threat_id` (`threat_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  KEY `uuid` (`uuid`),
  CONSTRAINT `amvs_ibfk_5` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `amvs_ibfk_6` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `amvs_ibfk_7` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anr_instance_metadata_fields`
--

DROP TABLE IF EXISTS `anr_instance_metadata_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anr_instance_metadata_fields` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned NOT NULL,
  `label_translation_key` varchar(255) NOT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  CONSTRAINT `anr_instance_metadata_fields_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anrs`
--

DROP TABLE IF EXISTS `anrs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anrs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `description1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description3` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description4` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seuil1` int(11) DEFAULT 0,
  `seuil2` int(11) DEFAULT 0,
  `seuil_rolf1` int(11) DEFAULT 0,
  `seuil_rolf2` int(11) DEFAULT 0,
  `seuil_traitement` int(11) DEFAULT 0,
  `init_anr_context` tinyint(4) DEFAULT 0,
  `init_eval_context` tinyint(4) DEFAULT 0,
  `init_risk_context` tinyint(4) DEFAULT 0,
  `init_def_context` tinyint(4) DEFAULT 0,
  `init_livrable_done` tinyint(4) DEFAULT 0,
  `model_impacts` tinyint(4) DEFAULT 0,
  `model_summary` tinyint(4) DEFAULT 0,
  `model_livrable_done` tinyint(4) DEFAULT 0,
  `eval_risks` tinyint(4) DEFAULT 0,
  `eval_plan_risks` tinyint(4) DEFAULT 0,
  `eval_livrable_done` tinyint(4) DEFAULT 0,
  `manage_risks` tinyint(4) DEFAULT 0,
  `context_ana_risk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_gest_risk` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `synth_threat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `synth_act` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cache_model_show_rolf_brut` tinyint(4) DEFAULT 0,
  `show_rolf_brut` tinyint(4) DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `status` tinyint(4) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anrs_objects`
--

DROP TABLE IF EXISTS `anrs_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anrs_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` char(36) NOT NULL,
  `anr_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `object_id` (`object_id`),
  CONSTRAINT `anrs_objects_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `anrs_objects_ibfk_2` FOREIGN KEY (`object_id`) REFERENCES `objects` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1597 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `anrs_objects_categories`
--

DROP TABLE IF EXISTS `anrs_objects_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `anrs_objects_categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `object_category_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `object_category_id` (`object_category_id`),
  CONSTRAINT `anrs_objects_categories_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `anrs_objects_categories_ibfk_2` FOREIGN KEY (`object_category_id`) REFERENCES `objects_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `uuid` char(36) NOT NULL,
  `mode` tinyint(4) DEFAULT 1,
  `type` tinyint(4) DEFAULT 1,
  `code` char(100) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `description1` text DEFAULT NULL,
  `description2` text DEFAULT NULL,
  `description3` text DEFAULT NULL,
  `description4` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `assets_code_unq` (`code`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assets_models`
--

DROP TABLE IF EXISTS `assets_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets_models` (
  `model_id` int(11) unsigned NOT NULL,
  `asset_id` char(36) NOT NULL,
  PRIMARY KEY (`asset_id`,`model_id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `assets_models_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`),
  CONSTRAINT `assets_models_ibfk_4` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`) ON DELETE CASCADE,
  CONSTRAINT `assets_models_ibfk_5` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guides`
--

DROP TABLE IF EXISTS `guides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guides` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `type` tinyint(4) NOT NULL,
  `description1` text DEFAULT NULL,
  `description2` text DEFAULT NULL,
  `description3` text DEFAULT NULL,
  `description4` text DEFAULT NULL,
  `is_with_items` tinyint(4) NOT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  CONSTRAINT `guides_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `guides_items`
--

DROP TABLE IF EXISTS `guides_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `guides_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `guide_id` int(11) unsigned DEFAULT NULL,
  `description1` text NOT NULL,
  `description2` text NOT NULL,
  `description3` text NOT NULL,
  `description4` text NOT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `guide_id` (`guide_id`),
  KEY `position` (`position`),
  CONSTRAINT `guides_items_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `guides_items_ibfk_2` FOREIGN KEY (`guide_id`) REFERENCES `guides` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historicals`
--

DROP TABLE IF EXISTS `historicals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historicals` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `source_id` varchar(64) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instances`
--

DROP TABLE IF EXISTS `instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instances` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` char(36) DEFAULT NULL,
  `asset_id` char(36) NOT NULL,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `root_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `name1` varchar(255) DEFAULT NULL,
  `name2` varchar(255) DEFAULT NULL,
  `name3` varchar(255) DEFAULT NULL,
  `name4` varchar(255) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `level` tinyint(4) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT 0,
  `c` int(11) DEFAULT -1,
  `i` int(11) DEFAULT -1,
  `d` int(11) DEFAULT -1,
  `ch` tinyint(4) DEFAULT 0,
  `ih` tinyint(4) DEFAULT 0,
  `dh` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `root_id` (`root_id`),
  KEY `parent_id` (`parent_id`),
  KEY `asset_id` (`asset_id`),
  KEY `object_id` (`object_id`),
  CONSTRAINT `instances_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_ibfk_4` FOREIGN KEY (`root_id`) REFERENCES `instances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_ibfk_5` FOREIGN KEY (`parent_id`) REFERENCES `instances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_ibfk_6` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `instances_ibfk_7` FOREIGN KEY (`object_id`) REFERENCES `objects` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instances_consequences`
--

DROP TABLE IF EXISTS `instances_consequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instances_consequences` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT 0,
  `instance_id` int(11) unsigned DEFAULT 0,
  `scale_impact_type_id` int(11) unsigned DEFAULT 0,
  `is_hidden` tinyint(4) DEFAULT 0,
  `c` tinyint(4) DEFAULT -1,
  `i` tinyint(4) DEFAULT -1,
  `d` tinyint(4) DEFAULT -1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `instance_id` (`instance_id`),
  KEY `scale_impact_type_id` (`scale_impact_type_id`),
  CONSTRAINT `instances_consequences_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_consequences_ibfk_2` FOREIGN KEY (`instance_id`) REFERENCES `instances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_consequences_ibfk_4` FOREIGN KEY (`scale_impact_type_id`) REFERENCES `scales_impact_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instances_risks`
--

DROP TABLE IF EXISTS `instances_risks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instances_risks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `amv_id` char(36) DEFAULT NULL,
  `vulnerability_id` char(36) NOT NULL,
  `threat_id` char(36) NOT NULL,
  `asset_id` char(36) NOT NULL,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `specific` tinyint(4) DEFAULT 0,
  `mh` tinyint(4) NOT NULL DEFAULT 1,
  `threat_rate` int(11) NOT NULL DEFAULT -1,
  `vulnerability_rate` int(11) NOT NULL DEFAULT -1,
  `kind_of_measure` tinyint(4) DEFAULT 5,
  `reduction_amount` int(3) DEFAULT 0,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment_after` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `risk_c` int(11) DEFAULT -1,
  `risk_i` int(11) DEFAULT -1,
  `risk_d` int(11) DEFAULT -1,
  `cache_max_risk` int(11) DEFAULT -1,
  `cache_targeted_risk` int(11) DEFAULT -1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `instance_id` int(11) unsigned DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `instance_id` (`instance_id`),
  KEY `asset_id` (`asset_id`),
  KEY `threat_id` (`threat_id`),
  KEY `vulnerability_id` (`vulnerability_id`),
  KEY `amv_id` (`amv_id`),
  CONSTRAINT `instances_risks_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_ibfk_10` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_ibfk_11` FOREIGN KEY (`amv_id`) REFERENCES `amvs` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_ibfk_7` FOREIGN KEY (`instance_id`) REFERENCES `instances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_ibfk_8` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_ibfk_9` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instances_risks_op`
--

DROP TABLE IF EXISTS `instances_risks_op`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instances_risks_op` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` char(36) DEFAULT NULL,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `instance_id` int(11) unsigned DEFAULT NULL,
  `rolf_risk_id` int(11) unsigned DEFAULT NULL,
  `risk_cache_code` char(100) DEFAULT NULL,
  `risk_cache_label1` varchar(255) DEFAULT NULL,
  `risk_cache_label2` varchar(255) DEFAULT NULL,
  `risk_cache_label3` varchar(255) DEFAULT NULL,
  `risk_cache_label4` varchar(255) DEFAULT NULL,
  `risk_cache_description1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `risk_cache_description2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `risk_cache_description3` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `risk_cache_description4` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `brut_prob` int(11) DEFAULT -1,
  `cache_brut_risk` int(11) DEFAULT -1,
  `net_prob` int(11) DEFAULT -1,
  `cache_net_risk` int(11) DEFAULT -1,
  `targeted_prob` int(11) DEFAULT -1,
  `cache_targeted_risk` int(11) DEFAULT -1,
  `kind_of_measure` tinyint(4) DEFAULT 5,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mitigation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specific` tinyint(4) DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `instance_id` (`instance_id`),
  KEY `rolf_risk_id` (`rolf_risk_id`),
  KEY `object_id` (`object_id`),
  CONSTRAINT `instances_risks_op_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_op_ibfk_2` FOREIGN KEY (`instance_id`) REFERENCES `instances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `instances_risks_op_ibfk_3` FOREIGN KEY (`rolf_risk_id`) REFERENCES `rolf_risks` (`id`) ON DELETE SET NULL,
  CONSTRAINT `instances_risks_op_ibfk_4` FOREIGN KEY (`object_id`) REFERENCES `objects` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `measures`
--

DROP TABLE IF EXISTS `measures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `measures` (
  `uuid` char(36) NOT NULL,
  `soacategory_id` int(11) unsigned DEFAULT NULL,
  `referential_uuid` char(36) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `label1` text DEFAULT NULL,
  `label2` text DEFAULT NULL,
  `label3` text DEFAULT NULL,
  `label4` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `referential_uuid` (`referential_uuid`,`code`),
  KEY `soacategory_id` (`soacategory_id`),
  KEY `uuid` (`uuid`),
  CONSTRAINT `measures_ibfk_2` FOREIGN KEY (`referential_uuid`) REFERENCES `referentials` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `measures_ibfk_3` FOREIGN KEY (`soacategory_id`) REFERENCES `soacategory` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `measures_amvs`
--

DROP TABLE IF EXISTS `measures_amvs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `measures_amvs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `measure_id` char(36) NOT NULL,
  `amv_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `measure_id` (`measure_id`),
  KEY `amv_id` (`amv_id`),
  CONSTRAINT `measures_amvs_ibfk_2` FOREIGN KEY (`measure_id`) REFERENCES `measures` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `measures_amvs_ibfk_3` FOREIGN KEY (`amv_id`) REFERENCES `amvs` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43996 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `measures_measures`
--

DROP TABLE IF EXISTS `measures_measures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `measures_measures` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `linked_measure_id` char(36) NOT NULL,
  `master_measure_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `master_measure_id` (`master_measure_id`,`linked_measure_id`),
  KEY `father_id` (`master_measure_id`),
  KEY `linked_measure_id` (`linked_measure_id`),
  CONSTRAINT `measures_measures_ibfk_1` FOREIGN KEY (`master_measure_id`) REFERENCES `measures` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `measures_measures_ibfk_2` FOREIGN KEY (`linked_measure_id`) REFERENCES `measures` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3211 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `measures_rolf_risks`
--

DROP TABLE IF EXISTS `measures_rolf_risks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `measures_rolf_risks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rolf_risk_id` int(11) unsigned DEFAULT NULL,
  `measure_id` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `rolf_risk_id` (`rolf_risk_id`),
  KEY `measure_id` (`measure_id`),
  CONSTRAINT `measures_rolf_risks_ibfk_2` FOREIGN KEY (`rolf_risk_id`) REFERENCES `rolf_risks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `measures_rolf_risks_ibfk_3` FOREIGN KEY (`measure_id`) REFERENCES `measures` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `models`
--

DROP TABLE IF EXISTS `models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `models` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `description1` text DEFAULT NULL,
  `description2` text DEFAULT NULL,
  `description3` text DEFAULT NULL,
  `description4` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `are_scales_updatable` tinyint(4) DEFAULT 1,
  `is_default` tinyint(4) DEFAULT 0,
  `is_generic` tinyint(4) DEFAULT 0,
  `show_rolf_brut` tinyint(4) DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  CONSTRAINT `models_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `objects`
--

DROP TABLE IF EXISTS `objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objects` (
  `uuid` char(36) NOT NULL,
  `asset_id` char(36) NOT NULL,
  `object_category_id` int(11) unsigned DEFAULT NULL,
  `rolf_tag_id` int(11) unsigned DEFAULT NULL,
  `mode` tinyint(4) DEFAULT 1,
  `scope` tinyint(4) DEFAULT 1,
  `name1` varchar(255) DEFAULT NULL,
  `name2` varchar(255) DEFAULT NULL,
  `name3` varchar(255) DEFAULT NULL,
  `name4` varchar(255) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `object_category_id` (`object_category_id`),
  KEY `rolf_tag_id` (`rolf_tag_id`),
  KEY `asset_id` (`asset_id`),
  KEY `uuid` (`uuid`),
  CONSTRAINT `objects_ibfk_2` FOREIGN KEY (`object_category_id`) REFERENCES `objects_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `objects_ibfk_5` FOREIGN KEY (`rolf_tag_id`) REFERENCES `rolf_tags` (`id`) ON DELETE SET NULL,
  CONSTRAINT `objects_ibfk_8` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `objects_categories`
--

DROP TABLE IF EXISTS `objects_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objects_categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `root_id` int(11) unsigned DEFAULT NULL,
  `parent_id` int(11) unsigned DEFAULT NULL,
  `label1` varchar(2048) NOT NULL DEFAULT '',
  `label2` varchar(2048) NOT NULL DEFAULT '',
  `label3` varchar(2048) NOT NULL DEFAULT '',
  `label4` varchar(2048) NOT NULL DEFAULT '',
  `position` int(11) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `root_id` (`root_id`),
  KEY `parent_id` (`parent_id`),
  KEY `position` (`position`),
  CONSTRAINT `objects_categories_ibfk_2` FOREIGN KEY (`root_id`) REFERENCES `objects_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `objects_categories_ibfk_3` FOREIGN KEY (`parent_id`) REFERENCES `objects_categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `objects_objects`
--

DROP TABLE IF EXISTS `objects_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objects_objects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `child_id` char(36) DEFAULT NULL,
  `father_id` char(36) DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `father_id_2` (`father_id`,`child_id`),
  KEY `father_id` (`father_id`),
  KEY `child_id` (`child_id`),
  CONSTRAINT `objects_objects_ibfk_2` FOREIGN KEY (`father_id`) REFERENCES `objects` (`uuid`) ON DELETE CASCADE,
  CONSTRAINT `objects_objects_ibfk_3` FOREIGN KEY (`child_id`) REFERENCES `objects` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=665 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operational_instance_risks_scales`
--

DROP TABLE IF EXISTS `operational_instance_risks_scales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operational_instance_risks_scales` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `instance_risk_op_id` int(11) unsigned NOT NULL,
  `operational_risk_scale_type_id` int(11) unsigned NOT NULL,
  `brut_value` int(11) NOT NULL DEFAULT -1,
  `net_value` int(11) NOT NULL DEFAULT -1,
  `targeted_value` int(11) NOT NULL DEFAULT -1,
  `creator` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `oirs_instance_risk_op_id_indx` (`instance_risk_op_id`),
  KEY `oirs_op_risk_scale_type_id_indx` (`operational_risk_scale_type_id`),
  KEY `anr_id` (`anr_id`,`instance_risk_op_id`,`operational_risk_scale_type_id`),
  CONSTRAINT `oirs_instance_risk_op_id_fk` FOREIGN KEY (`instance_risk_op_id`) REFERENCES `instances_risks_op` (`id`) ON DELETE CASCADE,
  CONSTRAINT `oirs_operational_risk_scale_type_id_fk` FOREIGN KEY (`operational_risk_scale_type_id`) REFERENCES `operational_risks_scales_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `op_instance_risks_scales_anr_id_fk` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operational_risks_scales`
--

DROP TABLE IF EXISTS `operational_risks_scales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operational_risks_scales` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `min` smallint(6) unsigned NOT NULL DEFAULT 0,
  `max` smallint(6) unsigned NOT NULL DEFAULT 0,
  `creator` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `op_risks_scales_anr_id_type_unq` (`anr_id`,`type`),
  CONSTRAINT `op_risks_scales_anr_id_fk` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operational_risks_scales_comments`
--

DROP TABLE IF EXISTS `operational_risks_scales_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operational_risks_scales_comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `operational_risk_scale_id` int(11) unsigned NOT NULL,
  `operational_risk_scale_type_id` int(11) unsigned DEFAULT NULL,
  `scale_value` int(11) unsigned NOT NULL,
  `scale_index` smallint(6) unsigned NOT NULL,
  `label_translation_key` varchar(255) NOT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `creator` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `op_risks_scales_comments_anr_id_indx` (`anr_id`),
  KEY `op_risks_scales_comments_scale_id_indx` (`operational_risk_scale_id`),
  KEY `op_risks_scales_comments_scale_type_id_indx` (`operational_risk_scale_type_id`),
  CONSTRAINT `op_risks_scales_comments_anr_id_fk` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `op_risks_scales_comments_scale_id_fk` FOREIGN KEY (`operational_risk_scale_id`) REFERENCES `operational_risks_scales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `op_risks_scales_comments_scale_type_id_fk` FOREIGN KEY (`operational_risk_scale_type_id`) REFERENCES `operational_risks_scales_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operational_risks_scales_types`
--

DROP TABLE IF EXISTS `operational_risks_scales_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operational_risks_scales_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `operational_risk_scale_id` int(11) unsigned NOT NULL,
  `label_translation_key` varchar(255) NOT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `creator` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `op_risks_scales_types_anr_id_indx` (`anr_id`),
  KEY `op_risks_scales_types_scale_id_indx` (`operational_risk_scale_id`),
  CONSTRAINT `op_risks_scales_types_anr_id_fk` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `op_risks_scales_types_scale_id_fk` FOREIGN KEY (`operational_risk_scale_id`) REFERENCES `operational_risks_scales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phinxlog`
--

DROP TABLE IF EXISTS `phinxlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phinxlog` (
  `version` bigint(20) NOT NULL,
  `migration_name` varchar(100) DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `breakpoint` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `position` int(11) unsigned DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `multichoice` tinyint(4) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questions_choices`
--

DROP TABLE IF EXISTS `questions_choices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions_choices` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `question_id` int(11) unsigned DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `position` int(11) unsigned DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT 0,
  `multichoice` tinyint(4) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `questions_choices_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `referentials`
--

DROP TABLE IF EXISTS `referentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `referentials` (
  `uuid` char(36) NOT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rolf_risks`
--

DROP TABLE IF EXISTS `rolf_risks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolf_risks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(100) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `description1` text DEFAULT NULL,
  `description2` text DEFAULT NULL,
  `description3` text DEFAULT NULL,
  `description4` text DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rolf_risks_tags`
--

DROP TABLE IF EXISTS `rolf_risks_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolf_risks_tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rolf_risk_id` int(11) unsigned DEFAULT NULL,
  `rolf_tag_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rolf_risk_id` (`rolf_risk_id`),
  KEY `rolf_tag_id` (`rolf_tag_id`),
  CONSTRAINT `rolf_risks_tags_ibfk_1` FOREIGN KEY (`rolf_risk_id`) REFERENCES `rolf_risks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rolf_risks_tags_ibfk_2` FOREIGN KEY (`rolf_tag_id`) REFERENCES `rolf_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rolf_tags`
--

DROP TABLE IF EXISTS `rolf_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolf_tags` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` char(100) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scales`
--

DROP TABLE IF EXISTS `scales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scales` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `type` tinyint(4) DEFAULT 0,
  `min` int(11) DEFAULT 0,
  `max` int(11) DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  CONSTRAINT `scales_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scales_comments`
--

DROP TABLE IF EXISTS `scales_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scales_comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `scale_id` int(11) unsigned DEFAULT NULL,
  `scale_type_impact_id` int(11) unsigned DEFAULT NULL,
  `scale_value` int(11) DEFAULT 0,
  `scale_index` int(11) unsigned DEFAULT NULL,
  `comment1` text DEFAULT NULL,
  `comment2` text DEFAULT NULL,
  `comment3` text DEFAULT NULL,
  `comment4` text DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `scale_id` (`scale_id`),
  KEY `scale_type_impact_id` (`scale_type_impact_id`),
  CONSTRAINT `scales_comments_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `scales_comments_ibfk_2` FOREIGN KEY (`scale_id`) REFERENCES `scales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `scales_comments_ibfk_3` FOREIGN KEY (`scale_type_impact_id`) REFERENCES `scales_impact_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1222 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `scales_impact_types`
--

DROP TABLE IF EXISTS `scales_impact_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scales_impact_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `scale_id` int(11) unsigned DEFAULT NULL,
  `type` char(3) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `is_sys` tinyint(4) DEFAULT 0,
  `is_hidden` tinyint(4) DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  KEY `scale_id` (`scale_id`),
  KEY `type` (`type`),
  CONSTRAINT `scales_impact_types_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `scales_impact_types_ibfk_2` FOREIGN KEY (`scale_id`) REFERENCES `scales` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=273 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `soa_scale_comments`
--

DROP TABLE IF EXISTS `soa_scale_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `soa_scale_comments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `scale_index` int(11) unsigned DEFAULT NULL,
  `colour` varchar(7) DEFAULT NULL,
  `label_translation_key` varchar(255) DEFAULT NULL,
  `is_hidden` tinyint(1) NOT NULL DEFAULT 0,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `anr_id` (`anr_id`),
  CONSTRAINT `soa_scale_comments_ibfk_1` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `soacategory`
--

DROP TABLE IF EXISTS `soacategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `soacategory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label3` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label4` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `referential_uuid` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `referential_uuid` (`referential_uuid`),
  CONSTRAINT `soacategory_ibfk_1` FOREIGN KEY (`referential_uuid`) REFERENCES `referentials` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `themes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `threats`
--

DROP TABLE IF EXISTS `threats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threats` (
  `uuid` char(36) NOT NULL,
  `theme_id` int(11) unsigned DEFAULT NULL,
  `mode` tinyint(4) DEFAULT 1,
  `code` char(100) DEFAULT NULL,
  `label1` varchar(255) DEFAULT NULL,
  `label2` varchar(255) DEFAULT NULL,
  `label3` varchar(255) DEFAULT NULL,
  `label4` varchar(255) DEFAULT NULL,
  `description1` varchar(1024) DEFAULT NULL,
  `description2` varchar(1024) DEFAULT NULL,
  `description3` varchar(1024) DEFAULT NULL,
  `description4` varchar(1024) DEFAULT NULL,
  `c` tinyint(4) DEFAULT 0,
  `i` tinyint(4) DEFAULT 0,
  `a` tinyint(4) DEFAULT 0,
  `status` tinyint(4) DEFAULT 1,
  `trend` int(11) NOT NULL DEFAULT 1,
  `comment` text DEFAULT NULL,
  `qualification` int(11) DEFAULT -1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `threats_code_unq` (`code`),
  KEY `threat_theme_id` (`theme_id`),
  KEY `uuid` (`uuid`),
  CONSTRAINT `threats_ibfk_2` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `threats_models`
--

DROP TABLE IF EXISTS `threats_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `threats_models` (
  `model_id` int(11) unsigned NOT NULL,
  `threat_id` char(36) NOT NULL,
  PRIMARY KEY (`threat_id`,`model_id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `threats_models_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`),
  CONSTRAINT `threats_models_ibfk_4` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`) ON DELETE CASCADE,
  CONSTRAINT `threats_models_ibfk_5` FOREIGN KEY (`threat_id`) REFERENCES `threats` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `translations`
--

DROP TABLE IF EXISTS `translations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `translations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `anr_id` int(11) unsigned DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `translation_key` varchar(255) NOT NULL,
  `lang` char(2) NOT NULL,
  `value` text DEFAULT NULL,
  `creator` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `translations_key_lang_unq` (`anr_id`,`translation_key`,`lang`),
  KEY `translations_key_indx` (`translation_key`),
  KEY `translations_type_indx` (`type`),
  CONSTRAINT `translations_anr_id_fk` FOREIGN KEY (`anr_id`) REFERENCES `anrs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vulnerabilities`
--

DROP TABLE IF EXISTS `vulnerabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vulnerabilities` (
  `uuid` char(36) NOT NULL,
  `mode` tinyint(4) DEFAULT 1,
  `code` char(100) DEFAULT NULL,
  `label1` varchar(255) DEFAULT '',
  `label2` varchar(255) DEFAULT '',
  `label3` varchar(255) DEFAULT '',
  `label4` varchar(255) DEFAULT '',
  `description1` text DEFAULT NULL,
  `description2` text DEFAULT NULL,
  `description3` text DEFAULT NULL,
  `description4` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `creator` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updater` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `vulnerabilities_code_unq` (`code`),
  KEY `uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vulnerabilities_models`
--

DROP TABLE IF EXISTS `vulnerabilities_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vulnerabilities_models` (
  `model_id` int(11) unsigned NOT NULL,
  `vulnerability_id` char(36) NOT NULL,
  PRIMARY KEY (`vulnerability_id`,`model_id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `vulnerabilities_models_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`),
  CONSTRAINT `vulnerabilities_models_ibfk_4` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vulnerabilities_models_ibfk_5` FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities` (`uuid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'monarc_dev_iso27002_common'
--

--
-- Dumping routines for database 'monarc_dev_iso27002_common'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-12 16:15:42

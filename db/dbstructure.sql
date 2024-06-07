-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 192.168.131.203    Database: JabloSCAN
-- ------------------------------------------------------
-- Server version	5.5.5-10.6.16-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `EIC`
--

DROP TABLE IF EXISTS `EIC`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EIC` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL COMMENT 'nazov odberneho miesta',
  `Code` varchar(100) NOT NULL COMMENT 'EIC kod odberneho miesta',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EIC_File`
--

DROP TABLE IF EXISTS `EIC_File`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EIC_File` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `FileName` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1589 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ElectricityConsumption`
--

DROP TABLE IF EXISTS `ElectricityConsumption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ElectricityConsumption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eic_id` int(11) NOT NULL,
  `consumption` decimal(10,3) NOT NULL,
  `timestamp` datetime NOT NULL,
  `changed` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'date and time of record creation',
  `EIC_filename_id` int(11) DEFAULT NULL,
  `export` decimal(10,3) DEFAULT 0.000,
  PRIMARY KEY (`id`),
  KEY `ElectricityConsumption_timestamp_IDX` (`timestamp`) USING BTREE,
  KEY `ElectricityConsumption_eic_id_IDX` (`eic_id`,`timestamp`) USING BTREE,
  KEY `ElectricityConsumption_FK_1` (`EIC_filename_id`),
  CONSTRAINT `ElectricityConsumption_FK` FOREIGN KEY (`eic_id`) REFERENCES `EIC` (`id`),
  CONSTRAINT `ElectricityConsumption_FK_1` FOREIGN KEY (`EIC_filename_id`) REFERENCES `EIC_File` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=275806 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dump completed on 2024-06-06 10:58:12
-- ElectricityConsumptionKWH source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `ElectricityConsumptionKWH` AS
select
    `ElectricityConsumption`.`timestamp` AS `timestamp`,
    `ElectricityConsumption`.`consumption` / 4 AS `consumption`,
    `ElectricityConsumption`.`export` / 4 AS `export`
from
    `ElectricityConsumption`;

INSERT INTO EIC
(id, Name, Code)
VALUES(1, 'Dom', '24ZSSxxxxxxxK');

-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: ecotech
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `cupons`
--

DROP TABLE IF EXISTS `cupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupons` (
  `id_cupom` int unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `valor_desconto` decimal(5,2) NOT NULL,
  `pontos_necessarios` int unsigned NOT NULL,
  `data_validade` date NOT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  PRIMARY KEY (`id_cupom`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupons`
--

LOCK TABLES `cupons` WRITE;
/*!40000 ALTER TABLE `cupons` DISABLE KEYS */;
INSERT INTO `cupons` VALUES (1,'10% na Loja Verde','Desconto em produtos sustentaveis',10.00,50,'2025-12-31','ativo'),(2,'Frete gratis EcoShop','Frete gratis em compras acima de R$50',0.00,80,'2025-10-31','ativo'),(3,'15% Restaurante Bio','Desconto em refeicoes saudaveis',15.00,120,'2025-09-30','ativo'),(4,'Ingresso Parque Gratis','Acesso gratuito ao parque ecologico',100.00,200,'2025-08-15','ativo'),(5,'5% Mercado Organico','Valido em qualquer produto organico',5.00,30,'2025-11-30','inativo');
/*!40000 ALTER TABLE `cupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cupons_usuario`
--

DROP TABLE IF EXISTS `cupons_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupons_usuario` (
  `id_cupom_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned NOT NULL,
  `id_cupom` int unsigned NOT NULL,
  `data_resgate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `utilizado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_cupom_usuario`),
  KEY `fk_cupusu_usuario` (`id_usuario`),
  KEY `fk_cupusu_cupom` (`id_cupom`),
  CONSTRAINT `fk_cupusu_cupom` FOREIGN KEY (`id_cupom`) REFERENCES `cupons` (`id_cupom`) ON DELETE CASCADE,
  CONSTRAINT `fk_cupusu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupons_usuario`
--

LOCK TABLES `cupons_usuario` WRITE;
/*!40000 ALTER TABLE `cupons_usuario` DISABLE KEYS */;
INSERT INTO `cupons_usuario` VALUES (1,1,1,'2026-04-15 15:27:43',1),(2,1,2,'2026-04-15 15:27:43',0),(3,3,1,'2026-04-15 15:27:43',0),(4,3,3,'2026-04-15 15:27:43',1),(5,5,5,'2026-04-15 15:27:43',0);
/*!40000 ALTER TABLE `cupons_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `descartes`
--

DROP TABLE IF EXISTS `descartes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `descartes` (
  `id_descarte` int unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned NOT NULL,
  `id_local` int unsigned DEFAULT NULL,
  `tipo_lixo` varchar(60) NOT NULL,
  `descricao` text,
  `data_descarte` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `correto` tinyint(1) NOT NULL DEFAULT '1',
  `pontos_ganhos` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_descarte`),
  KEY `fk_descarte_usuario` (`id_usuario`),
  KEY `fk_descarte_local` (`id_local`),
  CONSTRAINT `fk_descarte_local` FOREIGN KEY (`id_local`) REFERENCES `locais_descarte` (`id_local`) ON DELETE SET NULL,
  CONSTRAINT `fk_descarte_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `descartes`
--

LOCK TABLES `descartes` WRITE;
/*!40000 ALTER TABLE `descartes` DISABLE KEYS */;
INSERT INTO `descartes` VALUES (1,1,1,'Plastico','Garrafa PET descartada na lixeira correta','2026-04-15 15:27:43',1,10),(2,1,2,'Vidro','Pote de vidro no ecoponto','2026-04-15 15:27:43',1,10),(3,2,1,'Organico','Restos de comida na lixeira organica','2026-04-15 15:27:43',1,10),(4,3,3,'Eletronico','Celular antigo descartado corretamente','2026-04-15 15:27:43',1,30),(5,4,NULL,'Papel','Papelao jogado em local errado','2026-04-15 15:27:43',0,0);
/*!40000 ALTER TABLE `descartes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historico_pontos`
--

DROP TABLE IF EXISTS `historico_pontos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_pontos` (
  `id_historico` int unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned NOT NULL,
  `acao` varchar(120) NOT NULL,
  `pontos` int NOT NULL,
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historico`),
  KEY `fk_historico_usuario` (`id_usuario`),
  CONSTRAINT `fk_historico_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historico_pontos`
--

LOCK TABLES `historico_pontos` WRITE;
/*!40000 ALTER TABLE `historico_pontos` DISABLE KEYS */;
INSERT INTO `historico_pontos` VALUES (1,1,'Descarte correto: Plastico',10,'2026-04-15 15:27:43'),(2,1,'Descarte correto: Vidro',10,'2026-04-15 15:27:43'),(3,1,'Resgate de cupom: 10% Loja Verde',-50,'2026-04-15 15:27:43'),(4,2,'Descarte correto: Organico',10,'2026-04-15 15:27:43'),(5,3,'Descarte correto: Eletronico',30,'2026-04-15 15:27:43');
/*!40000 ALTER TABLE `historico_pontos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locais_descarte`
--

DROP TABLE IF EXISTS `locais_descarte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locais_descarte` (
  `id_local` int unsigned NOT NULL AUTO_INCREMENT,
  `nome_local` varchar(120) NOT NULL,
  `endereco` varchar(200) NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  PRIMARY KEY (`id_local`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locais_descarte`
--

LOCK TABLES `locais_descarte` WRITE;
/*!40000 ALTER TABLE `locais_descarte` DISABLE KEYS */;
INSERT INTO `locais_descarte` VALUES (1,'Ecoponto Centro','Rua das Flores, 100 - Centro',-23.550520,-46.633309),(2,'Ecoponto Vila Verde','Av. das Palmeiras, 450 - Vila Verde',-23.562100,-46.645200),(3,'Ecoponto Parque Norte','Rua do Parque, 30 - Jd. America',-23.540800,-46.620100),(4,'Ecoponto Sul','Av. Brasil, 900 - Bairro Sul',-23.575000,-46.660000),(5,'Ecoponto Leste','Rua Ipiranga, 210 - Zona Leste',-23.530000,-46.600000);
/*!40000 ALTER TABLE `locais_descarte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `id_login` int unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned NOT NULL,
  `data_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_login`),
  KEY `fk_login_usuario` (`id_usuario`),
  CONSTRAINT `fk_login_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES (1,1,'2025-06-01 08:32:00'),(2,2,'2025-06-02 10:15:00'),(3,3,'2025-06-03 09:00:00'),(4,1,'2025-06-04 07:45:00'),(5,5,'2025-06-04 11:20:00');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil`
--

DROP TABLE IF EXISTS `perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfil` (
  `id_perfil` int unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned NOT NULL,
  `pontos_totais` int unsigned NOT NULL DEFAULT '0',
  `nivel` varchar(30) NOT NULL DEFAULT 'Iniciante',
  `data_atualizacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_perfil`),
  UNIQUE KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `fk_perfil_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil`
--

LOCK TABLES `perfil` WRITE;
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` VALUES (1,1,320,'Prata','2026-04-15 15:27:43'),(2,2,80,'Iniciante','2026-04-15 15:27:43'),(3,3,550,'Ouro','2026-04-15 15:27:43'),(4,4,10,'Iniciante','2026-04-15 15:27:43'),(5,5,210,'Bronze','2026-04-15 15:27:43'),(6,6,0,'Iniciante','2026-04-16 17:01:08');
/*!40000 ALTER TABLE `perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `data_criacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Ana Lima','ana.lima@email.com','$2b$12$75eyUZ2OefpIBAvYaw3yBeFJKSn7P0cbKRzE3HEVlIn5Hvz69ytt6','2026-04-15 15:27:43','ativo'),(2,'Bruno Souza','bruno.souza@email.com','$2b$12$JRG2l.Z1mcLoYNvcqzP8H.L8bSoP8jvuHRyaA1JgrYVW3Pnq/lZv.','2026-04-15 15:27:43','ativo'),(3,'Carla Mendes','carla.mendes@email.com','$2b$12$y7Ml6fjZ1OPweaHCv.wZwezR.EaHl0F16nV2oQVc.gaT7Kh57o/22','2026-04-15 15:27:43','ativo'),(4,'Diego Rocha','diego.rocha@email.com','$2b$12$Fca3IGNrMC0y6.pHcJ1QHuiZ4oEeIxK/tPlmL4k5hm/GBNK68yIjO','2026-04-15 15:27:43','inativo'),(5,'Eva Nunes','eva.nunes@email.com','$2b$12$qFF5MqhrPUvp.MQei6f13.aDOgHLdpu0QXx/o40maX0TbhstvLcVG','2026-04-15 15:27:43','ativo'),(6,'joao teste','joaoteste@emial.com','$2b$12$VVmuwRhnfNhnUABmApj98.ocjuXvRJYGzLrZXidVcmFTKuuaVAI82','2026-04-16 17:01:08','ativo');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-16 14:16:33

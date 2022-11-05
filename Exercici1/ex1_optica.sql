CREATE DATABASE ex1_optica;

CREATE TABLE `ex1_optica`.`proveidor` (
  `id_proveidor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `carrer` VARCHAR(45) NOT NULL,
  `numero` VARCHAR(45) NULL,
  `pis` VARCHAR(45) NULL,
  `porta` VARCHAR(45) NULL,
  `codi_postal` VARCHAR(5) NOT NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `fax` VARCHAR(45) NULL,
  `nif` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveidor`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE);
  
  CREATE TABLE `ex1_optica`.`ulleres` (
  `id_ulleres` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_marca` INT UNSIGNED NOT NULL,
  `graduacio_esq` DECIMAL(2) NULL,
  `graduacio_dr` DECIMAL(2) NULL,
  `muntura` ENUM('flotant', 'pasta', 'metalica') CHARACTER SET 'cp1251' NULL,
  `color_muntura` VARCHAR(45) NULL,
  `color_esq` VARCHAR(45) NULL,
  `color_dr` VARCHAR(45) NULL,
  `preu` DECIMAL(10,2) UNSIGNED NOT NULL,
  `id_client` INT UNSIGNED NULL,
  `id_empleat` INT UNSIGNED NULL,
  PRIMARY KEY (`id_ulleres`));
  
  CREATE TABLE `ex1_optica`.`marca` (
  `id_marca` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `id_proveidor` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_marca`),
  INDEX `fr_id_proveidor_marca_idx` (`id_proveidor` ASC) VISIBLE,
  CONSTRAINT `fr_id_proveidor_marca`
    FOREIGN KEY (`id_proveidor`)
    REFERENCES `ex1_optica`.`proveidor` (`id_proveidor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex1_optica`.`client` (
  `id_client` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `adressa_postal` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `correu` VARCHAR(45) NOT NULL,
  `data_registre` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amic_id` INT UNSIGNED NULL,
  PRIMARY KEY (`id_client`));

CREATE TABLE `ex1_optica`.`empleat` (
  `id_empleat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_empleat`));
  
-- Creating FK for table 'ulleres'
ALTER TABLE `ex1_optica`.`ulleres` 
ADD INDEX `fr_id_marca_ulleres_idx` (`id_marca` ASC) VISIBLE,
ADD INDEX `fr_id_client_ulleres_idx` (`id_client` ASC) VISIBLE,
ADD INDEX `fr_id_empleat_ulleres_idx` (`id_empleat` ASC) VISIBLE;
;
ALTER TABLE `ex1_optica`.`ulleres` 
ADD CONSTRAINT `fr_id_marca_ulleres`
  FOREIGN KEY (`id_marca`)
  REFERENCES `ex1_optica`.`marca` (`id_marca`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fr_id_client_ulleres`
  FOREIGN KEY (`id_client`)
  REFERENCES `ex1_optica`.`client` (`id_client`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fr_id_empleat_ulleres`
  FOREIGN KEY (`id_empleat`)
  REFERENCES `ex1_optica`.`empleat` (`id_empleat`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
  -- Creating FK for table 'client'
  ALTER TABLE `ex1_optica`.`client` 
ADD INDEX `amic_id_idx` (`amic_id` ASC) VISIBLE;
;
ALTER TABLE `ex1_optica`.`client` 
ADD CONSTRAINT `amic_id`
  FOREIGN KEY (`amic_id`)
  REFERENCES `ex1_optica`.`client` (`id_client`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  -- Creating trigger that doesn't allow us to insert into the table 'client'
  -- in 'amic_id' the same 'id_client'. Which means that the same client can recoomend to himself/herself this service
DROP TRIGGER IF EXISTS `ex1_optica`.`client_BEFORE_INSERT`;

DELIMITER $$
USE `ex1_optica`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `client_BEFORE_INSERT` BEFORE INSERT ON `client` FOR EACH ROW BEGIN
IF new.id_client = new.amic_id THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "El mateix client no pot ser el client que li ha recomananat la optica";
END IF;
END$$
DELIMITER ;

-- Iserting some data to the database

INSERT INTO `ex1_optica`.`client` (`nom`, `adressa_postal`, `telefon`, `correu`) VALUES ('Jose', 'c/Sicilia 129', '659781230', 'jose@gmail.com');
INSERT INTO `ex1_optica`.`client` (`nom`, `adressa_postal`, `telefon`, `correu`, `amic_id`) VALUES ('Maria', 'c/Arago 236', '621473625', 'maria@gmail.com', '1');
INSERT INTO `ex1_optica`.`client` (`nom`, `adressa_postal`, `telefon`, `correu`, `amic_id`) VALUES ('Jordi', 'c/Pallars', '678510319', 'jordi@gmail.com', '2');

INSERT INTO `ex1_optica`.`empleat` (`nom`, `cognom`) VALUES ('Laura', 'Piulats');

INSERT INTO `ex1_optica`.`proveidor` (`nom`, `carrer`, `numero`, `codi_postal`, `ciutat`, `pais`, `telefon`, `fax`, `nif`) VALUES ('UlleresX', 'c/Mallorca', '124', '08012', 'Barcelona', 'España', '631480642', '625587453', 'B127056');
INSERT INTO `ex1_optica`.`proveidor` (`nom`, `carrer`, `numero`, `pis`, `codi_postal`, `ciutat`, `pais`, `telefon`, `fax`, `nif`) VALUES ('VistaTeva', 'c/Luis Pericot', '48', '1', '17006', 'Girona', 'España', '972645127', '652103697', 'B3647894');

INSERT INTO `ex1_optica`.`marca` (`nom`, `id_proveidor`) VALUES ('Morpheus', '1');
INSERT INTO `ex1_optica`.`marca` (`nom`, `id_proveidor`) VALUES ('HarryPotter', '1');
INSERT INTO `ex1_optica`.`marca` (`nom`, `id_proveidor`) VALUES ('XOK15', '2');

INSERT INTO `ex1_optica`.`ulleres` (`id_ulleres`, `id_marca`, `graduacio_esq`, `graduacio_dr`, `muntura`, `color_muntura`, `preu`, `id_client`, `id_empleat`) VALUES ('1', '1', '0.25', '0.5', 'pasta', 'negre', '250.95', '1', '1');
INSERT INTO `ex1_optica`.`ulleres` (`id_ulleres`, `id_marca`, `graduacio_esq`, `graduacio_dr`, `muntura`, `color_muntura`, `preu`, `id_client`, `id_empleat`) VALUES ('2', '1', '0.5', '0.5', 'metalica', 'vermell', '280', '1', '1');
INSERT INTO `ex1_optica`.`ulleres` (`id_ulleres`, `id_marca`, `graduacio_esq`, `graduacio_dr`, `muntura`, `color_muntura`, `preu`) VALUES ('3', '2', '-1', '-1.25', 'pasta', 'gris', '325');
INSERT INTO `ex1_optica`.`ulleres` (`id_marca`, `graduacio_esq`, `graduacio_dr`, `muntura`, `color_muntura`, `preu`, `id_client`, `id_empleat`) VALUES ('3', '-2', '-2.25', 'pasta', 'negre', '320', '1', '1');

-- Queries
-- List the total of the invoicing of one client
SELECT SUM(u.preu)
FROM ex1_optica.ulleres u
WHERE id_client = 1;

-- List different types of glasses sold by one employee
SELECT DISTINCT m.nom
FROM ex1_optica.marca m
JOIN ex1_optica.ulleres u
	ON m.id_marca = u.id_marca
WHERE id_empleat = 1;

-- List manufacturer that provided at list one sunglasses that was sold
SELECT DISTINCT p.nom
FROM ex1_optica.proveidor p
JOIN ex1_optica.marca m
	ON p.id_proveidor = m.id_proveidor
JOIN ex1_optica.ulleres u
	ON m.id_marca = u.id_marca
WHERE id_client IS NOT NULL;
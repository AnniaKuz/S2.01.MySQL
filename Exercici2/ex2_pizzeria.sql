CREATE DATABASE ex2_pizzeria;

CREATE TABLE `ex2_pizzeria`.`client` (
  `id_client` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognom` VARCHAR(45) NULL,
  `adressa` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(5) NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_client`));
  
  CREATE TABLE `ex2_pizzeria`.`comanda` (
  `id_comanda` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipus` ENUM('recollida', 'domicili') NOT NULL,
  `quant_cat_A` INT UNSIGNED NULL,
  `quant_cat_B` INT UNSIGNED NULL,
  `quant_cat_C` INT UNSIGNED NULL,
  `preu_total` DECIMAL(10,2) UNSIGNED NOT NULL,
  `id_client` INT UNSIGNED NOT NULL,
  `id_botiga` INT UNSIGNED NOT NULL,
  `id_repartidor` INT UNSIGNED NULL,
  `hora_repart` DATETIME NULL,
  PRIMARY KEY (`id_comanda`));
  
  CREATE TABLE `ex2_pizzeria`.`categoria` (
  `id_categoria` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categoria`));
  
  CREATE TABLE `ex2_pizzeria`.`comanda_productes` (
  `id_comanda` INT UNSIGNED NOT NULL,
  `id_producte` INT UNSIGNED NOT NULL,
  `quant_prod` INT UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_comanda`, `id_producte`));
  
  CREATE TABLE `ex2_pizzeria`.`producte` (
  `id_producte` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `id_categoria` INT UNSIGNED NOT NULL,
  `descripcio` TEXT(150) NULL,
  `imatge` BLOB NULL,
  PRIMARY KEY (`id_producte`));
  
  CREATE TABLE `ex2_pizzeria`.`botiga` (
  `id_botiga` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `adressa` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(5) NOT NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `provincia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_botiga`));
  
  CREATE TABLE `ex2_pizzeria`.`empleat` (
  `id_empleat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognom` VARCHAR(45) NOT NULL,
  `posicio` ENUM('repartidor', 'cuiner') NOT NULL,
  `id_botiga` INT UNSIGNED NOT NULL,
  `nif` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_empleat`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE);
  
  -- Creating FK 
ALTER TABLE `ex2_pizzeria`.`empleat` 
ADD INDEX `fr_id_botiga_emp_idx` (`id_botiga` ASC) VISIBLE;
;
ALTER TABLE `ex2_pizzeria`.`empleat` 
ADD CONSTRAINT `fr_id_botiga_emp`
  FOREIGN KEY (`id_botiga`)
  REFERENCES `ex2_pizzeria`.`botiga` (`id_botiga`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `ex2_pizzeria`.`producte` 
ADD INDEX `fr_id_categoria_pr_idx` (`id_categoria` ASC) VISIBLE;
;
ALTER TABLE `ex2_pizzeria`.`producte` 
ADD CONSTRAINT `fr_id_categoria_pr`
  FOREIGN KEY (`id_categoria`)
  REFERENCES `ex2_pizzeria`.`categoria` (`id_categoria`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `ex2_pizzeria`.`comanda` 
ADD INDEX `fr_id_client_c_idx` (`id_client` ASC) VISIBLE,
ADD INDEX `fr_id_botiga_c_idx` (`id_botiga` ASC) VISIBLE,
ADD INDEX `fr_id_repartidor_c_idx` (`id_repartidor` ASC) VISIBLE;
;
ALTER TABLE `ex2_pizzeria`.`comanda` 
ADD CONSTRAINT `fr_id_client_c`
  FOREIGN KEY (`id_client`)
  REFERENCES `ex2_pizzeria`.`client` (`id_client`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fr_id_botiga_c`
  FOREIGN KEY (`id_botiga`)
  REFERENCES `ex2_pizzeria`.`botiga` (`id_botiga`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fr_id_empleat_c`
  FOREIGN KEY (`id_empleat`)
  REFERENCES `ex2_pizzeria`.`empleat` (`id_empleat`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `ex2_pizzeria`.`comanda_productes` 
ADD INDEX `fr_id_producte_cp_idx` (`id_producte` ASC) VISIBLE;
;
ALTER TABLE `ex2_pizzeria`.`comanda_productes` 
ADD CONSTRAINT `fr_id_comanda_cp`
  FOREIGN KEY (`id_comanda`)
  REFERENCES `ex2_pizzeria`.`comanda` (`id_comanda`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fr_id_producte_cp`
  FOREIGN KEY (`id_producte`)
  REFERENCES `ex2_pizzeria`.`producte` (`id_producte`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  -- Creating stored procedures
  -- 1) to be able to calculate the quantity of all the products in one delivery
  
DROP procedure IF EXISTS `new_procedure`;

DELIMITER $$
USE `ex2_pizzeria`$$
CREATE PROCEDURE `calcular_quant_prod` (IN comanda_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
	UPDATE comanda
    SET quant_prod = (
	SELECT SUM(quant_prod) 
    FROM ex2_pizzeria.comanda_productes cp
    WHERE id_comanda = comanda_id);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;

-- 2) to be able to calculate total proce of one delivery
DROP procedure IF EXISTS `calcular_preu_total`;

DELIMITER $$
USE `ex2_pizzeria`$$
CREATE PROCEDURE `calcular_preu_total` (IN comanda_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
	UPDATE comanda
    SET  preu_total =(
	SELECT SUM(quant_prod*preu) AS preu_total_comanda
    FROM ex2_pizzeria.producte pr
    JOIN ex2_pizzeria.comanda_productes cpr
		ON pr.id_producte=cpr.id_producte
	WHERE cpr.id_comanda = comanda_id) WHERE (id_comanda = comanda_id);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;

-- Calling the stored procedures to update in `comanda` ``quant_prod` and `preu_total.
CALL calcular_quant_prod(1);
CALL calcular_preu_total(1);

-- Creating triggers

-- Creating triggers so the employees that deliver the products have to be only 'repartidor'
-- in table 'empleat' we have two different positions 'cuiner'/'repartidor', so it's logical to think 
-- that the cook do not do delivers. And the employee has to work at the same place where the order has been made
-- Also the 'tipus' 'domicili' is required.

DROP TRIGGER IF EXISTS `ex2_pizzeria`.`empleat_ha_de_ser_repartidor`;

DELIMITER $$
USE `ex2_pizzeria`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `empleat_ha_de_ser_repartidor` BEFORE INSERT ON `comanda` FOR EACH ROW BEGIN
IF(((SELECT posicio
	FROM ex2_pizzeria.empleat
	WHERE id_empleat = new.id_empleat) != "repartidor")
    OR ((SELECT em.id_botiga
    FROM empleat em
    WHERE id_empleat = new.id_empleat) != new.id_botiga)) 
	THEN 
    signal sqlstate '45000' SET MESSAGE_TEXT = "L'empleat ha de ser repartidor, ha de treballar en la mateixa botiga i el tipus de la comanda ha de ser 'domicili'";
END IF;
END$$
DELIMITER ;


-- Testing

-- Introducing some data 
INSERT INTO `ex2_pizzeria`.`categoria` (`nom`) VALUES ('Beguda');
INSERT INTO `ex2_pizzeria`.`categoria` (`nom`) VALUES ('Burguer');
INSERT INTO `ex2_pizzeria`.`categoria` (`nom`) VALUES ('Pizza');

INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `descripcio`, `preu`) VALUES ('Cola', '1', 'refresc', '2.2');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `descripcio`, `preu`) VALUES ('Fanta', '1', 'refresc', '2.2');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `descripcio`, `preu`) VALUES ('Aigua', '1', '', '1.8');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `descripcio`, `preu`) VALUES ('Americana', '2', 'hamburguesa amb formatge', '10.80');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `descripcio`, `preu`) VALUES ('Gourmet', '2', 'hamburguesa completa', '11.5');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `preu`) VALUES ('Diavola', '3', '10.9');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `preu`) VALUES ('4Formatges', '3', '11');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `id_categoria`, `preu`) VALUES ('Prosciutto', '3', '9.9');
INSERT INTO `ex2_pizzeria`.`producte` (`nom`, `descripcio`, `preu`) VALUES ('Vi Blanc', 'DO Alella', '14');

INSERT INTO `ex2_pizzeria`.`botiga` (`adressa`, `codi_postal`, `ciutat`, `provincia`) VALUES ('Gran Via 329', '08025categoria', 'Barcelona', 'Barcelona');
INSERT INTO `ex2_pizzeria`.`botiga` (`adressa`, `codi_postal`, `ciutat`, `provincia`) VALUES ('c/Mallorca 246', '08020', 'Barcelona', 'Barcelona');
INSERT INTO `ex2_pizzeria`.`botiga` (`adressa`, `codi_postal`, `ciutat`, `provincia`) VALUES ('c/Vilanova 54', '17005', 'Girona', 'Girona');

INSERT INTO `ex2_pizzeria`.`comanda` (`tipus`, `id_client`, `id_botiga`, `id_empleat`) VALUES ('domicili', '1', '1', '3');
INSERT INTO `ex2_pizzeria`.`comanda` (`tipus`, `id_client`, `id_botiga`, `id_empleat`) VALUES ('domicili', '2', '1', '3');
INSERT INTO `ex2_pizzeria`.`comanda` (`tipus`, `id_client`, `id_botiga`) VALUES ('recollida', '2', '3');

INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('1', '1', '2');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('1', '3', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('1', '7', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('1', '8', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('2', '1', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('2', '2', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('2', '7', '2');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('3', '3', '1');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('3', '6', '3');
INSERT INTO `ex2_pizzeria`.`comanda_productes` (`id_comanda`, `id_producte`, `quant_prod`) VALUES ('3', '9', '1');


-- Calling the stored procedures to update in `comanda` ``quant_prod` and `preu_total.
CALL calcular_quant_prod(1);
CALL calcular_preu_total(1);

-- Show how many products from Category 'Beguda' has been sold in one specific city

SELECT SUM(cp.quant_prod) AS 'total_Beguda' 
FROM comanda_productes cp
JOIN producte pr
	ON cp.id_producte = pr.id_producte
JOIN categoria c
	ON pr.id_categoria = c.id_categoria
JOIN comanda com
	ON cp.id_comanda = com.id_comanda
JOIN botiga b
	ON com.id_botiga = b.id_botiga
WHERE c.nom = "Bebidas" AND ciutat = "Barcelona";

-- Show how many deliveries employee Jordi has done

SELECT COUNT(id_comanda) AS 'comandas_Jordi'
FROM comanda c
JOIN empleat em
	ON c.id_empleat = em.id_empleat
WHERE em.nom = "Jordi";


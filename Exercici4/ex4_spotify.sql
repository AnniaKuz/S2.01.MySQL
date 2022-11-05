CREATE DATABASE ex4_spotify;

CREATE TABLE `ex4_spotify`.`user` (
  `id_user` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `status` ENUM('free', 'premium') NOT NULL,
  `birthdate` DATE NULL,
  `sex` ENUM('M', 'F') NULL,
  `country` VARCHAR(45) NOT NULL,
  `zip_code` VARCHAR(5) NULL,
  PRIMARY KEY (`id_user`));
  
  CREATE TABLE `ex4_spotify`.`premium_user` (
  `id_user_premium` INT UNSIGNED NOT NULL,
  `date_sub` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `data_dub_update` DATE NULL,
  `payment` ENUM('pp', 'cc') NULL,
  PRIMARY KEY (`id_user_premium`),
  CONSTRAINT `fk_id_user_premium`
    FOREIGN KEY (`id_user_premium`)
    REFERENCES `ex4_spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
  
 CREATE TABLE `ex4_spotify`.`payment` (
  `id_payment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` INT UNSIGNED NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total` DECIMAL(5,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_payment`),
  INDEX `fk_id_user_pay_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fk_id_user_pay`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`premium_user` (`id_user_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`paypal` (
  `id_user` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id_user`),
  CONSTRAINT `fk_id_user_pp`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`payment` (`id_payment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`creditcard` (
  `id_user` INT UNSIGNED NOT NULL,
  `cc_number` VARCHAR(45) NOT NULL,
  `expiration_date` DATE NULL,
  `cvv` INT(3) NULL,
  PRIMARY KEY (`id_user`),
  CONSTRAINT `fk_id_user_cc`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`payment` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`playlist` (
  `id_playlist` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` INT UNSIGNED NOT NULL,
  `name_playlist` VARCHAR(45) NOT NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `number_songs` INT UNSIGNED NULL,
  `status` ENUM('active', 'deleted') NOT NULL,
  `date_delete` DATE NULL,
  PRIMARY KEY (`id_playlist`),
  INDEX `fk_id_user_playlist_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fk_id_user_playlist`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`song` (
  `id_song` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `duration` INT UNSIGNED NOT NULL,
  `number_repro` INT UNSIGNED NULL,
  `id_album` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_song`));
  
  CREATE TABLE `ex4_spotify`.`playlist_active` (
  `id_playlist_active` INT UNSIGNED NOT NULL,
  `id_user` INT UNSIGNED NOT NULL,
  `id_song` INT UNSIGNED NOT NULL,
  `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `fk_id_playlist_active_idx` (`id_playlist_active` ASC) VISIBLE,
  INDEX `fk_id_user_pc_idx` (`id_user` ASC) VISIBLE,
  INDEX `fk_id_song_pc_idx` (`id_song` ASC) VISIBLE,
  CONSTRAINT `fk_id_playlist_active`
    FOREIGN KEY (`id_playlist_active`)
    REFERENCES `ex4_spotify`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_pc`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_song_pc`
    FOREIGN KEY (`id_song`)
    REFERENCES `ex4_spotify`.`song` (`id_song`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


CREATE TABLE `ex4_spotify`.`artist` (
  `id_artist` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `image` BLOB NULL,
  `style` ENUM('pop', 'rock') NOT NULL,
  PRIMARY KEY (`id_artist`));
  
  CREATE TABLE `ex4_spotify`.`album` (
  `id_album` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `year` YEAR(4) NULL,
  `imatge` BLOB NULL,
  `id_artist` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_album`),
  INDEX `fk_id_artist_alb_idx` (`id_artist` ASC) VISIBLE,
  CONSTRAINT `fk_id_artist_alb`
    FOREIGN KEY (`id_artist`)
    REFERENCES `ex4_spotify`.`artist` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`fav_album` (
  `id_album_fav` INT UNSIGNED NOT NULL,
  `id_user` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_album_fav`),
  INDEX `fk_id_user_fav_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fk_id_album_fav`
    FOREIGN KEY (`id_album_fav`)
    REFERENCES `ex4_spotify`.`album` (`id_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_fav`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `ex4_spotify`.`user_artist` (
  `id_user` INT UNSIGNED NOT NULL,
  `id_artist` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_user`, `id_artist`),
  INDEX `fk_id_artist_ua_idx` (`id_artist` ASC) VISIBLE,
  CONSTRAINT `fk_id_artist_ua`
    FOREIGN KEY (`id_artist`)
    REFERENCES `ex4_spotify`.`artist` (`id_artist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_ua`
    FOREIGN KEY (`id_user`)
    REFERENCES `ex4_spotify`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    ALTER TABLE `ex4_spotify`.`song` 
ADD INDEX `fk_id_album_song_idx` (`id_album` ASC) VISIBLE;
;
ALTER TABLE `ex4_spotify`.`song` 
ADD CONSTRAINT `fk_id_album_song`
  FOREIGN KEY (`id_album`)
  REFERENCES `ex4_spotify`.`album` (`id_album`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
INSERT INTO `ex4_spotify`.`user` (`password`, `name`, `status`, `country`) VALUES ('123456', 'laura', 'free', 'Spain');
INSERT INTO `ex4_spotify`.`user` (`password`, `name`, `status`, `country`) VALUES ('hdcdbcb4', 'rafa', 'premium', 'Spain');
INSERT INTO `ex4_spotify`.`user` (`password`, `name`, `status`, `country`) VALUES ('nfhfhfhf', 'daniel', 'premium', 'Spain');
INSERT INTO `ex4_spotify`.`user` (`password`, `name`, `status`, `country`) VALUES ('152474', 'maria', 'free', 'Spain');

INSERT INTO `ex4_spotify`.`artist` (`name`, `style`) VALUES ('Olga Moreno', 'pop');
INSERT INTO `ex4_spotify`.`artist` (`name`, `style`) VALUES ('HRstyle', 'rock');
INSERT INTO `ex4_spotify`.`artist` (`name`, `style`) VALUES ('HMCR', 'pop');
INSERT INTO `ex4_spotify`.`artist` (`name`, `style`) VALUES ('GeetBy', 'rock');
INSERT INTO `ex4_spotify`.`artist` (`name`, `style`) VALUES ('JessicaDD', 'pop');

UPDATE `ex4_spotify`.`artist` SET `style` = 'pop' WHERE (`id_artist` = '2');
UPDATE `ex4_spotify`.`artist` SET `style` = 'rock' WHERE (`id_artist` = '3');
UPDATE `ex4_spotify`.`artist` SET `style` = 'pop' WHERE (`id_artist` = '4');
UPDATE `ex4_spotify`.`artist` SET `style` = 'rock' WHERE (`id_artist` = '5');

INSERT INTO `ex4_spotify`.`album` (`name`, `year`, `id_artist`) VALUES ('Spring', 2010, '1');
INSERT INTO `ex4_spotify`.`album` (`name`, `id_artist`) VALUES ('HolaMundo', '2');
INSERT INTO `ex4_spotify`.`album` (`name`, `id_artist`) VALUES ('Melody', '3');
INSERT INTO `ex4_spotify`.`album` (`name`, `id_artist`) VALUES ('LifeIsGood', '4');

INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('1', '185', '1');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('2', '220', '1');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('3', '175', '1');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('4', '210', '1');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('5', '195', '2');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('6', '205', '3');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('7', '170', '3');
INSERT INTO `ex4_spotify`.`song` (`id_song`, `duration`, `id_album`) VALUES ('8', '230', '2');

INSERT INTO `ex4_spotify`.`user_artist` (`id_user`, `id_artist`) VALUES ('1', '1');
INSERT INTO `ex4_spotify`.`user_artist` (`id_user`, `id_artist`) VALUES ('2', '2');

INSERT INTO `ex4_spotify`.`premium_user` (`id_user_premium`) VALUES ('2');

INSERT INTO `ex4_spotify`.`playlist` (`id_playlist`, `id_user`, `name_playlist`, `status`) VALUES ('1', '1', 'my', 'active');
INSERT INTO `ex4_spotify`.`playlist` (`id_playlist`, `id_user`, `name_playlist`, `status`) VALUES ('2', '2', 'hhh', 'active');

INSERT INTO `ex4_spotify`.`playlist_active` (`id_playlist_active`, `id_user`, `id_song`) VALUES ('1', '1', '1');
INSERT INTO `ex4_spotify`.`playlist_active` (`id_playlist_active`, `id_user`, `id_song`) VALUES ('1', '2', '2');
INSERT INTO `ex4_spotify`.`playlist_active` (`id_playlist_active`, `id_user`, `id_song`) VALUES ('1', '2', '3');
INSERT INTO `ex4_spotify`.`playlist_active` (`id_playlist_active`, `id_user`, `id_song`) VALUES ('2', '2', '4');

-- Creating trigger so the user with 'free' status couldn't be added to `premium_user' table
DROP TRIGGER IF EXISTS `ex4_spotify`.`has_to_be_premium`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `has_to_be_premium` BEFORE INSERT ON `premium_user` FOR EACH ROW BEGIN
IF(SELECT status
FROM user
WHERE id_user=new.id_user_premium) != 'premium' THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "User has to be premium, change the status in 'user'";
END IF;
END$$
DELIMITER ;

-- Trigger to prevent 'deleted' playlist be in the table 'playlist_active' where user can add songs to it
DROP TRIGGER IF EXISTS `ex4_spotify`.`playlist_active_BEFORE_INSERT`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ex4_spotify`.`playlist_active_BEFORE_INSERT` BEFORE INSERT ON `playlist_active` FOR EACH ROW
BEGIN
IF(SELECT status
FROM playlist
WHERE id_playlist = new.id_playlist_active) != 'active' THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "Playlist has to be active";
END IF;
END$$
DELIMITER ;

-- Stored procedures to recommend to the users the artists they might like

USE `ex4_spotify`;
DROP procedure IF EXISTS `recommendartist`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `recommendartist`(IN user_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
         SELECT art.name  FROM artist art
         LEFT JOIN user_artist ua 
			ON art.id_artist=ua.id_artist
         WHERE art.style=(SELECT style 
							FROM artist art1
							JOIN user_artist ua1 
								ON art1.id_artist=ua1.id_artist
							WHERE ua1.id_user=user_id) 
			AND ua.id_user!=user_id;
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;




-- Change playlist from 'active' to 'deleted'

USE `ex4_spotify`;
DROP procedure IF EXISTS `ex4_spotify`.`recommendartist`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_playlist`(IN playlist_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
UPDATE playlist
SET status = 'deleted'
WHERE id_playlist=playlist_id;
UPDATE playlist
SET date_delete = current_timestamp()
WHERE id_playlist=playlist_id;
DELETE  FROM playlist_active WHERE id_playlist_active = playlist_id;
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
;

-- Trigger for not allowing 'free' user to be added to the table 'payment'
DROP TRIGGER IF EXISTS `ex4_spotify`.`has_to_be_premium_user`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `has_to_be_premium_user` BEFORE INSERT ON `payment` FOR EACH ROW BEGIN
IF(SELECT status
FROM user
WHERE id_user=new.id_user) != 'premium' THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "User has to be premium, change the status in 'user'";
END IF;
END$$
DELIMITER ;

-- Trigger for not allowing 'free' user to be added to the table 'creditcard'
DROP TRIGGER IF EXISTS `ex4_spotify`.`creditcard_BEFORE_INSERT`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ex4_spotify`.`creditcard_BEFORE_INSERT` BEFORE INSERT ON `creditcard` FOR EACH ROW
BEGIN
IF(SELECT status
FROM user
WHERE id_user=new.id_user) != 'premium' THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "User has to be premium, change the status in 'user'";
END IF;
END$$
DELIMITER ;

-- Trigger for not allowing 'free' user to be added to the table 'paypal'
DROP TRIGGER IF EXISTS `ex4_spotify`.`paypal_BEFORE_INSERT`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER = CURRENT_USER TRIGGER `ex4_spotify`.`paypal_BEFORE_INSERT` BEFORE INSERT ON `paypal` FOR EACH ROW
BEGIN
IF(SELECT status
FROM user
WHERE id_user=new.id_user) != 'premium' THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "User has to be premium, change the status in 'user'";
END IF;
END$$
DELIMITER ;

-- Procedure to count the numbe of songs in one playlist
USE `ex4_spotify`;
DROP procedure IF EXISTS `count_songs`;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_songs`(IN playlist_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
	UPDATE playlist
    SET  number_songs =(
	SELECT COUNT(id_song) 
    FROM playlist_active
	WHERE id_playlist_active=playlist_id) WHERE (id_playlist = playlist_id);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;

-- Procedure to add information into 'payment' and update 'data_dub_update' in the table 'premium_user'
USE `ex4_spotify`;
DROP procedure IF EXISTS `ex4_spotify`.`execute_payment`;
;

DELIMITER $$
USE `ex4_spotify`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `execute_payment`(IN user_id INT, price DECIMAL(5,2) )
BEGIN
SET SQL_SAFE_UPDATES = 0;
INSERT INTO `ex4_spotify`.`payment` (`id_user`, `total`) VALUES (`user_id`,`price`);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
;





    
    
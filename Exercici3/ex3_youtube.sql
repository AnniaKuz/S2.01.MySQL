CREATE DATABASE youtube_exercici1;

CREATE TABLE `youtube_exercici1`.`user` (
  `id_user` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NOT NULL,
  `birthdate` DATE NULL,
  `sex` ENUM('M', 'F') NULL,
  `zip_code` VARCHAR(5) NULL,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_user`));
  
  CREATE TABLE `youtube_exercici1`.`video` (
  `id_video` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `description` TEXT(150) NULL,
  `size` DECIMAL(5,0) UNSIGNED NULL,
  `file_name` VARCHAR(45) NOT NULL,
  `lenght` INT UNSIGNED NULL,
  `thumbnail` INT UNSIGNED NULL,
  `likes` INT UNSIGNED NULL,
  `dislikes` INT UNSIGNED NULL,
  `reproduction` INT UNSIGNED NULL,
  `status` ENUM('public', 'private', 'hidden') NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_video`),
  INDEX `fr_id_user_video_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fr_id_user_video`
    FOREIGN KEY (`id_user`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube_exercici1`.`hashtag` (
  `id_hashtag` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_hashtag`));
  
  CREATE TABLE `youtube_exercici1`.`video_hashtag` (
  `id_video` INT UNSIGNED NOT NULL,
  `id_hashtag` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_video`, `id_hashtag`),
  INDEX `fr_id_hashtag_yh_idx` (`id_hashtag` ASC) VISIBLE,
  CONSTRAINT `fr_id_video_yh`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube_exercici1`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fr_id_hashtag_yh`
    FOREIGN KEY (`id_hashtag`)
    REFERENCES `youtube_exercici1`.`hashtag` (`id_hashtag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `youtube_exercici1`.`channel` (
  `id_channel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT(200) NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_creator` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_channel`),
  INDEX `fr_id_creator_ch_idx` (`id_creator` ASC) VISIBLE,
  CONSTRAINT `fr_id_creator_ch`
    FOREIGN KEY (`id_creator`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `youtube_exercici1`.`channel_subscriptions` (
  `id_channel` INT UNSIGNED NOT NULL,
  `id_user_sub` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_channel`, `id_user_sub`),
  INDEX `fk_id_user_sub_idx` (`id_user_sub` ASC) VISIBLE,
  CONSTRAINT `fk_id_channel_sub`
    FOREIGN KEY (`id_channel`)
    REFERENCES `youtube_exercici1`.`channel` (`id_channel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_sub`
    FOREIGN KEY (`id_user_sub`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `youtube_exercici1`.`video_interactions` (
  `id_video` INT UNSIGNED NOT NULL,
  `id_user_int` INT UNSIGNED NOT NULL,
  `like_dislike` ENUM('like', 'dislike') NOT NULL,
  `date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_video`, `id_user_int`),
  INDEX `fk_id_user_int_idx` (`id_user_int` ASC) VISIBLE,
  CONSTRAINT `fk_id_video`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube_exercici1`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_int`
    FOREIGN KEY (`id_user_int`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube_exercici1`.`playlist` (
  `id_playlist` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `id_user` INT UNSIGNED NOT NULL,
  `status` ENUM('private', 'public') NOT NULL,
  `date_creation` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_playlist`),
  INDEX `fk_id_user_pl_idx` (`id_user` ASC) VISIBLE,
  CONSTRAINT `fk_id_user_pl`
    FOREIGN KEY (`id_user`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `youtube_exercici1`.`playlist_video` (
  `id_playlist` INT UNSIGNED NOT NULL,
  `id_video` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_playlist`, `id_video`),
  INDEX `fk_id_video_plv_idx` (`id_video` ASC) VISIBLE,
  CONSTRAINT `fk_id_playlist_plv`
    FOREIGN KEY (`id_playlist`)
    REFERENCES `youtube_exercici1`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_video_plv`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube_exercici1`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
    CREATE TABLE `youtube_exercici1`.`video_comment` (
  `id_comment` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(60) NOT NULL,
  `id_video` INT UNSIGNED NOT NULL,
  `id_user_com` INT UNSIGNED NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_comment`),
  INDEX `fr_id_video_comm_idx` (`id_video` ASC) VISIBLE,
  INDEX `fk_id_user_com_idx` (`id_user_com` ASC) VISIBLE,
  CONSTRAINT `fk_id_video_comm`
    FOREIGN KEY (`id_video`)
    REFERENCES `youtube_exercici1`.`video` (`id_video`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_user_com`
    FOREIGN KEY (`id_user_com`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE `youtube_exercici1`.`comment_interaction` (
  `id_comment` INT UNSIGNED NOT NULL,
  `id_user_inter` INT UNSIGNED NOT NULL,
  `like_dislike` ENUM('dislike', 'like') NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_comment`),
  INDEX `fk_id_user_inter_idx` (`id_user_inter` ASC) VISIBLE,
  CONSTRAINT `fk_id_user_inter`
    FOREIGN KEY (`id_user_inter`)
    REFERENCES `youtube_exercici1`.`user` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_id_comment_inter`
    FOREIGN KEY (`id_comment`)
    REFERENCES `youtube_exercici1`.`video_comment` (`id_comment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- Creating triggers
DROP TRIGGER IF EXISTS `youtube_exercici1`.`like_dislike_only_once`;

DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER = CURRENT_USER TRIGGER `like_dislike_only_once` BEFORE INSERT ON `video_interactions` FOR EACH ROW
BEGIN
IF(SELECT COUNT(id_video)
	FROM video_interactions
	WHERE id_video = new.id_video AND id_user_int = new.id_user_int)>0
THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "The user can interact with like/dislike with the same video only once";
END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `youtube_exercici1`.`like_dislike_only_once`;

DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER = CURRENT_USER TRIGGER `like_dislike_only_once` BEFORE INSERT ON `comment_interaction` FOR EACH ROW
BEGIN
IF(SELECT COUNT(id_comment)
	FROM comment_interaction
	WHERE id_comment = new.id_comment AND id_user_inter = new.id_user_inter)>0 THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "The user can interact with like/dislike with the same comment only once";    
END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `youtube_exercici1`.`user_can_subscr_thesamevide_only_once`;

DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `user_can_subscr_thesamevide_only_once` BEFORE INSERT ON `channel_subscriptions` FOR EACH ROW BEGIN
IF(SELECT COUNT(id_channel)
FROM channel_subscriptions
WHERE id_channel = new.id_channel AND id_user_sub = new.id_user_sub)>0 THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "The user can't subscribe more then once on the same channel and the creator of the channel can't subscribe on his/her own channel";
END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `youtube_exercici1`.`video_in_playlist_only_once`;

DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER = CURRENT_USER TRIGGER `video_in_playlist_only_once` BEFORE INSERT ON `playlist_video` FOR EACH ROW
BEGIN
IF(SELECT COUNT(id_playlist)
FROM playlist_video
WHERE id_playlist = new.id_playlist AND id_video = new.id_video)>0 THEN
signal sqlstate '45000' SET MESSAGE_TEXT = "The video can be added to the playlist only once";    
END IF;
END$$
DELIMITER ;

-- Inserting some data
INSERT INTO `youtube_exercici1`.`user` (`name`, `email`, `password`, `sex`, `country`) VALUES ('elsa.star', 'elsa@gmail.com', 'helloworld', 'F', 'UK');
INSERT INTO `youtube_exercici1`.`user` (`name`, `email`, `password`, `sex`, `country`) VALUES ('alice_wonderland', 'alice@gmail.com', '123456alice', 'F', 'USA');
INSERT INTO `youtube_exercici1`.`user` (`name`, `email`, `password`, `sex`, `country`) VALUES ('paul_robot', 'paul@gmail.com', 'htd55d', 'M', 'Spain');
INSERT INTO `youtube_exercici1`.`user` (`name`, `email`, `password`, `sex`, `country`) VALUES ('jordi_mas', 'jordi@gmail.com', 'vichy_catalan', 'M', 'Spain');
INSERT INTO `youtube_exercici1`.`user` (`name`, `email`, `password`, `sex`, `country`) VALUES ('homo_sapiens', 'myemail@gmail.com', 'helloitsme21', 'M', 'France');

INSERT INTO `youtube_exercici1`.`video` (`id_user`, `title`, `file_name`, `status`) VALUES ('1', 'it\'s me', 'video1', 'public');
INSERT INTO `youtube_exercici1`.`video` (`id_user`, `title`, `file_name`, `status`) VALUES ('1', 'hello', 'video2', 'public');
INSERT INTO `youtube_exercici1`.`video` (`id_user`, `title`, `file_name`, `status`) VALUES ('1', 'tutorial', 'video3', 'private');
INSERT INTO `youtube_exercici1`.`video` (`id_user`, `title`, `file_name`, `status`) VALUES ('2', 'hello,world', 'myVideo', 'public');

INSERT INTO `youtube_exercici1`.`hashtag` (`name`) VALUES ('world');
INSERT INTO `youtube_exercici1`.`hashtag` (`name`) VALUES ('tutorial');
INSERT INTO `youtube_exercici1`.`hashtag` (`name`) VALUES ('cats');
INSERT INTO `youtube_exercici1`.`hashtag` (`name`) VALUES ('myvideo');

INSERT INTO `youtube_exercici1`.`video_hashtag` (`id_video`, `id_hashtag`) VALUES ('1', '4');
INSERT INTO `youtube_exercici1`.`video_hashtag` (`id_video`, `id_hashtag`) VALUES ('1', '1');
INSERT INTO `youtube_exercici1`.`video_hashtag` (`id_video`, `id_hashtag`) VALUES ('3', '2');

INSERT INTO `youtube_exercici1`.`channel` (`name`, `id_creator`) VALUES ('my_channel_for_you', '1');

INSERT INTO `youtube_exercici1`.`channel_subscriptions` (`id_channel`, `id_user_sub`) VALUES ('1', '2');
INSERT INTO `youtube_exercici1`.`channel_subscriptions` (`id_channel`, `id_user_sub`) VALUES ('1', '3');

INSERT INTO `youtube_exercici1`.`playlist` (`id_playlist`, `name`, `id_user`, `status`) VALUES ('1', 'coolvideos', '2', 'private');

INSERT INTO `youtube_exercici1`.`playlist_video` (`id_playlist`, `id_video`) VALUES ('1', '2');

INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('1', '2', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('1', '3', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('2', '1', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('2', '2', 'dislike');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('2', '5', 'dislike');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('3', '4', 'dislike');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('2', '3', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('2', '4', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('1', '5', 'like');
INSERT INTO `youtube_exercici1`.`video_interactions` (`id_video`, `id_user_int`, `like_dislike`) VALUES ('1', '4', 'dislike');

-- Creating stored procedures

-- To calculate the amount of likes for one video and update the database
USE `youtube_exercici1`;
DROP procedure IF EXISTS `youtube_exercici1`.`calculate_likes_total`;
;

DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_likes_total`(IN video_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
	UPDATE video
    SET  likes =(
	SELECT COUNT(like_dislike) AS total_likes
    FROM video_interactions 
	WHERE like_dislike = 'like' AND id_video = video_id) WHERE (id_video = video_id);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
;


DELIMITER $$
USE `youtube_exercici1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_dislikes_total`(IN video_id INT)
BEGIN
SET SQL_SAFE_UPDATES = 0;
	UPDATE video
    SET  dislikes =(
	SELECT COUNT(like_dislike) AS total_dislikes
    FROM video_interactions 
	WHERE like_dislike = 'dislike' AND id_video = video_id) WHERE (id_video = video_id);
SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
;

-- Calling the procedures
CALL calculate_dislikes_total(1);
CALL calculate_likes_total(1);
CALL calculate_likes_total(2);
CALL calculate_dislikes_total(2);








/* Create USER*/
/* CREATE USER */
/*CREATE USER 'test'@'localhost' IDENTIFIED BY 'a';
GRANT ALL PRIVILEGES  ON databaseName.* TO 'test'@'localhost'
 WITH GRANT OPTION*/


/* ASSIGN PRIVILEGES */
GRANT ALL PRIVILEGES ON msghandler.* TO 'msgadmin'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM msgadmin@localhost;
CREATE USER msgadmin@localhost IDENTIFIED BY "msgpw";


-- FLUSH PRIVILEGES
FLUSH PRIVILEGES;
-- DELETE DATABASE THEN CREATE A NEW SAMPLE

DROP DATABASE IF EXISTS `msg`;
CREATE DATABASE `msg`;

ALTER DATABASE `msg` CHARACTER SET utf8;

USE msg;
-- CREATE TABLES
-- LANGUAGE table
CREATE TABLE `tbllanguage`(
	`id_langcode` VARCHAR(2),
	`dt_description` VARCHAR(150),
	CONSTRAINT `id_langcode` PRIMARY KEY (`id_langcode`)
)ENGINE=InnoDB;
-- TYPE_TABLE
CREATE TABLE `tbltype`(
	`id_type` SMALLINT UNSIGNED AUTO_INCREMENT,
	`dt_description` VARCHAR(100),
	CONSTRAINT `id_type` PRIMARY KEY (`id_type`)
)ENGINE=InnoDB;
-- TEXT_TABLE LANGUAGE -> X <-TYPE
CREATE TABLE `tbltext`(
	`dt_description` VARCHAR(100),
	`fi_type` SMALLINT UNSIGNED,
    `fi_langcode` VARCHAR(2)
)ENGINE=InnoDB;
-- ALERT_TABLE
CREATE TABLE `tblalert`(
	`id_alert` TINYINT UNSIGNED AUTO_INCREMENT,
	`dt_description` VARCHAR(100),
    `fi_message` TINYINT UNSIGNED NOT NULL,
    `fi_type` SMALLINT UNSIGNED NOT NULL,
    `fi_user` SMALLINT UNSIGNED NOT NULL,
	CONSTRAINT `id_alert` PRIMARY KEY (`id_alert`)
)ENGINE=InnoDB;
-- ACTUAL_TEXT LANGUAGE -> X <-ALERT
CREATE TABLE `tblmessage`(
    `id_message` TINYINT UNSIGNED AUTO_INCREMENT,
	`dt_description` VARCHAR(100),
	`fi_langcode` VARCHAR(2) NOT NULL,
	`fi_alert` TINYINT UNSIGNED,
	CONSTRAINT `id_message` PRIMARY KEY (`id_message`)
)ENGINE=InnoDB;
-- NOTIFY_VIA
CREATE TABLE `tblnotify`(
	`id_notify` SMALLINT UNSIGNED AUTO_INCREMENT,
	`dt_description` VARCHAR(100),
	`fi_alert` TINYINT UNSIGNED,
	CONSTRAINT `id_notify` PRIMARY KEY (`id_notify`)
)ENGINE=InnoDB;
/* LOGFILE_TABLE */
CREATE TABLE `tbllogfile`(
	`id_file` TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`dt_path` VARCHAR(50),
    `fi_notify` SMALLINT UNSIGNED
)ENGINE=InnoDB;
/* TWITTER_TABLE */
CREATE TABLE `tbltwitter`(
	`id_key` TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`dtusername` VARCHAR(30),
	`dt_consumer_key` VARCHAR(30),
	`dt_consumer_secret` VARCHAR(60),
	`dt_token` VARCHAR(60),
	`dt_secret` VARCHAR(60),
    `fi_notify` SMALLINT UNSIGNED
)ENGINE=InnoDB;
/* EMAIL_TABLE */
CREATE TABLE `tblemail`(
	`id_email` TINYINT UNSIGNED AUTO_INCREMENT,
	`dt_email` VARCHAR(50),
    `fi_notify` SMALLINT UNSIGNED,
    `fi_group` TINYINT UNSIGNED,
	CONSTRAINT `id_email` PRIMARY KEY (`id_email`)
)ENGINE=InnoDB;
/* EMAIL_GROUP_TABLE */
CREATE TABLE `tblgroups`(
	`id_group` TINYINT UNSIGNED AUTO_INCREMENT,
	`dt_name` VARCHAR(20),
	`dt_description` VARCHAR(40),
	CONSTRAINT `id_group` PRIMARY KEY (`id_group`)
)ENGINE=InnoDB;
/* USERS_TABLE */
CREATE TABLE tblusers(
	`id_user` SMALLINT UNSIGNED AUTO_INCREMENT,
	`dt_username` VARCHAR(15) UNIQUE,
	`dt_password` VARCHAR(20),
	`dt_fname` VARCHAR(10),
	`dt_lname` VARCHAR(10),
	`fi_group` TINYINT UNSIGNED,
	CONSTRAINT `id_user` PRIMARY KEY (`id_user`)
)ENGINE=InnoDB;

/******************** Sample Values ********************/
INSERT INTO `tbllanguage` (`id_langcode`, `dt_description`) VALUES ('EN', 'English'), ('DE', 'Deutsch');
INSERT INTO `tbltype` (`id_type`, `dt_description`) VALUES ('404', 'Not found'), ('403', 'Not authorized');
INSERT INTO `tbltext` (`dt_description`, `fi_type`, `fi_langcode`) VALUES ('Access prohibited', '403', 'EN'), ('Zugang untersagt', '403', 'DE');
INSERT INTO `tblmessage` (`id_message`, `dt_description`, `fi_langcode`, `fi_alert`) VALUES (NULL, 'Objekt not found', 'EN', NULL);
INSERT INTO `tblusers` (`id_user`, `dt_username`, `dt_password`, `dt_fname`, `dt_lname`, `fi_group`) VALUES (NULL, 'test', 'test', 'test', 'test', NULL);
INSERT INTO `tblalert` (`id_alert`, `dt_description`, `fi_message`, `fi_type`, `fi_user`) VALUES (NULL, 'Notify Warnings', '1', '404', '1');
INSERT INTO `tblnotify` (`id_notify`, `dt_description`, `fi_alert`) VALUES (NULL, 'Warn user something not found', '1');

INSERT INTO `tbllogfile` (`id_file`, `dt_path`, `fi_notify`) VALUES (NULL, '/www/log/test.txt', '1');
INSERT INTO `tbltwitter` (`id_key`, `dtusername`, `dt_consumer_key`, `dt_consumer_secret`, `dt_token`, `dt_secret`, `fi_notify`) VALUES (NULL, 'cark112Handler', 'mIVuhGNlfj3wXduGRVIgjRupY', 'l3o20rGMzYywltN31kVJelhkkTzkelAeH1bW30UwDLI3ovrV5w', '719828210268168193-iQvEQEeRRVGWEqbdkmMug3AurWNEIFx', 'j7pw73dNrvVpKv8nZDSJwQ6tm30yrQJVs3N4uWcGiePIz', '1');

INSERT INTO `tblgroups` (`id_group`, `dt_name`, `dt_description`) VALUES (NULL, 'WarningGroup', 'Receives only warning messages');
INSERT INTO `tblusers` (`id_user`, `dt_username`, `dt_password`, `dt_fname`, `dt_lname`, `fi_group`) VALUES (NULL, 'test1', 'test1', 'test1', 'test1', '1');
INSERT INTO `tblemail` (`id_email`, `dt_email`, `fi_notify`, `fi_group`) VALUES (NULL, 'msghandercark@yopmail.com', '1', '1');

/******************** ASSIGN FOREIGN KEYS ********************/
/* tbllangcode <- tbltext -> tbltype */

ALTER TABLE tbltext 
    ADD FOREIGN KEY(fi_langcode) REFERENCES tbllanguage(id_langcode),
    ADD FOREIGN KEY(fi_type) REFERENCES tbltype(id_type);
/* tbllangcode <- tblmessage -> tblalert */
ALTER TABLE tblmessage 
    ADD FOREIGN KEY(fi_langcode) REFERENCES tbllanguage(id_langcode),
    ADD FOREIGN KEY(fi_alert) REFERENCES tblalert(id_alert);
/* tblmessage <- tblalert -> tbltype */
ALTER TABLE tblalert 
    ADD FOREIGN KEY(fi_message) REFERENCES tblmessage(id_message),
    ADD FOREIGN KEY(fi_type) REFERENCES tbltype(id_type),
    ADD FOREIGN KEY(fi_user) REFERENCES tblusers(id_user);

/* tblnotifyvia -> tblalert */
ALTER TABLE tblnotify
    ADD FOREIGN KEY(fi_alert) REFERENCES tblalert(id_alert);
/* tbllogfile -> tblnotifyvia */
ALTER TABLE tbllogfile
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify);
/* tbltwitter -> tblnotifyvia */
ALTER TABLE tbltwitter
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify);
/* tblemail -> tblnotifyvia */
/* tblemail -> tblgroup */
ALTER TABLE tblemail
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify),
    ADD FOREIGN KEY(fi_group) REFERENCES tblgroups(id_group);
/* tblusers -> tblgroup */
ALTER TABLE tblusers
    ADD FOREIGN KEY(fi_group) REFERENCES tblgroups(id_group);
/* Insert sample values */

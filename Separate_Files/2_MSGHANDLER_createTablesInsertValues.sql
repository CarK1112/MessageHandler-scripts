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
	`id_type` SMALLINT UNSIGNED,
	`dt_description` VARCHAR(100),
	CONSTRAINT `id_type` PRIMARY KEY (`id_type`)
)ENGINE=InnoDB;
-- TEXT_TABLE LANGUAGE -> X <-TYPE
CREATE TABLE `tbltext`(
	`id_text` TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
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
    `dt_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `id_alert` PRIMARY KEY (`id_alert`)
)ENGINE=InnoDB;
-- ACTUAL_TEXT LANGUAGE -> X <-ALERT
CREATE TABLE `tblmessage`(
    `id_message` TINYINT UNSIGNED AUTO_INCREMENT,
	`dt_title` VARCHAR(50),
	`dt_description` VARCHAR(255),
    `dt_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`fi_langcode` VARCHAR(2) NOT NULL,
	`fi_user` SMALLINT UNSIGNED,
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

CREATE TABLE tblmsglogger(
	`id_log` SMALLINT UNSIGNED AUTO_INCREMENT,
	`dt_msgtext` VARCHAR(255),
	`dt_msgcode` VARCHAR(255),
	`dt_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `id_log` PRIMARY KEY (`id_log`)
)ENGINE=InnoDB;

/******************** ASSIGN FOREIGN KEYS ********************/
/* tbllangcode <- tbltext -> tbltype */

ALTER TABLE tbltext
    ADD FOREIGN KEY(fi_langcode) REFERENCES tbllanguage(id_langcode) /*ON DELETE CASCADE*/,
    ADD FOREIGN KEY(fi_type) REFERENCES tbltype(id_type);
/* tbllangcode <- tblmessage -> tblalert */
ALTER TABLE tblmessage
    ADD FOREIGN KEY(fi_langcode) REFERENCES tbllanguage(id_langcode) ON DELETE CASCADE,
    ADD FOREIGN KEY(fi_user) REFERENCES tblusers(id_user) /*Keep users messages? ON DELETE CASCADE*/;
/* tblmessage <- tblalert -> tbltype */
ALTER TABLE tblalert
    ADD FOREIGN KEY(fi_message) REFERENCES tblmessage(id_message) ON DELETE CASCADE,
    ADD FOREIGN KEY(fi_type) REFERENCES tbltype(id_type),
    ADD FOREIGN KEY(fi_user) REFERENCES tblusers(id_user);

/* tblnotifyvia -> tblalert */
ALTER TABLE tblnotify
    ADD FOREIGN KEY(fi_alert) REFERENCES tblalert(id_alert) ON DELETE CASCADE;
/* tbllogfile -> tblnotifyvia */
ALTER TABLE tbllogfile
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify) ON DELETE CASCADE;
/* tbltwitter -> tblnotifyvia */
ALTER TABLE tbltwitter
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify) ON DELETE CASCADE;
/* tblemail -> tblnotifyvia */
/* tblemail -> tblgroup */
ALTER TABLE tblemail
    ADD FOREIGN KEY(fi_notify) REFERENCES tblnotify(id_notify) ON DELETE CASCADE,
    ADD FOREIGN KEY(fi_group) REFERENCES tblgroups(id_group) ON DELETE CASCADE;
/* tblusers -> tblgroup */
ALTER TABLE tblusers
    ADD FOREIGN KEY(fi_group) REFERENCES tblgroups(id_group);
/* Insert sample values */





/******************** Sample Values ********************/
INSERT INTO `tblgroups` (`id_group`, `dt_name`, `dt_description`) VALUES
	('1', 'French Warning Group', 'French receives only warning messages'),
	('2', 'German Warning Group', 'Germans receives only error messages');
INSERT INTO `tblusers` (`id_user`, `dt_username`, `dt_password`, `dt_fname`, `dt_lname`, `fi_group`) VALUES
	(NULL, 'admin', 'admin', 'Administrator', 'Ken', NULL),
	(NULL, 'test', 'test', 'Test', 'User', '1'),
	(NULL, 'user', 'user', 'Test', 'User', '2');

INSERT INTO `tbllanguage` (`id_langcode`, `dt_description`) VALUES
	('EN', 'English'),
	('DE', 'Deutsch'),
	('NL', 'Dutch'),
	('PL', 'Polish'),
	('RU', 'Russian'),
	('ES', 'Spanish'),
	('FR', 'Francais');

INSERT INTO `tbltype` (`id_type`, `dt_description`) VALUES
	('1', 'ERROR'),
	('2', 'NOT FOUND'),
	('3', 'WARNING'),
	('4', 'REMARK'),
	('5', 'SUCCESS');

INSERT INTO `tbltext` (`id_text`, `dt_description`, `fi_type`, `fi_langcode`) VALUES
	(NULL, 'Error', '1', 'EN'),
	(NULL, 'Erreur', '1', 'FR'),
	(NULL, 'Fehler', '1', 'DE'),
	(NULL, 'Warnung', '3', 'DE'),
	(NULL, 'Éxito', '5', 'ES'),
	(NULL, 'Observación', '4', 'ES'),
	(NULL, 'Remarque', '4', 'FR');

INSERT INTO `tblmessage` (`id_message`,`dt_title` ,`dt_description`, `dt_timestamp`, `fi_langcode`,`fi_user`) VALUES
	('1', 'Object not found','Ref:123 Object was not found. Please ensure that it can be found', '0', 'EN','1'),
	('2', 'Objekt nicht gefunden','Ref: 123 Objekt wurde nicht gefunden. Bitte stellen Sie sicher, dass es gefunden werden kann', CURRENT_TIMESTAMP(), 'DE','1'),
	('3', 'Attention','Une remarque inutile', CURRENT_TIMESTAMP(), 'FR','1'),
	('4', 'Uwaga','Niepotrzebna uwaga', CURRENT_TIMESTAMP(), 'PL','1'),
	('5', 'Operation Erfolgreich','Operation wurde erfolgreich ausgeführt', CURRENT_TIMESTAMP(), 'DE','1');

INSERT INTO `tblalert` (`id_alert`, `dt_description`, `fi_message`, `fi_type`, `fi_user`,`dt_timestamp`) VALUES
	('1', 'FR_NotifyWarnings', '3', '3', '1',CURRENT_TIMESTAMP()),
	('2', 'DE_NotifyError', '2', '1', '1',CURRENT_TIMESTAMP()),
	('3', 'DE_NotifyError', '2', '1', '1',CURRENT_TIMESTAMP());

INSERT INTO `tblnotify` (`id_notify`, `dt_description`, `fi_alert`) VALUES
	('1', 'Warning using an ouput', '1'),
	('2', 'Warn via twitter', '1'),
	('3', 'Warning using email', '1');

INSERT INTO `tbllogfile` (`id_file`, `dt_path`, `fi_notify`) VALUES (NULL, '/www/log/test.txt', '1');
INSERT INTO `tbltwitter` (`id_key`, `dtusername`, `dt_consumer_key`, `dt_consumer_secret`, `dt_token`, `dt_secret`, `fi_notify`) VALUES
	('1', 'cark112Handler', 'mIVuhGNlfj3wXduGRVIgjRupY', 'l3o20rGMzYywltN31kVJelhkkTzkelAeH1bW30UwDLI3ovrV5w', '719828210268168193-iQvEQEeRRVGWEqbdkmMug3AurWNEIFx', 'j7pw73dNrvVpKv8nZDSJwQ6tm30yrQJVs3N4uWcGiePIz', '2');

INSERT INTO `tblemail` (`id_email`, `dt_email`, `fi_notify`, `fi_group`) VALUES (NULL, 'msghandercark@yopmail.com', '2', '1');


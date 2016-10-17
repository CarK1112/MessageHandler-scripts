/* 
Import mysql -uUSERNAME -pPASSWORD DATABASE < backup.sql

// INVOKER from PHP user connect
// DEFINER 


*/

/* 
----------- ----------- ----------- ----------- ----------- UNDER CONSTRUCTION ----------- ----------- ----------- ----------- ----------- ----------- 	
Function name:	check_UserCredentials
What it does:	checks if a username exists in database + checks his credentials
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS check_UserCredentials;
CREATE PROCEDURE check_UserCredentials(IN in_username VARCHAR(15),IN in_password VARCHAR(20)) 
BEGIN
	DECLARE doesExist INT;
    DECLARE out_id SMALLINT;
    DECLARE out_username VARCHAR(15);
    DECLARE out_fname NVARCHAR(10);
    DECLARE out_lname NVARCHAR(10);
    DECLARE out_fi_group TINYINT;
    
	IF EXISTS(SELECT * from tblusers where dt_username = in_username) THEN
        SELECT  out_id = id_user,
				out_username = dt_username,
				out_fname = dt_fname,
                out_lname = dt_lname,
                out_fi_group = fi_group,
		FROM    tblusers
		WHERE   dt_username = in_username
	ELSE
		DECLARE doesExist BOOLEAN;
		SET doesExist = 0;
	END IF;
    SELECT CONCAT('Failed to insert ',out_id,': duplicate key') as "Result"; 
END $$
DELIMITER ;

/* GET FI USER TO GATHER INFO TO SHOW WHO CREATED THE MESSAGE */






/* ----------- ----------- ----------- ----------- ----------- END OF UNDER CONSTRUCTION ----------- ----------- ----------- ----------- ----------- ----------- */



/* 
Function name:	check_ifNull
What it does:	checks if data given from IN parameter is null. Returns boolean 1(empty) or 0(not empty);
*/
DELIMITER $$
DROP FUNCTION IF EXISTS check_ifNull;
CREATE FUNCTION check_ifNull (in_data VARCHAR(255)) RETURNS INT
BEGIN
 
 DECLARE isNullEmtpy BOOL;

    SET isNullEmtpy = 0;
	IF (in_data IS NULL OR in_data = '') THEN
        SET isNullEmtpy = 1;
	ELSE
       SET isNullEmtpy = 0;
	END IF;

    RETURN 1;
END $$
DELIMITER ;
/* 
Function name:	check_ifExists
What it does:	checks if data+table given from IN parameters already exists;
*/
DELIMITER $$
DROP FUNCTION IF EXISTS check_ifExists;
CREATE FUNCTION check_ifExists(IN in_tableName VARCHAR(100),IN in_fi_key SMALLINT UNSIGNED) RETURNS BOOL
BEGIN
    DECLARE doesExist BOOL;
	DECLARE tableName VARCHAR(100;
	SET	tableName=in_tableName;
    SET doesExist = 0;
	IF EXISTS(select * from tableName where id_alert = in_fi_key) THEN
        SET doesExist = 1;
	ELSE
        SET doesExist = 0;
	END IF;
    RETURN doesExist;
END $$
DELIMITER ;

/*
Insert statements using the according functions + Handlers
*/

/* insert tbllanguage 
-> RE: requires dublicate key check, since we use text as primary key
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_language;
CREATE DEFINER = 'root'@'localhost';
PROCEDURE insert_language(IN in_langcode VARCHAR(2), IN in_description VARCHAR(150))
/*SQL SECURITY DEFINER or SQL SECURITY INVOKER*/
SQL SECURITY DEFINER 
BEGIN
DECLARE duplicate_key INT DEFAULT 0;
    BEGIN
        DECLARE EXIT HANDLER FOR 1062 SET duplicate_key=1;
        IF check_ifNull(in_langcode) = 0 AND check_ifNull(in_description) = 0 THEN
            INSERT INTO tbllanguage(id_langcode,dt_description) 
            VALUES (in_langcode,in_description);
        END IF;
    END;
    IF duplicate_key=1 THEN
        SELECT CONCAT('Failed to insert ',in_langcode,': duplicate key') as "Result";
	END IF;
END$$
DELIMITER ;



DELIMITER $$
DROP USER IF EXISTS check_ifUserExists;
DROP PROCEDURE IF EXISTS msg.check_ifUserExists ;
DELIMITER $$
CREATE PROCEDURE msg.drop_user_if_exists()
BEGIN
  DECLARE foo BIGINT DEFAULT 0 ;
  SELECT COUNT(*)
  INTO foo
    FROM mysql.user
      WHERE User = 'msgadmin' and  Host = 'localhost';
   IF foo > 0 THEN
         DROP USER 'msgadmin'@'localhost';
  END IF;
END $$
DELIMITER ;

CALL databaseName.drop_user_if_exists() ;
DROP PROCEDURE IF EXISTS databaseName.drop_users_if_exists ;















/* insert tbltype
-> RE: requires dublicate key check, since we use int WITHOUT auto increment. -> Self defined key
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_type;
CREATE PROCEDURE insert_type (IN in_id_type SMALLINT UNSIGNED, IN in_description VARCHAR(100))
BEGIN
    DECLARE duplicate_key INT DEFAULT 0;
    BEGIN
        DECLARE EXIT HANDLER FOR 1062 SET duplicate_key=1;
        IF check_ifNull(in_description) = 0 THEN
          INSERT INTO tbltype(id_type,dt_description)
          VALUES(in_id_type,in_description);
        END IF;
	END;
    IF duplicate_key=1 THEN
        SELECT CONCAT('Failed to insert ',in_id_type,': duplicate key') as "Result";
	END IF;
END$$
DELIMITER ;
/* insert tbltype */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_text;
CREATE PROCEDURE insert_text(IN in_description VARCHAR(100),IN in_fi_type SMALLINT UNSIGNED,IN in_fi_langcode VARCHAR(2))
BEGIN
/* debug -> check if FIs exists! then insert */
   IF check_ifNull(in_description) = 0 AND check_ifNull(in_fi_type) = 0 AND check_ifNull(in_fi_langcode) = 0 THEN
       INSERT INTO tbltext(dt_description,fi_type,fi_langcode)
       VALUES(in_description,in_fi_type,in_fi_langcode);
   END IF;
END$$
DELIMITER ;
/* insert tblalert */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_alert;
CREATE PROCEDURE insert_alert(IN in_description VARCHAR(100),IN in_fi_message TINYINT UNSIGNED, IN in_fi_type SMALLINT UNSIGNED, IN in_fi_user SMALLINT UNSIGNED)                   
BEGIN
/* debug -> check if fi_message,fi_type,fi_user exists! then insert*/
   IF check_ifNull(in_description) = 0 AND check_ifNull(in_fi_message) = 0 AND check_ifNull(in_fi_type) = 0 AND check_ifNull(in_fi_user) = 0 THEN
       INSERT INTO tblalert(id_alert,dt_description,fi_message,fi_type,fi_user)
       VALUES(NULL,in_description,in_fi_message,in_fi_type,in_fi_user);
   END IF;
END$$
DELIMITER ;
/* insert tblmessage */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_message;
CREATE PROCEDURE insert_message(IN in_description VARCHAR(100),IN in_fi_langcode VARCHAR(2),IN in_fi_alert TINYINT UNSIGNED)                   
BEGIN
/* debug -> check if fi_langcode exists! then insert 
	Warning a message can be created without having any Alert(notify function), so fi_alert can be null!!!
*/
   DECLARE l_error_code    INT DEFAULT = 0;
   DECLARE l_dubkey_code   INT DEFAULT = 0;
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   DECLARE dubKey_error        CONDITION FOR 1062;
   
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET l_error_code = 1;
   DECLARE CONTINUE HANDLER FOR dubKey_error       SET l_dubkey_code = 1;

   
   IF check_ifNull(in_description) = 0 AND check_ifNull(in_fi_langcode) = 0 AND check_ifNull(in_fi_alert) = 0 THEN
      INSERT INTO tblmessage(id_message,dt_description,fi_langcode,dt_description)
      VALUES(NULL,in_description,in_fi_langcode,in_fi_alert); 
   END IF;
   IF l_error_code=1 THEN
        SELECT CONCAT('Failed to insert fi key not found') as "Result";
   END IF;
   IF l_dubkey_code=1 THEN
        SELECT CONCAT('Failed to insert ',id_message,': duplicate key') as "Result";
   END IF;
END$$
DELIMITER ;

/* insert tblnotify */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_notify;
CREATE PROCEDURE insert_notify(IN in_description VARCHAR(100),IN in_fi_alert VARCHAR(2))
BEGIN
   IF check_ifNull(in_description) = 0 AND check_ifNull(in_fi_alert) = 0 THEN
       INSERT INTO tblnotify(id_notify,dt_description,fi_alert)
       VALUES(NULL,in_description,in_fi_alert);
   END IF;
END$$
DELIMITER ;

/* insert tbllogfile */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_logfile;
CREATE PROCEDURE insert_logfile(IN in_path VARCHAR(50),IN in_fi_notify SMALLINT UNSIGNED)
BEGIN
   IF check_ifNull(in_path) = 0 AND check_ifNull(in_fi_notify) = 0 THEN
      INSERT INTO tbllogfile(id_file,dt_path,fi_notify)
      VALUES(NULL,in_path,in_fi_notify);
   END IF;
END$$

DELIMITER ;
/* insert tbltwitter */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_twitter;
CREATE PROCEDURE insert_twitter(IN in_username VARCHAR(30),IN in_consumer_key VARCHAR(30),IN in_consumer_secret VARCHAR(60),IN in_token VARCHAR(60),IN in_secret VARCHAR(60),IN in_fi_notify SMALLINT UNSIGNED)                   
BEGIN
   IF check_ifNull(in_username) = 0 AND check_ifNull(in_consumer_key) = 0 AND check_ifNull(in_consumer_secret) = 0 AND check_ifNull(in_token) = 0 AND check_ifNull(in_secret) = 0 AND check_ifNull(in_fi_notify) = 0 THEN
      INSERT INTO tbltwitter(id_key,dtusername,dt_consumer_key,dt_consumer_secret,dt_token,dt_secret,fi_notify)
      VALUES(NULL,in_username,in_consumer_key,in_consumer_secret,in_token,in_secret,in_fi_notify);
   END IF;
END$$
DELIMITER ;
/* insert tblgroups */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_groups;
CREATE PROCEDURE insert_groups(IN in_name VARCHAR(20),IN in_description VARCHAR(40))
BEGIN
   IF check_ifNull(in_name) = 0 AND check_ifNull(in_description) = 0 THEN
      INSERT INTO tblgroups(id_group,dt_name,dt_description) 
      VALUES(NULL,in_name,in_description);
   END IF;
END$$
DELIMITER ;
/* insert tblgroups */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_groups;
CREATE PROCEDURE insert_groups(IN in_name VARCHAR(20),IN in_description VARCHAR(40))
BEGIN
      IF check_ifNull(in_name) = 0 AND check_ifNull(in_description) = 0 THEN
      INSERT INTO tblgroups(id_group,dt_name,dt_description)
      VALUES(NULL,in_name,in_description);
   END IF;
END$$
DELIMITER ;
/* insert tblusers */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_users;
CREATE PROCEDURE insert_users(IN in_username VARCHAR(15),IN in_password VARCHAR(20),IN in_fname VARCHAR(10),IN in_lname VARCHAR(20),IN in_fi_group TINYINT UNSIGNED)                   
BEGIN
   IF check_ifNull(in_username) = 0 AND check_ifNull(in_password) = 0 AND check_ifNull(in_fname) = 0 AND check_ifNull(in_lname) AND check_ifNull(in_fi_group) = 0 THEN
      INSERT INTO tblusers(id_user,dt_username,dt_password,dt_fname,dt_lname,fi_group)
      VALUES(NULL,in_username,in_password,in_fname,in_lname,in_fi_group);
   END IF;
END$$
DELIMITER ;
/* insert tblemail */
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_email;
CREATE PROCEDURE insert_email(IN in_email VARCHAR(50),IN in_notify SMALLINT UNSIGNED,IN in_group TINYINT UNSIGNED)
BEGIN
IF check_ifNull(in_email) = 0 AND check_ifNull(in_notify) = 0 AND check_ifNull(in_group) = 0 THEN
   INSERT INTO tblemail(id_email,dt_email,fi_notify,fi_group) 
   VALUES(NULL,in_email,in_notify,in_group); 
END IF;
END$$
DELIMITER ;

CREATE TABLE `tbllanguage`(
	`id_langcode` VARCHAR(2),
	`dt_description` VARCHAR(150),
	CONSTRAINT `id_langcode` PRIMARY KEY (`id_langcode`)
)ENGINE=InnoDB;


/* SELECT STATEMENT: FETCH LANGUAGES 
http://www.java2s.com/Code/SQL/Cursor/FETCHStatement.htm
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS myProc;
CREATE PROCEDURE myProc(IN in_id_langcode VARCHAR(2))
BEGIN
   DECLARE l_last_row_fetched int;
   DECLARE l_id_langcode VARCHAR(2);
   DECLARE l_dt_description VARCHAR(30);
   DECLARE c1 CURSOR FOR
      SELECT id_langcode,dt_description
      FROM tbllanguage
      WHERE id_langcode=in_id_langcode;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched=1;
    SET l_last_row_fetched=0;
    OPEN c1;
     cursor_loop:LOOP
      FETCH c1 INTO l_id_langcode,l_dt_description;
         IF l_last_row_fetched=1 THEN
         LEAVE cursor_loop;
      END IF;
    END LOOP cursor_loop;
    CLOSE c1;
    SET l_last_row_fetched=0;
END $$
DELIMITER ;

/* SELECT LANGUAGES */
DELIMITER $$
DROP PROCEDURE IF EXISTS get_langList;
CREATE FUNCTION get_langList() RETURNS VARCHAR(2)
BEGIN
   DECLARE finished INTEGER DEFAULT 0;
   DECLARE language_name VARCHAR(50) DEFAULT "";
   DECLARE list VARCHAR(255) DEFAULT "";
   DECLARE language_cur CURSOR FOR SELECT id_langcode FROM tbllanguage;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
   OPEN language_cur;
    get_language: LOOP
       FETCH language_cur INTO language_name;
          IF finished THEN
             LEAVE get_language;
          END IF;
          SET list = CONCAT(list,", ",language_name);
       END LOOP get_language;
   CLOSE language_cur;
RETURN SUBSTR(list,3);
END $$
DELIMITER ;






DELIMITER $$
CREATE PROCEDURE build_email_list (INOUT email_list varchar(4000))
BEGIN
   DECLARE v_finished INTEGER DEFAULT 0;
   DECLARE v_email varchar(100) DEFAULT "";
   -- declare cursor for employee email
   DEClARE language_cursor CURSOR FOR 
   SELECT email FROM employees;
   -- declare NOT FOUND handler
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
   OPEN language_cursor;
     get_email: LOOP
       FETCH language_cursor INTO v_email;
       IF v_finished = 1 THEN 
          LEAVE get_email;
       END IF;
   -- build email list
   SET email_list = CONCAT(v_email,";",email_list); 
END LOOP get_email;
CLOSE language_cursor; 
END$$
DELIMITER ;



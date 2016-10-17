
DELIMITER $$
DROP PROCEDURE IF EXISTS insert_language;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_language(
IN in_langcode VARCHAR(2),
IN in_description VARCHAR(150),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   -- Declaration of named conditions

   DECLARE duplicate_key CONDITION FOR 1062;

   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR duplicate_key SET out_execCode = 1062;

   -- initialisation of the out parameters

   SET out_execCode = 0;
   SET out_execText = "Executed success!";

   -- INSERT statements

    INSERT INTO tbllanguage(id_langcode,dt_description)
    VALUES (UPPER(in_langcode),in_description);

   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_language: ok";
        WHEN 1062 THEN
               SET out_execText = "insert_language: dublicate key_language ERROR!";
               CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_language: an unknown error happend with the procedure insert_language');
             SET out_execCode = 'FATAL';
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_message;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_message(
  IN  in_dt_title       VARCHAR(50),
  IN  in_dt_description VARCHAR(100),
  IN  in_dt_timestamp   TIMESTAMP,
  IN  in_fi_langcode    VARCHAR(2),
  IN  in_fi_user        SMALLINT UNSIGNED,
  OUT out_execCode      INT,
  OUT out_execText      VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    DECLARE noForeignKey_error CONDITION FOR 1452;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    INSERT INTO tblmessage (id_message, dt_title, dt_description, dt_timestamp, fi_langcode, fi_user)
    VALUES (NULL, in_dt_title, in_dt_description, in_dt_timestamp, in_fi_langcode, in_fi_user);

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert_message: ok";
      WHEN 1452
      THEN SET out_execText = "insert_message: foreign key ERROR! Check if language exists";
        SET out_execCode = 1452;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
    ELSE
      BEGIN
        SET out_execText = CONCAT('insert_message: an unknown error happend with the insert_message procedure');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode,out_execText,@Code,@Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_type;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_type(
IN in_id_type SMALLINT UNSIGNED,
IN in_description VARCHAR(255),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   -- Declaration of named conditions

   DECLARE dubKeyError  CONDITION FOR 1062;

   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR dubKeyError SET out_execCode = 1062;

   -- initialisation of the out parameters

   SET out_execCode = 0;
   SET out_execText = "Executed success!";

   -- INSERT statements

      INSERT INTO tbltype(id_type,dt_description)
          VALUES(in_id_type,in_description);

   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_type: ok";
        WHEN 1062 THEN
           SET out_execText = "insert_type: Dublicate Key ERROR!";
     SET out_execCode = 1062;
           CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_type: an unknown error happend');
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode, out_execText, @Code, @Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_text;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_text(
IN in_description VARCHAR(100),
IN in_fi_type SMALLINT UNSIGNED,
IN in_fi_langcode VARCHAR(2),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER             
BEGIN

   -- Declaration of named conditions
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   -- INSERT statements
   
      INSERT INTO tbltext(id_text,dt_description,fi_type,fi_langcode)
      VALUES(NULL,in_description,in_fi_type,in_fi_langcode);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_text: ok";
        WHEN 1452 THEN
             SET out_execText = "insert_text: foreign key ERROR!";
             SET out_execCode = 1452;
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
             SET out_execCode = 'FATAL';
             SET out_execText = CONCAT('insert_text: an unknown error happend.');
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_alert;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_alert(
IN in_description VARCHAR(100),
IN in_fi_message TINYINT UNSIGNED, 
IN in_fi_type SMALLINT UNSIGNED, 
IN in_fi_user SMALLINT UNSIGNED,
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER             
BEGIN

   -- Declaration of named conditions
      DECLARE noForeignKey_error  CONDITION FOR 1452;
   -- Declaration of handlers
      DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;
   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   -- INSERT statements
   
       INSERT INTO tblalert(id_alert,dt_description,fi_message,fi_type,fi_user,dt_timestamp)
       VALUES(NULL,in_description,in_fi_message,in_fi_type,in_fi_user,CURRENT_TIMESTAMP);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert: ok";
        WHEN 1452 THEN
            SET out_execText = "insert: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('INSERT status: an unknown error happed: ', out_execText);
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_message;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_message(
IN in_dt_title VARCHAR(50), 
IN in_dt_description VARCHAR(100),
IN in_dt_timestamp TIMESTAMP ,
IN in_fi_langcode VARCHAR(2),
IN in_fi_user SMALLINT UNSIGNED,
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)                   
BEGIN

   -- Declaration of named conditions
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
      INSERT INTO tblmessage(id_message,dt_title,dt_description,dt_timestamp,fi_langcode,fi_user)
      VALUES(NULL,in_dt_title,in_dt_description,in_dt_timestamp,in_fi_langcode,in_fi_user);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_message: ok";
        WHEN 1452 THEN
            SET out_execText = "insert_message: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
         ELSE
           BEGIN
            SET out_execText = CONCAT('insert_message: an unknown error happend');
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_notify;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_notify(
IN in_description VARCHAR(100),
IN in_fi_alert VARCHAR(2),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER             
BEGIN

   -- Declaration of named conditions
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   -- INSERT statements
   
   INSERT INTO tblnotify(id_notify,dt_description,fi_alert)
   VALUES(NULL,in_description,in_fi_alert); 
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_notify: ok";
        WHEN 1452 THEN
            SET out_execText = "insert_notify: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_notify: an unknown error happend');
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_logfile;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_logfile(
IN in_path VARCHAR(50),
IN in_fi_notify SMALLINT UNSIGNED,
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER                 
BEGIN

   -- Declaration of named conditions
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   INSERT INTO tbllogfile(id_file,dt_path,fi_notify)
   VALUES(NULL,in_path,in_fi_notify);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert: ok";
        WHEN 1452 THEN
            SET out_execText = "insert: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('INSERT status: an unknown error happed: ', out_execText);
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_twitter;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_twitter(
  IN  in_username        VARCHAR(30),
  IN  in_consumer_key    VARCHAR(30),
  IN  in_consumer_secret VARCHAR(60),
  IN  in_token           VARCHAR(60),
  IN  in_secret          VARCHAR(60),
  IN  in_fi_notify       SMALLINT UNSIGNED,
  OUT out_execCode       INT,
  OUT out_execText       VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    DECLARE noForeignKey_error CONDITION FOR 1452;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    INSERT INTO tbltwitter (id_key, dtusername, dt_consumer_key, dt_consumer_secret, dt_token, dt_secret, fi_notify)
    VALUES (NULL, in_username, in_consumer_key, in_consumer_secret, in_token, in_secret, in_fi_notify);

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert: ok";
      WHEN 1452
      THEN
        SET out_execText = "insert: foreign key ERROR!";
        SET out_execCode = 1452;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
    ELSE
      BEGIN
        SET out_execText = CONCAT('INSERT status: an unknown error happed: ', out_execText);
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_groups;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_groups(
  IN  in_name        VARCHAR(20),
  IN  in_description VARCHAR(40),
  OUT out_execCode   INT,
  OUT out_execText   VARCHAR(255)
)
  BEGIN

    -- Declaration of named conditions

    -- Declaration of handlers
    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    INSERT INTO tblgroups (id_group, dt_name, dt_description)
    VALUES (NULL, in_name, in_description);

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert_groups: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('insert_groups: an unknown error happend');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_users;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_users(
  IN  in_username  VARCHAR(15),
  IN  in_password  VARCHAR(20),
  IN  in_fname     VARCHAR(10),
  IN  in_lname     VARCHAR(20),
  IN  in_fi_group  TINYINT UNSIGNED,
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    DECLARE duplicate_key CONDITION FOR 1062;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR duplicate_key SET out_execCode = 1452;

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    -- INSERT statements

    INSERT INTO tblusers (id_user, dt_username, dt_password, dt_fname, dt_lname, fi_group)
    VALUES (NULL, in_username, in_password, in_fname, in_lname, in_fi_group);


    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert_users: ok";
      WHEN 1452
      THEN
        SET out_execText = "insert_users: foreign key ERROR!";
        SET out_execCode = 1452;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
    ELSE
      BEGIN
        SET out_execText = CONCAT('insert_users: an unknown error happend');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_email;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_email(
  IN  in_email     VARCHAR(50),
  IN  in_notify    SMALLINT UNSIGNED,
  IN  in_group     TINYINT UNSIGNED,
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    DECLARE foreignKeyNotFound CONDITION FOR 1452;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR foreignKeyNotFound SET out_execCode = 1452;

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    -- INSERT statements

    INSERT INTO tblemail (id_email, dt_email, fi_notify, fi_group)
    VALUES (NULL, in_email, in_notify, in_group);


    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert: ok";
      WHEN 1452
      THEN
        SET out_execText = "insert: foreign key ERROR!";
        SET out_execCode = 1452;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
    ELSE
      BEGIN
        SET out_execText = CONCAT('INSERT status: an unknown error happend: ', out_execText);
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS delete_Message;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE delete_Message(
  IN  in_id_message TINYINT,
  OUT out_execCode  INT,
  OUT out_execText  VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    -- Declaration of handlers

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    -- INSERT statements

    DELETE FROM `msg`.`tblmessage`
    WHERE `tblmessage`.`id_message` = in_id_message;

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "deleteMessage: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('deleteMessage: an unknown error happend.');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_error;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_error(
IN in_execCode VARCHAR(255),
IN in_execText VARCHAR(255),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER                   
BEGIN
    INSERT INTO `msg`.`tblmsglogger` (`id_log`, `dt_msgtext`, `dt_msgcode`, `dt_timestamp`)
    VALUES (NULL, in_execText, in_execCode, CURRENT_TIMESTAMP);
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_userCredentials;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_userCredentials(
  IN  in_username  VARCHAR(150),
  IN  in_password  VARCHAR(20),
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN

    DECLARE c_out_id_user SMALLINT;
    DECLARE c_out_dt_username VARCHAR(150);
    DECLARE c_out_dt_fname VARCHAR(10);
    DECLARE c_out_dt_lname VARCHAR(10);
    DECLARE c_out_fi_group VARCHAR(10);
    DECLARE l_last_row_fetched INT(1);
    DECLARE c_languages CURSOR FOR SELECT
                                     id_user,
                                     dt_username,
                                     dt_fname,
                                     dt_lname,
                                     fi_group
                                   FROM tblusers
                                   WHERE dt_username = in_username
                                         AND dt_password = in_password;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched = 1;

    SET l_last_row_fetched = 0;
    OPEN c_languages;
    lang_cursor: LOOP
      FETCH c_languages
      INTO
        c_out_id_user, c_out_dt_username, c_out_dt_fname, c_out_dt_lname, c_out_fi_group;
      IF l_last_row_fetched = 1
      THEN
        LEAVE lang_cursor;
      END IF;
      SELECT
        c_out_id_user,
        c_out_dt_username,
        c_out_dt_fname,
        c_out_dt_lname,
        c_out_fi_group;
    END LOOP lang_cursor;
    CLOSE c_languages;

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "get_userCredentials: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('get_userCredentials: an unknown error happend while calling informations');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_searchFiMessage;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_searchFiMessage(
  IN  in_userSearch VARCHAR(50),
  OUT out_execCode  INT,
  OUT out_execText  VARCHAR(255)
)
  BEGIN

    SELECT
      id_message,
      dt_title
    FROM `tblmessage`
    WHERE `dt_title` LIKE CONCAT('%', in_userSearch, '%')
    LIMIT 1;

    SET out_execCode = 0;
    SET out_execText = "Executed success!";
    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "Select: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('SELECT status: an unknown error happend:');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS get_Types;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE get_Types(
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   -- SELECT * FROM tbltype;
   SELECT GROUP_CONCAT(id_type,'=', dt_description SEPARATOR ',') result FROM tbltype;
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   CASE out_execCode
        WHEN 0 THEN SET out_execText = "insert: ok";
        ELSE
           BEGIN
            SET out_execText = CONCAT('SELECT status: an unknown error happend: ', out_execText);
            SET out_execCode = 'FATAL';
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Languages;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Languages(
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN

    -- SELECT * FROM tbllanguage;
    SELECT GROUP_CONCAT(id_langcode, '=', dt_description SEPARATOR ',') result
    FROM tbllanguage;

    SET out_execCode = 0;
    SET out_execText = "Executed success!";
    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('SELECT status: an unknown error happend: ', out_execText);
        SET out_execCode = -1;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Types;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Types(
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN


    -- SELECT tbltype.id_type,tbltype.dt_description FROM tbltype;
    SELECT GROUP_CONCAT(id_type, '=', dt_description SEPARATOR ',') result
    FROM tbltype;

    SET out_execCode = 0;
    SET out_execText = "Executed success!";
    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "Select: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('SELECT status: an unknown error happend: ');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Messages;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Messages(
  IN  in_begin     TINYINT(3),
  IN  in_limit     TINYINT(3),
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN

    SELECT GROUP_CONCAT(tblmessage.id_message, '=', tblmessage.dt_title, '=', tblmessage.dt_timestamp, '=',
                        tbllanguage.dt_description, '=', tblusers.dt_username SEPARATOR ',') result
    FROM tblmessage, tbllanguage, tblusers
    WHERE tblmessage.fi_langcode = tbllanguage.id_langcode AND tblmessage.fi_user = tblusers.id_user
    LIMIT in_begin, in_limit;


    SET out_execCode = 0;
    SET out_execText = "Executed success!";
    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "Select: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('SELECT status: an unknown error happend: ');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Twitter;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE get_Twitter(
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   SELECT GROUP_CONCAT(id_key,'=', dtusername SEPARATOR ',') result FROM tbltwitter;


   SET out_execCode = 0;
   SET out_execText = "Executed twitter list request success!";
   CASE out_execCode
        WHEN 0 THEN SET out_execText = "Select: ok";
        ELSE
           BEGIN
            SET out_execText = CONCAT('SELECT status: an unknown error happend: ');
            SET out_execCode = 'FATAL';
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Logs;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Logs(
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN


    SELECT GROUP_CONCAT(id_file,'=', 	dt_path,'=', fi_notify SEPARATOR ',') result FROM tbllogfile;

  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Logs;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Logs(
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN


    SELECT GROUP_CONCAT(id_file,'=', 	dt_path,'=', fi_notify SEPARATOR ',') result FROM tbllogfile;

  END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Emails;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE get_Emails(
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   SELECT GROUP_CONCAT(id_email,'=', dt_email SEPARATOR ',') result FROM tblemail;
   SET out_execCode = 0;
   SET out_execText = "Executed twitter list request success!";
   CASE out_execCode
        WHEN 0 THEN SET out_execText = "Select: ok";
        ELSE
           BEGIN
            SET out_execText = CONCAT('get_Emails: an unknown error happend: ');
            SET out_execCode = 'FATAL';
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Error;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Error(
  IN  in_begin     TINYINT(3),
  IN  in_limit     TINYINT(3),
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN

    SELECT GROUP_CONCAT(id_log,'=', dt_msgtext,'=',dt_msgcode,'=', dt_timestamp SEPARATOR ',') result FROM tblmsglogger;


    SET out_execCode = 0;
    SET out_execText = "Executed success!";
    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "Select: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('get_Error: an unknown error happend: ');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS delete_Logmsg;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE delete_Logmsg(
  IN  in_id_logmsg TINYINT,
  OUT out_execCode  INT,
  OUT out_execText  VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    -- Declaration of handlers

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    -- INSERT statements

    DELETE FROM `msg`.`tblmsglogger`
    WHERE `tblmsglogger`.`id_log` = in_id_logmsg;

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "deleteLog: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('deleteLog: an unknown error happend.');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;
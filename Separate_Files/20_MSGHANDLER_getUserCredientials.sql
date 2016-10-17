/*----------------------------------------------------------------------------
| Routine : get_userCredentials
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Gathers a row of user uppon log to handle with php
| 
| Parameters :
| ------------
|  IN  : 	in_username 		: inserted username
| 			in_password 		: inserted password
|
|  OUT : out_execCode : Error code uppon query
|        out_execText : Error text uppon query
|        ...
|        <paramX> : <description of paramX>
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  : out_execCode, out_execText
|   stdReturnValuesUsed : 0 	: execution successfull 
|                         <stdReturnValueX> : <description/cause of stdReturnValueX>
|
| History of change(s) (yyyy-mm-dd)
| -------------------
|  <date of last change(s)> <NameOfTheAuthorOfTheChange> : <description of the change>
|   ...
|  <date of secnd change(s)> <NameOfTheAuthorOfTheChange> : <description of the change>
|  <date of first change(s)> <NameOfTheAuthorOfTheChange> : <description of the change>
|  
| List of callers : (this routine is called by the following routines)
| -----------------
| insert_error
|
|	Example: 
| call get_userCredentials('test','test',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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








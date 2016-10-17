/*----------------------------------------------------------------------------
| Routine : insert_users
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a User into tlbusers
| 
| Parameters :
| ------------
|  IN  : 	in_username 		: inserts username of user
| 			in_password 		: inserts password of user
| 			in_fname 			: inserts first name of user
| 			in_lname 			: inserts last name of user
| 			in_fi_group 		: inserts group of user
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
|                         1452  : foreign key error (fi_group)
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
|  call insert_users('user', 'userpw', 'FUser', 'LUser', '1',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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



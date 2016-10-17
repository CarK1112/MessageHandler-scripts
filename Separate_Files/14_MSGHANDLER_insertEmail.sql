/*----------------------------------------------------------------------------
| Routine : insert_email
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a Email into tblemail for a group of users
| 
| Parameters :
| ------------
|  IN  : 	in_langcode 		: inserts a language Code (ID)
| 			in_description 		: inserts Full name of abbreviation of id_langcude
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
| Example:
|   call insert_email('email@mail.com', '2', '1',@Code,@Text);
|   call insert_email('email@mail.com', '', '',@Code,@Text);
|
|---------------------------------------------------------------------------*/

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

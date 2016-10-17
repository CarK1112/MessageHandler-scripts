/*----------------------------------------------------------------------------
| Routine : insert_message
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts message into tblmessage
| 
| Parameters :
| ------------
|  IN  : 	in_dt_title 		: inserts a title
|  			in_dt_description 	: inserts description
|  			in_dt_timestamp 	: inserts timestamp (Default system timestamp)
|  			in_fi_langcode 		: inserts fi_language code
|  			in_fi_user 		    : inserts fi_user code
|
|  OUT : out_execCode : <description of param1>
|        <param2> : <description of param2>
|        ...
|        <paramX> : <description of paramX>
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  : out_execCode, out_execText
|   stdReturnValuesUsed : 0 	: execution successfull 
|                         1062 	: dublicate key error(id_message)
|                         1452  : foreign key error (fi_type)
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
|  call insert_message('Object not found','Object BLA BLA not found','0', 'EN','1',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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
      THEN SET out_execText = "insert_message: foreign key ERROR!";
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

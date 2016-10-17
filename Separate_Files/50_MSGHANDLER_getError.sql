/*----------------------------------------------------------------------------
| Routine : get_Error
| Author(s)  : (c) BTSi <Name_FirstName of author>
| CreateDate : 20.05.2016
|
| Description : Gathers error output
| 
| Parameters :
| ------------
|  IN  : 	/
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
|  call get_Error('1','5',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/




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




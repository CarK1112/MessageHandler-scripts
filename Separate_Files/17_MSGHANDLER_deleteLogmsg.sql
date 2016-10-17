/*----------------------------------------------------------------------------
| Routine : deleteLogmsg
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Deletes a message
| 
| Parameters :
| ------------
|  IN  : 	in_id_logmsg 		: The given ID parameter to get the specific log
|
|  OUT : out_execCode : outputs Code error
|  		   out_execText : output Text error
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  : out_execCode, out_execText
|   stdReturnValuesUsed : 0 	: execution successfull 
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
	Example: 
   call delete_Logmsg('1',@Code,@Text);

|
|---------------------------------------------------------------------------*/

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

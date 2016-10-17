/*----------------------------------------------------------------------------
| Routine : deleteMessage
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Deletes a message
| 
| Parameters :
| ------------
|  IN  : 	in_id_message 		: The given ID parameter to get the specific message
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
call insert_notify('Notify Message 404', '1',@Code,@Text);
INSERT INTO `tblnotify` (`id_notify`, `dt_description`, `fi_alert`) VALUES (NULL, 'Warn user something not found', '1');

|
|---------------------------------------------------------------------------*/

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

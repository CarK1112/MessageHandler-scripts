/*----------------------------------------------------------------------------
| Routine : get_Messages
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Outputs litteraly all messages and builds up a table
| 
| Parameters :
| ------------
|  IN  : 	in_begin    : LIMIT begin with
|  IN  : 	in_limit    : LIMIT how maby rows to show
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
|  call get_Messages('0','10',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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











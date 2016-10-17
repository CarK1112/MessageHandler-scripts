/*----------------------------------------------------------------------------
| Routine : get_FiMessage
| Author(s)  : (c) BTSi Ken Cardoso
| CreateDate : 20.05.2016
|
| Description : Gathers all type from a selected Language
| 
| Parameters :
| ------------
|  IN  : 	in_userSearch : Search for title of a message
|
|  OUT : out_execCode : Error code uppon query
|        out_execText : Error text uppon query
|        ...
|        <paramX> : <description of paramX>
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  :       out_execCode, out_execText
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
|  insert_error
|
|	Example:
|  call get_FiMessage('Obj',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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











/*----------------------------------------------------------------------------
| Routine : get_Twitter
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Outputs a list of twitter accounts to select
| 
| Parameters :
| ------------
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
|  call get_Twitter(@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

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











/*----------------------------------------------------------------------------
| Routine : insert_error
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts message into tblmessage
| 
| Parameters :
| ------------
|  IN  : 	in_execCode 		: inserts a code of the error
| 			in_execText 		: inserts the text of the given error message
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
|                         1062 	: dublicate key error(id_message)
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
| <routine1>, <routine2>, <routine3>, ...
|
|	Example:
|   call insert_error('1062','Dublicate keys....',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_error;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_error(
IN in_execCode VARCHAR(255),
IN in_execText VARCHAR(255),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER                   
BEGIN
    INSERT INTO `msg`.`tblmsglogger` (`id_log`, `dt_msgtext`, `dt_msgcode`, `dt_timestamp`)
    VALUES (NULL, in_execText, in_execCode, CURRENT_TIMESTAMP);
END$$
DELIMITER ;



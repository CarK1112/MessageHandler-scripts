/*----------------------------------------------------------------------------
| Routine : insert_message
| Author(s)  : (c) BTSi <Name_FirstName of author>
| CreateDate : 20.05.2016
|
| Description : Inserts message into tblmessage
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
	Example: 
call insert_language('DE','Deutsch',@Code,@Text);

|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_language;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_language(
IN in_langcode VARCHAR(2), 
IN in_description VARCHAR(150),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER                   
BEGIN

   -- Declaration of named conditions
   
   DECLARE duplicate_key CONDITION FOR 1062;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR duplicate_key SET out_execCode = 1062;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   -- INSERT statements
   
    INSERT INTO tbllanguage(id_langcode,dt_description) 
    VALUES (in_langcode,in_description);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert: ok";
        WHEN 1062 THEN SET out_execText = "insert: dublicate key ERROR!";
        ELSE
           BEGIN
            SET out_execText = CONCAT('INSERT status: an unknown error happend: ', out_execText);
          END;
   END CASE;
   /*IF l_error_code=1 THEN
        SELECT CONCAT('Failed to insert fi key not found') as "Result";
   END IF;*/
END$$
DELIMITER ;



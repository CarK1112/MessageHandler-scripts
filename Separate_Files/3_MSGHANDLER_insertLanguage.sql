/*----------------------------------------------------------------------------
| Routine : insert_message
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts message into tblmessage
| 
| Parameters :
| ------------
|  IN  : 	in_langcode 		: inserts a language Code (ID)
| 			  in_description 		: inserts Full name of abbreviation of id_langcode
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
| insert_error
|
|	Example:
|   call insert_language('DE','Deutsch',@Code,@Text);
|
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
    VALUES (UPPER(in_langcode),in_description);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_language: ok";
        WHEN 1062 THEN
               SET out_execText = "insert_language: dublicate key_language ERROR!";
               CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_language: an unknown error happend with the procedure insert_language');
             SET out_execCode = 'FATAL';
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;



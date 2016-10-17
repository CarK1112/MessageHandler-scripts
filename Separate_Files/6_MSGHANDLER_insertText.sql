/*----------------------------------------------------------------------------
| Routine : insert_text
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts text into tbltext
| 
| Parameters :
| ------------
|  IN  : 	in_description 		: inserts a brief description
| 			in_fi_type 			: inserts Type of error
|  			in_fi_langcode 		: inserts Language Code Abbreviation
|  			in_dt_timestamp 	: inserts timestamp (Default system timestamp)
|  			in_fi_langcode 		: inserts fi_language code from tbllanguage
|  			in_fi_alert 		: inserts fi_alert from tblAlert
|
|  OUT : out_execCode : outputs error Code
|        out_execText : outputs error Text
|        ...
|        <paramX> : <description of paramX>
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
|	Example: 
|    call insert_text('Access prohibited', '403', 'EN',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_text;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_text(
IN in_description VARCHAR(100),
IN in_fi_type SMALLINT UNSIGNED,
IN in_fi_langcode VARCHAR(2),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER             
BEGIN

   -- Declaration of named conditions
   
   DECLARE noForeignKey_error  CONDITION FOR 1452;
   
   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

   -- initialisation of the out parameters
   
   SET out_execCode = 0;
   SET out_execText = "Executed success!";
   
   -- INSERT statements
   
      INSERT INTO tbltext(id_text,dt_description,fi_type,fi_langcode)
      VALUES(NULL,in_description,in_fi_type,in_fi_langcode);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_text: ok";
        WHEN 1452 THEN
             SET out_execText = "insert_text: foreign key ERROR!";
             SET out_execCode = 1452;
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
             SET out_execCode = 'FATAL';
             SET out_execText = CONCAT('insert_text: an unknown error happend.');
          END;
   END CASE;
END$$
DELIMITER ;



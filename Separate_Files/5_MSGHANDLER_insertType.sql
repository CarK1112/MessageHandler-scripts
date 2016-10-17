/*----------------------------------------------------------------------------
| Routine : insert_type
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a type into tbltype
| 
| Parameters :
| ------------
|  IN  : 	in_id_type 			: inserts a type of error (ID)
| 			in_description 		: inserts a brief description of the Type of error
|
|  OUT : out_execCode : Outputs error code
|        out_execText : Outputs error code
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
|   call insert_type('403', 'FORBIDDEN',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_type;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_type(
IN in_id_type SMALLINT UNSIGNED,
IN in_description VARCHAR(255),
OUT out_execCode INT,
OUT out_execText VARCHAR(255)
)
SQL SECURITY DEFINER
BEGIN

   -- Declaration of named conditions

   DECLARE dubKeyError  CONDITION FOR 1062;

   -- Declaration of handlers
   DECLARE CONTINUE HANDLER FOR dubKeyError SET out_execCode = 1062;

   -- initialisation of the out parameters

   SET out_execCode = 0;
   SET out_execText = "Executed success!";

   -- INSERT statements

      INSERT INTO tbltype(id_type,dt_description)
          VALUES(in_id_type,in_description);

   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_type: ok";
        WHEN 1062 THEN
           SET out_execText = "insert_type: Dublicate Key ERROR!";
     SET out_execCode = 1062;
           CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_type: an unknown error happend');
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode, out_execText, @Code, @Text);
          END;
   END CASE;
END$$
DELIMITER ;

/*----------------------------------------------------------------------------
| Routine : insert_alert
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts an alert 
| 
| Parameters :
| ------------
|  IN  : 	in_description 		: inserts description
| 			in_fi_message 		: gets its message
| 			in_fi_type 			: gets its type
|			in_fi_user 			: gets its user who created the alert (can be null, if user doenst exist anymore)
|  OUT : out_execCode : outputs Code error
|  		 out_execText : output Text error
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  : out_execCode, out_execText
|   stdReturnValuesUsed : 0 	: execution successfull 
|   stdReturnValuesUsed : 1452 	: no foreign key found
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
| call insert_alert('Notify Warnings', '1', '1', '1',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_alert;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_alert(
IN in_description VARCHAR(100),
IN in_fi_message TINYINT UNSIGNED, 
IN in_fi_type SMALLINT UNSIGNED, 
IN in_fi_user SMALLINT UNSIGNED,
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
   
       INSERT INTO tblalert(id_alert,dt_description,fi_message,fi_type,fi_user,dt_timestamp)
       VALUES(NULL,in_description,in_fi_message,in_fi_type,in_fi_user,CURRENT_TIMESTAMP);
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert: ok";
        WHEN 1452 THEN
            SET out_execText = "insert: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('INSERT status: an unknown error happed: ', out_execText);
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;


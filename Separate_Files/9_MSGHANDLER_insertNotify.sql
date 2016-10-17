/*----------------------------------------------------------------------------
| Routine : insert_notify
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a new notifier
| 
| Parameters :
| ------------
|  IN  : 	in_description 		: inserts a description
| 			in_fi_alert 		: inserts alert created by 
|
|  OUT : out_execCode : outputs Code error
|  		 out_execText : output Text error
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
|   call insert_notify('Notify Message 404', '1',@Code,@Text);
|   INSERT INTO `tblnotify` (`id_notify`, `dt_description`, `fi_alert`) VALUES (NULL, 'Warn user something not found', '1');
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_notify;
CREATE DEFINER=`msgadmin`@`localhost` PROCEDURE insert_notify(
IN in_description VARCHAR(100),
IN in_fi_alert VARCHAR(2),
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
   
   INSERT INTO tblnotify(id_notify,dt_description,fi_alert)
   VALUES(NULL,in_description,in_fi_alert); 
   
   CASE out_execCode
        WHEN 0    THEN SET out_execText = "insert_notify: ok";
        WHEN 1452 THEN
            SET out_execText = "insert_notify: foreign key ERROR!";
            SET out_execCode = 1452;
            CALL insert_error(out_execCode,out_execText,@Code,@Text);
        ELSE
           BEGIN
            SET out_execText = CONCAT('insert_notify: an unknown error happend');
             SET out_execCode = 'FATAL';
             CALL insert_error(out_execCode,out_execText,@Code,@Text);
          END;
   END CASE;
END$$
DELIMITER ;

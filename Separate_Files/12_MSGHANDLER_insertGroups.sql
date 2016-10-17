/*----------------------------------------------------------------------------
| Routine : insert_groups
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a group into tblgroup
| 
| Parameters :
| ------------
|  IN  : 	in_name 			: group name
| 			  in_description 		: a brief description of the group
|
|  OUT : out_execCode : output error code
|        out_execText : output custom Text code
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
| call insert_groups('WarningGroup', 'Receives only warning messages',@Code,@Text);
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_groups;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_groups(
  IN  in_name        VARCHAR(20),
  IN  in_description VARCHAR(40),
  OUT out_execCode   INT,
  OUT out_execText   VARCHAR(255)
)
  BEGIN

    -- Declaration of named conditions

    -- Declaration of handlers
    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    INSERT INTO tblgroups (id_group, dt_name, dt_description)
    VALUES (NULL, in_name, in_description);

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert_groups: ok";
    ELSE
      BEGIN
        SET out_execText = CONCAT('insert_groups: an unknown error happend');
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;

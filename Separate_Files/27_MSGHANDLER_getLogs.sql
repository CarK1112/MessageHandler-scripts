/*----------------------------------------------------------------------------
| Routine : get_Logs
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Outputs a list of log paths to select
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
|  call get_Logs(@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS get_Logs;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE get_Logs(
  OUT out_execCode INT,
  OUT out_execText VARCHAR(255)
)
  BEGIN


    SELECT GROUP_CONCAT(id_file,'=', 	dt_path,'=', fi_notify SEPARATOR ',') result FROM tbllogfile;

  END$$
DELIMITER ;











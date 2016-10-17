/*----------------------------------------------------------------------------
| Routine : insert_twitter
| Author(s)  : (c) BTSi Cardoso Ken
| CreateDate : 20.05.2016
|
| Description : Inserts a twitter notification setting
| 
| Parameters :
| ------------
|  IN  : 	in_username 			: inserts username of twitter
| 			in_consumer_key 		: inserts consumer key
| 			in_consumer_secret 		: inserts consumer secret
| 			in_token 				: inserts consumer token
| 			in_secret 				: inserts  secret code
| 			in_fi_notify 			: inserts to which notify it belongs
|
|  OUT : out_execCode : out_error Code
|        out_execText : out error Text
|        ...
|        <paramX> : <description of paramX>
|
| stdReturnValues : 
| -----------------
|   stdReturnParameter  : out_execCode, out_execText
|   stdReturnValuesUsed : 0 	: execution successfull 
|                         1452  : foreign key error (fi_notify)
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
|   call insert_twitter('cark112Handler', 'mIVuhGNlfj3wXduGRVIgjRupY', 'l3o20rGMzYywltN31kVJelhkkTzkelAeH1bW30UwDLI3ovrV5w', '719828210268168193-iQvEQEeRRVGWEqbdkmMug3AurWNEIFx', 'j7pw73dNrvVpKv8nZDSJwQ6tm30yrQJVs3N4uWcGiePIz', '1',@Code,@Text);
|
|
|---------------------------------------------------------------------------*/

DELIMITER $$
DROP PROCEDURE IF EXISTS insert_twitter;
CREATE DEFINER =`msgadmin`@`localhost` PROCEDURE insert_twitter(
  IN  in_username        VARCHAR(30),
  IN  in_consumer_key    VARCHAR(30),
  IN  in_consumer_secret VARCHAR(60),
  IN  in_token           VARCHAR(60),
  IN  in_secret          VARCHAR(60),
  IN  in_fi_notify       SMALLINT UNSIGNED,
  OUT out_execCode       INT,
  OUT out_execText       VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions

    DECLARE noForeignKey_error CONDITION FOR 1452;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR noForeignKey_error SET out_execCode = 1452;

    -- initialisation of the out parameters

    SET out_execCode = 0;
    SET out_execText = "Executed success!";

    INSERT INTO tbltwitter (id_key, dtusername, dt_consumer_key, dt_consumer_secret, dt_token, dt_secret, fi_notify)
    VALUES (NULL, in_username, in_consumer_key, in_consumer_secret, in_token, in_secret, in_fi_notify);

    CASE out_execCode
      WHEN 0
      THEN SET out_execText = "insert: ok";
      WHEN 1452
      THEN
        SET out_execText = "insert: foreign key ERROR!";
        SET out_execCode = 1452;
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
    ELSE
      BEGIN
        SET out_execText = CONCAT('INSERT status: an unknown error happed: ', out_execText);
        SET out_execCode = 'FATAL';
        CALL insert_error(out_execCode, out_execText, @Code, @Text);
      END;
    END CASE;
  END$$
DELIMITER ;


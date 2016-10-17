DROP USER 'msgadmin'@localhost;
FLUSH PRIVILEGES;
CREATE USER 'msgadmin'@localhost IDENTIFIED BY 'q1w2e3!';

-- GRANT EXECUTE ON PROCEDURE `msg`.

GRANT ALL PRIVILEGES ON msg.* TO 'msgadmin'@'localhost' WITH GRANT OPTION;


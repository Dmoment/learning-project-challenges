DROP DATABASE IF EXISTS lhm_testing;
CREATE DATABASE lhm_testing;

DROP TABLE IF EXISTS lhm_testing.users;

CREATE TABLE lhm_testing.users(
  id INT PRIMARY KEY,
  first_name VARCHAR(40)
);

DROP TABLE IF EXISTS lhm_testing.shadow_users;

CREATE TABLE lhm_testing.shadow_users(
  id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40) NOT NULL DEFAULT 'Doe',
  UNIQUE KEY(first_name, last_name)
);

-- Insert trigger
DROP TRIGGER IF EXISTS lhm_testing.lhm_insert_trigger;

CREATE TRIGGER
  lhm_testing.lhm_insert_trigger
AFTER INSERT ON 
  lhm_testing.users
FOR EACH ROW
  REPLACE INTO
    lhm_testing.shadow_users(id, first_name)
  VALUES
    (NEW.id, NEW.first_name);

-- Update trigger 
DROP TRIGGER IF EXISTS lhm_testing.lhm_update_trigger;

CREATE TRIGGER
  lhm_testing.lhm_update_trigger
AFTER UPDATE ON 
  lhm_testing.users
FOR EACH ROW
  REPLACE INTO
    lhm_testing.shadow_users(id, first_name)
  VALUES
    (NEW.id, NEW.first_name);

-- Delete trigger   
DROP TRIGGER IF EXISTS lhm_testing.lhm_delete_trigger;

CREATE TRIGGER
  lhm_testing.lhm_delete_trigger
AFTER DELETE ON 
  lhm_testing.users
FOR EACH ROW
  DELETE IGNORE FROM 
    lhm_testing.shadow_users
  WHERE
    lhm_testing.shadow_users.id = OLD.id;  

-- Populate users table
INSERT INTO lhm_testing.users
	(`id`, `first_name`)
VALUES
	(1, 'john'),
	(2, 'jack');    


-- -- Assume records have already been migrated (only for UPDATE and DELETE)
-- INSERT INTO lhm_testing.shadow_users
-- 	(`id`, `first_name`)
-- VALUES
-- 	(1, 'john'),
-- 	(2, 'jack');    

-- For the INSERT trigger
INSERT INTO lhm_testing.users
	(`id`, `first_name`)
VALUES
	(3, 'jack');

-- For the UPDATE trigger
UPDATE
	lhm_testing.users
SET
	`first_name` = 'john'
WHERE
	`first_name` = 'jack';

-- For the DELETE trigger
DELETE FROM
	lhm_testing.users
WHERE
	`first_name` = 'jack';

SELECT * FROM lhm_testing.users;
SELECT * FROM lhm_testing.shadow_users;
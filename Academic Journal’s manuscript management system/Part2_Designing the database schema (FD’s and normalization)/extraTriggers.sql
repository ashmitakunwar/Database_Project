-- Extra Triggers -- 


-- 4 different triggers are created and included. These 4 commands must be triggered after the
-- table creation and before data insert. To be on the safer side we have placed all
--  of these Triggers in tables.sql and Insert.sql query tab, so they don't miss out. 


DROP TRIGGER IF EXISTS After_Person_Insert_Role_Editor; 

DELIMITER $$
CREATE TRIGGER After_Person_Insert_Role_Editor
AFTER INSERT ON Person
FOR EACH ROW 
 BEGIN
	IF (NEW.Person_role= 'editor')
    THEN
	INSERT INTO Editor
	SET Person_id = NEW.Person_id; 
    END IF;
END $$
DELIMITER ;


-- Trigger to insert data in Reviewer table when new Person record is added having person_role as 'Reviewer'

DROP TRIGGER IF EXISTS After_Person_Insert_Role_Reviewer;

DELIMITER $$
CREATE TRIGGER After_Person_Insert_Role_Reviewer
AFTER INSERT ON Person
FOR EACH ROW 
 BEGIN
	IF (NEW.Person_role= 'reviewer')
    THEN
	INSERT INTO Reviewer
	SET Person_id = NEW.Person_id; 
    END IF;
END $$
DELIMITER ;

-- Trigger to insert data in 'Author' table when new Person record is added having person_role as 'Author'

DROP TRIGGER IF EXISTS After_Person_Insert_Role_Author;

DELIMITER $$
CREATE TRIGGER After_Person_Insert_Role_Author
AFTER INSERT ON Person
FOR EACH ROW 
 BEGIN
	IF (NEW.Person_role= 'author')
    THEN
	INSERT INTO Author
	SET Person_id = NEW.Person_id; 
    END IF;
END $$
DELIMITER ;

 -- Trigger to update the the current timestamp for the field last_status_change in Manuscript table when status is updated. 

DROP TRIGGER IF EXISTS Manuscript_status_change_update_time; 

DELIMITER $$
CREATE TRIGGER Manuscript_status_change_update_time
BEFORE UPDATE ON Manuscript
FOR EACH ROW 
 BEGIN
	IF( NEW.Manuscript_status_idmanuscript_status != OLD.Manuscript_status_idmanuscript_status)
    THEN
	SET NEW.last_status_change=current_timestamp();
    END IF;
END $$
DELIMITER ;

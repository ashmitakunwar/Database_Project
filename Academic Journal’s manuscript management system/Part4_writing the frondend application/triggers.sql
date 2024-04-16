-- ------------------------  Triggers ---------------------------------------------

-- ---------------------------Trigger1---------------------------------------------

DROP TRIGGER IF EXISTS Trigger1;

DELIMITER $$
create trigger Trigger1 
after insert on Manuscript
for each row 
	begin 
		 IF NOT EXISTS (SELECT * FROM Reviewer_interest WHERE RICodes_RICodesID = NEW.Icode_icodeID) THEN

             signal sqlstate '20000' set message_text = 'Sorry!Paper cannot be considered this time.', MYSQL_ERRNO = 1001;  
             
		END IF;
	END $$
DELIMITER ;

-- ----------------------------------------Trigger2-----------------------------------------------------

DROP TRIGGER IF EXISTS Trigger2 ; 
DELIMITER $$
CREATE TRIGGER Trigger2 
AFTER UPDATE ON Manuscript_Feedback
for each row 
	begin 
		 IF EXISTS (SELECT * from Manuscript where Manuscript_status_idmanuscript_status = 3 and 
          Manuscript_id = NEW.Manuscript_manuscript_id AND NEW.Reviewer_status = "RESIGNS") THEN
           
           Update Manuscript set Manuscript_status_idmanuscript_status=1
           where Manuscript_id = NEW.Manuscript_manuscript_id;

	
			END IF;
	END $$
DELIMITER ;

-- --------------------------------------Trigger3-----------------------------------------------

DROP TRIGGER IF EXISTS Trigger3; 

DELIMITER $$
CREATE TRIGGER Trigger3
BEFORE UPDATE ON Manuscript
FOR EACH ROW 
 BEGIN
	IF(OLD.Manuscript_status_idmanuscript_status=4)
    THEN
     SET NEW.Manuscript_status_idmanuscript_status = 6 ; 
    END IF;
END $$
DELIMITER ;


 


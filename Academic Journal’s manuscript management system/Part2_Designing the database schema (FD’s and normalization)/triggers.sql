-- ------------------------  Triggers ---------------------------------------------

-- Trigger1 

DROP TRIGGER IF EXISTS Trigger1;

DELIMITER $$
create trigger Trigger1 
after insert on Manuscript
for each row 
	begin 
		 IF NOT EXISTS (SELECT * FROM Reviewer_interest WHERE RICodes_RICodesID = NEW.Icode_icodeID) THEN

             signal sqlstate '20000' set message_text = 'Sorry!Paper cannot be considered this time', MYSQL_ERRNO = 1001;  
             
		END IF;
	END $$
DELIMITER ;

-- Trigger 2 

-- --------------------------------------Trigger3-----------------------------------------------

DROP TRIGGER IF EXISTS changeStatus; 
DELIMITER $$
CREATE TRIGGER changeStatus
AFTER UPDATE ON Manuscript
FOR EACH ROW 
 BEGIN
	IF(NEW.Manuscript_status_idmanuscript_status=4)
    THEN
     SET NEW.Manuscript_status_idmanuscript_status = 6 ; 
    END IF;
END $$
DELIMITER ;

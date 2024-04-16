-- ---------------------- FUNCTION------------------------------------
-- DROP FUNCTION ''ResultFunction' IF EXISTS and CREATE A NEW ONE

-- We have explicitely declared the Minimum score as 7 for the Manuscript to be Accepted. 

DROP FUNCTION IF EXISTS ResultFunction; 

DELIMITER $$
CREATE FUNCTION ResultFunction
( Manuscript_total_score INT)
returns VARCHAR(10)
DETERMINISTIC 
BEGIN 
	DECLARE FeedbackResult VARCHAR(10); 
    IF Manuscript_total_score > 7 THEN 
		SET FeedbackResult = "ACCEPTED"; 
	ELSE 
		SET FeedbackResult = "REJECTED";
	END IF; 
		Return (FeedbackResult); 
END$$
DELIMITER ; 


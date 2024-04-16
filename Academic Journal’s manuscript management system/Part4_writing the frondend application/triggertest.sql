-- --------------------------- SQL CODES for testing triggers ---------------------

-- SQL code for Testing Trigger1

-- Here, Icode_icodeID = 111 which does not belong to any of the reviewers, so while trying to insert Manuscript 
-- with that ICode, it alerts by throwing exception 'Sorry!Paper cannot be considered this time.'

 INSERT INTO  Manuscript
      (
      Icode_icodeID,Manuscript_title,Manuscript_DateReceiced,Journal_JournalEdition, Manuscript_DateOfAcceptance, 
      Manuscript_JournalBeiginingPageNumber,Manuscript_Order_in_Journal,
      Manuscript_status_idmanuscript_status)
      values
      (111,'JUST A TRIAL FOR ','2021-07-02 12:00:01',NULL,NULL, NULL,NULL,2); 
      
      
      
   
   -- -------------------------- SQL Code for testing Trigger 2 ----------------------------------------------
   
   
-- Following query shows the status of Manuscript before trigger does it work.
-- Review status 3 means 'Under review' and 1 Means 'Received' -- here we are referencing Manuscript with id 10 to verify this scenario.

SELECT Manuscript_status_idmanuscript_status,Reviewer_status, Manuscript_id FROM Manuscript 
join Manuscript_Feedback on Manuscript.Manuscript_id = Manuscript_Feedback.Manuscript_manuscript_id 
where Manuscript_status_idmanuscript_status =3 and Manuscript_id=10; 
 
 
 -- Update reviewer_status from ACTIVE to RESIGNS for Manuscript_id=10
 
 UPDATE Manuscript_Feedback set Reviewer_status = "RESIGNS" WHERE Manuscript_manuscript_id = 10; 
 
 -- Trigger updates the Manuscript_status from 3 to 1 Automatically. 
 -- Run Following query to verify that. 
 
SELECT Manuscript_status_idmanuscript_status,Reviewer_status, Manuscript_id FROM Manuscript 
join Manuscript_Feedback on Manuscript.Manuscript_id = Manuscript_Feedback.Manuscript_manuscript_id 
where Manuscript_id=10;

-- ------------------------SQL Code for testing Trigger3------------------------------------

-- 4 = Reviewed 
-- 5 = Accepted 
-- 6 = Typesetting
-- On changing Manuscript status from 4 to 5 (i.e from Reviewed to Accepted - It will autoamtically changes to Typesetting)

-- Before Update and Trigger 
select Manuscript_status_idmanuscript_status, Manuscript_id from Manuscript where Manuscript_id = 13; 

-- Changing the status of manuscript from 4 t0 5 ( from Reviewed to Accepted)

Update Manuscript set Manuscript_status_idmanuscript_status = 5 where Manuscript_id = 13; 

-- After changing Manuscript from 4 to 5( Accepted state - Trigger Automatically change status to 5
-- Run the following query below to see the result

select Manuscript_status_idmanuscript_status, Manuscript_id from Manuscript where Manuscript_id = 13;






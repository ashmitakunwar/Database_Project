-- --------------------------- SQL CODES for testing triggers ---------------------

-- SQL code for Testing Trigger1

-- Here, Icode_icodeID = 111 which does not belong to any of the reviewers, so while trying to insert Manuscript 
-- with that ICode alerts by throwing exception 'Sorry!Paper cannot be considered this time.'

 INSERT INTO  Manuscript
      (
      Icode_icodeID,Manuscript_title,Manuscript_DateReceiced,Journal_JournalEdition, Manuscript_DateOfAcceptance, 
      Manuscript_JournalBeiginingPageNumber,Manuscript_Order_in_Journal,
      Manuscript_status_idmanuscript_status)
      values
      (111,'JUST A TRIAL FOR ','2021-07-02 12:00:01',NULL,NULL, NULL,NULL,2); 
      
      
      
-- SQL Code for Trigger3

-- 4 = Reviewed 
-- 5 = Accepted 
-- 6 = Typesetting
-- On changing Manuscript status from 4 to 5 (i.e from Reviewed to Accepted - It will autoamtically changes to Typesetting)

select Manuscript_status_idmanuscript_status, Manuscript_id from Manuscript where Manuscript_id = 13; 
Update Manuscript set Manuscript_status_idmanuscript_status = 4 where Manuscript_id = 13; 
select Manuscript_status_idmanuscript_status, Manuscript_id from Manuscript where Manuscript_id = 13;





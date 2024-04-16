--  --------------------------------------- VIEWS -----------------------------------------------

-- ------------------ -------LeadAuthorManuscripts-----------------------------------------------------

-- DROP VIEW IF EXISTS AND CREATE A NEW ONE

DROP VIEW IF EXISTS LeadAuthorManuscripts; 

CREATE VIEW LeadAuthorManuscripts AS 
 Select Manuscript_id, ( select Manuscript_status from Manuscript_status
 where M.Manuscript_status_idmanuscript_status = Manuscript_status.idManuscript_status)
 as Status_manuscript, AO.Author_idAuthor,P.Person_lname , M.last_status_change 
 from Manuscript as M join Author_order as AO
 on M.Manuscript_id=AO.Manuscript_idManuscript join Author as A on AO.Author_idAuthor = A.Author_id
 join Person as P on P.Person_id = A.Person_id WHERE AO.author_order_num = 1
 order by P.Person_lname, AO.Author_idAuthor, M.last_status_change  DESC ; 
 
 select * from LeadAuthorManuscripts; 
 -- ------------------ AnyAuthorManuscripts-----------------------------------------------------
 
 -- DROP VIEW IF EXISTS AND CREATE A NEW ONE
 
DROP VIEW IF EXISTS AnyAuthorManuscripts;

CREATE VIEW AnyAuthorManuscripts AS
Select  Person_fname, Person_lname,Author_id, Manuscript_id, Manuscript_title, 
last_status_change from Person as P
join Author AS A on  P.Person_id = A.Person_id
join Author_order as AO on A.Author_id=AO.Author_idAuthor
join Manuscript M  on AO.Manuscript_idManuscript=M.Manuscript_id
order by P.Person_lname, M.last_status_change desc ; 

 select * from AnyAuthorManuscripts; 

 -- ------------------ PublishedIssues -----------------------------------------------------
 
 -- DROP VIEW IF EXISTS AND CREATE A NEW ONE
DROP VIEW IF EXISTS PublishedIssues; 

CREATE VIEW PublishedIssues AS 
SELECT Journal_edition,	Manuscript_title, Published_year, Issue_number,Manuscript_JournalBeiginingPageNumber,
Manuscript_status_idmanuscript_status,Journal_status
FROM Manuscript as M
join ( Select * from Journal WHERE Journal_status = "Published" ) as J
on M.Journal_JournalEdition=J.Journal_edition 
ORDER BY Published_year,Issue_number,Manuscript_JournalBeiginingPageNumber ;

select * from PublishedIssues; 
-- ---------------------------- ReviewQueue -----------------------------------------------

DROP VIEW IF EXISTS ReviewQueue; 

CREATE VIEW ReviewQueue AS
Select Author_idAuthor, Manuscript_idManuscript, Reviewer_reviewer_id,last_status_change from Author_order
join Manuscript_Feedback on Author_order.Manuscript_idManuscript = Manuscript_Feedback.Manuscript_manuscript_id
join Manuscript on Manuscript_Feedback.Manuscript_manuscript_id = Manuscript.Manuscript_id
where author_order_num = 1 AND Manuscript_id in (Select Manuscript_id
from  Manuscript where Manuscript.Manuscript_status_idmanuscript_status = 3)
order by last_status_change DESC;

select * from ReviewQueue;
-- ------------------------------- WhatsLeft ---------------

DROP VIEW IF EXISTS WhatsLeft; 

CREATE VIEW WhatsLeft AS 
SELECT Manuscript.Manuscript_id,Manuscript_status.Manuscript_status, Manuscript.last_status_change
from Manuscript, Manuscript_status
where Manuscript.Manuscript_status_idmanuscript_status=Manuscript_status.idManuscript_status
order by Manuscript_id ;


select * from WhatsLeft;
-- -------------------------------- --- ReviewStatus -----------------------------------------

-- Funtion ViewRevId which is used in the  ReviewStatus

-- Drop function if exists and create a new one

DROP FUNCTION IF EXISTS ViewRevId;

DELIMITER &&
CREATE FUNCTION ViewRevId()
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE rev_id INT;
	SET rev_id=5;
    RETURN rev_id;
END &&  
DELIMITER ;

-- Drop view ReviewStatus if exists and create a new one 

DROP VIEW IF EXISTS ReviewStatus;

CREATE VIEW ReviewStatus AS
SELECT M.last_status_change, M.Manuscript_id, M.Manuscript_title, 
MF.Appropriateness, MF.Clarity, MF.Methodology, MF.Experimental_results,
MF.Recommendation_status, MF.Manuscript_Assigned_Time from Manuscript AS M 
join Manuscript_Feedback AS MF on M.Manuscript_id = MF.Manuscript_manuscript_id
where MF.Reviewer_reviewer_id=ViewRevId() ORDER BY MF.Manuscript_Assigned_Time ASC;

select * from ReviewStatus; 







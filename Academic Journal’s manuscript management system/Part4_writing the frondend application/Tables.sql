-- DROP 'Person' Table if exists and create a new one with same one.

DROP TABLE IF EXISTS Person; 
CREATE TABLE Person
  ( Person_id	    INT NOT NULL AUTO_INCREMENT,
	Person_role     VARCHAR(10) NOT NULL,
  	Person_fname   	VARCHAR(25) NOT NULL,
    Person_lname   	VARCHAR(25) NOT NULL,
    Person_email    VARCHAR(45) NOT NULL,
    Person_affiliation VARCHAR(65), 
    PRIMARY KEY (Person_id)
  );
  
  -- Since we do not store email for all the authors apart from Primary author so altered it to remove NOT NULL
Alter table Person modify column Person_email VARCHAR(45); 

  -- DROP 'Editor' Table if exists and create a new one with same one.
  
  DROP TABLE IF EXISTS Editor; 
  
  CREATE TABLE Editor
	( Editor_id		INT NOT NULL AUTO_INCREMENT, 
      Person_id     INT NOT NULL, 
      PRIMARY KEY(Editor_id), 
	  FOREIGN KEY (Person_id) REFERENCES Person(Person_id)
	); 
  
-- DROP Reviewer table if exists and then Create a new one.
  
DROP TABLE IF EXISTS Reviewer; 
  
CREATE TABLE Reviewer
	( Reviewer_id	INT NOT NULL AUTO_INCREMENT, 
      Person_id     INT NOT NULL, 
      PRIMARY KEY(Reviewer_id), 
	  FOREIGN KEY (Person_id) REFERENCES Person(Person_id)
	); 
    
    
-- DROP Author table if exists and then Create a new table named Author. 

DROP TABLE IF EXISTS Author; 
  
CREATE TABLE Author
	( Author_id	INT NOT NULL AUTO_INCREMENT, 
      Person_id     INT NOT NULL, 
      PRIMARY KEY(Author_id), 
	  FOREIGN KEY (Person_id) REFERENCES Person(Person_id)
	); 


-- Trigger to insert data in Editor table when new Person record is added having person_role as 'Editor'

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


-- DROP Table 'Journal' if exists and create a new table 'Journal'
DROP TABLE IF EXISTS Journal; 
CREATE TABLE Journal
	( Journal_edition		VARCHAR(10) NOT NULL, 
	  Journal_pages 		INT NOT NULL,
      Published_year 		INT NOT NULL, 
      Issue_number			INT NOT NULL CHECK (Issue_number<=4), 
      Journal_status        VARCHAR(15) NOT NULL,
      PRIMARY KEY (Journal_edition)
      ); 
      
-- Drop Table Ricodes if exist and create table RIcodes
DROP TABLE  IF EXISTS RICodes;

CREATE TABLE    RICodes
  ( icodeID        MEDIUMINT NOT NULL AUTO_INCREMENT,
    icode_interest    varchar(64) NOT NULL,
    PRIMARY KEY (icodeID)
  );

-- Drop Table Manuscript_status if exist and create table named 'Manuscript_status'

DROP TABLE IF EXISTS Manuscript_status; 

CREATE TABLE Manuscript_status
	( idManuscript_status 		INT NOT NULL AUTO_INCREMENT, 
	  Manuscript_status         VARCHAR(20) NOT NULL, 
      PRIMARY KEY(idManuscript_status)
	); 
    
-- Drop Table Manuscript if exist and create table named 'Manuscript'
  DROP TABLE IF EXISTS Manuscript; 
  
  CREATE TABLE Manuscript
	( Manuscript_id			INT NOT NULL AUTO_INCREMENT, 
      Icode_icodeID			MEDIUMINT NOT NULL, 
      Manuscript_title		VARCHAR(120) NOT NULL, 
      Manuscript_DateReceiced		DATETIME NOT NULL,
      Journal_JournalEdition		VARCHAR(10),
      Manuscript_DateOfAcceptance   DATETIME, 
      Manuscript_JournalBeiginingPageNumber INT, 
      Manuscript_Order_in_Journal   INT, 
      Manuscript_status_idmanuscript_status INT NOT NULL,
      last_status_change datetime not null default current_timestamp(),
      PRIMARY KEY (Manuscript_id), 
      FOREIGN KEY (Icode_icodeID) REFERENCES RICodes(icodeID),
      FOREIGN KEY (Journal_JournalEdition) REFERENCES Journal(Journal_edition), 
      FOREIGN KEY (Manuscript_Status_idmanuscript_status) REFERENCES Manuscript_status(idmanuscript_status)
      );

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


 -- DROP Table Author_order if exists and create a new table 'Author_order'. 
 
 DROP TABLE IF EXISTS Author_order; 
 
 CREATE TABLE Author_order
		( Manuscript_idManuscript		INT NOT NULL, 
          Author_idAuthor				INT NOT NULL, 
          author_order_num              INT NOT NULL,
          FOREIGN KEY (Manuscript_idManuscript) REFERENCES Manuscript(Manuscript_id), 
          FOREIGN KEY (Author_idAuthor) REFERENCES Author(Author_id), 
          PRIMARY KEY (Manuscript_idManuscript,Author_idAuthor)
          );

 -- Drop table Manuscript_Feedback if exists and create table named 'Manuscript_Feedback'
 
 DROP TABLE IF EXISTS Manuscript_Feedback;
 
 CREATE TABLE Manuscript_Feedback
 
     (
      idManuscript_Feedback INT NOT NULL auto_increment, 
      Manuscript_manuscript_id  INT NOT NULL, 
      Reviewer_reviewer_id INT NOT NULL,
      Appropriateness		INT CHECK( Appropriateness<=10) , 
      Clarity				INT CHECK( Clarity<=10), 
	  Methodology		INT CHECK (Methodology <=10),
      Experimental_results  INT CHECK(Experimental_results<=10),
      ManuscriptFeedback_ReceivedDate DATETIME, 
      Recommendation_status    VARCHAR(10) CHECK ( Recommendation_status in ('ACCEPT', 'REJECT')),
      Manuscript_total_score   INT as ((Appropriateness+Clarity+Methodology+Experimental_results)/4),
      FOREIGN KEY (Reviewer_reviewer_id) REFERENCES Reviewer(Reviewer_id), 
	  FOREIGN KEY (Manuscript_manuscript_id) REFERENCES Manuscript(Manuscript_id), 
      PRIMARY KEY (idManuscript_Feedback)
      );
  
ALTER TABLE Manuscript_Feedback 
add Manuscript_Assigned_time DATETIME NOT NULL DEFAULT current_timestamp(); 

ALTER TABLE Manuscript_Feedback ADD COLUMN Reviewer_status VARCHAR(10) DEFAULT "ACTIVE"; 


-- DROP Table Reviewer_interest if exists and create a table Reviewer_interest

DROP TABLE IF EXISTS Reviewer_interest; 

CREATE TABLE Reviewer_interest
		( Reviewer_ReviewerID		INT NOT NULL,
          RICodes_RICodesID			MEDIUMINT NOT NULL, 
          FOREIGN KEY (Reviewer_ReviewerID) REFERENCES Reviewer(Reviewer_id), 
          FOREIGN KEY (RICodes_RICodesID) REFERENCES RICodes(icodeID), 
          PRIMARY KEY (Reviewer_ReviewerID,RICodes_RICodesID)
          ); 
CREATE UNIQUE INDEX  ReviewerID_RICodesID ON Reviewer_interest (Reviewer_ReviewerID,RICodes_RICodesID); 
       



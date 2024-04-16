-- ------------------ INSERTING VALUES INTO Person Table ------------------------------------------------

-- 3 different triggers are created which automatically insert data in Editor, Author and Reviwer.
-- Data will be inserted into the respective table based on the 'Person_role' value 
-- from new data is inserted in Table 'Person'. If Person is 'author' it goes 
-- If there are multiple authors in a single manuscript, email of primary author is distrubeted among other authors. 

INSERT INTO Person (Person_role, Person_fname, Person_lname, Person_email, Person_affiliation) 
VALUES
("editor","Ashmita" , "Kunwar","ashmita.kunwar.gr@dart.edu", "Publication"),
("editor","Ed" , "Hausman","ed.haysman@dartsss.edu", "South western college"),
("author","Sean" , "Smith","ssmithhh@emailaddress.com22", "Dartmouth College"),
("reviewer","Parker" , "Phillip","pphilip@address.ghy", "Standford College"),
("author","Sunishka" , "Jain","sunishka.jain.gr@Dartmouth.edu", "Dartmouth College"),
("reviewer","James" , "Collins","Collinsemail12@emailid2.fg", "Texas tech University"),
("author","Sumit" , "Shrestha","Sumit.shresthadai@emailtechuni.er", "Oslo University"),
("author","Anustha" , "Mainali","Sumit.shresthadai@emailtechuni.er", "Oslo University"),
("reviewer","Aanvi" , "Karki","karkiaanvi@gshchaina.nnna", "Mothers Pride Academy"), 
("reviewer","Surendra", "KC", "surendrakarki@gmah.commm", "Cotiviti Private Limited"), 
("reviewer", "Neel","Gandhi","neelgandhiemail@nodoaminh.gsgs","Dartmouth College"),
("reviewer","Jack" , "Trump","jacktrump@hshshsh.c", "Trump Academy"), 
("reviewer","Srinkhala", "Khatiwada", "khatiwadhasjk@sns6.c", "Harvard"), 
("reviewer", "Alex","Danials","dshsskk@hhs.c","Princeton"),
("author","Jonathon","Mchenly","jjonamach@emi.usku", "Rochester Institute of Technology"), 
("author","Herrod", "Cummings", "herrodCummins@sns6.c", "Harvard"), 
("author", "Maya","Terrell","congue.turpis.in@protonmail.net","Meta"),
("author","Tyrone" , "England","jat@icloud.net", "Google"), 
("author","Shana", "Abbott", "imperdiet.erat@aol.org", "Harvard"), 
("author", "Scarlett","Kramer","venenatis.vel@icloud.com","Tesla"),
("author","Bryar" , "Hutchinson","cras.eu.tellus@yahoo.ca", "NASA"), 
("author","Lars", "Waller", "mattis@yahoo.edu", "Microsoft"), 
("author", "Warren","Burgess","vitae.erat@yahoo.couk","Princeton"),
("author","Palmer" , "Curtis","hendrerit@icloud.org", "MIT"), 
("author","Allistair", "Foster", "nascetur.ridiculus@yahoo.com", "Harvard"), 
("author", "Hyacinth","Cote","id@outlook.orgc","AIT Thailand"),
("author","Shelley","Kaufman","interdum@icloud.net","Meta"),
("author","Kane","Ramos","sed.facilisis.vitae@outlook.edu","Microsoft"),
("author","Regina","Murray","diam.nunc@outlook.couk","Harvard"),
("author","Maris","Higgins","non.bibendum@protonmail.ca","Oxford"),
("author","Martena","Becker","metus.eu.erat@hotmail.org","MIT"),
("author","Ronan","Koch","blandit.at@outlook.net","Apple"),
("author","Anjolie","Frederick","aenean.massa.integer@protonmail.com","Google"),
("author","Arden","Mcpherson","integer.tincidunt@google.org","Deerwalk"),
("author","Evelyn","Blanchard","praesent.eu@hotmail.org","Cedargate"),
("author","Deborah","Palmer","mi.duis.risus@outlook.ca","Reliance"),
("author","Caesar","Greer","cras.vehicula@outlook.couk","Ohio State University"),
("author","Tanner","Edwards","vitae.odio@google.ca","Tribhuvan University"),
("author","Hanae","Steele","non.hendrerit@google.com","University of Oslo"),
("author","Kylan","Conway","et.rutrum.non@icloud.org","Dartmouth"),
("author","Anthony","Schwartz","est.congue@yahoo.ca","Deerwalk Institute of Technology"),
("author","Abra","Lamb","in.ornare@icloud.com","gWell"),
("author","Cynthia","Fulton","velit@google.edu","Instride"),
("author","Gloria","Alvarado","mus.aenean@google.ca","MIT");

 Update Person  set Person_email = NULL where Person_id IN (5,15,17,19,20,22,26,39,40,41,43);
 
 

-- -----------------------------------INSERTING VALUES IN JOURNAL TABLE --------------------------------------------------------------------

-- Journal_status has two values 'Published' and 'Processing'.

INSERT INTO Journal 
(Journal_edition, Journal_pages, Published_year, Issue_number, Journal_status)
VALUES
('2021-1',120,2021,1,"Published"),
('2021-2',120,2021,2,"Published"),
('2021-3',90,2021,3,"Published"),
('2022-1',85,2022,1,"Processing"),
('2022-2',90,2022,2,"Processing");

-- Negative scenario to test CHECK constarint
-- the following insert query is for testing our CHECK that we have used to check Issue Number while inserting values.
-- Tried entering issue_number with 7  as a value and it is not inserted because we have 'CHECKED issue_number < =4 '.

INSERT INTO Journal 
(Journal_edition, Journal_pages, Published_year, Issue_number, Journal_status)
VALUES
('2021-3',90,2021,7,"Published");

-- 'Error Code: 3819. Error 'Check constraint 'Journal_chk_1' is violated' is seen on executing above insert command as expected. 

-- -------------------------------INSERT VALUES IN ICODES------------------------------------------------------------------------

INSERT INTO RICodes (icode_interest) VALUES
('Agricultural engineering'),
('Biochemical engineering'),
('Biomechanical engineering'),
('Ergonomics'),
('Food engineering'),
('Bioprocess engineering'),
('Genetic engineering'),
('Human genetic engineering'),
('Metabolic engineering'),
('Molecular engineering'),
('Neural engineering'),
('Protein engineering'),
('Rehabilitation engineering'),
('Tissue engineering'),
('Aquatic and environmental engineering'),
('Architectural engineering'),
('Civionic engineering'),
('Construction engineering'),
('Earthquake engineering'),
('Earth systems engineering and management'),
('Ecological engineering'),
('Environmental engineering'),
('Geomatics engineering'),
('Geotechnical engineering'),
('Highway engineering'),
('Hydraulic engineering'),
('Landscape engineering'),
('Land development engineering'),
('Pavement engineering'),
('Railway systems engineering'),
('River engineering'),
('Sanitary engineering'),
('Sewage engineering'),
('Structural engineering'),
('Surveying'),
('Traffic engineering'),
('Transportation engineering'),
('Urban engineering'),
('Irrigation and agriculture engineering'),
('Explosives engineering'),
('Biomolecular engineering'),
('Ceramics engineering'),
('Broadcast engineering'),
('Building engineering'),
('Signal Processing'),
('Computer engineering'),
('Power systems engineering'),
('Control engineering'),
('Telecommunications engineering'),
('Electronic engineering'),
('Instrumentation engineering'),
('Network engineering'),
('Neuromorphic engineering'),
('Engineering Technology'),
('Integrated engineering'),
('Value engineering'),
('Cost engineering'),
('Fire protection engineering'),
('Domain engineering'),
('Engineering economics'),
('Engineering management'),
('Engineering psychology'),
('Ergonomics'),
('Facilities Engineering'),
('Logistic engineering'),
('Model-driven engineering'),
('Performance engineering'),
('Process engineering'),
('Product Family Engineering'),
('Quality engineering'),
('Reliability engineering'),
('Safety engineering'),
('Security engineering'),
('Support engineering'),
('Systems engineering'),
('Metallurgical Engineering'),
('Surface Engineering'),
('Biomaterials Engineering'),
('Crystal Engineering'),
('Amorphous Metals'),
('Metal Forming'),
('Ceramic Engineering'),
('Plastics Engineering'),
('Forensic Materials Engineering'),
('Composite Materials'),
('Casting'),
('Electronic Materials'),
('Nano materials'),
('Corrosion Engineering'),
('Vitreous Materials'),
('Welding'),
('Acoustical engineering'),
('Aerospace engineering'),
('Audio engineering'),
('Automotive engineering'),
('Building services engineering'),
('Earthquake engineering'),
('Forensic engineering'),
('Marine engineering'),
('Mechatronics'),
('Nanoengineering'),
('Naval architecture'),
('Sports engineering'),
('Structural engineering'),
('Vacuum engineering'),
('Military engineering'),
('Combat engineering'),
('Offshore engineering'),
('Optical engineering'),
('Geophysical engineering'),
('Mineral engineering'),
('Mining engineering'),
('Reservoir engineering'),
('Climate engineering'),
('Computer-aided engineering'),
('Cryptographic engineering'),
('Information engineering'),
('Knowledge engineering'),
('Language engineering'),
('Release engineering'),
('Teletraffic engineering'),
('Usability engineering'),
('Web engineering'),
('Systems engineering');




-- --------------------------------------INSERT VALUES INTO Manuscript_status-----------------------------------------------------------



insert into Manuscript_status
( Manuscript_status )
values 
('Received'), 
('Rejected'), 
('Under Review'),
('Reviewed'),
('Accepted'),
('Typesetting'),
('Ready'),
('Scheduled'),
('Published'); 


-- --------------------------------INSERT VALUES INTO Manuscript Table-----------------------------------------------------------------




-- We created a CSV file named 'Manuscript_data', which is provided in the zip file. We uploaded that file 
--  via 'Table data import Wizard'
-- Right Click Tables >> Table data import Wizard >> Browse Manuscript_dat.csv file from your system >>
-- Next >> Use existing table (Choose  'Manuscript' from drop down) >> Next >> uplaod ( it takes sometime)

      INSERT INTO  Manuscript
      (
      Icode_icodeID,Manuscript_title,Manuscript_DateReceiced,Journal_JournalEdition, Manuscript_DateOfAcceptance, 
      Manuscript_JournalBeiginingPageNumber,Manuscript_Order_in_Journal,
      Manuscript_status_idmanuscript_status)
      values
      (89,'Manuscript for Testing','2021-07-02 12:00:01','2022-2','2021-12-12 03:56:22',14,2,8); 
      
      
      

-- --------------------------------INSERT VALUES INTO Reviewer_interest Table----------------------------------------------------


INSERT INTO Reviewer_interest
(Reviewer_ReviewerID,RICodes_RICodesID)
VALUES
(1,1), (1,5),(1,72), 
(2,5),(2,12),(2,7),
(3,21),(3,41),(3,45),
(4,72),(4,21),(4,12), 
(5,19),(5,76),(5,40),
(6,9),(6,25),(6,32),
(7,17),(7,18),(7,20),
(8,76); 


-- --------------------------------INSERT VALUES INTO Author_order Table----------------------------------------------------



INSERT  INTO Author_order
( Manuscript_idManuscript, Author_idAuthor, author_order_num )
VALUES 
        (1,1,1),(1,2,2),(2,7,1),(3,3,1),(4,3,2),(4,4,1),(4,5,3),
        (5,6,1),(5,1,2),(6,8,1),(6,9,2),(6,10,3),(7,11,1),(7,12,2),(8,13,1),
        (8,12,2),(9,14,1),(10,15,1),(10,16,2),(11,17,1),(12,18,1),(13,19,1),
        (14,20,1),(15,21,1),(16,22,1),(17,23,1),(18,24,1),(19,25,1),(20,26,1), 
        (21,27,1),(21,30,2),(22,28,1),(22,29,2),(22,31,3),(23,32,1),(23,33,2);
        
        

-- ----------------------------------------Manuscript_Feedback----------------------------------------------------------

-- Imported the CSV file 'Manuscript_Feedback_data.csv' using Table data Import Wizard, like that of Manuscript. 
-- Need to follow the same steps. 

 INSERT INTO Manuscript_Feedback
      (Manuscript_manuscript_id, Reviewer_reviewer_id, Appropriateness,Clarity,Methodology,
      Experimental_results,ManuscriptFeedback_ReceivedDate,Recommendation_status)
      values
      (1,1,10,10,10,10,"2021-02-25 8:23:45", "REJECT"); 






  




 










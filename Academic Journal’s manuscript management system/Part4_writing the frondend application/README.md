
## Table of Content
1. Tables.sql 
2. insert.sql
3. views.sql
4. triggersetup.sql
4. triggers.sql
5. triggertest.sql
6. function.sql
7. functionstest.sql
8. ExtraTriggers.sql

Order of Execution >> Tables.sql >> Insert.sql >> triggers.sql >> triggerstest.sql >> views.sql >>function.sql >> functiontest.sql 

ExtraTriggers.sql >> This contains extra triggers that were created while working on data insertion in the table.These tables are already included in Tables.sql Query tab -- Please run those on the same sequence in which they are placed.

CSV Upload : Please make sure to upload 'Manuscript_data.csv' and 'Manuscript\_Feedback\_data.csv' for Manuscript and Manuscript_Feedback table. 

### Tables.sql 
  There are all together 11 tables created here. 

 1. Person : Table Where all the demographic information of Editor, Author and Reviewer are stored. There is a person_role attribute which differntiate their role. 
 2. Editor : Editors detail. 
 3. Reviewer : Reviewer detail.
 4. Author : Author detail 
 5. RICodes : ICodes detail
 6. Manuscript*_*status :Create a separate table for storing the diferent status which Manuscript are assigned with. All together there are 9 Manuscript_status stored.
 7. Manuscript : Deatils about Manuscript 
 8. Author_order : Since Manuscript has multiple Authors, so to store their order, a separate table is created.
 9. Manuscript*_*Feedback: Table to store all the Feedbacks from reviewers. 
 10. Reviewer_interest: To track the reviewer interest using RICodes. 
 11. RICodes : Table where all the Intrest code are stored and used by the system.


**CHECK** 
CHECK has been implemented in different tables to ensure only valid information is inserted into the data. For example, Issue number of Journal should be 1,2,3 and 4, if any other are inserted that is rejected. Similairy, score for each category from reviewers should not be greater than 10. And it has been implemented in multiple places. 

### Insert.sql 

 1. Person Table Data : All the data were inserted using the SQl insert command. Person table stores the information of Editor, Reviewer and Author. 

 2. Editor: When data is entered into a Person table with Person_role = 'editor', respective Person_id and Editor_id automatically gets insert Editor table. This automation is performed by a trigger 'After\_Person\_Insert\_Role\_Editor'

 3. Reviewer: Same like Editor, Trigger **'After\_Person\_Insert\_Role\_Reviewer'** automatically inserts data into Editor table when Person with 'reviewer' role is entered in Person table. 

 4. Author : Same as Editor and Reviewer. Trigger 'After\_Person\_Insert\_Role\_Author'

 5. RICodes: Used the same one provided in the website. 

 6. Manuscript_status : We have altogether 9 status  in a sequence as Received >> Rejcted >> Under Review >> Reviewed >> Accepted >> Typesetting >> Scheduled >> Published

 7. Manuscript : We created data and stored in CSV, which was imported using 'Table data Import Wizard'. Data file which we have used is attached here with name 'Manuscript_data.csv' Steps : Cick on 'Tables' >> Table data Import Wizard >> Browse (from your local machine) >> Use existing table (i.e Manuscript), check 'Truncate before update' >> Next.This file has to be uploaded before inserting data into Author\_order table.
 last_status_change field track the latest time when status has been updated in that Manuscript. This is automated by trigger.  

 8. Author_order : It acts as the bridge table between Author and Manuscript, also maintains the author_order. Tada are imported manually but as per the data of Manuscript, RICodes and Author information from above tables. 

 9. Manuscript_Feedback: Stores all the feedbacks from the reviewers. Average is stored in Manuscript_total_score, which is the average of 4 different scores and is derived value. Imported the CSV file 'Manuscript\_Feedback\_data.csv' using Table data Import Wizard, like that of Manuscript.  Use existing Manuscript_Feedback  table. 

 10. Reviewer_interest : Store interest of reviewer in the form of RICodes. Reviewer can have only one or max 3 codes assigned. 


## views.sql 

 All the views are included in this document. 


## triggers.sql

3 triggers are included in this document. 

## triggertest.sql 
Can use those sql commands to test. 

## function.sql

Sql query to create the given function is included here. 


## functionstest.sql
SQL Command to test the function are included here. 

## ExtraTriggers.sql
 4 different triggers are created and included. These 4 commands must be triggered after the table creation and before data insert. To be on the safer side I have placed all of these Triggers in tables.sql and Insert.sql query tab, so they don't miss out. 

















# Team 12 Lab 2D

Lab 2-D is about building a Python application that can interact with the database.


# Files

1.  Tables.sql
2.  insert.sql
3.  views.sql
4.  triggersetup.sql
5.  triggers.sql
6.  triggertest.sql
7.  function.sql
8.  functionstest.sql
9.  ExtraTriggers.sql
10. assignment.py
11. dbconfig.py
12. query.py
13. Team12Lab2.ini
14.  userconfig.ini



## File Description

The sql files are from the previous submission and contain the SQL queries for making the tables and adding information, triggers, functions and views. There are some test files as well which test these functionalities.
Apart from these sql files, we have Python files which are needed to interact with the database. 

 - The file '**Team12Lab2.ini**' contains the credentials of the database and the user for which the database exists. From the two group members' database, one has been used for development and testing while the other has been used for the purpose of display/deployment(not applicable in this case).
 - The file '**userconfig.ini**' stores the information about the current user including the *user_id which refers to the Person_id* and user_type *which refers to the role of the user* who is logged in.  
 - The execution commands are entered as parameter for the '**assignment.py**'. Each command requires running the script again. This is done to maintain history of the commands entered.
 - The file named '**query.py**' contains some helper functions for assignment.py. The tester can look into it but it does't contain a driver function as the funcitons are called from the other file.


# Execution

As mentioned earlier, only the assignment.py script is executed along with the parameters. Some sample commands are mentioned in the following section.

## Example commands

    >> python3 assignment.py register editor sunishka jain
 >> This command will create a user with role type as editor and display the user/person id for the newly created user.    

    >> python3 assignment.py login <user_id>
 >> This command will login as a user with the given id. This id can be whatever user is present in the database (eg: 104). The data is displayed according to the role.
 
 
    >> python3 assignment.py status
>> This command will show the details for all the manuscripts sorted by status and then manuscript id.
 
 

    >> python3 assignment.py assign <manuscriptid> <reviewer_id>
>> This command will enable a logged in editor to assign a reviewer to a manuscript for review

	>> python3 assignment.py reject <manuscriptid>
>> This command will enable a logged in editor to reject a manuscript


	>> python3 assignment.py accept <manuscriptid>
>> This command will enable a logged in editor to accept a manuscript after 3 reviews

	>> python3 assignment.py schedule <manuscriptid> <issue>
>> This command will enable a logged in editor to assign a manuscript to an issue in a journal which is yet to be published

	>> python3 assignment.py publish <issue>
>> This command will enable a logged in editor to assign a manuscript to an issue in a journal which is yet to be published

	>> python3 assignment.py reset
>> This command will enable a logged in editor to reset the database, i.e., empty all tables to their initial state before any entries were made

	>> python3 assignment.py reject <manuscriptid> <ascore> <cscore> <mscore> <escore>
>> This command will enable a logged in reviewer to reject a manuscript and provide the ACME scores justifying the reviewer's judgement

	>> python3 assignment.py accept <manuscriptid> <ascore> <cscore> <mscore> <escore>
>> This command will enable a logged in reviewer to accept a manuscript and provide the ACME scores justifying the reviewer's judgement

	>> python3 assignment.py resign
>> This command will enable a logged in reviewer to resign

	>> python3 assignment.py submit <title> <Affiliation> <ICode> <author2> <author3> <author4> <filename>
	Here: We have used Author ID instead of Author name Example : python assignment.py submit finaltestingTitle DWIT 12 83 84 85 LASTFILENAME
>> This command will enable a logged in author to submit a manuscript alongwith some information including the manuscript title, author’s current affiliation (a string), ICode representing the subject area, optional additional authors( we have used Author ID instead of author names), and the document itself. 

	>> python3 assignment.py status
>> This command will enable a logged in author to check the status of the submitted manuscript

---

Following are the USER ID’s for Editor, Author and Reviewer with data. 

For Editor : 
user ID number : 2
python assignment.py login 2


For Author :
User ID : 35
python assignment.py login 35

for Reviewer : 
User ID : 4
python assignment.py login 4
Please let us know if you have any questions regarding the implementation.


### Thank You!

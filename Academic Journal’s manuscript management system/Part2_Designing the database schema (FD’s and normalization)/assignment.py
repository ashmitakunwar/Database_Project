from mysql.connector import MySQLConnection, Error, errorcode, FieldType
from dbconfig import read_db_config
import getpass
import mysql
import sys
import argparse
from configparser import ConfigParser
from query import query, get_statuses
import pandas as pd
import datetime

userconfig = ConfigParser()
logged_in_user_type = None
logged_in_user_id = None


def mysql_connection():
    dbconfig = read_db_config()
    if dbconfig['password'] == "":  
        dbconfig['password'] = getpass.getpass("database password ? :")
    
    # print(dbconfig)
    mycursor = None

    # Connect to the database
    try:
        # print('Connecting to MySQL database...')
        conn = MySQLConnection(**dbconfig)
        if conn.is_connected():
            print('connection established.')
            mycursor = conn.cursor(buffered=True)
        else:
            print('connection failed.')

    except mysql.connector.Error as err:
        print('connection failed somehow')
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print("Unexpected error")
            print(err)
            sys.exit(1)

    return mycursor, conn


def read_user():
    global logged_in_user_type
    global logged_in_user_id
    userconfig.read('userconfig.ini') 
    user_id = userconfig.get("User","id") 
    user_type = userconfig.get("User", "user_type")
    # print("user_id", user_id)
    # print("user_type", user_type)
    if not str(user_type) in ["editor", "reviewer", "author"]:
        logged_in_user_type = None
        logged_in_user_id = None
    else:
        logged_in_user_type = str(user_type)
        logged_in_user_id = int(user_id)


def record_user(user_type=None, user_id=None):
    from pathlib import Path
    userconfig_file = Path('userconfig.ini')  #Path of your .ini file
    userconfig.read(userconfig_file)
    userconfig.set('User', 'id', str(user_id)) #Updating existing entry 
    userconfig.set('User', 'user_type', user_type) #Writing new entry
    userconfig.write(userconfig_file.open("w"))


def submit(title, affiliation, icode, filename, author_2=None, author_3=None, author_4=None):
    cursor, conn = mysql_connection()
    current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        query = (
            "insert into Manuscript(Icode_icodeID, Manuscript_title, Manuscript_DateReceiced, Manuscript_status_idmanuscript_status ) VALUES ('{}','{}','{}','{}');").format(
            icode, title, current_date, 1)
        # print("-->",query,"<--", end='')
        cursor.execute(query)
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        print("Thank you for submitting your Manuscript. Your Manuscript id is: ", cursor.lastrowid)
        manuscript_id = cursor.lastrowid
    conn.commit()

    try:
        # query = ("insert into Author_order (Manuscript_idManuscript, Author_idAuthor, author_order_num ) VALUES ('{}','{}','{}');").format(manuscript_id,logged_in_user_id, 1)
        query = ("select Author_id from Author where Person_id=" + str(logged_in_user_id))
        # print("-->",query,"<--", end='')
        cursor.execute(query)
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        primary_author_id = cursor.fetchone()[0]

    try:
        query = (
            "insert into Author_order (Manuscript_idManuscript, Author_idAuthor, author_order_num ) VALUES ('{}','{}','{}');").format(
            manuscript_id, primary_author_id, 1)
        # print("-->",query,"<--", end='')
        cursor.execute(query)
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        print("Primary Author has been added")
    conn.commit()

    if author_2 is not None:
        try:
            query = (
                "insert into Author_order (Manuscript_idManuscript, Author_idAuthor, author_order_num ) VALUES ('{}','{}','{}');").format(
                manuscript_id, author_2, 2)

            cursor.execute(query)

        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Second Author has been added.")
        conn.commit()

    if author_3 is not None:
        try:
            query = (
                "insert into Author_order (Manuscript_idManuscript, Author_idAuthor, author_order_num ) VALUES ('{}','{}','{}');").format(
                manuscript_id, author_3, 3)

            cursor.execute(query)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Third Author has been added")
        conn.commit()

    if author_4 is not None:
        try:
            query = (
                "insert into Author_order (Manuscript_idManuscript, Author_idAuthor, author_order_num ) VALUES ('{}','{}','{}');").format(
                manuscript_id, author_4, 3)

            cursor.execute(query)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Fourth Author has been added")

        conn.commit()
    cursor.close()
    conn.cmd_reset_connection()
    conn.close()


def assign(manuscript_id, reviewer_id):
    current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    query("""UPDATE Manuscript SET Manuscript_status_idmanuscript_status=3, last_status_change=%s 
          WHERE Manuscript_id=%s""", (current_date, manuscript_id), isUpdate=True)
    query("""UPDATE Manuscript_Feedback SET Reviewer_reviewer_id=%s WHERE Manuscript_manuscript_id=%s""",
          (reviewer_id, manuscript_id), isUpdate=True)


def get_status(user_type, user_id):
    cursor, conn = mysql_connection()
    statuses = get_statuses()

    if user_type == "author":
        try:
            cursor.execute(
                "Select Person_fname, Person_lname, Person_email  from Person where Person_id = " + str(user_id))
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            columns = [column[0] for column in cursor.description]
            results = []
            results.append(dict(zip(columns, cursor.fetchone())))
            Person_fname = results[0]['Person_fname']
            Person_lname = results[0]['Person_lname']
            Person_email = results[0]['Person_email']
            # Manuscript_status = results[0]['Manuscript_status']

            print("Hello " + str(Person_fname) + "  " + str(Person_lname) + "!\n")

        try:
            # query = "INSERT INTO `Person` (`Person_fname`,`Person_lname`, `Person_email`, `Person_affiliation`, `Person_role`) VALUES ('{}','{}', '{}', '{}', '{}');".format(fname, lname, email, affiliation, user_type)
            # # print("-->",query,"<--", end='')
            cursor.execute("Select Author_id from Author where Person_id = " + str(user_id))
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            # print("Thank you for registering. Your userid is: ", cursor.lastrowid)
            Author_id = cursor.fetchone()[0]
            # print("welcome" + str(Author_id))

        try:
            cursor.execute("Select Manuscript_status from WelcomeAuthor where Author_id= " + str(Author_id))
            # print("Rowcount:", cursor.rowcount)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            rowcount = cursor.rowcount
            # print(rowcount)
            if rowcount == 0:
                print("You haven't submitted any manuscript yet")
            else:
                columns = [column[0] for column in cursor.description]
                results = []
                for row in cursor.fetchall():
                    results.append(row[0])
                print("Your manuscript status:")
                print("Submitted: ", results.count("Received"), ", Under Review: ", results.count("Under Review"),
                      ", Reviewed: ", results.count("Reviewed"),
                      ", Rejected: ", results.count("Rejected"), ", Accepted: ", results.count("Accepted"),
                      ", In Typesetting: ", results.count("Typesetting"),
                      ", Ready: ", results.count("Ready"), ", Scheduled for publication: ", results.count("Scheduled"),
                      ", Published: ", results.count("Published"))
                # print("Status of your Manuscript is: "+ manuscript_status)

        cursor.close()
        conn.cmd_reset_connection()
        conn.close()

    elif user_type == "reviewer":
        rev = query("Select Reviewer_id from Reviewer where Person_id = " + str(user_id))
        Reviewer_id = rev[0][0]
        # print(Reviewer_id)

        ress = query("SELECT Person_fname, Person_lname FROM Person WHERE Person_id = " + str(user_id))
        # print(ress)
        Person_fname = ress[0][0]
        Person_lname = ress[0][1]

        results = query("SELECT Manuscript_manuscript_id FROM Manuscript_Feedback WHERE Reviewer_reviewer_id = " +
                       str(Reviewer_id))
        # print("Here",results)
        df = pd.DataFrame()
        for row in results:
            # print(row)
            if row is not None:
                manuscript_id = row[0]
                # print(manuscript_id)
                results = query("Select Manuscript_title, Manuscript_status_idmanuscript_status from Manuscript where Manuscript_id=" + str(manuscript_id))
                # print(results)
                df2 = pd.DataFrame({'Manuscript_Id': manuscript_id, 'Title': results[0][0], 'StatusNUM': results[0][1],
                                    'Status': statuses.loc[statuses['Status'] == results[0][1], 'Name'].iloc[0]},
                                   index=[0])
                df = pd.concat([df, df2], ignore_index=True)
                df.reset_index()

        print("Hello " + str(Person_fname) + " " + str(Person_lname))
        print("Here is a list of manuscripts for you:")
        try:
            df = df.sort_values(by=['StatusNUM', 'Manuscript_Id'], axis=0, ascending=[True, True],
                                kind='quicksort', ignore_index=True, key=None)
            df = df.drop('StatusNUM', axis=1)
            print(df)
        except:
            print("You have no manuscript assigned.")

    else:
        results = query("SELECT Editor_id FROM Editor WHERE Person_id = " + str(user_id))
        editor_id = results[0][0]
        results = query("SELECT Person_fname, Person_lname FROM Person WHERE Person_id = "+ str(user_id))
        Person_fname = results[0][0]
        Person_lname = results[0][1]

        results = query("SELECT Manuscript_id, Manuscript_title, Manuscript_status_idmanuscript_status FROM Manuscript")
        df = pd.DataFrame(results, columns=["Manuscript_Id", "Manuscript_Title", "Status"])
        df["Manuscript_Status"] = df.apply(lambda row: statuses.loc[statuses['Status'] == row.Status, 'Name'].iloc[0],
                                           axis=1)
        df = df.sort_values(by=['Status', 'Manuscript_Id'], axis=0, ascending=[True, True],
                            kind='quicksort', ignore_index=True, key=None)
        df = df.drop('Status', axis=1)
        print("Hello " + str(Person_fname) + " " + str(Person_lname))
        print("Here is a list of all manuscripts in the database")
        print(df)

    cursor.close()
    conn.cmd_reset_connection()
    conn.close()

    pass # if editor: lists all manuscripts by all authors in the system sorted by status and then manuscript 
    pass # if author: produces a report of all the author’s manuscripts currently in the system where they is the primary author. The most recent status timestamp is kept and reported.


def login(user_id):
    # print("Logging in", user_id)
    cursor, conn = mysql_connection()
  
    try:
        cursor.execute("Select Person_role from Person where Person_id = " + str(user_id))
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        Person_role = cursor.fetchone()[0]
    
    cursor.close()
    conn.cmd_reset_connection()
    conn.close()


    record_user(Person_role, user_id)
    read_user() # to update the current login variables (logged_in_user_type, logged_in_user_id)
    get_status(Person_role, user_id)


def reject(manuscript_id, ascore=0, cscore=0, mscore=0, escore=0):
    if logged_in_user_type == "editor":
        current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        results = query("""UPDATE Manuscript SET Manuscript_status_idmanuscript_status=2, last_status_change=%s 
                  WHERE Manuscript_id=%s""", (current_date, manuscript_id), isUpdate=True)
        print(results)

    elif logged_in_user_type == "reviewer":
        results = query(
            """UPDATE Manuscript_Feedback SET Recommendation_status='REJECT', Appropriateness=%s, Clarity=%s, 
            Methodolody=%s, Experimental_results=%s WHERE Manuscript_manuscript_id=%s""",
            (ascore, cscore, mscore, escore, manuscript_id), isUpdate=True)
        print(results)

    else:
        print("You don't have authorization.")
    print("rejecting manuscript check")
    pass


def accept(manuscript_id, ascore=0, cscore=0, mscore=0, escore=0):
    if logged_in_user_type == "editor":
        current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        results = query("""UPDATE Manuscript SET Manuscript_status_idmanuscript_status=5, last_status_change=%s 
                          WHERE Manuscript_id=%s""", (current_date, manuscript_id), isUpdate=True)
        print(results)

    elif logged_in_user_type == "reviewer":
        results = query(
            """UPDATE Manuscript_Feedback SET Recommendation_status='ACCEPT', Appropriateness=%s, Clarity=%s, 
            Methodolody=%s, Experimental_results=%s WHERE Manuscript_manuscript_id=%s""",
            (ascore, cscore, mscore, escore, manuscript_id), isUpdate=True)
        print(results)
    else:
        print("You don't have authorization.")
    print("accepting manuscript check")
    pass


def schedule(manuscript_id, issue):
    results = query("""SELECT * FROM Manuscript WHERE Manuscript_id=%s""", tuple(manuscript_id))
    manuscript_status = results[0][8]
    manuscript_title = results[0][2]
    results = query("SELECT Journal_pages FROM Journal WHERE Journal_edition=%(iss_no)s", { 'iss_no': str(issue) })
    journal_pages = results[0][0]

    if manuscript_status == 7 and journal_pages < 100:
        query("""UPDATE Manuscript SET Manuscript_status_idmanuscript_status=8, Journal_JournalEdition=%s 
                       WHERE Manuscript_id=%s""", (str(issue), manuscript_id), isUpdate=True)
        print("Manuscript " + manuscript_title + " moved to scheduled state")

    elif manuscript_status == 7 and journal_pages >= 100:
        print("Manuscript cannot be added to this edition as the numbers of pages in the edition is exceeding 100!")

    else:
        print("Manuscript is not in ready state yet!")


def publish(issue):
    current_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    results = query("SELECT Manuscript_id, Manuscript_title, Manuscript_status_idmanuscript_status, last_status_change FROM Manuscript WHERE Journal_JournalEdition=%(iss_no)s",
                    {'iss_no': str(issue)})

    for each_result in results:
        if each_result[2] == 8:
            query("""UPDATE Manuscript SET last_status_change=%s, Manuscript_status_idmanuscript_status=9 
                                   WHERE Manuscript_id=%s""", (current_date, each_result[0]), isUpdate=True)
            print("Manuscript " + each_result[1] + " moved to published state")


def resign():
    read_user()
    result = query("Select Reviewer_id from Reviewer where Person_id=%(u_id)s", {'u_id': str(logged_in_user_id)})
    reviewer_id = result[0][0]
    query("DELETE FROM Manuscript_Feedback where Reviewer_reviewer_id=%(u_id)s",
          {'u_id': str(reviewer_id)}, isUpdate=True)
    query("DELETE FROM Manuscript_Feedback1 where Reviewer_reviewer_id=%(u_id)s",
          {'u_id': str(reviewer_id)}, isUpdate=True)
    query("DELETE FROM Reviewer_interest where Reviewer_ReviewerID=%(u_id)s",
          {'u_id': str(reviewer_id)}, isUpdate=True)
    query("DELETE FROM Reviewer where Person_id=%(u_id)s", {'u_id': str(logged_in_user_id)}, isUpdate=True)
    print("Thank you for your service.")


def reset():
    fd = open('Tables.sql', 'r')
    sqlFile = fd.read()
    fd.close()
    sqlCommands = sqlFile.split(';')

    for command in sqlCommands:
        if command.strip() != '':
            query(command, isUpdate=True)

    print("Database has been reset!")

def register(user_type=None, fname=None, lname=None, email=None, affiliation=None, icode_1=None, icode_2=None, icode_3=None):
    cursor, conn = mysql_connection()
    if user_type == "author":
        try:
            query = "INSERT INTO `Person` (`Person_fname`,`Person_lname`, `Person_email`, `Person_affiliation`, `Person_role`) VALUES ('{}','{}', '{}', '{}', '{}');".format(fname, lname, email, affiliation, user_type)
            # print("-->",query,"<--", end='')
            cursor.execute(query)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Thank you for registering. Your userid is: ", cursor.lastrowid)
        conn.commit()
        cursor.close()
        conn.cmd_reset_connection()
        conn.close()
    elif user_type == "reviewer":
        try:
            query = "INSERT INTO `Person` (`Person_fname`,`Person_lname`, `Person_email`, `Person_affiliation`, `Person_role`) VALUES ('{}','{}', '{}', '{}', '{}');".format(fname, lname, email, affiliation, user_type)
            # print("-->",query,"<--", end='')
            cursor.execute(query)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Thank you for registering. Your userid is: ", cursor.lastrowid)
            reviewer_id = cursor.lastrowid
        conn.commit()
        
        # SELECT FROM reviewer
        try:
            cursor.execute("Select Reviewer_id from Reviewer where Person_id = " + str(reviewer_id))
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            # print("Thank you for registering. Your userid is: ", cursor.lastrowid)
            myresult = cursor.fetchone()[0]


        # pass # insert into reviewer table: fname, lname
        if icode_1 is not None:
            # print(icode_1)
            try:
                query = "INSERT INTO Reviewer_interest (Reviewer_ReviewerID, RICodes_RICodesID) VALUES ( '{}','{}');".format(myresult, icode_1);
                cursor.execute(query)
            except mysql.connector.Error as err:
                print(err.msg)
            else:
                print("Inserted icode_1")
            conn.commit()
      
        if icode_2 is not None:
             print(icode_2)
             try:
                query = "INSERT INTO Reviewer_interest (Reviewer_ReviewerID, RICodes_RICodesID) VALUES ( '{}','{}');".format(myresult, icode_2);
                cursor.execute(query)
             except mysql.connector.Error as err:
                print(err.msg)
             else:
                print("Inserted icode_2")
             conn.commit()

        if icode_3 is not None:
             try:
                query = "INSERT INTO Reviewer_interest (Reviewer_ReviewerID, RICodes_RICodesID) VALUES ( '{}','{}');".format(myresult, icode_3);
                cursor.execute(query)
             except mysql.connector.Error as err:
                print(err.msg)
             else:
                print("Inserted icode_3")
             conn.commit()
           
        cursor.close()
        conn.cmd_reset_connection()
        conn.close()

    else:
        try:
            query = "INSERT INTO `Person` (`Person_fname`,`Person_lname`, `Person_email`, `Person_affiliation`, `Person_role`) VALUES ('{}','{}', '{}', '{}', '{}');".format(fname, lname, email, affiliation, user_type)
            # print("-->",query,"<--", end='')
            cursor.execute(query)
        except mysql.connector.Error as err:
            print(err.msg)
        else:
            print("Thank you for registering. Your userid is: ", cursor.lastrowid)
        conn.commit()
        cursor.close()
        conn.cmd_reset_connection()
        conn.close()
        

if __name__ == '__main__':
    read_user()
    input_command = len(sys.argv) - 1
    if input_command >=1:
        parsed_command = sys.argv[1].lower()
        if parsed_command == "register":
            if sys.argv[2].lower() == "author":
                try:
                    fname = sys.argv[3].lower()
                    lname = sys.argv[4].lower()
                    email = sys.argv[5].lower()
                    affiliation = sys.argv[6].lower()
                except:
                    print("Error - please enter fname, lname, email and affiliation separated by a space.")
                    sys.exit(0)
                register("author", fname, lname, email, affiliation)
            elif sys.argv[2].lower() == "editor":
                try:
                    fname = sys.argv[3].lower()
                    lname = sys.argv[4].lower()
                except:
                    print("Error - missing first name and/or last name for editor.")
                    sys.exit(0)
                register("editor", fname, lname)
            elif sys.argv[2].lower() == "reviewer":
                icode_1 = None
                icode_2 = None
                icode_3 = None
                try:
                    fname = sys.argv[3].lower()
                    lname = sys.argv[4].lower()
                except:
                    print("Error - missing first name and/or last name for the reviewer.")
                    sys.exit(0)
                if input_command == 5:
                    icode_1 = sys.argv[5].lower()
                elif input_command == 6:
                    icode_1 = sys.argv[5].lower()
                    icode_2 = sys.argv[6].lower()
                elif input_command == 7:
                    icode_1 = sys.argv[5].lower()
                    icode_2 = sys.argv[6].lower()
                    icode_3 = sys.argv[7].lower()
                else:
                    print("Error - please enter 1 to 3 ICodes.")
                    sys.exit(0)
                register("reviewer", fname=fname, lname=lname, icode_1=icode_1, icode_2=icode_2, icode_3=icode_3)

        elif parsed_command == "login":
            try:
                user_id = sys.argv[2].lower()
            except:
                print("Error -- missing user id.")
                sys.exit(0)
            login(user_id)
        elif parsed_command == "status":
            if logged_in_user_type == "author" or logged_in_user_type == "editor":
                get_status(logged_in_user_type, logged_in_user_id)
            else:
                print("Please login as an editor or author.")
                sys.exit(0)

        elif parsed_command == "submit":
            if logged_in_user_type == "author":
                author_2 = None
                author_3 = None
                author_4 = None
                if input_command >= 5:
                    try:
                        title = sys.argv[2].lower()
                        affiliation = sys.argv[3].lower()
                        icode = sys.argv[4].lower()
                        filename = sys.argv[-1].lower()
                        total_coauthors = input_command - 5
                    except:
                        print("Error - missing information.")
                        sys.exit(0)
                else:
                    print("Error - missing information.")
                    sys.exit(0)
                if total_coauthors == 1:
                    author_2 = sys.argv[5].lower()
                elif total_coauthors == 2:
                    author_2 = sys.argv[5].lower()
                    author_3 = sys.argv[6].lower()
                elif total_coauthors == 3:
                    author_2 = sys.argv[5].lower()
                    author_3 = sys.argv[6].lower()
                    author_4 = sys.argv[7].lower()
                #print(title, affiliation, icode, filename, author_2, author_3, author_4, total_coauthors)
                submit(title, affiliation, icode, filename, author_2, author_3, author_4)
            else:
                print("Please login as an author.")
                sys.exit(0)

        elif parsed_command == "assign":
            if logged_in_user_type == "editor":
                try:
                    manuscript_id = sys.argv[2].lower()
                    reviewer_id = sys.argv[3].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                assign(manuscript_id, reviewer_id)
            else:
                print("Please login as an editor or author.")
                sys.exit(0)

        elif parsed_command == "reject":
            if logged_in_user_type == "editor":
                try:
                    manuscript_id = sys.argv[2].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                reject(manuscript_id)
            elif logged_in_user_type == "reviewer":
                try:
                    manuscript_id = sys.argv[2].lower()
                    ascore = sys.argv[3].lower()
                    cscore = sys.argv[4].lower()
                    mscore = sys.argv[5].lower()
                    escore = sys.argv[6].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                reject(manuscript_id, ascore, cscore, mscore, escore)
            else:
                print("Please login as an editor or reviewer.")
                sys.exit(0)

        elif parsed_command == "accept":
            if logged_in_user_type == "editor":
                try:
                    manuscript_id = sys.argv[2].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                accept(manuscript_id)
            elif logged_in_user_type == "reviewer":
                try:
                    manuscript_id = sys.argv[2].lower()
                    ascore = sys.argv[3].lower()
                    cscore = sys.argv[4].lower()
                    mscore = sys.argv[5].lower()
                    escore = sys.argv[6].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                accept(manuscript_id, ascore, cscore, mscore, escore)
            else:
                print("Please login as an editor or reviewer.")
                sys.exit(0)
                
        elif parsed_command == "schedule":
            if logged_in_user_type == "editor":
                try:
                    manuscript_id = sys.argv[2].lower()
                    issue = sys.argv[3].lower()
                except:
                    print("Error - missing information.")
                    sys.exit(0)
                schedule(manuscript_id, issue)
            else:
                print("Please login as an editor or reviewer.")
                sys.exit(0)

        elif parsed_command == "reset":
            if logged_in_user_type == "editor":
                reset()
            else:
                print("Please login as an editor.")
                sys.exit(0)

        elif parsed_command == "publish":
            if logged_in_user_type == "editor":
                try:
                    issue = sys.argv[2].lower()
                except:
                    print("Error - please enter the issue to publish.")
                publish(issue)
            else:
                print("Please login as an editor or reviewer.")
                sys.exit(0)

        elif parsed_command == "resign":
            if logged_in_user_type == "reviewer":
                resign()
            else:
                print("Please login as a reviewer.")
                sys.exit(0)
            pass
        else:
            print("Couldn't understand the command. Please try again.")
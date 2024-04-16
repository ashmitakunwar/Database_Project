from mysql.connector import MySQLConnection, Error, errorcode, FieldType
from dbconfig import read_db_config
import getpass
import mysql
import sys

# Added the last two imports above to fix problems running on some systems

def drop_table_if_exists(cursor, tablename):
    """Drop the specified table using the mysql connection cursor       
    
    Arguments:
        cursor  -- mysql connection cursor 
        tablename  -- string name of table to be dropped if exists
    """
    try:
        print("Dropping",tablename)
        cursor.execute("DROP TABLE IF EXISTS {}".format(tablename))

    except Error as error:
        print(error)

def add_members(mycursor):
    member_list = ( ('Vincent','Colleen'),
                    ('Blankenship','Shaine'),
                    ('Stout','Bradley'),
                    ('Kennedy','Taylor'),
                    ('Booth','Karen'),
                    ('Conley','Raven'),
                    ('Clark','Serina'),
                    ('Carpenter','Walker'),
                    ('Reid','Alice'),
                    ('Hendrix','Vielka')
                )
    for mem in member_list:
        print("adding: {}, {} ...".format(mem[0],mem[1]), end='')
        add_member(mycursor,mem)

def add_member(cursor, mem):
    try:
        query = "INSERT INTO `members` (`last_name`,`first_name`) VALUES ('{}','{}');".format(mem[0], mem[1])
        print("-->",query,"<--", end='')
        cursor.execute(query)
    except mysql.connector.Error as err:
        print(err.msg)
    else:
        print("OK")

def mysqldemo():
    """ This is a simple program to demonstrate using the MySQL connector in Python.

        1. Get DB credentials from config file
            if password is null, get it from the user
        2. Connect to the MySQL DB with those credentials.
        3. Drop TABLE IF EXISTS mysqldemo
        4. Do these SQL commands 
            DROP TABLE IF EXISTS 'authors';
            CREATE TABLE 'authors' (
            'id' int(11) NOT NULL AUTO_INCREMENT,
            'first_name' varchar(40) NOT NULL,
            'last_name' varchar(40) NOT NULL,
            'photo' blob,
            PRIMARY KEY ('id')
            ) ENGINE=InnoDB;

            # Data for the table 'authors'
            insert  into 'authors' ... initially with missingPhoto.jpg(blob)
            # do various SQL things
            select ...
            select where...
            update
            select where...
            delete
            select where...
            ...
    """ 

    dbconfig = read_db_config()
    if dbconfig['password'] == "":  
        dbconfig['password'] = getpass.getpass("database password ? :")
    
    print(dbconfig)
    mycursor = None

    # Connect to the database
    try:
        print('Connecting to MySQL database...')
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
     

    # Ensure the table is gone before we try to create it
    print("!", end='')
    print(mycursor.rowcount)
    print("!")
    drop_table_if_exists(mycursor, "members")
        
    # Create the table
    ct = (
    "CREATE TABLE `members` ("
    "  `id` int(11) NOT NULL AUTO_INCREMENT,"
    "  `last_name` varchar(40) NOT NULL,"
    "  `first_name` varchar(40) NOT NULL,"
    "  PRIMARY KEY (`id`)"
    ") ENGINE=InnoDB")

    try:
        print("Creating members table:")
        print(ct)
        print(":")
        mycursor.execute(ct)
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
            print("already exists.")
        else:
            print(err.msg)
    else:
        print("OK")

    # Add some members

    add_members(mycursor)

# and commit

    conn.commit()
    print("=== now get a member back ===")

    mycursor.execute("SELECT * FROM members LIMIT 1")
    rows = mycursor.fetchall()

    print('Total Row(s):', mycursor.rowcount)
    for row in rows:
       print(row)

    # Now access another table and show its members
    mycursor.execute("SELECT * FROM College")
    rows = mycursor.fetchall()

    print('Total Row(s):', mycursor.rowcount)
    for row in rows:
        print(row)

    # Check attribute types
    mycursor.execute("SELECT * FROM College")
    for i in range(len(mycursor.description)):
        print("Column {}:".format(i+1))
        desc = mycursor.description[i]
        print("  column_name = {}".format(desc[0]))
        print("  type = {} ({})".format(desc[1], FieldType.get_info(desc[1])))
        print("  null_ok = {}".format(desc[6]))
        print("  column_flags = {}".format(desc[7]))

        
    print("All done - closing up.")

    mycursor.close()
    conn.cmd_reset_connection()
    conn.close()
    print("DONE")


if __name__ == '__main__':
    mysqldemo()

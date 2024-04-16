from mysql.connector import MySQLConnection, Error, errorcode, FieldType
from dbconfig import read_db_config
import getpass
import mysql
import sys
import argparse
from configparser import ConfigParser
import pandas as pd

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


def query(input_str, params=None, isUpdate=False):
    cursor, conn = mysql_connection()

    try:
        cursor.execute(input_str, params)

    except mysql.connector.Error as err:
        print(err.msg)
        return list()

    if isUpdate == False:
        results = cursor.fetchall()
    else:
        results = []
    conn.commit()
    cursor.close()
    conn.cmd_reset_connection()
    conn.close()
    return results

def get_statuses():
    statuses = pd.DataFrame(
        {'Status': [1, 2, 3, 4, 5, 6, 7, 8, 9],
         'Name': ['Received', 'Rejected', 'Under Review', 'Reviewed', 'Accepted', 'Typesetting',
                  'Ready', 'Scheduled', 'Published']})
    return statuses

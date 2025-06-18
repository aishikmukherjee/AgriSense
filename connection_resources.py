# importing mysql.connector
try:
    import mysql.connector as sql
except ImportError:
    import os
    os.system('pip install mysql-connector-python')
    import mysql.connector as sql

def connection_dbms():
    """Call this function to connect to SERVER database's schema 'agrisense'
    \nreturns the connection, catch it with some variable like 'mydb'
    """
    print("\n⚠️Logging into DBMS: agrisense")

    # Attempting to connect to the database
    try:
        mydb = sql.connect(
            host='localhost',
            user="root",
            passwd="root",
            database="agrisense",
            port=3306  # default MySQL port as integer, not string
        )

        # Checking if the connection was successful
        if mydb.is_connected():
            print("\n✅ Connected to MySQL database!")
            return mydb

    # error catching in DBMS connection
    except sql.Error as e:
        print(f"\n❌ Failed to connect to database: {e}")
        exit()

# # closing connection
def disconnect_dbms(mydb):
    """Call this function to disconnect to SERVER database's schema 'agrisense'
        \ntakes input of the connection like 'mydb'
        """
    mydb.close()
    print("\n✅ The DBMS connection was closed successfully")

if __name__ == "__main__":
    print("\n⚠️⚠️⚠️CAUTION ️: This is a resource file for importing: mysql connector connection")

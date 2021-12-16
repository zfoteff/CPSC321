from configparser import Error
from PySimpleGUI.PySimpleGUI import T
import mysql
import mysql.connector as mysql
import config
import datetime
from Loggers import DatabaseLogger

logger = DatabaseLogger()

class DatabaseHelper():
    """
    DatabaseHelper class for assisting specifically with the ExpenseCalc.py application
    database calls
    """
    def __init__(self):
        self.usr = config.mysql['user']
        self.pwd = config.mysql['password']
        self.hst = config.mysql['host']
        self.db = config.mysql['db']
        self.conn = mysql
        self.cursor = mysql.cursor


    def openConnection(self):
        logger.log(f"Attempting Database connection ...")
        try:
            self.conn = mysql.connect(user=self.usr, password=self.pwd, host=self.hst, database=self.db)
            self.cursor = self.conn.cursor(buffered=True)
            logger.log(f"Successfully connected to Database")
        except mysql.connector.Error as err:
            logger.log(f"Database error {err} ... Quitting")
       
            
    def closeConnection(self):
        """ Save changes and close connection to database """
        self.cursor.close()
        self.conn.close()
        logger.log(f"Connection closed")
     
        
    def _resetAllTables(self):
        dropTransactionsQuery = "DROP TABLE IF EXISTS transactions;"
        dropAccountQuery = "DROP TABLE IF EXISTS account;" 
        dropUserQuery = "DROP TABLE IF EXISTS user;"
        userQuery = "CREATE TABLE user (uid INT NOT NULL AUTO_INCREMENT, username VARCHAR(100) NOT NULL UNIQUE, date_created VARCHAR(100), date_modified VARCHAR(100), PRIMARY KEY (uid));"
        accountQuery = "CREATE TABLE account (aid INT NOT NULL AUTO_INCREMENT, uid INT NOT NULL, account_name VARCHAR(100) NOT NULL, date_created VARCHAR(100), date_modified VARCHAR(100), PRIMARY KEY (aid), FOREIGN KEY (uid) REFERENCES user (uid) ON DELETE CASCADE);"
        transactionQuery = "CREATE TABLE transactions (tid INT NOT NULL AUTO_INCREMENT, aid INT NOT NULL, tag VARCHAR(50) NOT NULL, amount DOUBLE(18, 2) NOT NULL, description VARCHAR(255), year VARCHAR(10) NOT NULL, month VARCHAR(25) NOT NULL, date_created VARCHAR(100) NOT NULL, date_modified VARCHAR(100), PRIMARY KEY (tid), FOREIGN KEY (aid) REFERENCES account (aid) ON DELETE CASCADE);"
        
        self.cursor.execute(dropTransactionsQuery)
        logger.log(f"Dropped transactions table: {dropTransactionsQuery}")
        self.cursor.execute(dropAccountQuery)
        logger.log(f"Dropped account table: {dropAccountQuery}")
        self.cursor.execute(dropUserQuery)
        logger.log(f"Dropped users table: {dropUserQuery}")
        
        self.cursor.execute(userQuery)
        logger.log(f"Create new user table: {userQuery}")
        self.cursor.execute(accountQuery)
        logger.log(f"Create new account table: {accountQuery}")
        self.cursor.execute(transactionQuery)
        logger.log(f"Create new transaction table: {transactionQuery}")
        self.conn.commit()


    def userExists(self, username):
        query = (f"SELECT uid FROM user WHERE username='{username}';")
        self.cursor.execute(query)
        if self.cursor.fetchone() is not None:
            logger.log(f"Found user {username}")
            return True
        logger.log(f"Did not find user {username}")
        return False
      
        
    def accountExistsForUser(self, account, username):
        query = (f"SELECT aid FROM account WHERE account_name='{account}' and uid={self.getUserUid(username)};")
        self.cursor.execute(query)
        if self.cursor.fetchone() is not None:
            logger.log(f"Found account {account} for user {username}")
            return True
        logger.log(f"Did not find account {account} for user {username}")
        return False


    def createNewUser(self, name):
        try:
            query = (f"INSERT INTO user (username, date_created, date_modified) VALUES ('{name}', '{datetime.datetime.now()}', '{datetime.datetime.now()}');")
            self.cursor.execute(query)
            logger.log(f"Create new user {name}: {query}")
            self.conn.commit()
        except mysql.connector.errors.IntegrityError:
            logger.log(f"User already exists")
        
        
    def deleteUser(self, username):
        query = (f"DELETE FROM user WHERE uid={self.getUserUid(username)};")
        self.cursor.execute(query)
        logger.log(f"Delete user {username}: {query}")
        self.conn.commit()
        
        
    def createNewAccount(self, accountName, parentUser):
        try:
            query = (f"INSERT INTO account (uid, account_name, date_created, date_modified) VALUES ({self.getUserUid(parentUser)}, '{accountName}', '{datetime.datetime.now()}', '{datetime.datetime.now()}');")
            self.cursor.execute(query)
            logger.log(f"Create new account {parentUser}|{accountName}: {query}")
            self.conn.commit()
        except mysql.connector.errors.IntegrityError:
            logger.log(f"Account already exists")
       
        
    def deleteAccount(self, accountName):
        query = (f"DELETE FROM account WHERE aid={self.getAccountAid(accountName)}")
        self.cursor.execute(query)
        logger.log(f"Delete account {accountName}: {query}")
        self.conn.commit()


    def createNewTransaction(self, amount, account, tag, desc):
        date = datetime.datetime.now()
        year = date.year
        month = date.month
        parentAcct = self.getAccountAid(account)
        try:
            query = (f"INSERT INTO transactions (aid, tag, amount, description, year, month, date_created, date_modified) VALUES ({parentAcct}, '{tag}', {amount}, '{desc}', {year}, {month}, '{datetime.datetime.now()}', '{datetime.datetime.now()}')")
            self.cursor.execute(query)
            logger.log(f"Recorded new transaction for {account}|{tag} - {amount} [{desc}]: {query}")
            self.conn.commit()
        except Error:
            logger.log(f"Insertion error")
   
           
    def getTotalTransactionAmount(self, account):
        parentAcct = self.getAccountAid(account)
        result = 0
        try:
            query = (f"SELECT SUM(t.amount) FROM account as a JOIN transactions as t USING (aid) WHERE a.aid={parentAcct}")
            self.cursor.execute(query)
            rs = self.cursor.fetchone()
            if rs[0] is not None:
                result = rs[0]
        except mysql.connector.errors.IntegrityError:
            logger.log(f"Error")
        
        logger.log(f"Retrieved total transactions: {result}")
        return result


    def getNumEntries(self, tableName):
        """
        Return number of entries in the specifed table

        Returns:
        int: number of entries in specifed table
        """

        query = (f"SELECT COUNT(*) FROM {tableName};")
        self.cursor.execute(query)
        rs = self.cursor.fetchone()
        if not rs:
            return 0
        
        logger.log(f"Get call to database: {query}")
        return rs[0]


    def getHistory(self, account):
        parentAcct = self.getAccountAid(account)
        result = []
        try:
            query = (f"SELECT t.date_created, t.tag, t.amount, t.description FROM account as a JOIN transactions as t USING (aid) WHERE a.aid={parentAcct} ORDER BY t.tid DESC LIMIT 50")
            self.cursor.execute(query)
            for (time, tag, amount, desc) in self.cursor:
                result.append((time, tag, amount, desc))
            logger.log(f"Retrieved history entries for {account}")
        except Error:
            logger.log("Error")
            
        return result


    def getUserUid(self, username):
        query = (f"SELECT uid FROM user WHERE username='{username}';")
        self.cursor.execute(query)
        rs = self.cursor.fetchone()
        result = -1
        if rs is not None:
            result = rs[0]
        logger.log(f"Get user id: {query}")
        return result
    
    
    def getAccountAid(self, accountname):
        query = (f"SELECT aid FROM account WHERE account_name='{accountname}';")
        self.cursor.execute(query)
        rs = self.cursor.fetchone()
        result = -1
        if rs[0] is not None:
            result = rs[0]
        logger.log(f"Get account id: {query}")
        return result
    
    
    def getAccountUid(self, accountname):
        query = (f"SELECT uid FROM user JOIN account as a USING (uid) WHERE a.accountname='{accountname}';")
        self.cursor.execute(query)
        rs = self.cursor.fetchone()
        result = -1
        if rs is not None:
            result = rs[0]
        logger.log(f"Get account's accociated uid: {query}")
        return result
    
    
    def getAllUserAccounts(self, username):
        query = (f"SELECT a.aid, a.account_name FROM user JOIN account as a USING (uid)")
        self.cursor.execute(query)
        
        result = {}
        for (aid, accountName) in self.cursor:
            result[aid] = accountName
             
        logger.log(f"Get all accounts associated with {username}: {query}\nResult: {result}")
        return result
    
    
    def getAllAccountTags(self, accountname):
        query = (f"SELECT DISTINCT t.tag FROM transactions as t JOIN account as a USING (aid) WHERE a.account_name='{accountname}' ORDER BY t.tag ASC")
        self.cursor.execute(query)
        
        result = []
        for tag in self.cursor:
            result.append(tag[0])
        
        logger.log(f"Get all tags associated with account {accountname}: {query}\nResult: {result}")
        return result
    
    
    #   Get number of transactions recorded over the 12 months of the year
    def getTotalExpensesPerMonth(self, accountname):
        parentAcct = self.getAccountAid(accountname)
        date = datetime.datetime.now()
        currYear = date.year
        query = (f"SELECT t.month, SUM(t.amount) FROM transactions as t JOIN account as a USING (aid) WHERE a.aid={parentAcct} and year={currYear} GROUP BY t.month;")
        self.cursor.execute(query)
        
        result = {}
        for (month, amount) in self.cursor:
            result[month] = amount
            
        logger.log(f"Total expenses over a year {accountname}| {query}\nResult: {result}")
        return result
        
    
    #   Get the total expenses paid during the each month of the 12 months of the year
    def getTransactionsPerMonth(self, accountname):
        parentAcct = self.getAccountAid(accountname)
        date = datetime.datetime.now()
        year = date.year
        query = (f"SELECT t.month, COUNT(t.tid) FROM transactions as t JOIN account as a USING (aid) WHERE a.aid={parentAcct} and t.year={year} GROUP BY t.month;")
        self.cursor.execute(query)
        
        result = {}
        for (month, total) in self.cursor:
            result[month] = total
            
        logger.log(f"Total transactions over a year {accountname}| {query}\nResult: {result}")
        return result
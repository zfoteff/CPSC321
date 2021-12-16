import mysql.connector
import config

class DatabaseHelper():
    def __init__(self):
        self.usr = config.mysql['user']
        self.pwd = config.mysql['password']
        self.hst = config.mysql['host']
        self.db = config.mysql['db']
        self.conn = mysql.connector
        self.cursor = mysql.connector.cursor

    @property
    def userTable(self):
        return "user"
    
    @property
    def accountTable(self):
        return "account"
    
    @property
    def transactionTable(self):
        return "transaction"

    def openConnection(self):
        try:
            newConn = mysql.connector.connect(user=self.usr, password=self.pwd, host=self.hst, database=self.db)
            newCurs = newConn.cursor(buffered=True)
            self.conn = newConn
            self.cursor = newCurs
        except mysql.connector.Error as err:
            print(err)
            
    def closeConnection(self):
        """ Save changes and close connection to database """
        self.cursor.close()
        self.conn.close()
        
    def getCountries(self):
        query = (f"SELECT country_code, country_name FROM Country")
        self.cursor.execute(query)
        rs = "\n -- COUNTRIES STORED IN TABLE -- \n"
        for (c_id, c_name) in self.cursor:
            rs += "\t"+(f"{c_name} ({c_id})")+"\n"
        return rs
    
    def addCountry(self):
        newCountryName = input("Enter new country name: ").upper()
        newCountryCode = input("Enter new country code: ").upper()
        newCountryGDP = input("Enter new county's per capita gdp (USD): ")
        newCountryInfl = input("Enter new country's inflation (%): ")
        query = (f"SELECT country_name FROM Country WHERE country_code='{newCountryCode}'")
        self.cursor.execute(query)
        if (self.cursor.fetchall() == []):
            query = (f"INSERT INTO Country (country_code, country_name, gdp, inflation) VALUES ('{newCountryCode}', '{newCountryName}', '{newCountryGDP}', '{newCountryInfl}')")
            self.cursor.execute(query)
            self.conn.commit()
            return (f"Created new country {newCountryName} ({newCountryCode}) | gdp: ${newCountryGDP}, inflation: {newCountryInfl}") + "\n"
        return "Country already exists. Cancelling operation ...\n"
    
    def getCountriesBasedOnGDPAndInflation(self):
        maxCountries = int(input("Number of countries to display: "))
        minGDP = float(input("Minimum GDP (USD): "))
        maxInfl = float(input("Maximum Inflation (%): "))
        query = (f"SELECT country_code, country_name FROM Country WHERE gdp>{minGDP} and inflation<{maxInfl} LIMIT {maxCountries}")
        self.cursor.execute(query)
        results = self.cursor.fetchall()
        if (results != []):
            rs = "\n"+(f" -- Countries with gdp > {minGDP} & infl < {maxInfl} --")+"\n"
            for (c_id, c_name) in results:
                rs += "\t"+(f"{c_name} ({c_id})")+"\n"
            return rs
        else:
            return "No results found ..."
        
    def updateCountryGDPAndInflation(self):
        countryCode = input("Enter country code to update: ").upper()
        countryGDP = float(input("Enter updated country GDP (USD): "))
        countryInfl = float(input("Enter updated country Inflation (%): "))
        query = (f"SELECT country_name FROM Country WHERE country_code='{countryCode}'")
        self.cursor.execute(query)
        result = self.cursor.fetchone()
        if (result != []):
            rs = "\n" + (f"-- Updating {countryCode} GDP and Inflation --") +"\n"
            query = (f"UPDATE Country SET gdp={countryGDP}, inflation={countryInfl} WHERE country_code='{countryCode}'")
            self.cursor.execute(query)
            self.conn.commit()
            return rs+(f"Updated country ({countryCode}) | gdp: ${countryGDP}, inflation: {countryInfl}") + "\n"
        else:
            return "No country matched inputted country code. Cancelling operation ...\n"
from hw9_db_helper import DatabaseHelper

def main():
    db = DatabaseHelper()
    db.openConnection()
    keepGoing = True    
    while(keepGoing):
        userChoice = int(input(
            "1. List Countries\n"+
            "2. Add Country\n"+
            "3. Find countries based on gdp and inflation\n"+
            "4. Update country's gdp and inflation\n"+
            "5. Exit\n"+
            "Enter your choice [1-5]: "
            ))
        
        while (
            userChoice < 1 or
            userChoice > 5 
               ):
            userChoice = int(input(
            "Invalid selection. Please choose again:\n"+
            "1. List Countries\n"+
            "2. Add Country\n"+
            "3.Find countries based on gdp and inflation\n"+
            "4.Update country's gdp and inflation\n"+
            "5. Exit\n"+
            "Enter your choice [1-5]: "
            ))
        
        if userChoice == 1:
            result = db.getCountries()
            print(result)
        elif userChoice == 2:
            result = db.addCountry()
            print(result)
        elif userChoice == 3:
            result = db.getCountriesBasedOnGDPAndInflation()
            print(result)
        elif userChoice == 4:
            result = db.updateCountryGDPAndInflation()
            print(result)
        elif userChoice == 5:
            keepGoing = False
            break
    db.closeConnection()
main()
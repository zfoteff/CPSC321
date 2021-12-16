"""
Zachary Foteff
CPSC321: Database Management Systems
12/17/2021
Final Project

Main program for running the expense calculator application 
"""

import re
import PySimpleGUI as sg
from DatabaseHelper import DatabaseHelper
from Loggers import ExpenseCalcLogger
from matplotlib import pyplot as plt

logger = ExpenseCalcLogger()
db = DatabaseHelper()
db.openConnection()
loginWindow = None
homeWindow = None
historyWindow = None
loggedInUser = ""
activeAccount = ""

def filter_amount(amount):
    """
    Filter the amount input field into a string representation of a float that is always
    expanded to the hundredths decimal place

    Args:
        amount (str): Unfiltered amount
    Return:
        newAmount (str): Filtered amount string in the proper formatting
    """

    #   Filter spaces and characters
    newAmount = re.sub("\s|[a-z]", "", amount)

    # Round to .00 decimal places 
    newAmount = round(float(amount), 2)
    return newAmount

def filter_description(desc):
    """
    Filter description to remove carrage returns and newline characters added by multiline element
    
    Args:
        desc (str): Unfiltered description
    Return:
        newDesc (str): Filtered description
    """
    newDesc = desc.replace('\n', '')
    return newDesc

def deposit():
    """
    Records transaction of deposit into database and updates account balance
    """
    #   Filter the amount and description input fields to acceptable formats
    amount = filter_amount(homeWindow['amount'].Get())
    desc = filter_description(homeWindow['description'].Get())
    tag = homeWindow['tag'].Get()
    logger.log(f'Creating new deposit | Amount: {amount} Description: {desc} Tag: {tag}')

    try:
        #   Insert record of transaction into database
        db.createNewTransaction(amount, activeAccount, tag, desc)
    except Exception as e:
        logger.log(e)

def withdraw():
    """
    Withdraws money from the balance and adds a record to the database

    Parameters:
    balance (str): Pass by referance variable for dealing with balance
    """

    #   Filter the input fields into acceptable formats
    amount = filter_amount(homeWindow['amount'].Get()) * -1
    desc = filter_description(homeWindow['description'].Get())
    tag = homeWindow['tag'].Get()
    logger.log(f'Creating new deposit | Amount: {amount} Description: {desc} Tag: {tag}')

    try:
        #   Insert record of transaction into database
        #db.insert_new_entry("-"+amount, description)
        db.createNewTransaction(amount, activeAccount, tag, desc)
    except Exception as e:
        logger.log(e)

def drawPlot(points):
    plt.plot(points)
    plt.show(block=False)

def makeHomeWindow(user, account):
    balance = db.getTotalTransactionAmount(account)
    layout = [
        [sg.Text(f"{account}", key='account-name'), sg.Text(f"[{user}]", key='username'), sg.VerticalSeparator(), sg.Text(f"{balance}", key="balance")],
        [sg.Text("Amount\t", font="bold"), sg.VerticalSeparator(), sg.InputText(size=(16, 1), key='amount')],
        [sg.Text("Tag\t", font="bold"), sg.VerticalSeparator(), sg.InputText(size=(16, 1), key='tag')],
        [sg.Radio('Deposit', "R1", default=True, auto_size_text=True, key='deposit')],
        [sg.Radio('Withdraw', "R1", default=False, auto_size_text=True, key='withdraw')],
        [sg.Text("Description of Transaction:", font="bold")],
        [sg.Multiline("", size=(30, 8), key='description', no_scrollbar=True)],
        [sg.B('Submit', key='submit'), sg.B('History', key="history"), sg.B("Logout", key="logout"), sg.Quit()]
    ]
    return sg.Window("Expense Calculator", layout=layout, finalize=True, location=(50, 500), size=(250, 350))

def makeLoginWindow():
    layout = [
        [sg.Text("User\t"), sg.VerticalSeparator(), sg.InputText(size=(40,1), key="uid")],
        [sg.Text("Account\t"), sg.VerticalSeparator(), sg.InputText(size=(40,1), key="account")],
        [sg.Text("", key='login-output')],
        [sg.B("Login", key="login"), sg.B("Register", key="register"), sg.Quit()]
    ]
    return sg.Window("Login", layout, finalize=True, location=(50,300), size=(300, 120))

def makeHistoryWindow(history): 
    layout = [
        [sg.Multiline(history, size=(50, 20), key='history-output')],
        [sg.B('Plot Expenses / Month', key='expenses-by-month'), sg.B('Plot Transactions / Month', key="transactions-by-month"), sg.Quit()]
    ]
    return sg.Window("History", layout=layout, finalize=True, location=(70, 560), size=(400, 400), modal=True)

def validateUser(username, account):
    return db.userExists(username) and db.accountExistsForUser(account, username)

""" Main Event Loop """
loginWindow = makeLoginWindow()
while True:
    window, event, values = sg.read_all_windows()
    
    #   Check for exit logic in all windows
    if event == sg.WIN_CLOSED or event == 'Exit' or event == 'Quit':
        if window == loginWindow:
            #   Stop program
            break
        if window == homeWindow:
            #   Stop program
            break
        if window == historyWindow:
            #   Set window as closed
            window.close()
            historyWindow = None
    
    #   Event occured in the home menu
    if window == homeWindow:
        if event == 'submit':
            #   If deposit option button is selected -> deposit logic
            if homeWindow["amount"].Get() != '' and homeWindow["tag"].Get() != '':
                if values["deposit"] == True:
                    deposit()

                #   If deposit option button is selected -> withdraw logic
                elif values["withdraw"] == True:
                    withdraw()

                #   If no option is selected -> display error message
                else:
                    sg.PopupOK("Please select either Deposit or Withdraw", location=(500, 500), no_titlebar=True, line_width=25)

                #   Clear input fields
                homeWindow["amount"].update("")
                homeWindow["tag"].update("")
                homeWindow["description"].update("")
                #   Update balance
                new_balance = db.getTotalTransactionAmount(activeAccount)
                homeWindow['balance'](new_balance)
            else:
                sg.PopupOK('Input fields left unfilled', location=(500, 500), no_titlebar=True, line_width=25)
            
        if event == 'history':
            history = db.getHistory(activeAccount)
            hs = ""
            for each in history:
                hs += (f"{each[0]} | ({each[1]}) Amount: {each[2]}, Description: {each[3]}")+"\n"
            historyWindow = makeHistoryWindow(hs)
             
        if event == "logout":
            #   Close window and redirect to login window
            window.close()
            homeWindow = None
            loggedInUser = ""
            activeAccount = ""
            loginWindow = makeLoginWindow()
    
    #   Event occurred in the login menu
    if window == loginWindow:
        if event == 'login':
            username = str(loginWindow['uid'].Get())
            account = str(loginWindow['account'].Get())
            #   Check if user has inputted into the username and account fields
            if username and account:
                #   Check if user-account pairing is valid
                if (validateUser(username, account)):
                    #   User-account pairing is correct -> redirect to home menu
                    loggedInUser = username
                    activeAccount = account
                    #   Open home window
                    homeWindow = makeHomeWindow(username, account)
                    #   Close login window
                    window.close()
                    loginWindow = None
                    logger.log(f"Logged in Account: {account} User: {username}")
                else:
                    #   User-account pairing is incorrect
                    loginWindow['login-output']("User - Account pairing not found")
            else:
                #   User has not entered anything into user and/or account fields
                loginWindow['login-output']("Please enter a username and account name")
        
        if event == "register":
            #   Check if user has inputted into the username and account fields
            #   Check if user has inputted into the username and account fields
            username = str(loginWindow['uid'].Get())
            account = str(loginWindow['account'].Get())
            if username and account:
                #   Check that user doesnt already exist and account doesnt exist for the user
                if not db.userExists(username):
                    db.createNewUser(username)
                if not db.accountExistsForUser(account, username):
                    #   Add user and account to database -> Redirect to home menu
                    db.createNewAccount(account, username)
                    loggedInUser = username
                    activeAccount = account
    
                    #   Make home window
                    homeWindow = makeHomeWindow(username, account)
                    #   Close login window
                    window.close()
                    loginWindow = None
                    logger.log(f"Created Account: {account} User: {username}")
                else:
                    result = "User already exists"
                    loginWindow['login-output'](result)
            else:
                #   User has not entered anything into user and/or account fields
                result = "Please enter a username and account name"
                loginWindow['login-output'](result)

    #   Event occurred in the history menu
    if window == historyWindow:
        #   Plot expenses by month
        if event == 'expenses-by-month':
            result = db.getTotalExpensesPerMonth(activeAccount)
            resultSet = []
            for key in result.keys():
                resultSet.append(result[key])

            drawPlot(resultSet)
        
        #   Plot # of transactions by month
        if event == 'transactions-by-month':
            result = db.getTransactionsPerMonth(activeAccount)
            resultSet = []
            for key in result.keys():
                resultSet.append(result[key])
                
            drawPlot(resultSet)
    
        
db.closeConnection()
historyWindow = None
homeWindow = None
loginWindow = None
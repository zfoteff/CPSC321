from DatabaseHelper import DatabaseHelper
from Loggers import TestLogger

testLogger = TestLogger()
db = DatabaseHelper()

def test_user_exists():
    db.openConnection()
    testLogger.log("--- Starting user exists test ---")
    USER = "newuser"
    assert db.userExists(USER) == False
    db.createNewUser(USER)
    assert db.userExists(USER) == True
    db.deleteUser(USER)
    testLogger.log("--- Completed user exists test ---")
    db.closeConnection()

def test_get_user_id():
    db.openConnection()
    testLogger.log("--- Starting get user id test ---")
    USER = "newuser"
    db.createNewUser(USER)
    result = db.getUserUid(USER)
    testLogger.log(f"Result: {result}")
    assert result != -1
    db.deleteUser(USER)
    testLogger.log("--- Completed get user id test ---")
    db.closeConnection()
    
def test_get_nonexistant_user_id():
    db.openConnection()
    testLogger.log("--- Starting get nonexistant user id test ---")
    USER = "x"
    result = db.getUserUid(USER)
    testLogger.log(f"Result: {result}")
    assert result == -1
    testLogger.log("--- Completed get nonexistant user id test ---")
    db.closeConnection()    

def test_insert_and_delete_from_user_table():
    db.openConnection()
    testLogger.log("--- Starting delete from user table test ---")
    origNumEntries = int(db.getNumEntries('user'))
    db.createNewUser('steve')
    db.createNewUser('ron')
    db.createNewUser('tom')
    postAddEntries = int(db.getNumEntries('user'))
    assert postAddEntries > origNumEntries
    db.deleteUser('steve')
    db.deleteUser('ron')
    db.deleteUser('tom')
    postDeleteEntries = int(db.getNumEntries('user'))
    assert postDeleteEntries == origNumEntries
    testLogger.log("--- Completed delete from user table test --- ")
    db.closeConnection()
    
def test_account_exists_for_user():
    db.openConnection()
    testLogger.log("--- Starting account exists for user test ---")
    USER = "newuser"
    ACCT = 'a1'
    assert db.accountExistsForUser(ACCT, USER) == False
    db.createNewUser(USER)
    db.createNewAccount(ACCT, USER)
    assert db.accountExistsForUser(ACCT, USER) == True
    db.deleteAccount(ACCT)
    db.deleteUser(USER)
    testLogger.log("--- Completed account exists for user test ---")
    db.closeConnection()

def test_get_account_aid():
    db.openConnection()
    testLogger.log("--- Starting get account aid test ---")
    db.createNewUser("GetAccountAidTest")
    db.createNewAccount("a1", "GetAccountAidTest")
    aid = db.getAccountAid('a1')
    assert aid != -1
    testLogger.log(f"Result: {aid}")
    db.deleteAccount('a1')
    db.deleteUser('GetAccountAidTest')
    testLogger.log("--- Completed get account aid test ---")
    db.closeConnection()
    
def test_get_account_tags():
    db.openConnection()
    testLogger.log("--- Starting get account tags test ---")
    db.createNewUser("TagsTest")
    db.createNewAccount('a1', 'TagsTest')
    db.createNewTransaction(100.00, "a1", "Cheese", "Good cheese")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Apples", "Decent apples")
    db.createNewTransaction(100.00, "a1", "Juice", "Outstanding juice")
    result = result = db.getAllAccountTags('a1')
    assert len(result) > 0
    testLogger.log(f"Results: {result}")
    db.deleteAccount('a1')
    db.deleteUser('TagsTest')
    testLogger.log("--- Completed get account tags test ---")
    db.closeConnection()

def test_insert_and_delete_from_account_table():
    db.openConnection()
    testLogger.log("--- Starting account insert and delete test ---")
    origNumEntries = int(db.getNumEntries('account'))
    USER = "Accounts"
    db.createNewUser(USER)
    db.createNewAccount('school', USER)
    db.createNewAccount('gas', USER)
    db.createNewAccount('presents', USER)
    postInsEntries = int(db.getNumEntries('account'))
    assert postInsEntries > origNumEntries
    db.deleteAccount('school')
    db.deleteAccount('gas')
    db.deleteAccount('presents')
    postDelEntries = int(db.getNumEntries('account'))
    assert postDelEntries == origNumEntries
    db.deleteUser('accounts')
    testLogger.log("--- Completed account insert and delete test ---")
    db.closeConnection()

def test_insert_into_transaction_table():
    db.openConnection()
    testLogger.log("--- Starting transaction insert and delete test ---")
    db.createNewUser("InsertTransactionTest")
    db.createNewAccount("a1", "InsertTransactionTest")
    origNumEntries = db.getNumEntries('transactions')
    db.createNewTransaction(100.00, "a1", "Cheese", "Good cheese")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Apples", "Decent apples")
    db.createNewTransaction(100.00, "a1", "Juice", "Outstanding juice")
    postNumEntries = db.getNumEntries('transactions')
    assert origNumEntries < postNumEntries
    db.deleteAccount('a1')
    db.deleteUser('InsertTransactionTest')
    testLogger.log("--- Completed transaction insert and delete test ---")
    db.closeConnection()

def test_get_total_amount():
    db.openConnection()
    testLogger.log("--- Started get total amount test ---")
    db.createNewUser("GetTotalAmountTest")
    db.createNewAccount('a1', 'GetTotalAmountTest')
    db.createNewTransaction(100.00, "a1", "Cheese", "Good cheese")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Grapes", "Bad grapes")
    db.createNewTransaction(100.00, "a1", "Apples", "Decent apples")
    db.createNewTransaction(100.00, "a1", "Juice", "Outstanding juice")
    assert db.getTotalTransactionAmount("a1") == 500
    db.deleteAccount('a1')
    db.deleteUser('GetTotalAmountTest')
    testLogger.log("--- Completed get total amount test ---")
    db.closeConnection()
    
def main():
    test_get_user_id()
    test_user_exists()
    test_get_nonexistant_user_id()
    test_get_account_aid()
    test_account_exists_for_user()
    test_get_account_tags()
    test_insert_and_delete_from_user_table()
    test_insert_and_delete_from_account_table()
    test_insert_into_transaction_table()
    test_get_total_amount()
main()
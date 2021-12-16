
#include <iostream>
#include <mysql_connection.h>
#include <driver.h>
#include <prepared_statement.h>
#include <resultset.h>
#include <exception.h>
#include "mysql_test.h"

using namespace std;

string to_upper(const string& s);


int main()
{
  try {
    // create a connection
    sql::Driver *driver = get_driver_instance();
    sql::Connection *con = driver->connect(HOST, USER, PASS);
	string db = string(USER) + "DB";
    con->setSchema(db);

    // get a category from the user
    string pepper, heat;
    cout << "Please enter your favorite pepper: ";
    cin >> pepper;
    cout << "Please enter the heat level: ";
    cin >> heat;

    // insert the pepper in into the db
    string insert = "INSERT INTO pepper(common_name,heat) VALUES (?,?)";
    sql::PreparedStatement *prep_stmt = con->prepareStatement(insert);
    prep_stmt->setString(1, pepper);
    prep_stmt->setString(2, heat);
    // commit the changes
    prep_stmt->executeUpdate();
    delete prep_stmt;

    // update the db
    cout << "Please enter a pepper to change: ";
    cin >> pepper;
    cout << "Please enter a new heat value: ";
    cin >> heat;
    string update = "UPDATE pepper SET heat=? WHERE common_name=?";
    prep_stmt = con->prepareStatement(update);
    prep_stmt->setString(1, heat);
    prep_stmt->setString(2, pepper);
    // commit the changes
    prep_stmt->executeUpdate();
    delete prep_stmt;
    
    // remove from the db
    cout << "Please enter a pepper to remove: ";
    cin >> pepper;
    string del = "DELETE FROM pepper WHERE common_name=?";
    prep_stmt = con->prepareStatement(del);
    prep_stmt->setString(1, pepper);
    // commit the changes
    prep_stmt->executeUpdate();
    delete prep_stmt;
    
    delete con;

  } catch (sql::SQLException &e) {
    cout << e.what() << endl;
  }
  
  return 0;
}


#include <iostream>
#include <mysql_connection.h>
#include <driver.h>
#include <statement.h>
#include <resultset.h>
#include <exception.h>
#include "mysql_test.h"

using namespace std;

int main()
{
  try {
    sql::Driver *driver = get_driver_instance();
    sql::Connection *con = driver->connect(HOST, USER, PASS);
    con->setSchema("cpsc321");

    sql::Statement *stmt = con->createStatement();
    string q = "SELECT category_id, name FROM category";
    sql::ResultSet *res = stmt->executeQuery(q);
    while (res->next()) {
      string catid = res->getString("category_id");
      string name = res->getString("name");
      cout << catid << ", " << name << endl;
    }

    delete res;
    delete stmt;
    delete con;

  } catch (sql::SQLException &e) {
    cout << e.what() << endl;
  }
  
  return 0;
}

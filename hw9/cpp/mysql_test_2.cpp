
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
    con->setSchema("cpsc321");

    // get a category from the user
    int user_input_1;
    string user_input_2;
    cout << "Please enter a category id: ";
    cin >> user_input_1;
    cout << "Please enter a title keyword: ";
    cin >> user_input_2;

    // create and execute query
    string q =
      "SELECT COUNT(*) as total "
      "FROM film_category JOIN film USING (film_id) "
      "WHERE category_id = ? AND INSTR(title, ?)";
    sql::PreparedStatement *prep_stmt = con->prepareStatement(q);
    prep_stmt->setInt(1, user_input_1);
    prep_stmt->setString(2, to_upper(user_input_2));

    // print the result
    sql::ResultSet *res = prep_stmt->executeQuery();
    if (res->next()) {
      cout << "There are " << res->getInt("total")
	   << " films with category id " << user_input_1
	   << " and titles containing " << to_upper(user_input_2) << endl;
    }

    delete res;
    delete prep_stmt;
    delete con;

  } catch (sql::SQLException &e) {
    cout << e.what() << endl;
  }
  
  return 0;
}

// helper function 
string to_upper(const string& s)
{
  string result = "";
  for(size_t i = 0; i < s.length(); i++)
    result.append(1, toupper(s[i]));
  return result;
}

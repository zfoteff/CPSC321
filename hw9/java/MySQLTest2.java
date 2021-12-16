
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.Scanner;
import com.mysql.jdbc.Driver;

public class MySQLTest2 {

    public static void main(String[] args) {
	try {
	    // connection info
	    Properties prop = new Properties();
	    FileInputStream in = new FileInputStream("config.properties");
	    prop.load(in);
	    in.close();	    

	    // connect to datbase
	    String hst = prop.getProperty("host");
	    String usr = prop.getProperty("user");
	    String pwd = prop.getProperty("password");
	    String dab = "cpsc321";
	    String url = "jdbc:mysql://" + hst + "/" + dab;
	    Connection con = DriverManager.getConnection(url, usr, pwd);

	    // get a category from the user
	    System.out.print("Please enter a category id: ");
	    Scanner reader = new Scanner(System.in);
	    String userInput1 = reader.next();
	    System.out.print("Please enter a title keyword: ");
	    String userInput2 = reader.next();
	    reader.close();

	    // create and execute a prepared statement 
	    String q =
		"SELECT COUNT(*) as total FROM film_category " +
		"JOIN film USING (film_id) " + 
		"WHERE category_id = ? AND INSTR(title, ?)";
	    PreparedStatement stmt = con.prepareStatement(q);
	    stmt.setString(1, userInput1);
	    stmt.setString(2, userInput2.toUpperCase());
	    ResultSet rs = stmt.executeQuery();
	    
	    // print the result
	    if(rs.next()) {
		int num_films = rs.getInt("total");
		String ans = "There are " + num_films + " films with " +
		    "category id " + userInput1 + " and titles " + 
		    "containing " + userInput2.toUpperCase() + ".";
		System.out.println(ans);
	    }

	    // release resources
	    rs.close();
	    stmt.close();
	    con.close();
	    
	} catch(Exception err) {
	    err.printStackTrace();
	}
    }
    
}

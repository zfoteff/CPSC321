
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

public class MySQLTest3 {

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
	    String dab = usr + "DB"; 
	    String url = "jdbc:mysql://" + hst + "/" + dab;
	    Connection con = DriverManager.getConnection(url, usr, pwd);

	    // get a pepper and heat
	    System.out.print("Please enter your favorite pepper: ");
	    Scanner reader = new Scanner(System.in);
	    String pepper = reader.next();
	    System.out.print("Please enter the heat level: ");
	    String heat = reader.next();
	    // create and execute a prepared statement 
	    String q = "INSERT INTO pepper(common_name, heat) VALUES (?,?)";
	    PreparedStatement stmt = con.prepareStatement(q);
	    stmt.setString(1, pepper);
	    stmt.setString(2, heat);
	    stmt.execute();
	    
	    // update the db
	    System.out.print("Please enter a pepper to change: ");
	    pepper = reader.next();
	    System.out.print("Please enter a new heat level: ");
	    heat = reader.next();
	    // create and execute a prepared statement 
	    q = "UPDATE pepper SET heat=? WHERE common_name=?";
	    stmt = con.prepareStatement(q);
	    stmt.setString(1, heat);
	    stmt.setString(2, pepper);
	    stmt.execute();

	    // remove from the db
	    System.out.print("Please enter a pepper to remove: ");
	    pepper = reader.next();

	    // create and execute a prepared statement 
	    q = "DELETE FROM pepper WHERE common_name=?";
	    stmt = con.prepareStatement(q);
	    stmt.setString(1, pepper);
	    stmt.execute();

	    reader.close();
	    stmt.close();
	    con.close();
	    
	} catch(Exception err) {
	    err.printStackTrace();
	}
    }

    
}

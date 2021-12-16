
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class MySQLTest1 {

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

	    // create and execute query
	    Statement stmt = con.createStatement();
	    String q = "SELECT category_id, name FROM category";
	    ResultSet rs = stmt.executeQuery(q);

	    // print results
	    while(rs.next()) {
		String catid = rs.getString("category_id");
		String name = rs.getString("name");
		System.out.println(catid + ", " + name);
	    }

	    // release resources
	    rs.close();
	    stmt.close();
	    con.close();	    
	} catch(Exception err) {
	    // do something useful
	    err.printStackTrace();
	}
    }
    
}

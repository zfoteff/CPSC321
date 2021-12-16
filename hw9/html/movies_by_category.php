<!-- movies-by-category.ph[ -->
<html>
<body>
<h1>Movies by Category</h1>

<?php
  // get credentials (put your ini file somewhere private
  $config = parse_ini_file("../private/config.ini");
  $server = $config["servername"];
  $username = $config["username"];
  $password = $config["password"];
  $database = "cpsc321";

  // connect
  $conn = mysqli_connect($server, $username, $password, $database);

  // check connection
  if (!$conn) {
    die("Connection failed: " . mysqli_connect_error()); 
  }

  // get the category from the form:
  $category = $_POST["CategoryChoice"];
  
  echo "<p>Category: " . $category . "</p>";
  
  // the query
  $query = "SELECT f.title, f.length " . 
           "FROM category c JOIN film_category fc USING (category_id) " .
           "      JOIN film f USING (film_id) " . 
           "where c.name = ?";

  // initialize prepared statement
  $stmt = $conn->stmt_init();
  $stmt->prepare($query);

  // bind the parameter to the query (s=string)
  $stmt->bind_param("s", $category);

  // execute the statement and bind the result
  $stmt->execute();
  $stmt->bind_result($film_title, $film_length);

  echo "<p>Film titles and lengths:</p>\n"; 
  echo "<ol>\n";

  // get the results (each row bound to the variables
  while ($stmt->fetch()) {
    echo "<li>" . $film_title . " (" . $film_length . " min)</li>\n";
  }

  echo "</ol>\n";

  // clean up
  $stmt->close();
  $conn->close();
?>

</body>
</html>

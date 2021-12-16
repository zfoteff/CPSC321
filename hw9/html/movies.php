

<html>
<body>
<h1>Movies</h1>

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

  $query = "SELECT title FROM film ORDER BY title";
  $result = mysqli_query($conn, $query); 
 
 
  if (mysqli_num_rows($result) > 0) {
    // output each row of data
    echo "<p>Movie Titles:\n";
    echo "<ol>\n";
    while($row = mysqli_fetch_assoc($result)) {
      echo "<li>". $row["title"] . "</li>\n";
    }
    echo "</ol>";
  }
  else {
    echo "<b>No Movies</b>";
  }
  mysqli_close($conn);
?>

  </body>
</html>

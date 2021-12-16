<?php
  header('Content-type: application/json');
  echo '[';

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
    die('Error: ' . mysqli_connect_error()); 
  }

  // get the rating from the query params:
  // url: barney.gonzaga.edu/~bowers/movies_by_rating.php?rating='G'
  $rating = $_GET["rating"];
  // $rating = 'G';
  // the query
  $query = "SELECT film_id, title, length " . 
           "FROM film " . 
           "WHERE rating = ? " . 
           "ORDER BY length;";

  // initialize prepared statement
  $stmt = $conn->stmt_init();
  $stmt->prepare($query);

  // bind the parameter to the query (s=string)
  $stmt->bind_param("s", $rating);

  // execute the statement and bind the result
  $stmt->execute();
  $stmt->bind_result($film_id, $film_title, $film_length);

  // store to get the number of rows
  $stmt->store_result();
  $rows_left = $stmt->num_rows();

  // get the results (each row bound to the variables
  while ($stmt->fetch()) {
    echo '{';
    echo '"id":"' . $film_id . '",';
    echo '"title":"' . $film_title . '",';
    echo '"length":"' . $film_length . '"';
    echo '}';
    if ($rows_left > 1) {
      echo ',';
    }
    $rows_left--;
  } 

  $stmt->close();
  $conn->close();
  echo ']';
?>

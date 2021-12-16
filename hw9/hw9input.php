<html>
<body>
    <label for="country-selector"> Select a Country
    <form action="http://barney.gonzaga.edu/~zfoteff/hw9output.php" method="POST">
        <select name="country-selector" id="country-selector">
        <?php
            $config = parse_ini_file("../private/config.ini");
            $server = "cps-database.gonzaga.edu";
            $username = "zfoteff";
            $password = "k7ag,=X@";
            $database = "zfoteff_DB";

            $conn = mysqli_connect($server, $username, $password, $database);
            if (!$conn) {
                die("Connection failed: ".mysqli_connect_error());
            }

            //  Setup prepared stmt
            $query = "SELECT country_name, country_code FROM Country";
            $result = mysqli_query($conn, $query);

            //  Populate drop down menu
            if (mysqli_num_rows($result) > 0) {
                while ($row = mysqli_fetch_assoc($result)) {
                    $country = $row["country_name"];
                    echo "<option value=\"".$country."\"> ".$country."</option>\n";
                }
            }
            mysqli_close($conn);
        ?>
        </select>
        <input type="submit" value="Select Country">
    </form>
    </body>
</html>
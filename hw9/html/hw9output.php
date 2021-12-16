<html>
    <body>
        <?php
            $config = parse_ini_file("../private/config.ini");
            $server = "cps-database.gonzaga.edu";
            $username = "zfoteff";
            $password = "k7ag,=X@";
            $database = "zfoteff_DB";

            $country_name = $_POST["country-selector"];
            echo "<h1>".$country_name."</h1>\n";

            $conn = mysqli_connect($server, $username, $password, $database);
            if (!$conn) {
                die("Connection failed: ".mysqli_connect_error());
            }

            $query = "SELECT province_name, gdp, inflation, COUNT(*) FROM Country JOIN Province USING (country_codes) WHERE country_name = ? GROUP BY country_code";
            
            //  Prepare stmt and execute query
            $stmt = $conn->stmt_init();
            $stmt->prepare($query);
            echo "<p>".$query."</p>";
            $stmt->bind_param('s', $country_name);
            $stmt->execute();
            $stmt->bind_result($province, $gdp, $inflation, $numProvinces);

            //  Draw elements
            echo "<h2>".$province."</h2>\n";
            echo "<p>GDP: ".$gpd."</p>\n";
            echo "<p>Inflation: ".$inflation."</p>\n";
            echo "<p>Number of provinces: ".$numProvinces."</p>\n";
            
            $stmt->close();
            $conn->close();
        ?>
    </body>
</html>
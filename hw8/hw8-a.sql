/**********************************************************************
 * NAME:            Zac Foteff
 * CLASS:           CPSC321: 01
 * DATE:            11/23/2021
 * HOMEWORK:        HW#8
 * DESCRIPTION:     Set of advanced queries against the World Factbook 
 *                  Database constructed
 **********************************************************************/
use zfoteff_DB;

-- 1(a)
SELECT
    c.country_code as "Country",
    SUM(p.area) as "Total Area"
FROM
    Country as c JOIN Province as p USING (country_code)
GROUP BY 
    c.country_code;

-- 1(b)
SELECT
    c.country_code as "Country Name",
    c.gdp as "GDP",
    c.inflation as "Inflation Rate",
    SUM(ci.city_population) as "Total Population"
FROM
    Country as c JOIN 
    Province as p USING (country_code) JOIN
    City as ci USING (province_name)
GROUP BY 
    c.country_code;

-- 1(c)
-- Find the GDP, inflation, and total population of all provinces with a population over 10,000 persons
SELECT
    p.country_code as "Country",
    p.province_name as "Province",
    p.area as "Area",
    SUM(c.city_population) as "Total Population"
FROM 
    Province as p JOIN
    City as c USING (province_name)
GROUP BY 
    p.province_name
HAVING
    SUM(c.city_population) > 10000;

-- 1(d)
SELECT
    co.country_code as "Country Code",
    co.country_name as "Country Name",
    COUNT(*) as "Number of cities in country"
FROM
    Country as co JOIN
    City as ci USING (country_code) 
GROUP BY
    co.country_code
ORDER BY 
    COUNT(*) DESC;

-- 1(e)
-- Find country name, gdp, area, and number of cities for countries with an area smaller than 100000 
-- and a GDP larger than 1600000000.00, ordered by the number of cities in the country, descending
SELECT
    co.country_code as "Country Code",
    co.country_name as "Country Name",
    co.gdp as "GDP",
    SUM(p.area) as "Area",
    COUNT(ci.city_name) as "Number of cities in country"
FROM
    Country as co JOIN
    Province as p USING (country_code) JOIN
    City as ci USING (province_name)
GROUP BY                            
    co.country_code
HAVING
    SUM(p.area) < 100000
ORDER BY
    COUNT(ci.city_name) ASC,
    co.gdp DESC;

-- 1(f)
-- find countries with the most number of cities (w/ ties)
SELECT
    co.country_code as "Country/s with most number of cities",
    COUNT(ci.city_name) as "# Cities"
FROM
    Country as co JOIN 
    City as ci USING (country_code)
GROUP BY
    co.country_code
HAVING
    COUNT(ci.city_name) >= ALL(
        SELECT 
            COUNT(*)
        FROM 
            Country as co1 JOIN 
            City as ci1 using(country_code)
        GROUP BY 
            co1.country_code
        ); 
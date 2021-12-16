/**********************************************************************
 * NAME:            Zac Foteff
 * CLASS:           CPSC321: 01
 * DATE:            11/09/2021
 * HOMEWORK:        HW#7
 * DESCRIPTION:     Set of queries against the World Factbook Database
 *                  constructed during the last assignment
 **********************************************************************/
DROP TABLE IF EXISTS SymmetricBorder;

-- TODO: add queries with comments below
-- 1(a)
SELECT  
    AVG(c.gdp) as "Average GDP", AVG(c.inflation) as "Average Inflation"
FROM    
    Country as c
LIMIT 10;

-- 1(b)
SELECT  
    SUM(p.area) "Total area of all provinces in the USA", AVG(p.area) as "Average area of all provinces in the USA"
FROM    
    Country as c JOIN
    Province as p ON (c.country_code=p.country_code)
WHERE   
    (c.country_code="USA")
LIMIT 10;

-- 1(c)
SELECT  
    AVG (ci.city_population) as "Average population of cities within countries with a high GDP and low inflation"
FROM  
    Country as co JOIN
    Province as p ON (co.country_code=p.country_code) JOIN
    City as ci ON (p.province_name=ci.province_name)
WHERE   
    (co.inflation <= 4.0) and (co.gdp > 120000)
LIMIT 10;

-- 1(d)
SELECT  
    SUM(ci.city_population) as "Total population of cities within countries with a high GDP and low inflation"
FROM    
    Country as co JOIN
    Province as p ON (co.country_code=p.country_code) JOIN
    City as ci ON (p.province_name=ci.province_name)
WHERE   
    (p.area > 120000) and (co.inflation <= 4.0)
LIMIT 10;

-- 1(e)
SELECT
    AVG (ci.city_population) as "Average city population of cities in the same province, and country as Portland"
FROM
    Province as p JOIN
    City as ci ON (p.province_name=ci.province_name) JOIN
    City as Portland ON (Portland.city_name="Portland" and Portland.province_name=ci.province_name) JOIN 
    Country as co
WHERE
    (p.country_code=co.country_code)
LIMIT 10;

-- 1(f)
SELECT
    COUNT(c.country_name) as "Number of countries that border the USA"
FROM
    Country as c JOIN 
    Border as b ON (c.country_code=b.country_code_1)
WHERE
    c.country_code="USA"
LIMIT 10;

-- 1(g)
CREATE VIEW SymmetricBorder as
    (SELECT 
        b.country_code_1, b.country_code_2, b.border_length
    FROM
        Border as b)
    UNION
    (SELECT
        b.country_code_2, b.country_code_1, b.border_length
    FROM
        Border as b
    );
SELECT * FROM SymmetricBorder;

-- 1(h)
SELECT
    COUNT(*) as "Number of countries with bordering countries that have a larger inflation rate and a smaller GDP"
FROM
    Border as b JOIN 
    Country c1 ON (b.country_code_1=c1.country_code) JOIN 
    Country c2 ON (b.country_code_2=c2.country_code)
WHERE 
    (c1.inflation < c2.inflation) and (c1.gdp > c2.gdp)
LIMIT 10;

-- 1(i)
SELECT
    c1.country_code as "Country 1",
    c2.country_code as "Country 2",
    c1.inflation as "Country 1 Inflation", 
    c2.inflation as "Country 2 Inflation"
FROM
    Border as b JOIN 
    Country c1 ON (b.country_code_1=c1.country_code) JOIN 
    Country c2 ON (b.country_code_2=c2.country_code)
WHERE
    (c1.inflation < (c2.inflation - (c2.inflation * (0.1)))) and (c1.gdp > (c2.gdp - (c2.gdp * (0.2))))
ORDER BY
    c1.country_code ASC,
    c2.inflation ASC
LIMIT 10;

-- 1(j)
SELECT
    ci.city_name as "City Name",
    ci.city_population as "Population",
    p.province_name as "Province",
    co.country_name as "Country"
FROM
    Country as co JOIN 
    Province as p ON (co.country_code=p.country_code) JOIN
    City as ci ON (ci.province_name=p.province_name)
ORDER BY
    co.country_name ASC,
    p.province_name ASC,
    ci.city_name ASC,
    ci.city_population DESC
LIMIT 10;
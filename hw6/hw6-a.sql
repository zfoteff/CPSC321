/**********************************************************************
 * NAME:        Zac Foteff
 * CLASS:       CPSC321: Database Management Systems
 * DATE:        10/24/2021
 * HOMEWORK:    HW6
 * DESCRIPTION: Queries on the CIA factbook database created during HW5
 **********************************************************************/

-- Select statements for factbook table queries
-- 1(a)
SELECT * FROM Country as c WHERE (c.inflation < 5.0);

-- 1(b)
SELECT  
    p.country_code, 
    c.country_name, 
    c.inflation, 
    p.province_name, 
    c.gdp
FROM    
    Country as c, 
    Province as p
WHERE   
    (p.area < 120000) and
    (c.country_code=p.country_code) and 
    (c.inflation > 4.0);

-- 1(c)
SELECT  
    p.country_code, 
    c.country_name, 
    c.inflation, 
    p.province_name, 
    c.gdp
FROM
    Country as c JOIN Province as p ON (c.country_code=p.country_code)
WHERE
   (p.area < 120000) and (c.inflation > 4.0);

-- 1(d)
SELECT DISTINCT  
    p.country_code, 
    co.country_name, 
    p.province_name, 
    p.area
FROM    
    City as c, 
    Province as p, 
    Country as co
WHERE   
    (c.city_population > 1000) and 
    (p.country_code=co.country_code) and 
    (c.province_name=p.province_name);

-- 1(e)
SELECT DISTINCT 
    p.country_code, 
    co.country_name, 
    p.province_name, 
    p.area
FROM    
    City as c JOIN 
    Province as p ON (c.province_name=p.province_name) JOIN 
    Country as co ON (p.country_code=co.country_code)
WHERE
   (c.city_population > 1000);

-- 1(f)
SELECT DISTINCT
    p.country_code, 
    co.country_name, 
    p.province_name, 
    p.area
FROM    
    City as c1,
    City as c2,
    Province as p,
    Country as co
WHERE   
    (p.country_code=co.country_code) and 
    (c1.province_name=p.province_name) and 
    (c2.province_name=p.province_name) and
    (c1.city_population > 1000) and
    (c2.city_population > 1000);

-- 1(g)
SELECT DISTINCT
    p.country_code, 
    co.country_name, 
    p.province_name, 
    p.area
FROM
    City as c1 JOIN 
    City as c2 JOIN
    Province as p ON (p.province_name=c1.province_name and p.province_name=c2.province_name) JOIN
    Country as co ON (p.country_code=co.country_code)
WHERE   
    (c1.city_population > 1000) and
    (c2.city_population > 1000);

-- 1(h)
SELECT DISTINCT
    c1.city_name,
    c1.province_name,
    c1.country_code,
    c2.city_name,
    c2.province_name,
    c2.country_code,
    c1.city_population
FROM    
    City as c1 JOIN
    City as c2 ON (c1.city_population=c2.city_population)
WHERE   
    (c1.province_name<>c2.province_name) and (c1.country_code<>c2.country_code);

-- 1(i)
SELECT DISTINCT
    c1.country_code,
    c1.country_name
FROM    
    Country as c1,
    Country as c2,
    Border as b
WHERE   
    ((c1.inflation < 4.0) and 
    (c1.gdp > 20000000)) and
    ((c2.inflation > 4.0) and
    (c2.gdp < 20000000)) and
    (b.country_code_1=c1.country_code) and
    (b.country_code_2=c2.country_code);

-- 1(j)
SELECT DISTINCT
    c1.country_code,
    c1.country_name
FROM    
    Country as c1 JOIN
    Country as c2 ON ((c1.inflation < 4.0 and c1.gdp > 20000000) and (c2.inflation > 4.0 and c2.gdp < 20000000)) JOIN
    Border as b
WHERE   
    (b.country_code_1=c1.country_code) and
    (b.country_code_2=c2.country_code);
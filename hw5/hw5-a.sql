/**********************************************************************
* NAME: Zachary Foteff
* CLASS: CPSC321
* DATE: 10/18/2021
* HOMEWORK: 5
* DESCRIPTION:  Create and insert statements for creating a database of 
*               information regarding countries, provinces, and cities
**********************************************************************/
--  Drop table statements
DROP TABLE IF EXISTS Province;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Border;
DROP TABLE IF EXISTS Country;
--  Create table statements
CREATE TABLE Country (
    --  3 character code for a country
    country_code    VARCHAR(3) NOT NULL,
    country_name    TINYTEXT NOT NULL,
    gdp             DECIMAL(12, 2) NOT NULL,
    inflation       DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY (country_code)
);

CREATE TABLE Province (
    province_name   VARCHAR(100) NOT NULL,
    country_code    VARCHAR(4) NOT NULL,
    area            DECIMAL(11,3) UNSIGNED NOT NULL,
    PRIMARY KEY (province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES Country (country_code)
);

CREATE TABLE City (
    --  City/municipality name
    city_name       VARCHAR(100) NOT NULL,
    province_name   VARCHAR(100) NOT NULL,
    country_code    VARCHAR(4) NOT NULL,
    city_population INT UNSIGNED NOT NULL,
    PRIMARY KEY (city_name, province_name, country_code),
    FOREIGN KEY (country_code) REFERENCES Country (country_code)
);

CREATE TABLE Border (
    country_code_1  VARCHAR(4) NOT NULL,
    country_code_2  VARCHAR(4) NOT NULL,
    border_length   INT UNSIGNED NOT NULL,
    PRIMARY KEY (country_code_1, country_code_2),
    FOREIGN KEY (country_code_1) REFERENCES Country (country_code),
    FOREIGN KEY (country_code_2) REFERENCES Country (country_code)
);

-- Insert statements
--  Country insertions
INSERT INTO Country VALUES ('USA', 'UNITED STATES', 20936600.00, 5.4);
INSERT INTO Country VALUES ('MEX', 'MEXICO', 1076163000.32, 6.0);
INSERT INTO Country VALUES ('CAN', 'CANADA', 1643407000.98, 4.1);
INSERT INTO Country VALUES ('GUA', 'GUATEMALA', 77604632.17, 3.67);

--  US province insertions
INSERT INTO Province VALUES ('Oregon', 'USA', 248607.80);
INSERT INTO Province VALUES ('Washington', 'USA', 278479.97);
INSERT INTO Province VALUES ('Delaware', 'USA', 5133.36);

--  US city insertions
INSERT INTO City VALUE ('Happy Valley', 'Oregon', 'USA', 90000);
INSERT INTO City VALUE ('Eugene', 'Oregon', 'USA', 115000);
INSERT INTO City VALUE ('Portland', 'Oregon', 'USA', 150000);
INSERT INTO City VALUE ('Walla Wall', 'Washington', 'USA', 90000);
INSERT INTO City VALUE ('Spokane', 'Washington', 'USA', 115000);
INSERT INTO City VALUE ('Seattle', 'Washington', 'USA', 150000);
INSERT INTO City VALUE ('Pike Creek', 'Delaware', 'USA', 90000);
INSERT INTO City VALUE ('Arden', 'Delaware', 'USA', 115000);
INSERT INTO City VALUE ('Wilmington', 'Delaware', 'USA', 150000);

--  MEX province insertions
INSERT INTO Province VALUES ('Sinaloa', 'MEX', 2407.80);
INSERT INTO Province VALUES ('Jalisco', 'MEX', 2479.97);
INSERT INTO Province VALUES ('Tobasco', 'MEX', 5133.36);

--  MEX city insertions
INSERT INTO City VALUE ('Elota', 'Sinaloa', 'MEX', 90000);
INSERT INTO City VALUE ('Choix', 'Sinaloa', 'MEX', 115000);
INSERT INTO City VALUE ('Mocorito', 'Sinaloa', 'MEX', 150000);
INSERT INTO City VALUE ('Pihuamo', 'Jalisco', 'MEX', 90000);
INSERT INTO City VALUE ('Acatic', 'Jalisco', 'MEX', 115000);
INSERT INTO City VALUE ('San Marcos', 'Jalisco', 'MEX', 150000);
INSERT INTO City VALUE ('Villahermosa', 'Tobasco', 'MEX', 90000);
INSERT INTO City VALUE ('Cardenas', 'Tobasco', 'MEX', 115000);
INSERT INTO City VALUE ('Comalcalco', 'Tobasco', 'MEX', 150000);

--  CAN province insertions
INSERT INTO Province VALUES ('Quebec', 'CAN', 24860.80);
INSERT INTO Province VALUES ('British-Columbia', 'CAN', 2879.97);
INSERT INTO Province VALUES ('Manitoba', 'CAN', 51333.36);

--  CAN city insertions
INSERT INTO City VALUE ('Amos', 'Quebec', 'CAN', 90000);
INSERT INTO City VALUE ('Blainville', 'Quebec', 'CAN', 115000);
INSERT INTO City VALUE ('Lorraine', 'Quebec', 'CAN', 150000);
INSERT INTO City VALUE ('Delta', 'British-Columbia', 'CAN', 90000);
INSERT INTO City VALUE ('Vacouver', 'British-Columbia', 'CAN', 115000);
INSERT INTO City VALUE ('Rossland', 'British-Columbia', 'CAN', 150000);
INSERT INTO City VALUE ('Steinbach', 'Manitoba', 'CAN', 90000);
INSERT INTO City VALUE ('Thompson', 'Manitoba', 'CAN', 115000);
INSERT INTO City VALUE ('Winnipeg', 'Manitoba', 'CAN', 150000);

--  GUA province insertions
INSERT INTO Province VALUES ('Quetzaltenango', 'GUA', 24607.80);
INSERT INTO Province VALUES ('Escuintla', 'GUA', 2784.97);
INSERT INTO Province VALUES ('Zacapa', 'GUA', 5133.36);

--  GUA City insertions
INSERT INTO City VALUE ('Ostuncalco', 'Quetzaltenango', 'GUA', 90000);
INSERT INTO City VALUE ('Cantel', 'Quetzaltenango', 'GUA', 115000);
INSERT INTO City VALUE ('Zunil', 'Quetzaltenango', 'GUA', 150000);
INSERT INTO City VALUE ('Brito', 'Escuintla', 'GUA', 90000);
INSERT INTO City VALUE ('Iztapa', 'Escuintla', 'GUA', 115000);
INSERT INTO City VALUE ('Baul', 'Escuintla', 'GUA', 150000);
INSERT INTO City VALUE ('Capucal', 'Zacapa', 'GUA', 90000);
INSERT INTO City VALUE ('Caulotes', 'Zacapa', 'GUA', 115000);
INSERT INTO City VALUE ('Arenal', 'Zacapa', 'GUA', 150000);

--  Border table insertion
INSERT INTO Border VALUE ('USA', 'MEX', 3145);
INSERT INTO Border VALUE ('USA', 'CAN', 8891);
INSERT INTO Border VALUE ('MEX', 'GUA', 871);

-- Select statements (to print tables)
SELECT * FROM Country;
SELECT * FROM Province;
SELECT * FROM City;
SELECT * FROM Border;
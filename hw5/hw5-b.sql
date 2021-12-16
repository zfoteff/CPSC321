/**********************************************************************
* NAME: Zachary Foteff
* CLASS: CPSC321
* DATE: 10/18/2021
* HOMEWORK: 5
* DESCRIPTION: Create and insert stemenets for constructing a database
*              containing information about Legos and Lego sets
**********************************************************************/
--  Drop table statements
DROP TABLE IF EXISTS SetCategories;
DROP TABLE IF EXISTS PartsList;
DROP TABLE IF EXISTS LegoSets;
DROP TABLE IF EXISTS Themes;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Bricks;

--  Create table statements
CREATE TABLE Bricks (
    elem_id         INT(50) UNSIGNED NOT NULL,
    des_id          INT(50) UNSIGNED NOT NULL,
    brick_name      VARCHAR(50) NOT NULL,
    brick_color     VARCHAR(25) NOT NULL,
    price           DECIMAL(10, 2) UNSIGNED NOT NULL,
    PRIMARY KEY (elem_id, des_id)
);

CREATE TABLE Themes (
    --  Themes for a Lego set
    theme_name      VARCHAR(100) NOT NULL,
    year_start      YEAR,
    year_end        YEAR,
    license         VARCHAR(100),
    PRIMARY KEY (theme_name)
);

CREATE TABLE Categories (
    --  Categories of Lego sets
    category_name   VARCHAR(100) NOT NULL,
    age_range       VARCHAR(10),
    PRIMARY KEY (category_name)
);

CREATE TABLE LegoSets(
    --  Data representing a Lego set
    item_num        INT(50) UNSIGNED NOT NULL UNIQUE, 
    set_name        VARCHAR(100) NOT NULL,
    theme_name      VARCHAR(100) NOT NULL,
    price           DECIMAL(10, 2) UNSIGNED NOT NULL,
    minifig_count   SMALLINT NOT NULL,
    vip_points      SMALLINT NOT NULL,
    width           SMALLINT,
    heigth          SMALLINT,
    depth           SMALLINT,
    prod_start_year YEAR,
    prod_end_year   YEAR,
    PRIMARY KEY (item_num),
    FOREIGN KEY (theme_name) REFERENCES Themes (theme_name)
);

CREATE TABLE SetCategories (
    --  Table to categories mapped with set ids
    item_num        INT(50) UNSIGNED NOT NULL,
    category_name   VARCHAR(100) NOT NULL,
    PRIMARY KEY (item_num, category_name),
    FOREIGN KEY (item_num) REFERENCES LegoSets (item_num),
    FOREIGN KEY (category_name) REFERENCES Categories (category_name)
);

CREATE TABLE PartsList(
    --  A list of parts for a Lego set
    elem_id         INT(50) UNSIGNED NOT NULL,
    des_id          INT(50) UNSIGNED NOT NULL,
    item_num        INT(50) UNSIGNED NOT NULL,
    num_bricks      INT UNSIGNED,
    PRIMARY KEY (elem_id, des_id, item_num),
    FOREIGN KEY (elem_id, des_id) REFERENCES Bricks (elem_id, des_id),
    FOREIGN KEY (item_num) REFERENCES LegoSets (item_num) 
);

--  Insert statements
--  Brick insertion statements
INSERT INTO Bricks VALUES (101, 11, '2x4', 'Red', "0.22");
INSERT INTO Bricks VALUES (102, 11, '2x2', 'Green', "0.20");
INSERT INTO Bricks VALUES (101, 12, '2x4', 'Blue', "0.22");
INSERT INTO Bricks VALUES (103, 11, '4x16 Flat', 'Grey', "0.82");
INSERT INTO Bricks VALUES (104, 11, '1x4', 'Yellow', "0.32");
INSERT INTO Bricks VALUES (105, 11, '8x8 Flat', 'Black', "1.95");

--  Themes insertion statements
INSERT INTO Themes VALUES ("Star Wars", 2000, 2025, "Walt Disney Inc.");
INSERT INTO Themes VALUES ("Pirates of the Caribbean", 2004, 2025, "Walt Disney Inc.");
INSERT INTO Themes VALUES ("Lego City", NULL, NULL, NULL);
INSERT INTO Themes VALUES ("Real-World", NULL, NULL, "Various");

--  Categories insertion statements
INSERT INTO Categories VALUES ("Pirates", "8-18+");
INSERT INTO Categories VALUES ("Outer Space", "4-18+");
INSERT INTO Categories VALUES ("Movies", "4-18+");
INSERT INTO Categories VALUES ("City", "4-18+");
INSERT INTO Categories VALUES ("Real-world", "4-18+");

--  Lego Set insertion statements
INSERT INTO LegoSets VALUES (1001, "Jabba's Palace", "Star Wars", 120.00, 8, 350, 12, 6, 8, 2002, 2004);
INSERT INTO LegoSets VALUES (1002, "Space Shuttle", "Real-World", 85.50, 4, 400, 8, 3, 3, 1998, 2002);
INSERT INTO LegoSets VALUES (1003, "Captain Jack's Ship", "Pirates of the Caribbean", 75.00, 6, 350, 8, 16, 6, 2004, 2008);
INSERT INTO LegoSets VALUES (1004, "Gas Station", "Lego City", 60.00, 4, 300, 14, 12, 12, 2008, 2012);
INSERT INTO LegoSets VALUES (1005, "Lego City Minifig Pack", "Lego City", 15.00, 2, 75, NULL, NULL, NULL, 2008, 2012);

--  Set categories insertion statements
INSERT INTO SetCategories VALUES (1001, "Movies");
INSERT INTO SetCategories VALUES (1001, "Outer Space");
INSERT INTO SetCategories VALUES (1002, "Outer Space");
INSERT INTO SetCategories VALUES (1002, "Real-world");
INSERT INTO SetCategories VALUES (1003, "Pirates");
INSERT INTO SetCategories VALUES (1003, "Movies");
INSERT INTO SetCategories VALUES (1004, "City");
INSERT INTO SetCategories VALUES (1004, "Real-world");
INSERT INTO SetCategories VALUES (1005, "City");
INSERT INTO SetCategories VALUES (1005, "Real-world");

--  Part list insertion statements
INSERT INTO PartsList VALUES (101, 11, 1001, 75);
INSERT INTO PartsList VALUES (101, 12, 1001, 45);
INSERT INTO PartsList VALUES (102, 11, 1001, 905);
INSERT INTO PartsList VALUES (103, 11, 1001, 75);
INSERT INTO PartsList VALUES (104, 11, 1001, 100);
INSERT INTO PartsList VALUES (105, 11, 1001, 185);

--  Select statements (to print tables)
SELECT * FROM Bricks;
SELECT * FROM LegoSets;
SELECT * FROM Categories;
SELECT * FROM SetCategories;
SELECT * FROM Themes;
SELECT * FROM PartsList;
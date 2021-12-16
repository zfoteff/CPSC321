/**********************************************************************
 * NAME:         Zachary Foteff
 * CLASS:        CPSC321: Database Management Systems
 * DATE:         11/11/2021
 * HOMEWORK:     Final Project
 * DESCRIPTION:  Initial schema for DBMS final project   
 **********************************************************************/

-- Drop table statements
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Users;

-- Create table statements
CREATE TABLE Users (
    u_id        INT NOT NULL UNIQUE, 
    username    VARCHAR(100),
    PRIMARY KEY (u_id)
);

CREATE TABLE Accounts (
    --  Accounts id
    a_id        INT NOT NULL UNIQUE,
    -- Accounts name
    a_name      VARCHAR(100) NOT NULL,
    --  User id
    u_id        INT NOT NULL,
    PRIMARY KEY (a_id),
    FOREIGN KEY (u_id) REFERENCES Users(u_id) ON DELETE CASCADE
);

CREATE TABLE Transactions (
    --  Transaction id
    t_id        INT UNIQUE NOT NULL AUTO_INCREMENT,
    --  Transaction tag
    tag         VARCHAR(100) NOT NULL,
    --  Accounts --> Accounts ID 
    a_id        INT NOT NULL,
    --  Transaction amount
    amount      DECIMAL(10,2) NOT NULL,
    --  Transaction year
    t_month      INT NOT NULL,
    --  Transaction month
    t_day     INT NOT NULL,
    --  Transaction day
    t_year      INT NOT NULL,
    --  Transaction time
    t_time      VARCHAR(8) NOT NULL,
    --  Transaction description
    t_desc VARCHAR(255),
    PRIMARY KEY (t_id),
    FOREIGN KEY (a_id) REFERENCES Accounts(a_id) ON DELETE CASCADE
);

-- Insert statements
INSERT INTO Users VALUES (101, 'Zac');
INSERT INTO Users VALUES (102, 'Austin');
INSERT INTO Users VALUES (103, 'Lola');
INSERT INTO Users VALUES (104, 'Sadie');

INSERT INTO Accounts VALUES(1001, 'School Expenses', 101);
INSERT INTO Accounts VALUES(1002, 'Work Expenses', 101);
INSERT INTO Accounts VALUES(1003, 'Gas Expenses', 101);
INSERT INTO Accounts VALUES(1004, 'School expenses', 102);
INSERT INTO Accounts VALUES(1005, 'Team Expenses', 103);
INSERT INTO Accounts VALUES(1006, 'Misc. Expenses', 104);

INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Project Supplies', 1001, 320.00, 2021,8,12, "08:15:32","Expenses for CPSC312 final project");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Project Supplies', 1001, 46.95, 2020,10,19, "12:00:03", "Expenses for CPSC321 final project");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Project Supplies', 1001, 320.00, 2021,11,12, "08:15:32","Pizza party");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Project Supplies', 1001, 46.95, 2021,10,1, "12:00:03", "Hosting resources for Senior design project");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Parking fines', 1006, 50.00, 2021,6,14, "16:15:32", "Fine recieved on crossing of Sharp and Standard");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Gas', 1003, 60.00, 2021,8,12, "08:15:32","Gas purchase at ARCO");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Tuition', 1001, 8600.95, 2017,1,12, "12:00:03", "Tuition fee");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Startup fees', 1002, 1005.00, 2021,6,14, "16:15:32", "Fees invested in a startup");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Salary', 1002, 32000.00, 2021,1,8, "12:00:01","Salary for pay period");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Travel', 1005, 146.95, 2018,10,19, "17:41:43", "Bus rental fee for team bus");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Misc. Purchases', 1006, 499.00, 2021,6,14, "16:15:32", "New XBOX");
INSERT INTO Transactions (tag, a_id,amount, t_year, t_month, t_day, t_time, t_desc) VALUES('Misc. Purchases', 1001, 4.90, 2019,1,9, "16:15:32", "Coffee");

-- Select statements
SELECT * FROM Users;
SELECT * FROM Accounts;
SELECT * FROM Transactions;


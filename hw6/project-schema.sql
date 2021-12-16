/**********************************************************************
 * NAME:         Zachary Foteff
 * CLASS:        CPSC321: Database Management Systems
 * DATE:         10/24/2021
 * HOMEWORK:     Final Project
 * DESCRIPTION:  Initial schema for DBMS final project   
 **********************************************************************/

-- Drop table statements
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Users;

-- Create table statements
CREATE TABLE Users (
    u_id        INT NOT NULL UNIQUE, 
    username    VARCHAR(100),
    PRIMARY KEY (u_id)
);

CREATE TABLE Account (
    --  Account id
    a_id        INT NOT NULL UNIQUE,
    -- Account name
    a_name      VARCHAR(100) NOT NULL,
    --  User id
    u_id        INT NOT NULL,
    PRIMARY KEY (a_id),
    FOREIGN KEY (u_id) REFERENCES Users(u_id)
);

CREATE TABLE Transactions (
    --  Transaction id
    t_id        INT NOT NULL,
    --  Transaction tag
    tag         VARCHAR(100) NOT NULL,
    --  Account --> Account ID 
    a_id        INT NOT NULL,
    --  Transaction amount
    amount      DECIMAL(10,2) NOT NULL,
    --  Transaction timestamp
    timestamp   VARCHAR(100) NOT NULL,
    --  Transaction description
    t_desc VARCHAR(255),
    PRIMARY KEY (t_id),
    FOREIGN KEY (a_id) REFERENCES Account(a_id) 
);

-- Insert statements
INSERT INTO Users VALUES (101, 'Zac');
INSERT INTO Users VALUES (102, 'Austin');
INSERT INTO Users VALUES (103, 'Lola');
INSERT INTO Users VALUES (104, 'Sadie');

INSERT INTO Account VALUES(1001, 'School Expenses', 101);
INSERT INTO Account VALUES(1002, 'Work Expenses', 101);
INSERT INTO Account VALUES(1003, 'Gas Expenses', 101);
INSERT INTO Account VALUES(1004, 'School expenses', 102);
INSERT INTO Account VALUES(1005, 'Team Expenses', 103);
INSERT INTO Account VALUES(1006, 'Misc. Expenses', 104);

INSERT INTO Transactions VALUES(1, 'Project Supplies', 1001, 320.00, "08/12/21 08:15:32","Expenses for CPSC312 final project");
INSERT INTO Transactions VALUES(2, 'Project Supplies', 1001, 46.95, "10/19/20 12:00:03", "Expenses for CPSC321 final project");
INSERT INTO Transactions VALUES(3, 'Parking fines', 1006, 50.00, "06/14/21 16:15:32", "Fine recieved on crossing of Sharp and Standard");
INSERT INTO Transactions VALUES(4, 'Gas', 1003, 60.00, "08/12/21 08:15:32","Gas purchase at ARCO");
INSERT INTO Transactions VALUES(5, 'Project Supplies', 1001, 86.95, "1/12/17 12:00:03", "Expenses for CPSC314 final project");
INSERT INTO Transactions VALUES(6, 'Startup fees', 1002, 1005.00, "06/14/21 16:15:32", "Fees invested in a startup");
INSERT INTO Transactions VALUES(7, 'Salary', 1004, 32000.00, "08/1/21 12:00:01","Salary for pay period");
INSERT INTO Transactions VALUES(8, 'Travel', 1005, 146.95, "10/19/18 17:41:43", "Bus rental fee for team bus");
INSERT INTO Transactions VALUES(9, 'Misc. Purchases', 1006, 499.00, "06/14/21 16:15:32", "New XBOX");

-- Select statements
SELECT * FROM Users;
SELECT * FROM Account;
SELECT * FROM Transactions;


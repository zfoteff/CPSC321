/**********************************************************************
 * NAME:         Zachary Foteff
 * CLASS:        CPSC321: Database Management Systems
 * DATE:         11/11/2021
 * HOMEWORK:     Final Project
 * DESCRIPTION:  Queries against initial schema for final project   
 **********************************************************************/
-- 1
-- List all transactions for account 1001 with the Project Supplies tag 
SELECT
    a.a_id as "Account ID",
    a.a_name as "Account name",
    t.amount as "Amount",
    t.t_desc as "Description"
FROM
    Accounts as a JOIN 
    Transactions as t ON (a.a_id=t.a_id)
WHERE
    t.tag="Project Supplies"
ORDER BY 
    t.t_year DESC;

-- 2
-- List the total expenses of each account for user 101
SELECT 
    a.a_name as "Account Name", 
    SUM(t.amount) as "Total Expenses"
FROM
    Users as u JOIN
    Accounts as a ON (u.u_id=a.u_id) JOIN 
    Transactions as t ON (t.a_id=a.a_id)
WHERE
    (u.u_id=101)
GROUP BY 
    a.a_name;

-- 3
-- Get the total expenses of all transactions with the Project Supplies tag from user 101, ordered by year
SELECT
    t.t_year as "Year",
    SUM(t.amount) as "Total Expenses"
FROM
    Users as u JOIN 
    Accounts as a ON (u.u_id=a.u_id) JOIN
    Transactions as t ON (t.a_id=a.a_id)
WHERE
    (t.tag="Project Supplies") and (u.u_id=101)
GROUP BY 
    t.t_year DESC;

-- 4
-- Get a list of all transactions linked to user 101 ordered by year (descending)
SELECT
    t.t_year as "Year",
    u.u_id as "User ID",
    u.username as "Username",
    a.a_name as "User account",
    t.t_id as "Transaction ID",
    t.amount as "Amount",
    t.t_desc as "Description"
FROM
    Users as u JOIN
    Accounts as a ON (u.u_id=a.u_id) JOIN
    Transactions as t ON (a.a_id=t.a_id)
WHERE
    (u.u_id=101)
ORDER BY
    t.t_year DESC,
    t.t_id ASC;

-- 5
-- Count all large transactions (amount > $100) under each tag
SELECT
    t.tag as "Tag",
    COUNT(t.t_id) as "Num Large Transactions",
    SUM(t.amount) as "Sum of Large Transactions"
FROM 
    Transactions as t
WHERE
    (t.amount>100)
GROUP BY
    t.tag;
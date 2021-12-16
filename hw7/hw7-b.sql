/**********************************************************************
 * NAME:            Zac Foteff
 * CLASS:           CPSC321: 01
 * DATE:            11/09/2021
 * HOMEWORK:        HW#7
 * DESCRIPTION:     5 interesting queries against the cpsc321 database
 **********************************************************************/

-- 2(a)
-- Find the price and customer id associated with all rentals that have not been returned yet
SELECT
    r.rental_date as "Rental Data",
    p.amount as "Payment ($)",
    p.customer_id as "Customer ID"
FROM
    payment as p JOIN 
    rental as r ON (p.rental_id=r.rental_id and p.customer_id=r.customer_id)
WHERE
    r.return_date is NULL
ORDER BY
    r.rental_date ASC
LIMIT 10;


-- 2(b)
-- Find the total cost of all rentals for the film id 32 "APOCALYPSE FLAMINGOS"
SELECT  
    SUM(p.amount) as "Total cost of all rentals for the film APOCALYPSE FLAMINGOS"
FROM
    film as f JOIN 
    inventory as i ON (f.film_id=i.film_id) JOIN
    rental as r ON (r.inventory_id=i.inventory_id) JOIN
    payment as p ON (r.rental_id=p.rental_id)
WHERE
    (f.film_id=32)
LIMIT 10;


-- 2(c)
-- Find total replacement cost for all late rentals at store #1
SELECT 
    SUM(f.replacement_cost) as "Total replacement cost of late films at store #1"
FROM 
    store as s JOIN 
    inventory as i ON (i.store_id=s.store_id) JOIN 
    rental as r ON (i.inventory_id=r.inventory_id) JOIN 
    film as f ON (i.film_id=f.film_id)
WHERE
    (s.store_id=1) and (r.return_date is NULL)
LIMIT 10;


-- 2(d)
-- Find all inactive customers who belong to store 2 ordered by last_update
SELECT
    --  Customer id, customer name, store, last_update
    c.customer_id as "Customer ID",
    c.first_name as "Customer Name",
    s.store_id as "Store",
    c.last_update as "Last Update"
FROM
    customer as c JOIN 
    store as s ON (c.store_id=s.store_id)
WHERE
    (c.active=0) and (c.store_id=2)
ORDER BY
    c.last_update DESC
LIMIT 10;


-- 2(e)
-- Get the username and password associated with the emails of all active employees
SELECT
    s.email as "Staff Email",
    s.username as "Username",
    s.password as "Password",
    st.store_id as "Active store"
FROM 
    staff as s JOIN 
    store as st ON(s.store_id=st.store_id)
WHERE
    (s.active=1)
LIMIT 10;
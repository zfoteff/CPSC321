/**********************************************************************
 * NAME:            Zac Foteff
 * CLASS:           CPSC321: 01
 * DATE:            11/23/2021
 * HOMEWORK:        HW#8
 * DESCRIPTION:     Set of advanced queries against the class movie 
 *                  rental database
 **********************************************************************/
use cpsc321;

-- 2(a)
-- Find total number of films by category, descending
SELECT
    c.name as "Category",
    COUNT(f.film_id) as "Number of Movies"
FROM
    category as c JOIN 
    film_category as f USING (category_id)
GROUP BY
    c.name
ORDER BY
    COUNT(f.film_id) DESC;

-- 2(b)
-- Find first and last names of customers that have rented >= 4 PG rated films that cost 
-- 2.99, organized by number of films rented, descending
SELECT
    c.first_name as "First name",
    c.last_name as "Last name",
    COUNT(*) as "Number of $2.99 PG Films Rented"
FROM
    customer as c JOIN 
    rental as r USING (customer_id) JOIN
    inventory as i USING (inventory_id) JOIN 
    film as f USING (film_id) JOIN
    payment as p ON (r.rental_id=p.rental_id)
WHERE
    (p.amount=2.99) and (f.rating="PG")
GROUP BY
    c.customer_id
ORDER BY
    COUNT(f.film_id) DESC
LIMIT 10;

-- 2(c)
-- Find all G rated movies that have been rented for the largest amount across all rentals
SELECT 
    f.title as "Film title",
    p.amount as "Crazy High Rental Price"
FROM
    film as f JOIN
    inventory as i USING (film_id) JOIN
    rental as r USING (inventory_id) JOIN
    payment as p USING (rental_id)
WHERE
    (f.rating="G") and p.amount >= ALL (
        SELECT 
            p0.amount
        FROM 
            film as f0 JOIN
            inventory as i0 USING (film_id) JOIN
            rental as r0 USING (inventory_id) JOIN
            payment as p0 USING (rental_id)
        WHERE
            (f0.rating="G")
        GROUP BY 
            f.film_id
    )
GROUP BY 
    f.film_id;

-- 2(d)
-- Find film category with the most number of PG rated films
SELECT 
    c.name as "Category",
    COUNT(*) as "Number of PG Rated Films"
FROM
    category as c JOIN 
    film_category USING (category_id) JOIN
    film as f USING (film_id)
WHERE
    (f.rating="PG")
GROUP BY
    c.category_id
HAVING 
    COUNT(*) >= ALL (
        SELECT 
            COUNT(*)
        FROM
            category as c0 JOIN 
            film_category USING (category_id) JOIN
            film as f0 USING (film_id)
        WHERE
            (f0.rating="PG")
        GROUP BY
            c0.category_id
    );

-- 2(e)
-- Find G rated films that have ben rented at a higher than average amount
SELECT 
    title as "Title",
    COUNT(*) as "Number of rentals"
FROM
    film as f JOIN
    inventory USING (film_id) JOIN
    rental USING (inventory_id)
WHERE
    (f.rating="G")
GROUP BY 
    f.film_id
HAVING 
    COUNT(*) >= ALL(
        SELECT
            COUNT(*)
        FROM
            film as f0 JOIN
            inventory USING (film_id) JOIN
            rental USING (inventory_id)
        WHERE
            (f0.rating="G")
        GROUP BY 
            f0.film_id
    );

-- 2(f)
-- Find actors/actresses that have never acted in a G rated film
SELECT
    first_name as "First Name",
    last_name as "Last Name"
FROM
    actor 
WHERE
    actor_id NOT IN (
        --  Find all actors that have acted in G rated films
        SELECT 
            a.actor_id
        FROM
            actor as a JOIN
            film_actor USING (actor_id) JOIN
            film as f USING (film_id) 
        WHERE
            (f.rating="G")
    );

-- 2(g)
-- Find the films that every store carries
SELECT DISTINCT
    f.title as "Film Title"
FROM
    store as s JOIN 
    inventory as i USING (store_id) JOIN
    film as f USING (film_id)
WHERE
    f.title IN (
        -- Find all films in stores that are not the original store
        SELECT
            f0.title
        FROM
            store as s0 JOIN
            inventory as i0 USING (store_id) JOIN
            film as f0 using (film_id)
        WHERE
            s0.store_id<>s.store_id
        ORDER BY
            s0.store_id
    )
ORDER BY
    s.store_id
LIMIT 10;

-- 2(h)
-- Find the % of G rated movies each actor has acted in 
SELECT
    a.first_name as "First name",
    a.last_name as "Last name",
    (   SELECT 
            COUNT(*)
        FROM
            actor a0 JOIN 
            film_actor USING (actor_id) 
            JOIN film as f0 USING (film_id)
        WHERE
            (f0.rating="G")
    ) / (COUNT(*) * 100.0) as "Percentage"
FROM
    actor a JOIN
    film_actor USING (actor_id) JOIN
    film f USING (film_id)
GROUP BY
    f.film_id
LIMIT 10;

-- 2(i)
-- Find all film titles that have no actors
SELECT
    f.title as "Title with no actors"
FROM
    actor a JOIN
    film_actor USING (actor_id) RIGHT OUTER JOIN
    film f USING (film_id)
GROUP BY
    f.film_id
HAVING
    COUNT(a.actor_id)=0;

-- 2(f)
-- Find all film titles that are in a store's inventory, but haven't been rented
SELECT 
    f.title as "Title's in inventory that haven't been rented"
FROM
    rental as r RIGHT OUTER JOIN 
    inventory as i USING (inventory_id) JOIN 
    film as f USING (film_id)
WHERE
    (r.rental_date is NULL) and (r.return_date is NULL);

-- 2(h)
-- Find number of actors that acted in each film 
SELECT 
    f.film_id as "Film ID", 
    COUNT(a.actor_id) as "Number of Actors"
FROM
    actor a JOIN 
    film_actor USING (actor_id) RIGHT OUTER JOIN
    film f using (film_id)
GROUP BY
    f.film_id
limit 10;
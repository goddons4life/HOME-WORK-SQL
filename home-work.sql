-- Question 1a
SELECT  first_name,last_name FROM actor;
-- Question 1b	
SELECT CONCAT(first_name,",",last_name) AS "Actor Name"
FROM actor;
-- Question 2a
SELECT actor_id,last_name 

FROM actor 
WHERE  first_name = "Joe";
    -- Question 2b
  SELECT  last_name
  FROM actor
  WHERE last_name like "%GEN%";
  -- Qustion 2c
  SELECT last_name,first_name
  FROM actor
  WHERE last_name like "%LI%"
  ORDER BY last_name ASC, first_name ASC;
  -- Question 2d
  SELECT country_id,country
  FROM country
  WHERE country IN("Afghanistan","Bangladesh", "China");
   -- Question 3a
   ALTER TABLE actor ADD COLUMN descriptions BLOB;
   -- check data type
   SELECT column_name,
        data_type
FROM information_schema.columns
WHERE table_name = 'actor';
-- Question 3b
ALTER TABLE actor DROP COLUMN descriptions;
-- Question 4a
  SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;
-- Question 4b
SELECT last_name, COUNT(last_name) as "names_count"
FROM actor
GROUP BY  last_name
HAVING names_count > 1;
-- Question 4c
UPDATE actor SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
-- Question4d
SELECT actor_id
FROM actor
WHERE first_name = 'HARPO'
        AND last_name = 'WILLIAMS';
UPDATE actor SET first_name =
    CASE
    WHEN first_name = 'HARPO' THEN
    'GROUCHO'
    WHEN first_name = 'GROUCHO' THEN
    'MUCHO GROUCHO'
    ELSE first_name
    END
WHERE actor_id = 172;

-- Question 5a
CREATE TABLE IF NOT EXISTS address ( address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT, address varchar(50) NOT NULL, address2 varchar(50) DEFAULT NULL, district varchar(20) NOT NULL, city_id smallint(5) unsigned NOT NULL, postal_code varchar(10) DEFAULT NULL, phone varchar(20) NOT NULL, location geometry NOT NULL, last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (address_id), KEY idx_fk_city_id (city_id), SPATIAL KEY idx_location(location), CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- Question 6a
SELECT s.first_name,s.last_name,a.address
FROM staff s
LEFT JOIN address a
ON s.address_id = a.address_id;

-- Question6b
SELECT staff.first_name, staff.last_name, 
SUM(payment.amount) AS revenue_received FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id 
WHERE payment.payment_date LIKE '2005-08%' 
GROUP BY payment.staff_id;
-- Question6c
-- Use inner join. 
SELECT title, COUNT(actor_id) AS number_of_actors 
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id 
GROUP BY title;
-- Question 6d
SELECT f.title,
COUNT(i.inventory_id) AS number_of_copies
FROM film f
JOIN inventory i
    ON f.film_id = i.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY  f.title;
-- Question 6e
SELECT c.last_name,
COUNT(p.amount) AS amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY  c.last_name
ORDER BY  c.last_name ASC;
-- Question 7a
SELECT title FROM film 
WHERE language_id 
IN (SELECT language_id FROM language WHERE name = "English" ) AND (title LIKE "K%") OR (title LIKE "Q%");
-- Question 7b
SELECT first_name, last_name FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor 
    WHERE film_id = (
		SELECT film_id FROM film 
        WHERE title = "Alone Trip"));
-- Question 7c
SELECT c.last_name,
         c.first_name,
         c.email
FROM customer c
JOIN address a
    ON c.address_id = a.address_id
JOIN city ci
    ON a.city_id = ci.city_id
JOIN country co
    ON ci.country_id = co.country_id
WHERE country = 'Canada'
ORDER BY  last_name ASC;
-- Question 7d
SELECT title
FROM film f
JOIN film_category fc
    ON f.film_id = fc.film_id
JOIN category c
    ON fc.category_id = c.category_id
WHERE c.category_id = 8;
-- Question 7e
SELECT f.title, COUNT(f.title) AS rent_count
FROM rental AS r
INNER JOIN inventory AS i
    ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
    ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rent_count DESC;
-- Question 7f
SELECT str.store_id,
         SUM(p.amount) AS total_sales
FROM store str
JOIN staff stf
ON str.store_id = stf.store_id
JOIN payment p
ON stf.staff_id = p.staff_id
GROUP BY  str.store_id;
-- Quetion 7g
SELECT s.store_id, a.address, cy.city, co.country
FROM store AS s
INNER JOIN address AS a
ON s.address_id = a.address_id
INNER JOIN city AS cy
ON cy.city_id = a.city_id
INNER JOIN country AS co
ON co.country_id = cy.country_id;
-- Question 7h
SELECT c.name,
         SUM(p.amount) AS gross_revenue
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY  c.name
ORDER BY  gross_revenue DESC limit 5;
-- Question 8a
CREATE OR REPLACE VIEW top_five_grossing_genres AS
SELECT c.name,
         SUM(p.amount) AS gross_revenue
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY  c.name
ORDER BY  gross_revenue DESC limit 5;
-- Question 8b
SELECT * FROM top_five_grossing_genres;
-- Question 8c
DROP VIEW top_five_grossing_genres;
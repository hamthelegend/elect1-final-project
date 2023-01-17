USE video_town;

DROP PROCEDURE IF EXISTS customers;

CREATE PROCEDURE customers()
BEGIN
    SELECT * FROM customers;
END;

DROP PROCEDURE IF EXISTS customer;

CREATE PROCEDURE customer(_customer_id BIGINT)
BEGIN
    SELECT * FROM customers WHERE customer_id = _customer_id;
END;

DROP PROCEDURE IF EXISTS employees;

CREATE PROCEDURE employees()
BEGIN
    SELECT * FROM employees;
END;

DROP PROCEDURE IF EXISTS employee;

CREATE PROCEDURE employee(_employee_id BIGINT)
BEGIN
    SELECT * FROM employees WHERE employee_id = _employee_id;
END;

DROP PROCEDURE IF EXISTS genres;

CREATE PROCEDURE genres()
BEGIN
    SELECT * FROM genres;
END;

DROP PROCEDURE IF EXISTS genre;

CREATE PROCEDURE genre(_genre_id BIGINT)
BEGIN
    SELECT * FROM genres WHERE genre_id = _genre_id;
END;

DROP PROCEDURE IF EXISTS movies;

CREATE PROCEDURE movies()
BEGIN
    SELECT movie_id,
           title,
           release_date,
           director,
           g.genre_id,
           tag AS genre,
           aisle_number
    FROM movies m
             JOIN genres g ON g.genre_id = m.genre_id
    ORDER BY movie_id;
END;

DROP PROCEDURE IF EXISTS movie;

CREATE PROCEDURE movie(_movie_id BIGINT)
BEGIN
    SELECT movie_id,
           title,
           release_date,
           director,
           g.genre_id,
           tag AS genre,
           aisle_number
    FROM movies m
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE movie_id = _movie_id;
END;

DROP PROCEDURE IF EXISTS copies;

CREATE PROCEDURE copies(_movie_id BIGINT)
BEGIN
    SELECT copy_id,
           medium_format,
           cost,
           NOT is_copy_borrowed(copy_id) AS isAvailable,
           remarks,
           m.movie_id,
           title,
           aisle_number
    FROM copies c
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE m.movie_id = _movie_id
    ORDER BY copy_id;
END;

DROP PROCEDURE IF EXISTS copy;

CREATE PROCEDURE copy(_copy_id BIGINT)
BEGIN
    SELECT copy_id,
           medium_format,
           cost,
           NOT is_copy_borrowed(copy_id) AS isAvailable,
           remarks,
           m.movie_id,
           title,
           release_date,
           director,
           g.genre_id,
           tag                           AS genre,
           aisle_number
    FROM copies c
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE copy_id = _copy_id;
END;

DROP PROCEDURE IF EXISTS transactions;

CREATE PROCEDURE transactions()
BEGIN
    SELECT t.transaction_id,
           c.customer_id                          AS customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer,
           e.employee_id                          AS cashier_employee_id,
           CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
           time_processed,
           is_return,
           GROUP_CONCAT(title)                    AS items,
           is_closed
    FROM transactions t
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN employees e ON e.employee_id = t.cashier_employee_id
             JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
             JOIN copies cp ON tc.copy_id = cp.copy_id
             JOIN movies m ON cp.movie_id = m.movie_id
    GROUP BY transaction_id;
END;

DROP PROCEDURE IF EXISTS transactions_by_customer;
CREATE PROCEDURE transactions_by_customer(_customer_id BIGINT)
BEGIN
        SELECT t.transaction_id,
           c.customer_id                          AS customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer,
           e.employee_id                          AS cashier_employee_id,
           CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
           time_processed,
           is_return,
           GROUP_CONCAT(title)                    AS items,
           is_closed
    FROM transactions t
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN employees e ON e.employee_id = t.cashier_employee_id
             JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
             JOIN copies cp ON tc.copy_id = cp.copy_id
             JOIN movies m ON cp.movie_id = m.movie_id
    WHERE c.customer_id = _customer_id
    GROUP BY transaction_id;
END;

DROP PROCEDURE IF EXISTS rent_transactions;

CREATE PROCEDURE rent_transactions()
BEGIN
    SELECT t.transaction_id,
           c.customer_id                          AS customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer,
           e.employee_id                          AS cashier_employee_id,
           CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
           time_processed,
           is_return,
           GROUP_CONCAT(title)                    AS items,
           SUM(cp.cost)                           AS totalCost,
           is_closed
    FROM transactions t
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN employees e ON e.employee_id = t.cashier_employee_id
             JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
             JOIN copies cp ON tc.copy_id = cp.copy_id
             JOIN movies m ON cp.movie_id = m.movie_id
    WHERE NOT is_return
    GROUP BY transaction_id;
END;

DROP PROCEDURE IF EXISTS return_transactions;

CREATE PROCEDURE return_transactions()
BEGIN
    SELECT t.transaction_id,
           c.customer_id                          AS customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer,
           e.employee_id                          AS cashier_employee_id,
           CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
           time_processed,
           is_return,
           GROUP_CONCAT(title)                    AS items,
           is_closed
    FROM transactions t
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN employees e ON e.employee_id = t.cashier_employee_id
             JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
             JOIN copies cp ON tc.copy_id = cp.copy_id
             JOIN movies m ON cp.movie_id = m.movie_id
    WHERE is_return
    GROUP BY transaction_id;
END;

DROP PROCEDURE IF EXISTS transaction;

CREATE PROCEDURE transaction(_transaction_id BIGINT)
BEGIN
    DECLARE _is_return BOOL;

    SELECT is_return FROM transactions WHERE transaction_id = _transaction_id INTO _is_return;

    IF _is_return THEN
        SELECT t.transaction_id,
               c.customer_id                          AS customer_id,
               CONCAT(c.first_name, ' ', c.last_name) AS customer,
               e.employee_id                          AS cashier_employee_id,
               CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
               time_processed,
               _is_return,
               GROUP_CONCAT(title)                    AS items,
               is_closed
        FROM transactions t
                 JOIN customers c ON c.customer_id = t.customer_id
                 JOIN employees e ON e.employee_id = t.cashier_employee_id
                 JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
                 JOIN copies cp ON tc.copy_id = cp.copy_id
                 JOIN movies m ON cp.movie_id = m.movie_id
        WHERE t.transaction_id = _transaction_id
        GROUP BY transaction_id;
    ELSE
        SELECT t.transaction_id,
               c.customer_id                          AS customer_id,
               CONCAT(c.first_name, ' ', c.last_name) AS customer,
               e.employee_id                          AS cashier_employee_id,
               CONCAT(e.first_name, ' ', e.last_name) AS cashier_employee,
               time_processed,
               is_return,
               GROUP_CONCAT(title)                    AS items,
               SUM(cp.cost)                           AS totalCost,
               is_closed
        FROM transactions t
                 JOIN customers c ON c.customer_id = t.customer_id
                 JOIN employees e ON e.employee_id = t.cashier_employee_id
                 JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
                 JOIN copies cp ON tc.copy_id = cp.copy_id
                 JOIN movies m ON cp.movie_id = m.movie_id
        WHERE t.transaction_id = _transaction_id
        GROUP BY transaction_id;
    END IF;
END;

DROP PROCEDURE IF EXISTS transaction_contents;

CREATE PROCEDURE transaction_contents(_transaction_id BIGINT)
BEGIN
    SELECT transaction_id,
           transaction_content_id,
           c.copy_id,
           medium_format,
           cost,
           m.movie_id,
           title AS movie,
           release_date
    FROM transaction_contents tc
             JOIN copies c ON c.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = c.movie_id
    WHERE transaction_id = _transaction_id;
END;

DROP PROCEDURE IF EXISTS copies_rented_by_month;

CREATE PROCEDURE copies_rented_by_month(year INT)
BEGIN
    SELECT MONTH(time_processed)            AS month,
           COUNT(tc.transaction_content_id) AS copies_rented,
           SUM(c.cost)                      AS revenue
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN copies c ON c.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = c.movie_id
    WHERE NOT is_return
      AND YEAR(time_processed) = year
    GROUP BY MONTH(time_processed);
END;

DROP PROCEDURE IF EXISTS top_five_movies_from_genre_by_copies_rented;

CREATE PROCEDURE top_five_movies_from_genre_by_copies_rented(_genre_id BIGINT)
BEGIN
    SELECT m.movie_id,
           m.title,
           COUNT(tc.transaction_content_id) AS copies_rented
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN copies c ON c.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE NOT is_return
      AND g.genre_id = _genre_id
    GROUP BY m.movie_id
    ORDER BY copies_rented DESC
    LIMIT 5;
END;

DROP PROCEDURE IF EXISTS top_five_movies_from_genre_by_revenue;

CREATE PROCEDURE top_five_movies_from_genre_by_revenue(_genre_id BIGINT)
BEGIN
    SELECT m.movie_id,
           m.title,
           COUNT(tc.transaction_content_id) AS copiesRented,
           SUM(cost)                        AS totalRevenue
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN copies c ON c.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE NOT is_return
      AND g.genre_id = _genre_id
    GROUP BY m.movie_id
    ORDER BY totalRevenue DESC
    LIMIT 5;
END;

DROP PROCEDURE IF EXISTS top_ten_movies_by_revenue;
CREATE PROCEDURE top_ten_movies_by_revenue()
BEGIN
    SELECT m.movie_id,
           m.title,
           COUNT(tc.transaction_content_id) AS copiesRented,
           SUM(cost)                        AS totalRevenue
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN copies c ON c.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = c.movie_id
    WHERE NOT t.is_return
    GROUP BY m.movie_id
    ORDER BY totalRevenue DESC
    LIMIT 10;
END;

DROP PROCEDURE IF EXISTS customers_by_month;
CREATE PROCEDURE customers_by_month(_year INT)
BEGIN
    WITH cte
             AS (SELECT MONTH(t.time_processed)          AS month,
                        c.customer_id,
                        CONCAT(c.first_name, ' ', c.last_name) AS customer,
                        COUNT(tc.transaction_content_id) AS movies_rented
                 FROM transaction_contents tc
                          JOIN transactions t ON t.transaction_id = tc.transaction_id
                          JOIN customers c ON c.customer_id = t.customer_id
                 WHERE YEAR(time_processed) = _year
                   AND NOT is_return
                 GROUP BY month, c.customer_id)
    SELECT *
    FROM cte;

END;

DROP PROCEDURE IF EXISTS top_customers_by_month;
CREATE PROCEDURE top_customers_by_month(_year INT)
BEGIN
    WITH cte
             AS (SELECT MONTH(t.time_processed)                AS month,
                        c.customer_id,
                        CONCAT(c.first_name, ' ', c.last_name) AS customer,
                        COUNT(tc.transaction_content_id)       AS movies_rented
                 FROM transaction_contents tc
                          JOIN transactions t ON t.transaction_id = tc.transaction_id
                          JOIN customers c ON c.customer_id = t.customer_id
                 WHERE YEAR(time_processed) = _year
                   AND NOT is_return
                 GROUP BY month, c.customer_id)
    SELECT t1.month,
           t1.customer_id,
           t1.customer,
           t1.movies_rented
    FROM cte t1
             INNER JOIN (SELECT month,
                                MAX(movies_rented) AS max_rented
                         FROM cte
                         GROUP BY month) t2
                        ON t1.month = t2.month AND t1.movies_rented = t2.max_rented
    ORDER BY t1.month;

END;

DROP PROCEDURE IF EXISTS best_employee_by_year;
CREATE PROCEDURE best_employee_by_year()
BEGIN
    WITH cte
             AS (SELECT YEAR(t.time_processed)                 AS year,
                        e.employee_id,
                        CONCAT(e.first_name, ' ', e.last_name) AS employee,
                        SUM(cost)                              AS revenue
                 FROM transaction_contents tc
                          JOIN transactions t ON t.transaction_id = tc.transaction_id
                          JOIN employees e ON e.employee_id = t.cashier_employee_id
                          JOIN copies c ON c.copy_id = tc.copy_id
                 WHERE NOT is_return
                 GROUP BY year, e.employee_id)
    SELECT t1.year,
           t1.employee_id,
           t1.employee,
           t1.revenue
    FROM cte t1
             INNER JOIN (SELECT year,
                                MAX(revenue) AS max_revenue
                         FROM cte
                         GROUP BY year) t2
                        ON t1.year = t2.year AND t1.revenue = t2.max_revenue
    ORDER BY t1.year;
END;

DROP PROCEDURE IF EXISTS unreturned_copies;
CREATE PROCEDURE unreturned_copies()
BEGIN
    SELECT cp.copy_id,
           medium_format,
           cost,
           c.customer_id AS borrower_customer_id,
           CONCAT(first_name, ' ', last_name) AS borrower,
           remarks,
           m.movie_id,
           title,
           aisle_number
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN copies cp ON cp.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = cp.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE is_copy_borrowed(cp.copy_id)
    ORDER BY copy_id;
END;

DROP PROCEDURE IF EXISTS unreturned_copies_by_customer;
CREATE PROCEDURE unreturned_copies_by_customer(_customer_id BIGINT)
BEGIN
    SELECT cp.copy_id,
           medium_format,
           cost,
           c.customer_id AS borrower_customer_id,
           CONCAT(first_name, ' ', last_name) AS borrower,
           remarks,
           m.movie_id,
           title,
           aisle_number
    FROM transaction_contents tc
             JOIN transactions t ON t.transaction_id = tc.transaction_id
             JOIN customers c ON c.customer_id = t.customer_id
             JOIN copies cp ON cp.copy_id = tc.copy_id
             JOIN movies m ON m.movie_id = cp.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE is_copy_borrowed(cp.copy_id) AND _customer_id = c.customer_id
    ORDER BY copy_id;
END;
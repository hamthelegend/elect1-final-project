USE video_town;

CREATE PROCEDURE customers()
BEGIN
    SELECT * FROM customers;
END;

CREATE PROCEDURE customer(_customer_id BIGINT)
BEGIN
    SELECT * FROM customers WHERE customer_id = _customer_id;
END;

CREATE PROCEDURE employees()
BEGIN
    SELECT * FROM employees;
END;

CREATE PROCEDURE employee(_employee_id BIGINT)
BEGIN
    SELECT * FROM employees WHERE employee_id = _employee_id;
END;

CREATE PROCEDURE genres()
BEGIN
    SELECT * FROM genres;
END;

CREATE PROCEDURE genre(_genre_id BIGINT)
BEGIN
    SELECT * FROM genres WHERE genre_id = _genre_id;
END;

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
             JOIN genres g ON g.genre_id = m.genre_id;
END;

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

CREATE PROCEDURE copies()
BEGIN
    SELECT copy_id,
           medium_format,
           cost,
           remarks,
           m.movie_id,
           title,
           release_date,
           director,
           g.genre_id,
           tag AS genre,
           aisle_number
    FROM copies c
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id;
END;

CREATE PROCEDURE copy(_copy_id BIGINT)
BEGIN
    SELECT copy_id,
           medium_format,
           cost,
           remarks,
           m.movie_id,
           title,
           release_date,
           director,
           g.genre_id,
           tag AS genre,
           aisle_number
    FROM copies c
             JOIN movies m ON m.movie_id = c.movie_id
             JOIN genres g ON g.genre_id = m.genre_id
    WHERE copy_id = _copy_id;
END;

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

CREATE PROCEDURE transaction(_transaction_id BIGINT)
BEGIN
    DECLARE is_return BOOL;

    SELECT is_return FROM transactions WHERE transaction_id = _transaction_id;

    IF is_return THEN
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

CREATE PROCEDURE transaction_contents(_transaction_id BIGINT)
BEGIN
    SELECT
        transaction_id,
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

CREATE PROCEDURE copies_rented_by_month(year INT)
BEGIN
    SELECT
        MONTH(time_processed) AS month,
        COUNT(tc.transaction_content_id) AS copiesRented,
        SUM(c.cost) AS revenue
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN copies c ON c.copy_id = tc.copy_id
    JOIN movies m ON m.movie_id = c.movie_id
    WHERE NOT is_return AND YEAR(time_processed) = year
    GROUP BY MONTH(time_processed);
END;

CREATE PROCEDURE top_five_movies_from_genre(_genre_id BIGINT)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        COUNT(tc.transaction_content_id) AS copiesRented
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN copies c ON c.copy_id = tc.copy_id
    JOIN movies m ON m.movie_id = c.movie_id
    JOIN genres g ON g.genre_id = m.genre_id
    WHERE NOT is_return AND g.genre_id = _genre_id
    GROUP BY m.movie_id
    ORDER BY copiesRented;
END;

CREATE PROCEDURE top_five_movies_from_genre_by_revenue(_genre_id BIGINT)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        COUNT(tc.transaction_content_id) AS copiesRented,
        SUM(cost) AS totalRevenue
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN copies c ON c.copy_id = tc.copy_id
    JOIN movies m ON m.movie_id = c.movie_id
    JOIN genres g ON g.genre_id = m.genre_id
    WHERE NOT is_return AND g.genre_id = _genre_id
    GROUP BY m.movie_id
    ORDER BY copiesRented;
END;

CREATE PROCEDURE top_five_movies_from_genre_by_revenue(_genre_id BIGINT)
BEGIN
    SELECT
        m.movie_id,
        m.title,
        COUNT(tc.transaction_content_id) AS copiesRented,
        SUM(cost) AS totalRevenue
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN copies c ON c.copy_id = tc.copy_id
    JOIN movies m ON m.movie_id = c.movie_id
    JOIN genres g ON g.genre_id = m.genre_id
    WHERE NOT is_return AND g.genre_id = _genre_id
    GROUP BY m.movie_id
    ORDER BY copiesRented;
END;

CREATE PROCEDURE top_ten_movies_by_revenue()
BEGIN
    SELECT
        m.movie_id,
        m.title,
        COUNT(tc.transaction_content_id) AS copiesRented,
        SUM(cost) AS totalRevenue
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN copies c ON c.copy_id = tc.copy_id
    JOIN movies m ON m.movie_id = c.movie_id
    GROUP BY m.movie_id
    ORDER BY copiesRented;
END;

CREATE PROCEDURE top_customers_by_month(_year INT)
BEGIN
    SELECT
        *
    FROM transaction_contents tc
    JOIN transactions t ON t.transaction_id = tc.transaction_id
    JOIN customers c ON c.customer_id = t.customer_id
    WHERE YEAR(time_processed) = _year
    GROUP BY MONTH(t.time_processed), c.customer_id;
END;


USE video_town;

DROP FUNCTION IF EXISTS is_copy_borrowed;
CREATE FUNCTION is_copy_borrowed(_copy_id BIGINT)
    RETURNS BOOLEAN
    DETERMINISTIC
BEGIN
    DECLARE has_transactions BOOLEAN DEFAULT FALSE;
    DECLARE is_last_transaction_return BOOLEAN DEFAULT TRUE;
    DECLARE is_borrowed BOOLEAN DEFAULT FALSE;

    DROP TEMPORARY TABLE IF EXISTS copy_transactions;

    CREATE TEMPORARY TABLE copy_transactions
    AS (SELECT is_return
        FROM transactions t
                 JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
        WHERE copy_id = _copy_id
        ORDER BY time_processed DESC);

    SELECT COUNT(*) != 0 FROM copy_transactions INTO has_transactions;
    SELECT is_return FROM copy_transactions LIMIT 1 INTO is_last_transaction_return;

    IF NOT has_transactions OR is_last_transaction_return THEN
        SET is_borrowed = FALSE;
    ELSE
        SET is_borrowed = TRUE;
    END IF;

    RETURN is_borrowed;
END;

DROP PROCEDURE IF EXISTS new_customer;
CREATE PROCEDURE new_customer(
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    INSERT INTO customers(last_name, first_name, birthday, contact_number, address)
    VALUES (TRIM(_last_name), TRIM(_first_name), _birthday, _contact_number, _address);

    SELECT *
    FROM customers
    WHERE last_name = _last_name
    ORDER BY customer_id DESC
    LIMIT 1;
END;

DROP PROCEDURE IF EXISTS update_customer;
CREATE PROCEDURE update_customer(
    _customer_id BIGINT,
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    DECLARE __last_name VARCHAR(50);
    DECLARE __first_name VARCHAR(50);
    DECLARE __birthday DATE;
    DECLARE __contact_number VARCHAR(11);
    DECLARE __address VARCHAR(256);

    DROP TEMPORARY TABLE IF EXISTS customer_to_update;

    CREATE TEMPORARY TABLE customer_to_update
    AS (SELECT *
        FROM customers
        WHERE customer_id = _customer_id);

    SELECT last_name FROM customer_to_update INTO __last_name;
    SELECT first_name FROM customer_to_update INTO __first_name;
    SELECT birthday FROM customer_to_update INTO __birthday;
    SELECT contact_number FROM customer_to_update INTO __contact_number;
    SELECT address FROM customer_to_update INTO __address;

    IF _last_name IS NOT NULL THEN
        SET __last_name = _last_name;
    END IF;
    IF _first_name IS NOT NULL THEN
        SET __first_name = _first_name;
    END IF;
    IF _birthday IS NOT NULL THEN
        SET __birthday = _birthday;
    END IF;
    IF _contact_number IS NOT NULL THEN
        SET __contact_number = _contact_number;
    END IF;
    IF _address IS NOT NULL THEN
        SET __address = _address;
    END IF;
    UPDATE customers
    SET last_name      = TRIM(__last_name),
        first_name     = TRIM(__first_name),
        birthday       = __birthday,
        contact_number = __contact_number,
        address        = __address
    WHERE customer_id = _customer_id;

    SELECT *
    FROM customers
    WHERE customer_id = _customer_id;
END;

DROP PROCEDURE IF EXISTS hire;
CREATE PROCEDURE hire(
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    INSERT INTO employees(last_name, first_name, birthday, contact_number, address)
    VALUES (TRIM(_last_name), TRIM(_first_name), _birthday, _contact_number, _address);

    SELECT *
    FROM employees
    WHERE last_name = _last_name
    ORDER BY employee_id DESC
    LIMIT 1;
END;

DROP PROCEDURE IF EXISTS update_employee;
CREATE PROCEDURE update_employee(
    _employee_id BIGINT,
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    DECLARE __last_name VARCHAR(50);
    DECLARE __first_name VARCHAR(50);
    DECLARE __birthday DATE;
    DECLARE __contact_number VARCHAR(11);
    DECLARE __address VARCHAR(256);

    CREATE TEMPORARY TABLE employee_to_update
    AS (SELECT *
        FROM employees
        WHERE employee_id = _employee_id);

    DROP TEMPORARY TABLE IF EXISTS employee_to_update;

    SELECT last_name FROM employee_to_update INTO __last_name;
    SELECT first_name FROM employee_to_update INTO __first_name;
    SELECT birthday FROM employee_to_update INTO __birthday;
    SELECT contact_number FROM employee_to_update INTO __contact_number;
    SELECT address FROM employee_to_update INTO __address;

    IF _last_name IS NOT NULL THEN
        SET __last_name = _last_name;
    END IF;
    IF _first_name IS NOT NULL THEN
        SET __first_name = _first_name;
    END IF;
    IF _birthday IS NOT NULL THEN
        SET __birthday = _birthday;
    END IF;
    IF _contact_number IS NOT NULL THEN
        SET __contact_number = _contact_number;
    END IF;
    IF _address IS NOT NULL THEN
        SET __address = _address;
    END IF;
    UPDATE employees
    SET last_name      = TRIM(__last_name),
        first_name     = TRIM(__first_name),
        birthday       = __birthday,
        contact_number = __contact_number,
        address        = __address
    WHERE employee_id = _employee_id;

    SELECT *
    FROM employees
    WHERE employee_id = _employee_id;
END;

DROP PROCEDURE IF EXISTS new_genre;
CREATE PROCEDURE new_genre(
    _tag VARCHAR(50),
    _aisle_number INT
)
BEGIN
    INSERT INTO genres(tag, aisle_number)
    VALUES (_tag, _aisle_number);

    SELECT *
    FROM genres
    WHERE tag = _tag
    ORDER BY genre_id DESC
    LIMIT 1;
END;

DROP PROCEDURE IF EXISTS update_genre;
CREATE PROCEDURE update_genre(
    _genre_id BIGINT,
    _tag VARCHAR(50),
    _aisle_number INT
)
BEGIN
    DECLARE __tag VARCHAR(50);
    DECLARE __aisle_number INT;

    DROP TEMPORARY TABLE IF EXISTS genre_to_update;

    CREATE TEMPORARY TABLE genre_to_update
    AS (SELECT *
        FROM genres
        WHERE genre_id = _genre_id);

    SELECT tag FROM genre_to_update INTO __tag;
    SELECT aisle_number FROM genre_to_update INTO __aisle_number;

    IF _tag IS NOT NULL THEN
        SET __tag = _tag;
    END IF;
    IF __aisle_number IS NOT NULL THEN
        SET __aisle_number = _aisle_number;
    END IF;

    UPDATE genres
    SET tag          = __tag,
        aisle_number = __aisle_number
    WHERE genre_id = _genre_id;

    SELECT *
    FROM genres
    WHERE genre_id = _genre_id;
END;

DROP PROCEDURE IF EXISTS new_movie;
CREATE PROCEDURE new_movie(
    _genre_id BIGINT,
    _title VARCHAR(50),
    _release_date DATE,
    _director VARCHAR(50)
)
BEGIN
    INSERT INTO movies(genre_id, title, release_date, director)
    VALUES (_genre_id, _title, _release_date, _director);

    SELECT *
    FROM movies
    WHERE title = _title
    ORDER BY genre_id DESC
    LIMIT 1;
END;

DROP PROCEDURE IF EXISTS update_movie;
CREATE PROCEDURE update_movie(
    _movie_id BIGINT,
    _genre_id BIGINT,
    _title VARCHAR(50),
    _release_date DATE,
    _director VARCHAR(50)
)
BEGIN
    DECLARE __genre_id BIGINT;
    DECLARE __title VARCHAR(50);
    DECLARE __release_date DATE;
    DECLARE __director VARCHAR(50);

    DROP TEMPORARY TABLE IF EXISTS movie_to_update;

    CREATE TEMPORARY TABLE movie_to_update
    AS (SELECT *
        FROM movies
        WHERE movie_id = _movie_id);

    SELECT genre_id FROM movie_to_update INTO __genre_id;
    SELECT title FROM movie_to_update INTO __title;
    SELECT release_date FROM movie_to_update INTO __release_date;
    SELECT director FROM movie_to_update INTO __director;

    IF _genre_id IS NOT NULL THEN
        SET __genre_id = _genre_id;
    END IF;
    IF _title IS NOT NULL THEN
        SET __title = _title;
    END IF;
    IF _release_date IS NOT NULL THEN
        SET __release_date = _release_date;
    END IF;
    IF _director IS NOT NULL THEN
        SET __director = _director;
    END IF;

    UPDATE movies
    SET genre_id     = __genre_id,
        title        = __title,
        release_date = __release_date,
        director     = __director
    WHERE genre_id = _genre_id;

    SELECT *
    FROM movies
    WHERE movie_id = _movie_id;
END;

DROP PROCEDURE IF EXISTS add_copies;
CREATE PROCEDURE add_copies(
    _movie_id BIGINT,
    _medium_format VARCHAR(10),
    _cost DEC(65, 2),
    _quantity INT,
    _remarks VARCHAR(100)
)
BEGIN
    DECLARE i INT DEFAULT 0;
    SET i = 0;

    WHILE i < _quantity
        DO
            INSERT INTO copies(movie_id, medium_format, cost, remarks)
            VALUES (_movie_id, _medium_format, _cost, _remarks);
            SET i = i + 1;
        END WHILE;

    SELECT *
    FROM copies
    WHERE movie_id = _movie_id
      AND medium_format = _medium_format
      AND cost = _cost
      AND remarks = _remarks
    ORDER BY copy_id DESC;
END;

DROP PROCEDURE IF EXISTS update_copy;
CREATE PROCEDURE update_copy(
    _copy_id BIGINT,
    _movie_id BIGINT,
    _medium_format VARCHAR(10),
    _cost DEC(65, 2),
    _remarks VARCHAR(256)
)
BEGIN
    DECLARE __movie_id BIGINT;
    DECLARE __medium_format VARCHAR(10);
    DECLARE __cost DEC(65, 2);
    DECLARE __remarks VARCHAR(256);

    DROP TEMPORARY TABLE IF EXISTS copy_to_update;

    CREATE TEMPORARY TABLE copy_to_update
    AS (SELECT *
        FROM copies
        WHERE copy_id = _copy_id);
    SELECT movie_id FROM copy_to_update INTO __movie_id;
    SELECT medium_format FROM copy_to_update INTO __medium_format;
    SELECT cost FROM copy_to_update INTO __cost;

    SELECT remarks FROM copy_to_update INTO __remarks;

    IF _movie_id IS NOT NULL THEN
        SET __movie_id = _movie_id;
    END IF;
    IF _medium_format IS NOT NULL THEN
        SET __medium_format = _medium_format;
    END IF;
    IF _cost IS NOT NULL THEN
        SET __cost = _cost;
    END IF;
    IF _remarks IS NOT NULL THEN
        SET __remarks = _remarks;
    END IF;
    UPDATE copies
    SET movie_id      = TRIM(__movie_id),
        medium_format = TRIM(__medium_format),
        cost          = __cost,
        remarks       = __remarks
    WHERE copy_id = _copy_id;

    SELECT *
    FROM copies
    WHERE copy_id = _copy_id;
END;

DROP PROCEDURE IF EXISTS start_transaction;
CREATE PROCEDURE start_transaction(
    _customer_id BIGINT,
    _cashier_employee_id BIGINT,
    _is_return BOOL
)
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT TRUE;

    SELECT is_closed
    FROM transactions
    ORDER BY time_processed DESC
    LIMIT 1
    INTO is_last_transaction_done;

    IF is_last_transaction_done THEN
        INSERT INTO transactions(customer_id, cashier_employee_id, time_processed, is_return, is_closed)
        VALUES (_customer_id, _cashier_employee_id, NOW(6), _is_return, FALSE);

        SELECT *
        FROM transactions
        ORDER BY time_processed DESC
        LIMIT 1;
    ELSE
        SELECT 'You have to close your previous transaction first.';
    END IF;
END;

DROP PROCEDURE IF EXISTS add_item;
CREATE PROCEDURE add_item(
    _copy_id BIGINT
)
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT FALSE;
    DECLARE _is_return BOOL;
    DECLARE _transaction_id BIGINT;
    DECLARE _is_copy_borrowed BOOL;

    DROP TEMPORARY TABLE IF EXISTS last_transaction;

    CREATE TEMPORARY TABLE last_transaction
    AS (SELECT transaction_id, is_return, is_closed
        FROM transactions
        ORDER BY time_processed DESC
        LIMIT 1);

    SELECT is_closed FROM last_transaction INTO is_last_transaction_done;
    SELECT is_return FROM last_transaction INTO _is_return;
    SELECT transaction_id FROM last_transaction INTO _transaction_id;
    SET _is_copy_borrowed = is_copy_borrowed(_copy_id);

    IF NOT is_last_transaction_done THEN
        IF (NOT _is_copy_borrowed AND NOT _is_return) OR (_is_copy_borrowed AND _is_return) THEN
            INSERT INTO transaction_contents (transaction_id, copy_id)
            VALUES (_transaction_id, _copy_id);

            SELECT *
            FROM transaction_contents
            WHERE transaction_id = _transaction_id
              AND copy_id = _copy_id
            ORDER BY transaction_content_id DESC
            LIMIT 1;
        ELSEIF _is_copy_borrowed AND NOT _is_return THEN
            SELECT 'This copy was already borrowed by someone else.';
        ELSE
            SELECT 'This copy was not yet borrowed to be returned.';
        END IF;
    ELSE
        SELECT 'You currently have no open transactions.';
    END IF;
END;

DROP PROCEDURE IF EXISTS end_transaction;
CREATE PROCEDURE end_transaction()
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT TRUE;
    DECLARE _transaction_id BIGINT;
    DECLARE _has_contents BOOL DEFAULT FALSE;

    DROP TEMPORARY TABLE IF EXISTS last_transaction;

    CREATE TEMPORARY TABLE last_transaction
    AS (SELECT transaction_id, is_closed
        FROM transactions
        ORDER BY time_processed DESC
        LIMIT 1);

    SELECT is_closed FROM last_transaction INTO is_last_transaction_done;
    SELECT transaction_id FROM last_transaction INTO _transaction_id;
    SELECT COUNT(transaction_content_id) > 0 FROM transaction_contents WHERE transaction_id = _transaction_id INTO _has_contents;

    IF NOT is_last_transaction_done AND _has_contents THEN
        UPDATE transactions
        SET time_processed = NOW(6),
            is_closed      = TRUE
        WHERE transaction_id = _transaction_id;

        CALL transaction(_transaction_id);
    ELSEIF NOT _has_contents THEN
        SELECT 'Please add at least 1 item to this transaction before closing it.';
    ELSE
        SELECT 'You currently have no open transactions.';
    END IF;
END;

DROP PROCEDURE IF EXISTS void_transaction;
CREATE PROCEDURE void_transaction()
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT TRUE;
    DECLARE _transaction_id BIGINT;

    DROP TEMPORARY TABLE IF EXISTS last_transaction;

    CREATE TEMPORARY TABLE last_transaction
    AS (SELECT transaction_id, is_closed
        FROM transactions
        ORDER BY time_processed DESC
        LIMIT 1);

    SELECT is_closed FROM last_transaction INTO is_last_transaction_done;
    SELECT transaction_id FROM last_transaction INTO _transaction_id;

    IF NOT is_last_transaction_done THEN
        DELETE FROM transactions WHERE transaction_id = _transaction_id;
        DELETE FROM transaction_contents WHERE transaction_id = _transaction_id;

        SELECT 'Transaction voided.';
    ELSE
        SELECT 'You currently have no open transactions.';
    END IF;
END;

DROP PROCEDURE IF EXISTS new_seed_customer;
CREATE PROCEDURE new_seed_customer(
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    INSERT INTO customers(last_name, first_name, birthday, contact_number, address)
    VALUES (TRIM(_last_name), TRIM(_first_name), _birthday, _contact_number, _address);
END;

DROP PROCEDURE IF EXISTS update_seed_customer;
CREATE PROCEDURE update_seed_customer(
    _customer_id BIGINT,
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    DECLARE __last_name VARCHAR(50);
    DECLARE __first_name VARCHAR(50);
    DECLARE __birthday DATE;
    DECLARE __contact_number VARCHAR(11);
    DECLARE __address VARCHAR(256);

    DROP TEMPORARY TABLE IF EXISTS customer_to_update;

    CREATE TEMPORARY TABLE customer_to_update
    AS (SELECT *
        FROM customers
        WHERE customer_id = _customer_id);

    SELECT last_name FROM customer_to_update INTO __last_name;
    SELECT first_name FROM customer_to_update INTO __first_name;
    SELECT birthday FROM customer_to_update INTO __birthday;
    SELECT contact_number FROM customer_to_update INTO __contact_number;
    SELECT address FROM customer_to_update INTO __address;

    IF _last_name IS NOT NULL THEN
        SET __last_name = _last_name;
    END IF;
    IF _first_name IS NOT NULL THEN
        SET __first_name = _first_name;
    END IF;
    IF _birthday IS NOT NULL THEN
        SET __birthday = _birthday;
    END IF;
    IF _contact_number IS NOT NULL THEN
        SET __contact_number = _contact_number;
    END IF;
    IF _address IS NOT NULL THEN
        SET __address = _address;
    END IF;
    UPDATE customers
    SET last_name      = TRIM(__last_name),
        first_name     = TRIM(__first_name),
        birthday       = __birthday,
        contact_number = __contact_number,
        address        = __address
    WHERE customer_id = _customer_id;
END;

DROP PROCEDURE IF EXISTS hire_seed;
CREATE PROCEDURE hire_seed(
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    INSERT INTO employees(last_name, first_name, birthday, contact_number, address)
    VALUES (TRIM(_last_name), TRIM(_first_name), _birthday, _contact_number, _address);
END;

DROP PROCEDURE IF EXISTS update_seed_employee;
CREATE PROCEDURE update_seed_employee(
    _employee_id BIGINT,
    _last_name VARCHAR(50),
    _first_name VARCHAR(50),
    _birthday DATE,
    _contact_number VARCHAR(11),
    _address VARCHAR(256)
)
BEGIN
    DECLARE __last_name VARCHAR(50);
    DECLARE __first_name VARCHAR(50);
    DECLARE __birthday DATE;
    DECLARE __contact_number VARCHAR(11);
    DECLARE __address VARCHAR(256);

    CREATE TEMPORARY TABLE employee_to_update
    AS (SELECT *
        FROM employees
        WHERE employee_id = _employee_id);

    DROP TEMPORARY TABLE IF EXISTS employee_to_update;

    SELECT last_name FROM employee_to_update INTO __last_name;
    SELECT first_name FROM employee_to_update INTO __first_name;
    SELECT birthday FROM employee_to_update INTO __birthday;
    SELECT contact_number FROM employee_to_update INTO __contact_number;
    SELECT address FROM employee_to_update INTO __address;

    IF _last_name IS NOT NULL THEN
        SET __last_name = _last_name;
    END IF;
    IF _first_name IS NOT NULL THEN
        SET __first_name = _first_name;
    END IF;
    IF _birthday IS NOT NULL THEN
        SET __birthday = _birthday;
    END IF;
    IF _contact_number IS NOT NULL THEN
        SET __contact_number = _contact_number;
    END IF;
    IF _address IS NOT NULL THEN
        SET __address = _address;
    END IF;
    UPDATE employees
    SET last_name      = TRIM(__last_name),
        first_name     = TRIM(__first_name),
        birthday       = __birthday,
        contact_number = __contact_number,
        address        = __address
    WHERE employee_id = _employee_id;
END;

DROP PROCEDURE IF EXISTS new_seed_genre;
CREATE PROCEDURE new_seed_genre(
    _tag VARCHAR(50),
    _aisle_number INT
)
BEGIN
    INSERT INTO genres(tag, aisle_number)
    VALUES (_tag, _aisle_number);
END;

DROP PROCEDURE IF EXISTS update_seed_genre;
CREATE PROCEDURE update_seed_genre(
    _genre_id BIGINT,
    _tag VARCHAR(50),
    _aisle_number INT
)
BEGIN
    DECLARE __tag VARCHAR(50);
    DECLARE __aisle_number INT;

    DROP TEMPORARY TABLE IF EXISTS genre_to_update;

    CREATE TEMPORARY TABLE genre_to_update
    AS (SELECT *
        FROM genres
        WHERE genre_id = _genre_id);

    SELECT tag FROM genre_to_update INTO __tag;
    SELECT aisle_number FROM genre_to_update INTO __aisle_number;

    IF _tag IS NOT NULL THEN
        SET __tag = _tag;
    END IF;
    IF __aisle_number IS NOT NULL THEN
        SET __aisle_number = _aisle_number;
    END IF;

    UPDATE genres
    SET tag          = __tag,
        aisle_number = __aisle_number
    WHERE genre_id = _genre_id;
END;

DROP PROCEDURE IF EXISTS new_seed_movie;
CREATE PROCEDURE new_seed_movie(
    _genre_id BIGINT,
    _title VARCHAR(50),
    _release_date DATE,
    _director VARCHAR(50)
)
BEGIN
    INSERT INTO movies(genre_id, title, release_date, director)
    VALUES (_genre_id, _title, _release_date, _director);
END;

DROP PROCEDURE IF EXISTS update_seed_movie;
CREATE PROCEDURE update_seed_movie(
    _movie_id BIGINT,
    _genre_id BIGINT,
    _title VARCHAR(50),
    _release_date DATE,
    _director VARCHAR(50)
)
BEGIN
    DECLARE __genre_id BIGINT;
    DECLARE __title VARCHAR(50);
    DECLARE __release_date DATE;
    DECLARE __director VARCHAR(50);

    DROP TEMPORARY TABLE IF EXISTS movie_to_update;

    CREATE TEMPORARY TABLE movie_to_update
    AS (SELECT *
        FROM movies
        WHERE movie_id = _movie_id);

    SELECT genre_id FROM movie_to_update INTO __genre_id;
    SELECT title FROM movie_to_update INTO __title;
    SELECT release_date FROM movie_to_update INTO __release_date;
    SELECT director FROM movie_to_update INTO __director;

    IF _genre_id IS NOT NULL THEN
        SET __genre_id = _genre_id;
    END IF;
    IF _title IS NOT NULL THEN
        SET __title = _title;
    END IF;
    IF _release_date IS NOT NULL THEN
        SET __release_date = _release_date;
    END IF;
    IF _director IS NOT NULL THEN
        SET __director = _director;
    END IF;

    UPDATE movies
    SET genre_id     = __genre_id,
        title        = __title,
        release_date = __release_date,
        director     = __director
    WHERE genre_id = _genre_id;
END;

DROP PROCEDURE IF EXISTS add_seed_copies;
CREATE PROCEDURE add_seed_copies(
    _movie_id BIGINT,
    _medium_format VARCHAR(10),
    _cost DEC(65, 2),
    _quantity INT,
    _remarks VARCHAR(100)
)
BEGIN
    DECLARE i INT DEFAULT 0;
    SET i = 0;

    WHILE i < _quantity
        DO
            INSERT INTO copies(movie_id, medium_format, cost, remarks)
            VALUES (_movie_id, _medium_format, _cost, _remarks);
            SET i = i + 1;
        END WHILE;
END;

DROP PROCEDURE IF EXISTS update_seed_copy;
CREATE PROCEDURE update_seed_copy(
    _copy_id BIGINT,
    _movie_id BIGINT,
    _medium_format VARCHAR(10),
    _cost DEC(65, 2),
    _remarks VARCHAR(256)
)
BEGIN
    DECLARE __movie_id BIGINT;
    DECLARE __medium_format VARCHAR(10);
    DECLARE __cost DEC(65, 2);
    DECLARE __remarks VARCHAR(256);

    DROP TEMPORARY TABLE IF EXISTS copy_to_update;

    CREATE TEMPORARY TABLE copy_to_update
    AS (SELECT *
        FROM copies
        WHERE copy_id = _copy_id);
    SELECT movie_id FROM copy_to_update INTO __movie_id;
    SELECT medium_format FROM copy_to_update INTO __medium_format;
    SELECT cost FROM copy_to_update INTO __cost;

    SELECT remarks FROM copy_to_update INTO __remarks;

    IF _movie_id IS NOT NULL THEN
        SET __movie_id = _movie_id;
    END IF;
    IF _medium_format IS NOT NULL THEN
        SET __medium_format = _medium_format;
    END IF;
    IF _cost IS NOT NULL THEN
        SET __cost = _cost;
    END IF;
    IF _remarks IS NOT NULL THEN
        SET __remarks = _remarks;
    END IF;
    UPDATE copies
    SET movie_id      = TRIM(__movie_id),
        medium_format = TRIM(__medium_format),
        cost          = __cost,
        remarks       = __remarks
    WHERE copy_id = _copy_id;
END;

DROP PROCEDURE IF EXISTS start_seed_transaction;
CREATE PROCEDURE start_seed_transaction(
    _customer_id BIGINT,
    _cashier_employee_id BIGINT,
    _time_processed TIMESTAMP,
    _is_return BOOL
)
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT TRUE;

    SELECT is_closed
    FROM transactions
    ORDER BY time_processed DESC
    LIMIT 1
    INTO is_last_transaction_done;

    IF is_last_transaction_done THEN
        INSERT INTO transactions(customer_id, cashier_employee_id, time_processed, is_return, is_closed)
        VALUES (_customer_id, _cashier_employee_id, _time_processed, _is_return, FALSE);
    ELSE
        SELECT 'You have to close your previous transaction first.';
    END IF;
END;

DROP PROCEDURE IF EXISTS add_seed_item;
CREATE PROCEDURE add_seed_item(
    _copy_id BIGINT
)
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT FALSE;
    DECLARE _is_return BOOL;
    DECLARE _transaction_id BIGINT;
    DECLARE _is_copy_borrowed BOOL;

    DROP TEMPORARY TABLE IF EXISTS last_transaction;

    CREATE TEMPORARY TABLE last_transaction
    AS (SELECT transaction_id, is_closed, is_return
        FROM transactions
        ORDER BY transaction_id DESC
        LIMIT 1);

    SELECT is_closed FROM last_transaction INTO is_last_transaction_done;
    SELECT transaction_id FROM last_transaction INTO _transaction_id;
    SELECT is_return FROM last_transaction INTO _is_return;
    SET _is_copy_borrowed = is_copy_borrowed(_copy_id);

    IF NOT is_last_transaction_done THEN
        IF (NOT _is_copy_borrowed AND NOT _is_return) OR (_is_copy_borrowed AND _is_return) THEN
            INSERT INTO transaction_contents (transaction_id, copy_id)
            VALUES (_transaction_id, _copy_id);
        ELSEIF _is_copy_borrowed AND NOT _is_return THEN
            SELECT 'This copy was already borrowed by someone else.';
        ELSE
            SELECT 'This copy was not yet borrowed to be returned.';
        END IF;
    ELSE
        SELECT 'You currently have no open transactions.';
    END IF;
END;

DROP PROCEDURE IF EXISTS end_seed_transaction;
CREATE PROCEDURE end_seed_transaction()
BEGIN
    DECLARE is_last_transaction_done BOOL DEFAULT TRUE;
    DECLARE _transaction_id BIGINT;
    DECLARE _has_contents BOOL DEFAULT FALSE;

    DROP TEMPORARY TABLE IF EXISTS last_transaction;

    CREATE TEMPORARY TABLE last_transaction
    AS (SELECT transaction_id, is_closed
        FROM transactions
        ORDER BY transaction_id DESC
        LIMIT 1);

    SELECT is_closed FROM last_transaction INTO is_last_transaction_done;
    SELECT transaction_id FROM last_transaction INTO _transaction_id;
    SELECT COUNT(transaction_content_id) > 0 FROM transaction_contents WHERE transaction_id = _transaction_id INTO _has_contents;

    IF NOT is_last_transaction_done AND _has_contents THEN
        UPDATE transactions
        SET is_closed = TRUE
        WHERE transaction_id = _transaction_id;
    ELSEIF NOT _has_contents THEN
        SELECT 'Please add at least 1 item to this transaction before closing it.';
    ELSE
        SELECT 'You currently have no open transactions.';
    END IF;
END;

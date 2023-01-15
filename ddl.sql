CREATE DATABASE IF NOT EXISTS video_town;

USE video_town;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id BIGINT,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    birthday DATE,
    contact_number VARCHAR(11),
    PRIMARY KEY (customer_id)
);

CREATE TABLE employees (
    employee_id BIGINT,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    birthday DATE,
    contact_number VARCHAR(11),
    PRIMARY KEY (employee_id)
);

CREATE TABLE genres (
     genre_id BIGINT,
     name VARCHAR(50),
     aisle_number INT

);

CREATE TABLE movies (
    movie_id BIGINT,
    FK genre_id BIGINT,
    title VARCHAR(50),
    release_date DATE,
    director VARCHAR(50),
    PRIMARY KEY(movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE copies(
    copy_id BIGINT,
    movie_id BIGINT,
    medium VARCHAR(10),
    cost DEC(65,2),
    remarks VARCHAR(100),
    PRIMARY KEY(copy_id),
    FOREIGN KEY(movie_id) REFERENCES movies(movie_id)

);

CREATE TABLE transactions(
    transaction_id BIGINT,
    purchaser_customer_id BIGINT,
    cashier_employee_id BIGINT,
    timestamp TIMESTAMP,
    is_return BOOL,
    PRIMARY KEY(transaction_id),
    FOREIGN KEY(purchaser_customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE transaction_contents(
    transaction_content_id BIGINT,
    transaction_id BIGINT,
    copy_id BIGINT,
    PRIMARY KEY(transaction_content_id),
    FOREIGN KEY(transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY(copy_id) REFERENCES copies(copy_id)
);

# Insert remaining table in the following order:
# employees
# genres
# movies
# copies
# transactions
# transaction_contents

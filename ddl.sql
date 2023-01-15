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

# Insert remaining table in the following order:
# employees
# genres
# movies
# copies
# transactions
# transaction_contents
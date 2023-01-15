CREATE DATABASE IF NOT EXISTS video_town;

USE video_town;

DROP TABLE IF EXISTS transaction_contents;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS copies;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;


CREATE TABLE customers (
customer_id BIGINT AUTO_INCREMENT,
last_name VARCHAR(50),
first_name VARCHAR(50),
middle_name VARCHAR(50),
birthday DATE,
contact_number VARCHAR(11),
PRIMARY KEY (customer_id)
);


CREATE TABLE employees (
employee_id BIGINT AUTO_INCREMENT,
last_name VARCHAR(50),
first_name VARCHAR(50),
middle_name VARCHAR(50),
birthday DATE,
contact_number VARCHAR(11),
PRIMARY KEY (employee_id)
);

CREATE TABLE genres (
genre_id BIGINT AUTO_INCREMENT,
tag VARCHAR(50),
aisle_number INT,
PRIMARY KEY (genre_id)
);

CREATE TABLE movies (
    movie_id BIGINT AUTO_INCREMENT,
    genre_id BIGINT,
    title VARCHAR(50),
    release_date DATE,
    director VARCHAR(50),
    PRIMARY KEY (movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE copies (
    copy_id BIGINT AUTO_INCREMENT,
    movie_id BIGINT,
    medium_format VARCHAR(10),
    cost DEC(65,2),
    remarks VARCHAR(100),
    PRIMARY KEY (copy_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

CREATE TABLE transactions (
    transaction_id BIGINT AUTO_INCREMENT,
    purchaser_customer_id BIGINT,
    cashier_employee_id BIGINT,
    time_processed TIMESTAMP,
    is_return BOOL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (purchaser_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (cashier_employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE transaction_contents (
    transaction_content_id BIGINT AUTO_INCREMENT,
    transaction_id BIGINT,
    copy_id BIGINT,
    PRIMARY KEY (transaction_content_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (copy_id) REFERENCES copies(copy_id)
);

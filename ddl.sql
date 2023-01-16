DROP DATABASE video_town;

CREATE DATABASE video_town;

USE video_town;

CREATE TABLE customers
(
    customer_id    BIGINT AUTO_INCREMENT,
    last_name      VARCHAR(50)  NOT NULL,
    first_name     VARCHAR(50)  NOT NULL,
    birthday       DATE         NOT NULL,
    contact_number VARCHAR(11)  NOT NULL,
    address        VARCHAR(256) NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT customers_contact_number_check CHECK (contact_number RLIKE '0[89][0-9]{9}')
);

CREATE TABLE employees
(
    employee_id    BIGINT AUTO_INCREMENT,
    last_name      VARCHAR(50)  NOT NULL,
    first_name     VARCHAR(50)  NOT NULL,
    birthday       DATE         NOT NULL,
    contact_number VARCHAR(11)  NOT NULL,
    address        VARCHAR(256) NOT NULL,
    PRIMARY KEY (employee_id),
    CONSTRAINT employees_contact_number_check CHECK (contact_number RLIKE '0[89][0-9]{9}')
);

CREATE TABLE genres
(
    genre_id     BIGINT AUTO_INCREMENT,
    tag          VARCHAR(50) NOT NULL,
    aisle_number INT         NOT NULL,
    PRIMARY KEY (genre_id)
);

CREATE TABLE movies
(
    movie_id     BIGINT AUTO_INCREMENT,
    genre_id     BIGINT      NOT NULL,
    title        VARCHAR(50) NOT NULL,
    release_date DATE        NOT NULL,
    director     VARCHAR(50) NOT NULL,
    PRIMARY KEY (movie_id),
    FOREIGN KEY (genre_id) REFERENCES genres (genre_id)
);

CREATE TABLE copies
(
    copy_id       BIGINT AUTO_INCREMENT,
    movie_id      BIGINT       NOT NULL,
    medium_format VARCHAR(10)  NOT NULL,
    cost          DEC(65, 2)   NOT NULL,
    remarks       VARCHAR(100),
    PRIMARY KEY (copy_id),
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id)
);

CREATE TABLE transactions
(
    transaction_id      BIGINT AUTO_INCREMENT,
    customer_id         BIGINT       NOT NULL,
    cashier_employee_id BIGINT       NOT NULL,
    time_processed      TIMESTAMP(6) NOT NULL,
    is_return           BOOL         NOT NULL,
    is_closed           BOOL         NOT NULL,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (cashier_employee_id) REFERENCES employees (employee_id)
);

CREATE TABLE transaction_contents
(
    transaction_content_id BIGINT AUTO_INCREMENT,
    transaction_id         BIGINT NOT NULL,
    copy_id                BIGINT NOT NULL,
    PRIMARY KEY (transaction_content_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions (transaction_id),
    FOREIGN KEY (copy_id) REFERENCES copies (copy_id)
);

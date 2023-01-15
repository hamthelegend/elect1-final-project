USE video_town;

INSERT INTO genres(tag, aisle_number)
VALUES ('Crazy', 1);

INSERT INTO movies(genre_id, title, release_date, director)
VALUES (1, 'Moon Knight', CURDATE(), 'Hamuel Agulto');

INSERT INTO copies(movie_id, medium_format, cost, remarks)
VALUES (1, 'DVD', 999, '');

INSERT INTO customers(last_name, first_name, birthday, contact_number, address)
VALUES ('Justine', 'Manalansan', CURDATE(), 09999999999, 'Here');

INSERT INTO employees(last_name, first_name, birthday, contact_number, address)
VALUES ('Jonel', 'David', CURDATE(), 09888888888, 'There');

INSERT INTO transactions(customer_id, cashier_employee_id, time_processed, is_return)
VALUES (1, 1, NOW(6), FALSE);

INSERT INTO transaction_contents(transaction_id, copy_id)
VALUES (1, 1);

INSERT INTO transactions(customer_id, cashier_employee_id, time_processed, is_return)
VALUES (1, 1, NOW(6), TRUE);

INSERT INTO transaction_contents(transaction_id, copy_id)
VALUES (2, 1);

SELECT is_copy_borrowed(1);
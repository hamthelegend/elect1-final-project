USE video_town;

CALL customers;

CALL customer(12);

CALL employees;

CALL employee(4);

CALL genres;

CALL genre(3);

CALL movies;

CALL movie(3);

CALL copies(1);

CALL copy(3);

CALL transactions;

CALL rent_transactions();

CALL return_transactions();

CALL transaction(8);

CALL transaction_contents(8);

CALL copies_rented_by_month(2021);

CALL top_five_movies_from_genre_by_revenue(5);

CALL top_ten_movies_by_revenue();

CALL customers_by_month(2021);

CALL top_customers_by_month(2021);

CALL best_employee_by_year;

CALL unreturned_copies;

CALL start_seed_transaction(1, 1, '2023-01-17 15:10:59.934792', TRUE);

CALL add_seed_item(1);

CALL end_seed_transaction();

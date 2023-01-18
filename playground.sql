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

CALL transactions_by_customer(1);

CALL rent_transactions();

CALL return_transactions();

CALL transaction(8);

CALL transaction_contents(8);

# Count of movies (not unique) rented over the year by month
CALL copies_rented_by_month(2021);

# Top 5 movies rented by genre
CALL top_five_movies_by_genre_by_copies_rented;
CALL top_five_movies_by_genre_by_revenue;

# Top 10 most popular movies by revenue (from rental)
CALL top_ten_movies_by_revenue();

CALL customers_by_month(2021);

# Best customer each month (most number of rented movies)
CALL top_customers_by_month(2021);

# Best employee of the year by revenue generated
CALL best_employee_by_year;

CALL unreturned_copies;
CALL unreturned_copies_by_customer(1);

# Check-out transaction - must handle items already unavailable. Also, don't forget the cost!
# Check-in transaction

CALL start_transaction(1, 4, TRUE); # This is a return transaction
SELECT is_copy_borrowed(71); # This was not yet borrowed
CALL add_item(71); # This transaction should fail
CALL void_transaction;

CALL start_transaction(3, 7, FALSE); # This is a rent transaction
SELECT is_copy_borrowed(830); # This was already borrowed
CALL add_item(830);
CALL void_transaction();

CALL start_transaction(4, 3, FALSE);
CALL add_item(7);
CALL add_item(111);
CALL add_item(370);
CALL end_transaction();
CALL transactions;

CALL start_transaction(4, 3, TRUE);
CALL add_item(7);
CALL add_item(111);
CALL add_item(370);
CALL end_transaction();
CALL transactions;

# Updating customer information such as address and mobile number
CALL customer(1);
CALL update_customer(1, NULL, NULL, NULL, '09123456789', 'Over there');
CALL customer(1);
# Also works for other entities

# New employee hire
CALL hire('Diaz', 'Jericho', '2022-01-01', '09999999999', 'There');

# New shipment of movies
CALL new_movie(2, 'The Boys: The Movie', '2023-01-01', 'Blythe Espiritu');
CALL add_copies(61, 'DVD', 1.00, 10, 'Brand new');

CALL copy_transaction_history(370);
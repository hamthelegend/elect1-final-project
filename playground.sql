USE video_town;

CALL new_genre('Crazy', 1);

CALL new_movie(
        1,
        'Moon Knight: The Movie',
        '2021-01-10',
        'hamthelegend'
    );

CALL add_copies(
        1,
        'DVD',
        99.99,
        5,
        ''
    );

CALL new_customer(
        'Manalansan',
        'Justine',
        CURDATE(),
        '09999999999',
        'Here'
    );

CALL hire(
    'David',
    'Jonel',
    CURDATE(),
    '09888888888',
    'There'
    );

CALL start_seed_transaction(
    1,
    1,
    '2022-01-16 16:46:32.128455',
    FALSE
    );
CALL add_seed_item(2);
CALL add_seed_item(3);
CALL add_seed_item(4);
CALL end_seed_transaction();

CALL start_seed_transaction(
    1,
    1,
    '2022-01-18 16:46:32.128455',
    FALSE
    );
CALL add_seed_item(1);
CALL end_seed_transaction();
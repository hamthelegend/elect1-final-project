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

CALL start_transaction(
    1,
    1,
    FALSE
    );
CALL add_item(1);
CALL end_transaction();

CALL start_transaction(
    1,
    1,
    TRUE
    );
CALL add_item(2);
CALL end_transaction();
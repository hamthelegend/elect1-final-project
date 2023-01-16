USE video_town;

CALL start_seed_transaction(
        1,
        1,
        NOW(6),
        FALSE
    );

CALL add_seed_item(1);

CALL end_transaction;
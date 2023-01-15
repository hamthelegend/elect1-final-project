USE video_town;

CREATE FUNCTION is_copy_borrowed (copy_id BIGINT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    DECLARE has_transactions BOOLEAN DEFAULT FALSE;
    DECLARE is_last_transaction_return BOOLEAN DEFAULT TRUE;
    DECLARE is_borrowed BOOLEAN DEFAULT FALSE;

    DROP TEMPORARY TABLE IF EXISTS copy_transactions;

    CREATE TEMPORARY TABLE copy_transactions AS (
        SELECT
            is_return
        FROM transactions t
        JOIN transaction_contents tc ON t.transaction_id = tc.transaction_id
        WHERE tc.copy_id = copy_id
        ORDER BY time_processed DESC
    );

    SELECT COUNT(*) != 0 FROM copy_transactions INTO has_transactions;
    SELECT * FROM copy_transactions LIMIT 1 INTO is_last_transaction_return;

    IF NOT has_transactions OR is_last_transaction_return THEN
        SET is_borrowed = FALSE;
    ELSE
        SET is_borrowed = TRUE;
    END IF;

    RETURN is_borrowed;
END;
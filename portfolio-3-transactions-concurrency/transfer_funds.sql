-- Atomic wallet-to-wallet transfer function (PostgreSQL)
-- Locks both wallet rows in ascending ID order to reduce deadlock risk.
CREATE OR REPLACE FUNCTION transfer_funds(
    p_source_wallet_id BIGINT,
    p_destination_wallet_id BIGINT,
    p_amount NUMERIC(18,2),
    p_reference VARCHAR(40)
) RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_source wallets%ROWTYPE;
    v_destination wallets%ROWTYPE;
    v_transaction_id BIGINT;
BEGIN
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Transfer amount must be greater than zero';
    END IF;
    IF p_source_wallet_id = p_destination_wallet_id THEN
        RAISE EXCEPTION 'Source and destination wallets must differ';
    END IF;

    -- Lock rows in deterministic order.
    PERFORM 1 FROM wallets
     WHERE wallet_id IN (p_source_wallet_id, p_destination_wallet_id)
     ORDER BY wallet_id
     FOR UPDATE;

    SELECT * INTO v_source FROM wallets WHERE wallet_id = p_source_wallet_id;
    SELECT * INTO v_destination FROM wallets WHERE wallet_id = p_destination_wallet_id;

    IF v_source.wallet_id IS NULL OR v_destination.wallet_id IS NULL THEN
        RAISE EXCEPTION 'Wallet not found';
    END IF;
    IF v_source.wallet_status <> 'ACTIVE' OR v_destination.wallet_status <> 'ACTIVE' THEN
        RAISE EXCEPTION 'Both wallets must be active';
    END IF;
    IF v_source.currency <> v_destination.currency THEN
        RAISE EXCEPTION 'Wallet currencies must match';
    END IF;
    IF v_source.balance < p_amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;

    UPDATE wallets SET balance = balance - p_amount
     WHERE wallet_id = p_source_wallet_id;
    UPDATE wallets SET balance = balance + p_amount
     WHERE wallet_id = p_destination_wallet_id;

    INSERT INTO payment_transactions
      (reference, transaction_type, source_wallet_id, destination_wallet_id,
       amount, currency, transaction_status, description)
    VALUES
      (p_reference, 'TRANSFER', p_source_wallet_id, p_destination_wallet_id,
       p_amount, v_source.currency, 'SUCCESS', 'Wallet-to-wallet transfer')
    RETURNING transaction_id INTO v_transaction_id;

    RETURN v_transaction_id;
END;
$$;

-- Example call; choose a unique reference each time:
-- SELECT transfer_funds(1, 2, 250.00, 'PF-TEST-0001');
-- The function call is one database statement and is atomic. If it raises
-- an exception, the statement's changes are rolled back.

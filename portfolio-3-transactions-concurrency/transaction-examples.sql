-- Explicit COMMIT example
BEGIN;
UPDATE wallets SET balance = balance + 100.00 WHERE wallet_id = 1;
COMMIT;

-- ROLLBACK example: the balance change is not retained
BEGIN;
UPDATE wallets SET balance = balance - 50.00 WHERE wallet_id = 1;
ROLLBACK;

-- Demonstrate a transfer using the function (ensure reference is unique)
SELECT transfer_funds(1, 2, 250.00, 'PF-TEST-0002');

-- Inspect balances and transaction record
SELECT wallet_id, balance FROM wallets WHERE wallet_id IN (1, 2);
SELECT * FROM payment_transactions WHERE reference = 'PF-TEST-0002';

-- Isolation level example (run in a session)
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT wallet_id, balance FROM wallets WHERE wallet_id = 1;
COMMIT;

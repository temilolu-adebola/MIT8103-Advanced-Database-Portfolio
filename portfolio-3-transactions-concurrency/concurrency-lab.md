# Transactions and concurrency practical

## ACID applied to PayFlow
- **Atomicity:** a transfer debits the source wallet, credits the destination wallet and inserts the transaction record as one unit. Failure must not leave only part of the transfer applied.
- **Consistency:** constraints and transfer validation preserve valid balances, currencies and statuses.
- **Isolation:** concurrent transfers must not spend the same available balance twice. Row-level locks and transaction isolation help coordinate concurrent sessions.
- **Durability:** after COMMIT succeeds, the database records the committed change durably according to its configured storage and recovery settings.

## Concurrency exercise (two database sessions)
1. Create two wallets with a known source balance, for example 1,000.00.
2. In Session A, begin a transaction and lock the source wallet using `SELECT * FROM wallets WHERE wallet_id = 1 FOR UPDATE;`.
3. In Session B, attempt to lock/update the same wallet. Observe that it waits until Session A commits or rolls back.
4. In Session A, make a valid update and COMMIT. Observe Session B continuing.
5. Repeat using the `transfer_funds` function from two sessions and verify that the final balance never becomes negative.
6. Record the exact commands and observed output.

## Isolation discussion
PostgreSQL's default isolation level is READ COMMITTED. Each statement sees data committed before that statement began. REPEATABLE READ provides a stable snapshot for the transaction; SERIALIZABLE provides stronger protection against serialization anomalies but transactions may need to be retried after serialization failures. Select the isolation level based on correctness requirements and workload.

## Evidence still to capture
Save genuine screenshots from both sessions showing the lock/wait behaviour, COMMIT/ROLLBACK outcomes and final wallet balances. Put them in this folder's `evidence/` directory.

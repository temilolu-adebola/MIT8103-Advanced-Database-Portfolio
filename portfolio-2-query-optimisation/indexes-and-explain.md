# Query optimisation and execution-plan evidence

## Indexing strategy
The schema creates indexes for:
- `wallets(customer_id)` for customer-to-wallet lookups.
- `bank_accounts(customer_id)` for linked-account retrieval.
- `payment_transactions(source_wallet_id, created_at DESC)` for a customer's outgoing history.
- `payment_transactions(transaction_status, created_at DESC)` for status/time filtering.
- `fraud_alerts(review_status)` for open-alert queues.

Indexes can reduce table scanning for selective predicates but consume storage and add write overhead. The correct index depends on actual query patterns and data volume.

## Required practical comparison
1. Run `ANALYZE;` after loading a representative dataset.
2. Run `EXPLAIN (ANALYZE, BUFFERS)` for Query 2 in `queries.sql`.
3. Record the plan, execution time, rows and buffer information in `execution-plans/query-2-before.txt`.
4. For a meaningful before/after test, temporarily drop the relevant composite index, run the plan, then recreate it and rerun. Do not drop indexes in a shared/production database.
5. Compare actual execution plans. With only a few sample rows, PostgreSQL may correctly choose a sequential scan; use a larger generated test dataset for a fair index demonstration.
6. Save genuine screenshots and describe the observed results. Do not invent performance improvements.

Example:
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT transaction_id, reference, amount, created_at
FROM payment_transactions
WHERE source_wallet_id = 1
ORDER BY created_at DESC
LIMIT 50;
```

## Analysis template
- Dataset size:
- Query tested:
- Index state:
- Plan node(s):
- Actual execution time:
- Rows returned:
- Buffer reads/hits:
- Interpretation:
- Limitation:

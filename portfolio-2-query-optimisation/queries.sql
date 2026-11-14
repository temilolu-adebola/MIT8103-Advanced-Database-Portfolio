-- Query 1: Customer wallets
SELECT c.customer_id, c.first_name, c.last_name, w.wallet_id, w.currency, w.balance
FROM customers AS c
JOIN wallets AS w ON w.customer_id = c.customer_id
ORDER BY c.customer_id;

-- Query 2: Transaction history for one wallet (replace 1 with a wallet ID)
SELECT transaction_id, reference, transaction_type, amount, currency,
       transaction_status, created_at
FROM payment_transactions
WHERE source_wallet_id = 1 OR destination_wallet_id = 1
ORDER BY created_at DESC;

-- Query 3: Successful transaction volume by type
SELECT transaction_type, COUNT(*) AS transaction_count,
       SUM(amount) AS total_amount
FROM payment_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY transaction_type
ORDER BY total_amount DESC;

-- Query 4: Customers with total outgoing successful transaction value
SELECT c.customer_id, c.first_name, c.last_name,
       COALESCE(SUM(t.amount), 0) AS outgoing_total
FROM customers c
JOIN wallets w ON w.customer_id = c.customer_id
LEFT JOIN payment_transactions t
  ON t.source_wallet_id = w.wallet_id
 AND t.transaction_status = 'SUCCESS'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY outgoing_total DESC;

-- Query 5: Open fraud alerts with transaction context
SELECT fa.alert_id, fa.risk_score, fa.alert_reason, fa.review_status,
       t.reference, t.amount, t.currency, t.created_at
FROM fraud_alerts fa
JOIN payment_transactions t ON t.transaction_id = fa.transaction_id
WHERE fa.review_status IN ('OPEN', 'UNDER_REVIEW')
ORDER BY fa.risk_score DESC, t.created_at DESC;

-- Query 6: High-value successful payments (threshold is illustrative)
SELECT reference, transaction_type, amount, currency, created_at
FROM payment_transactions
WHERE transaction_status = 'SUCCESS'
  AND amount >= 10000
ORDER BY amount DESC;

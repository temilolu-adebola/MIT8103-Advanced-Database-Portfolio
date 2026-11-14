-- Sample data for local testing. Run after schema.sql.
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('Ada', 'Okafor', 'ada.okafor@example.test', '+2348000000001'),
('Tunde', 'Bello', 'tunde.bello@example.test', '+2348000000002'),
('Mariam', ' Yusuf', 'mariam.yusuf@example.test', '+2348000000003');

INSERT INTO wallets (customer_id, currency, balance)
SELECT customer_id, 'NGN',
       CASE email
         WHEN 'ada.okafor@example.test' THEN 150000.00
         WHEN 'tunde.bello@example.test' THEN 50000.00
         ELSE 25000.00
       END
FROM customers;

INSERT INTO bank_accounts (customer_id, bank_name, account_token, masked_account_number, verified)
SELECT customer_id, 'Example Bank',
       'tok_' || customer_id::text, '******' || LPAD(customer_id::text, 4, '0'), TRUE
FROM customers;

INSERT INTO merchants (merchant_name, merchant_category, settlement_reference) VALUES
('City Utilities', 'UTILITIES', 'SETTLE-CITY-001'),
('Fresh Basket', 'GROCERY', 'SETTLE-FRESH-001');

INSERT INTO payment_transactions
(reference, transaction_type, source_wallet_id, destination_wallet_id,
 amount, currency, transaction_status, description)
VALUES
('PF-SEED-0001', 'TRANSFER', 1, 2, 5000.00, 'NGN', 'SUCCESS', 'Sample historical transfer'),
('PF-SEED-0002', 'TRANSFER', 2, 3, 1500.00, 'NGN', 'SUCCESS', 'Sample historical transfer');

INSERT INTO fraud_alerts (transaction_id, risk_score, alert_reason)
VALUES (2, 72.50, 'Unusual transaction pattern – sample training alert');

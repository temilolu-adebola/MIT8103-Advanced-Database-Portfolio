-- PayFlow relational schema (PostgreSQL)
CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED'))
);

CREATE TABLE bank_accounts (
    bank_account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    bank_name VARCHAR(120) NOT NULL,
    account_token VARCHAR(100) NOT NULL UNIQUE,
    masked_account_number VARCHAR(30) NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wallets (
    wallet_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL UNIQUE REFERENCES customers(customer_id),
    currency CHAR(3) NOT NULL DEFAULT 'NGN',
    balance NUMERIC(18,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
    wallet_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (wallet_status IN ('ACTIVE', 'FROZEN', 'CLOSED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE merchants (
    merchant_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    merchant_name VARCHAR(150) NOT NULL,
    merchant_category VARCHAR(80) NOT NULL,
    settlement_reference VARCHAR(100) UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED'))
);

CREATE TABLE payment_transactions (
    transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference VARCHAR(40) NOT NULL UNIQUE,
    transaction_type VARCHAR(20) NOT NULL
        CHECK (transaction_type IN ('TRANSFER', 'MERCHANT_PAYMENT', 'REVERSAL')),
    source_wallet_id BIGINT REFERENCES wallets(wallet_id),
    destination_wallet_id BIGINT REFERENCES wallets(wallet_id),
    merchant_id BIGINT REFERENCES merchants(merchant_id),
    amount NUMERIC(18,2) NOT NULL CHECK (amount > 0),
    currency CHAR(3) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (transaction_status IN ('PENDING', 'SUCCESS', 'FAILED', 'REVERSED')),
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK (source_wallet_id IS NULL OR destination_wallet_id IS NULL
           OR source_wallet_id <> destination_wallet_id),
    CHECK (
      (transaction_type = 'TRANSFER' AND source_wallet_id IS NOT NULL
       AND destination_wallet_id IS NOT NULL AND merchant_id IS NULL)
      OR
      (transaction_type = 'MERCHANT_PAYMENT' AND source_wallet_id IS NOT NULL
       AND merchant_id IS NOT NULL AND destination_wallet_id IS NULL)
      OR
      (transaction_type = 'REVERSAL')
    )
);

CREATE TABLE fraud_alerts (
    alert_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_id BIGINT NOT NULL REFERENCES payment_transactions(transaction_id),
    risk_score NUMERIC(5,2) NOT NULL CHECK (risk_score BETWEEN 0 AND 100),
    alert_reason VARCHAR(255) NOT NULL,
    review_status VARCHAR(20) NOT NULL DEFAULT 'OPEN'
        CHECK (review_status IN ('OPEN', 'UNDER_REVIEW', 'CLOSED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Helpful indexes; further performance testing is in Portfolio 2.
CREATE INDEX idx_wallets_customer ON wallets(customer_id);
CREATE INDEX idx_bank_accounts_customer ON bank_accounts(customer_id);
CREATE INDEX idx_tx_source_created ON payment_transactions(source_wallet_id, created_at DESC);
CREATE INDEX idx_tx_status_created ON payment_transactions(transaction_status, created_at DESC);
CREATE INDEX idx_fraud_alerts_status ON fraud_alerts(review_status);

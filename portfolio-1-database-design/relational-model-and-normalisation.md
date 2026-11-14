# Relational model, keys and normalisation

## Entity relationships
- `customers` 1-to-many `bank_accounts`: one customer may link multiple external accounts.
- `customers` 1-to-1 `wallets` in this simplified case study: `wallets.customer_id` is UNIQUE.
- `wallets` 1-to-many `payment_transactions` as source wallet.
- `wallets` 1-to-many `payment_transactions` as destination wallet.
- `merchants` 1-to-many `payment_transactions` for merchant payments.
- `payment_transactions` 1-to-many `fraud_alerts`: a transaction may generate multiple alerts.

## Keys and constraints
Each table has a surrogate primary key. Foreign keys preserve referential integrity. Unique constraints protect email, account token, transaction reference and the one-wallet-per-customer assumption. CHECK constraints validate statuses, positive transaction amounts, non-negative wallet balances, risk-score range and transaction-type structure. NOT NULL constraints protect required attributes.

## Normalisation
**First Normal Form (1NF):** Each field stores a single value; repeating bank accounts are represented as separate rows in `bank_accounts`, not as comma-separated values in a customer field.

**Second Normal Form (2NF):** Each table uses a single-column primary key, so non-key attributes depend on the whole key. The design avoids partial dependencies on a composite key.

**Third Normal Form (3NF):** Non-key attributes describe their table's key and are not stored as facts about another non-key attribute. For example, merchant details are stored in `merchants`, not repeated in every transaction. Customer contact details are stored in `customers`, not copied into `wallets`.

## ER diagram
Create an ER diagram in diagrams.net using the entities and relationships above. Export it as `er-diagram.png` and commit it here. The diagram should show PK/FK labels and relationship cardinalities. A text description is provided here; a genuine exported diagram is still required as visual evidence.

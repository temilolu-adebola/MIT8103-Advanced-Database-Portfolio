# Portfolio 1 – Case Study: PayFlow

## Organisation and business context
PayFlow is a simulated digital payments company. Its platform enables customers to hold funds in digital wallets, link external bank accounts, transfer money to other PayFlow wallets and pay registered merchants.

## Database users
- Customers: initiate payments and view their own wallet and transaction information through the application.
- Payment service: validates and records transfers and merchant payments.
- Merchants: receive payment status and transaction references.
- Operations and fraud analysts: review transaction activity and investigate flagged activity.
- Database administrators: maintain database availability, security, backup and performance.

## Main data
The relational database stores customer profiles, linked bank-account references, wallets, merchants, payment transactions and fraud alerts. Sensitive bank details are represented by masked account references in this teaching dataset; production systems should use tokenisation and avoid storing unnecessary payment credentials.

## Operations supported
1. Register a customer and create a wallet.
2. Link an external bank account reference to a customer.
3. Register a merchant.
4. Transfer funds between two PayFlow wallets.
5. Pay a merchant from a customer's wallet.
6. Retrieve transaction history and identify high-value transactions.
7. Record and review fraud alerts.

## Scope and assumptions
- Each customer has one wallet in this simplified model; a customer may have multiple linked bank-account references.
- Each wallet has one currency. Transfers are allowed only between wallets using the same currency.
- Each transaction row represents one logical transfer/payment, not the individual debit and credit ledger legs. A production ledger would normally use immutable double-entry postings.
- Amounts must be positive and balances cannot become negative.
- The schema is for education and is not a production payment-processing system.

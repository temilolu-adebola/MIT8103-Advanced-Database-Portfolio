# Portfolio 4 – NoSQL document model

## Selected model
MongoDB document database, using a `transaction_events` collection.

## Why document storage is suitable
Transaction event records may contain variable metadata, risk flags, counterparty details and a sequence of status events. A document model can keep related event information together and allows optional fields to vary between event types. This is useful for operational event history and fraud-analysis context.

## Example document structure
The executable sample is in `mongodb-model.js`. It includes a transaction reference, customer and wallet identifiers, a nested amount/currency object, a counterparty subdocument, risk metadata and an embedded event-history array.

## Relational versus document responsibilities
The relational PostgreSQL database remains the authoritative store for wallet balances and money movement because constraints, relational integrity and ACID transactions are central to financial transfers. MongoDB is used here as a complementary event/document store for flexible transaction-event details and analysis. It should not independently update balances without a controlled consistency design.

## Practical evidence
Run the JavaScript in `mongosh`, capture successful insert output, index creation and query results. Record MongoDB version and environment. The sample is illustrative and must be executed before claiming successful implementation.

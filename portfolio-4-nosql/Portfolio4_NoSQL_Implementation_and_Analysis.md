Portfolio 4: NoSQL & Advanced Data Models



4.1 Implementing a NoSQL Database



As part of this activity, a NoSQL database was implemented using MongoDB as the database. This is a document-based database that stores data in BSON documents.



A database was created named payflow_nosql. There were two collections in this database, transactions and fraud_alerts. The transactions collection contains payment information with the transaction ID, customer ID, transaction Type, amount, currency and status. Additional information about the transaction, such as the merchant information, payment information, fraud information and time created, were stored as embedded documents.



The fraud_alerts collection contains information about the alert, such as the alert ID, transaction ID, customer ID, alert type, risk score, severity, status and investigation.



4.2 Queries, Aggregation & Indexing



A few queries were executed using MongoDB Compass. A query was executed to filter the transactions with a status of SUCCESS. A query to filter transactions with a failed status was also executed.



An aggregation was created using the group and sort stages. This grouped the transactions by the status. This gave us an indication of how many transactions there were per status and what the total was. In our test data we had one transaction with a SUCCESS status (NGN 250) and one transaction with a failed status (NGN 1500).



An index was created on the status field. This would allow us to search for payments based on their status. Using the schema analysis in MongoDB Compass we looked at what fields and data types there were in our transaction documents.



4.3 Suitability of MongoDB for PayFlow



This database is suited to PayFlow as there could be a variety of information to store in relation to payments, such as merchant information, payment channel, wallet reference and fraud information. The ease of inserting data into documents means we can store related data together within one document, reducing the need for multiple joins.



Using embedded documents made the data easier to show how the payment and fraud information was nested. Being able to perform an aggregation allowed us to create summary reports on the transactions. Creating indexes can improve the performance of searching for frequently searched records.



Additional work would be required if this was being implemented as a live payment platform. For example, appropriate security, validation, back up, replication and ensuring consistency in transactions. This implementation has been done for educational purposes only and uses sample data.
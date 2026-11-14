# Portfolio 5 – Distributed and cloud database design

## Proposed architecture
For a growing PayFlow service, deploy PostgreSQL as the authoritative transactional database in a managed cloud database service, with a primary writer and one or more read replicas in separate availability zones. Application services connect through a private network. Backups and point-in-time recovery are enabled. Monitoring tracks CPU, storage, connection count, replication lag, transaction latency and failed queries.

## Replication
- Synchronous replication may be considered for a standby where the required durability/availability trade-off is acceptable.
- Asynchronous read replicas can serve reporting and read-heavy transaction-history queries, reducing load on the primary.
- Replica lag means a recent committed transaction may not immediately appear on a replica. The application should read-after-write from the primary for critical confirmation screens.
- Failover procedures, backup restoration and replica promotion must be tested.

## Sharding and partitioning
Sharding distributes data across multiple database nodes. A possible future shard key is a stable customer or wallet identifier, keeping a customer's wallet-related workload together. The choice must avoid hot shards and account for cross-shard transfers, reporting and rebalancing complexity. Sharding is not recommended prematurely; vertical scaling, indexing, connection pooling and read replicas should be assessed first.

Time-based partitioning of high-volume transaction history can also help manage retention and large tables. Partitioning within one PostgreSQL cluster is not the same as sharding across independent nodes.

## Availability and consistency
The primary database should enforce strong transactional consistency for wallet debits and credits. Read replicas may be eventually consistent because of replication lag. The application must distinguish critical balance/payment confirmation reads from reports that can tolerate slightly stale data.

## Security and resilience
Use private networking, TLS in transit, encryption at rest, least-privilege database roles, secrets management, audit logging, automated backups, point-in-time recovery and tested disaster-recovery runbooks. Do not place credentials or real customer/payment data in GitHub.

## Limitations and implementation evidence
This portfolio presents a design exercise, not a live cloud deployment. To claim deployment evidence, provision an approved cloud database, configure replication, run controlled tests and capture configuration and monitoring screenshots. Do not expose cloud credentials in the repository.

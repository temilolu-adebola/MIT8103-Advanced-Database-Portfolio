// Run in mongosh after selecting the payflow_nosql database.
use("payflow_nosql");

db.createCollection("transaction_events");

db.transaction_events.insertMany([
  {
    reference: "PF-MONGO-0001",
    customerId: 1,
    walletId: 1,
    eventType: "TRANSFER",
    amount: { value: 5000.00, currency: "NGN" },
    status: "SUCCESS",
    counterparty: { type: "WALLET", walletId: 2 },
    risk: { score: 12.5, flags: [] },
    eventHistory: [
      { status: "PENDING", at: ISODate("2026-10-01T10:00:00Z") },
      { status: "SUCCESS", at: ISODate("2026-10-01T10:00:02Z") }
    ],
    createdAt: ISODate("2026-10-01T10:00:00Z")
  },
  {
    reference: "PF-MONGO-0002",
    customerId: 2,
    walletId: 2,
    eventType: "MERCHANT_PAYMENT",
    amount: { value: 1800.00, currency: "NGN" },
    status: "SUCCESS",
    counterparty: { type: "MERCHANT", merchantId: 1, name: "City Utilities" },
    risk: { score: 74.0, flags: ["UNUSUAL_AMOUNT"] },
    eventHistory: [
      { status: "PENDING", at: ISODate("2026-10-02T12:00:00Z") },
      { status: "SUCCESS", at: ISODate("2026-10-02T12:00:03Z") }
    ],
    createdAt: ISODate("2026-10-02T12:00:00Z")
  }
]);

db.transaction_events.createIndex({ reference: 1 }, { unique: true });
db.transaction_events.createIndex({ customerId: 1, createdAt: -1 });
db.transaction_events.createIndex({ status: 1, createdAt: -1 });

// Example queries
db.transaction_events.find({ customerId: 1 }).sort({ createdAt: -1 });
db.transaction_events.find({ "risk.score": { $gte: 70 } });
db.transaction_events.find(
  { status: "SUCCESS", "amount.currency": "NGN" },
  { reference: 1, amount: 1, createdAt: 1, _id: 0 }
);

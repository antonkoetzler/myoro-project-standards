# SQL & Database Standards

## Style

- Keywords UPPERCASE. Identifiers snake_case. One clause per line for complex queries.

## Naming

- PKs: `id`. FKs: `<table>_id`. Indexes: `idx_<table>_<col>`. Unique: `uq_<table>_<col>`.
- Tables: singular or plural — be consistent across the project.

## Migrations

- Always use a migration tool. Never modify schema manually in production.
- Migrations are forward-only. Never edit an existing migration once merged.
- Expand/contract pattern for zero-downtime deployments.

## N+1 Prevention

- Eager load associations. Use JOINs, not queries in loops.
- Use EXPLAIN ANALYZE in development to catch N+1 patterns.

## Indexes

- Index every FK column. Index columns used in WHERE/ORDER BY/JOIN ON.
- Do not over-index (slows writes). Audit unused indexes. Verify with EXPLAIN ANALYZE.

## Transactions

- Wrap multi-step mutations in a transaction. Keep transactions short.
- Consistent lock acquisition order to avoid deadlocks.
- Use SERIALIZABLE isolation only when necessary.

## Connection Pooling

- Always use a connection pool. Set sensible min/max pool sizes.
- Never open a connection per request without a pool.

## NoSQL

- Only when relational model genuinely doesn't fit. Document the data shape contract.
- No full-collection scans. Define and use indexes.

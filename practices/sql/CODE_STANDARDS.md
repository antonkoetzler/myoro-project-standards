# SQL & Database Standards

## SQL Style

- Keywords UPPERCASE: `SELECT`, `FROM`, `WHERE`, `JOIN`, `ON`, `GROUP BY`, `ORDER BY`, `HAVING`.
- Identifiers snake_case: `user_id`, `created_at`, `order_items`.
- One clause per line for complex queries:

```sql
SELECT
  u.id,
  u.email,
  COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id, u.email
ORDER BY order_count DESC;
```

## Naming Conventions

- Tables: singular or plural — pick one and apply consistently across the project.
- Primary keys: `id` (not `user_id` on the `users` table).
- Foreign keys: `<referenced_table>_id` — e.g. `user_id`, `order_id`.
- Indexes: `idx_<table>_<column(s)>` — e.g. `idx_users_email`, `idx_orders_user_id_created_at`.
- Unique constraints: `uq_<table>_<column(s)>` — e.g. `uq_users_email`.
- Check constraints: `chk_<table>_<description>` — e.g. `chk_products_price_positive`.

## Migrations

- Always use a migration tool: Flyway, Alembic, Liquibase, golang-migrate, Prisma Migrate.
- Never modify the database schema manually in production.
- Migrations are forward-only: if you need to undo, write a compensating migration. Do not rely on "down" migrations in production — they are rarely safe.
- Migration files are immutable once merged; never edit an existing migration.
- Every migration should be independently deployable without breaking the running application (expand/contract pattern for zero-downtime deployments).

## N+1 Prevention

- Eager load associations when you know you'll use them.
- Use JOINs to fetch related data in one query rather than querying in a loop.
- Use query analysis tools (EXPLAIN ANALYZE, ORM query loggers) in development to catch N+1 patterns.
- Never put database queries inside a loop without a deliberate batch strategy.

## Indexes

- Index every foreign key column.
- Index columns frequently used in `WHERE`, `ORDER BY`, or `JOIN ON` clauses.
- Do not over-index: each index slows `INSERT`, `UPDATE`, and `DELETE`. Audit unused indexes.
- Use `EXPLAIN ANALYZE` to verify that indexes are being used.
- Consider partial indexes for columns where only a subset of rows are queried.

## Transactions

- Wrap multi-step mutations in a single transaction; either all steps succeed or none do.
- Keep transactions as short as possible; long-running transactions lock rows and degrade throughput.
- Understand isolation levels: READ COMMITTED is the default for most databases; use SERIALIZABLE only when necessary (it is expensive).
- Never acquire locks in inconsistent order across transactions — this causes deadlocks.

## Connection Pooling

- Always use a connection pool (PgBouncer, HikariCP, SQLAlchemy pool, database/sql in Go).
- Set sensible min/max pool sizes for your workload; defaults are rarely optimal.
- Do not open a new database connection per request without a pool.
- Close connections and return them to the pool after use; connection leaks degrade performance.

## NoSQL

- Use NoSQL only when the relational model genuinely does not fit (document store for truly schema-free data, key-value for caching, time-series for metrics, graph for relationship-heavy queries).
- Document the data shape contract explicitly even without a schema — a schema is a form of documentation.
- No queries that scan entire collections; always define and use indexes.
- Avoid modeling relational data in a document store; joins in application code are expensive and error-prone.

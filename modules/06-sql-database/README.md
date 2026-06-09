# Module 6 — SQL and the database

> The persistence layer behind the service.

## Theory

So far candidates vanish when the server restarts. A database makes them persist.

- **Schema**: tables with typed columns and constraints (a `candidates` table; `email` not null; a primary key `id`).
- **CRUD**: the four operations — `INSERT`, `SELECT`, `UPDATE`, `DELETE` — that map onto the create/read/update/delete the service needs.
- **Joins**: combining rows from related tables on a shared key. You'll want this once there's more than one table (candidates and, say, the consultant who reads them).
- **SQLite to MySQL**: SQLite is a file, zero setup — enough to start. MySQL is a server, closer to production. Because the data access sits behind the service (module 9), moving from one to the other touches only the model.
- **Security**: always use **parameterised queries**, never string formatting. `"... WHERE email = ?"` with a bound value, not `f"... WHERE email = '{email}'"` — the second is SQL injection waiting to happen, and module 14 will try to exploit exactly that.

## Exercise

Replace the in-memory store with a real one:

- Define the `candidates` schema.
- Make `POST /candidates` insert and `GET /candidates` select, through parameterised queries.
- Confirm records survive a server restart.

Start on SQLite. Keep the database calls in one place so the swap to MySQL later is a single-file change.

## Solution

See [`solution/`](solution).

# Solution — SQL and the database

```bash
git checkout module-06
```

## What "done" looks like

- A `candidates` table with a primary key and the right `NOT NULL` constraints.
- Create and list go through the database with **parameterised** queries (bound values, no string interpolation).
- Data survives a restart.
- All database access lives in one module, so the SQLite→MySQL move is isolated.

## Notes

- The connection string for MySQL must come from an environment variable, never a literal in code.
- This is the first module with a real injection surface — keep the queries parameterised and module 14's abuse tests will pass by construction.

# Solution — the MVC pattern

```bash
git checkout module-09
```

## What "done" looks like

- A `service` module holding candidate logic as plain functions, testable without HTTP.
- Controllers reduced to parse → call service → respond.
- Templates render only what they're given.
- Database access reachable only through the service, so the model can change underneath it.

## Notes

- The proof it worked: you can `import` a service function and unit-test it directly, and swapping SQLite for MySQL touches only the model.
- This is "structure for testability", not structure for its own sake — every separation here pays off in modules 10–12.

# Solution — Test data and isolation

```bash
git checkout module-12
pytest tests/e2e -p no:randomly   # then run again WITH random order to prove isolation
```

## What "done" looks like

- A `candidate` (and test-account) fixture that sets up via the API and tears down in a `yield`/finally so cleanup runs even on failure.
- A factory producing valid data with overridable fields.
- The suite passes in any order and on repeat with no residue in the database.

## Notes

- Set up through the API, not the UI — fast and reliable. Drive the UI only for the behaviour you're actually testing.
- A good check: run the suite twice in a row. If the second run fails, something leaked. Randomise test order to flush hidden dependencies.

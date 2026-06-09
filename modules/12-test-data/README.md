# Module 12 — Test data and isolation

> What separates a stable suite from one full of flaky tests.

## Theory

A test that depends on data left behind by another test will eventually fail for reasons that have nothing to do with the code. The fix is **isolation**: each test creates the state it needs and destroys it afterwards, so order and history don't matter.

- **Fixtures**: setup/teardown wrapped around a test. In pytest and in Playwright a fixture can create a **test account or candidate** before the test and clean it up after — even if the test fails. This is the account lifecycle module 4 hinted at and module 7 made possible with programmatic auth.
- **Factories**: small builders that produce valid test data with sensible defaults, so a test states only the field it cares about (`make_candidate(email="dup@example.com")`).
- **Setup then teardown, per test**: the discipline that keeps the suite deterministic.

```python
@pytest.fixture
def candidate(api):
    # setup: create via the API (fast, no UI)
    created = api.create_candidate(make_candidate())
    yield created
    # teardown: always runs, even on failure
    api.delete_candidate(created["id"])
```

Create state through the **fast** path (the API) even when the *test* drives the slow path (the browser) — you don't need the UI to set up a candidate, only to test the behaviour under test.

## Exercise

Make each end-to-end test own its data:

- a fixture that creates a candidate (and/or a test account) before the test and deletes it after;
- a small factory for valid candidate data;
- prove isolation: run the suite in any order, repeatedly, with no leftover state and no cross-test failures.

## Solution

See [`solution/`](solution).

# Solution — API testing

```bash
git checkout module-10
pytest tests/api
```

## What "done" looks like

- `tests/api/` with httpx-based tests covering create, list, the `422` and `401` error paths, and at least one schema assertion.
- Each test name reads as a contract statement (`test_malformed_candidate_is_rejected`).
- The suite runs in seconds and needs no browser.

## Notes

- Use a FastAPI `TestClient` / httpx client fixture so tests don't depend on a separately running server.
- Test the **failing** paths deliberately — a suite that only proves the happy path tells you nothing about how the system refuses bad input, which is half of what module 14 cares about.

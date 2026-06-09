# Solution — Playwright and the UI

```bash
git checkout module-11
playwright install
pytest tests/e2e
```

## What "done" looks like

- Page objects (`CandidateForm`, `AdminLogin`) exposing intent methods; tests with **no raw selectors**.
- An end-to-end test for candidate submission and one for admin sign-in.
- Role/label locators and web-first assertions, no fixed `sleep`.

## Notes

- The test for "did I select the right element" belongs in the page object; the test for "did the behaviour happen" belongs in the test. Keeping that line is the whole point of POM.
- These tests are slow and few by design — the test pyramid (module 4) says push input-level coverage down to the API tests (module 10) and keep E2E for the flows that prove the pieces connect.

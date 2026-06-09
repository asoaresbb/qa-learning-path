# Solution — CI with GitHub Actions

```bash
git checkout module-19
# the workflow lives at .github/workflows/
```

## What "done" looks like

- A workflow triggered on PR that brings up the Docker stack and runs unit + API + e2e + security baseline + perf smoke.
- A scheduled (nightly) workflow for the full security and load runs.
- A demonstrated red→green: a deliberate failure turns the PR red; the fix turns it green.
- `main` protected so nothing merges without a green run.

## Notes

- Secrets (database password, signing key, any token) come from GitHub Actions **secrets**, never committed to the workflow file.
- The split — fast checks per PR, heavy checks nightly — is the real lesson: fast feedback and thorough coverage are different jobs.
- This closes the path: the final project is everything above, running automatically on every change.

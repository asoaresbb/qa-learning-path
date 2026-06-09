# Solution — Authentication and sessions

```bash
git checkout module-07
```

## What "done" looks like

- A login endpoint returning a token (or setting a session cookie) for valid credentials, and `401` for bad ones.
- An admin endpoint that lists candidates only with valid auth, `401`/`403` otherwise.
- A documented way to obtain auth in one programmatic call — the seam module 12's fixture will use.

## Notes

- Signing secret and admin credentials in environment variables. Never commit them; never log the token.
- This is the cleanest example in the path of *test design driving production design*: you expose a programmatic login because driving the UI per test would be slow and brittle.

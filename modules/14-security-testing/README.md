# Module 14 — Security testing

> The non-functional dimension that matters most given the data the site collects.

## Theory

The point of security testing is to check what the application must **refuse** to do, not only what it should do. You own this system, so you can attack it freely and fix what you find.

The **OWASP Top 10** applied to your own app:

- **Injection** — try SQL injection against the inputs; module 6's parameterised queries are what should defeat it. Prove it.
- **Broken authentication** — can you reach the admin view without auth, with an expired or tampered token, by guessing?
- **Input validation** — what happens with oversized, malformed, or unexpected-type input? The `422` path from module 10 is the first line.
- **File-upload attack surface** — if CV upload is included, validate type and size; an unchecked upload is a classic entry point.

Approach:

- **Hand-written negative and abuse tests** against the API — the targeted half, expressing specific threats as checks.
- **OWASP ZAP** for a **baseline scan** of the running site — the broad, automated half that surfaces the obvious.

## Exercise

- Write negative/abuse tests: an injection attempt that must be neutralised, an auth-bypass attempt that must be rejected, an oversized/malformed payload that must be refused.
- If CV upload exists, test that the wrong type and an oversized file are rejected.
- Run a **ZAP baseline scan** against the running site and triage the findings.

## Solution

See [`solution/`](solution).

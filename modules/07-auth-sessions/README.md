# Module 7 — Authentication and sessions

> Who is allowed to do what, and how tests get past the door without driving the login screen a thousand times.

## Theory

- **Cookies vs tokens**: a cookie is set by the server and sent back automatically by the browser; a token (often a **JWT**) is a signed string the client sends in an `Authorization: Bearer ...` header. A JWT carries claims (who you are, when it expires) that the server can verify without a session store.
- **Sessions**: server-side state keyed by a cookie — the classic alternative to stateless tokens.
- **Testing implication** (the point of putting this before the test modules): logging in through the UI on every test is slow and flaky. Instead you authenticate **once**, programmatically — hit the login endpoint, get a token or session cookie, and reuse it. Module 12 turns this into a fixture.
- **Mutual TLS**: given the security context, mTLS can come in towards the end — both sides present certificates, not just the server.

## Exercise

Add a protected area:

- A login endpoint that issues a token or session on valid credentials.
- A protected **admin view** (read the submitted candidates) that returns `401`/`403` without valid auth.
- A way to authenticate in a test *without* the login screen — a request that returns a usable token/cookie.

Credentials and signing secrets come from environment variables, never code.

## Solution

See [`solution/`](solution).

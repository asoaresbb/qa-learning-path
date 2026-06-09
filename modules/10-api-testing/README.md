# Module 10 — API testing

> Now there is an API of your own to test — far better than testing someone else's blind.

## Theory

This is where module 4's "intent over mechanics" first becomes code. An API test should read **declaratively**: name the endpoint, send a payload, assert the outcome. The test is a statement about the **contract**, not a pile of plumbing.

What to assert:

- **Status** — the right code for the right situation (`201` on create, `422` on bad input, `401` unauthenticated).
- **Contract / schema** — the response has the fields, types and shape the contract promises.
- **Error paths** — the requests that *should* fail, failing the right way. These matter as much as the happy path.
- **Authentication** — protected endpoints reject unauthenticated calls and accept authenticated ones.

Tools: **pytest with httpx** for the suite; **Postman** to see and poke the API by hand first.

```python
# Declarative: the test names intent, not mechanics.
def test_create_candidate_returns_201(client):
    resp = client.post("/candidates", json={"name": "Ada", "email": "ada@example.com"})
    assert resp.status_code == 201
    body = resp.json()
    assert body["id"]
    assert body["email"] == "ada@example.com"

def test_malformed_candidate_is_rejected(client):
    resp = client.post("/candidates", json={"name": "Ada"})  # missing email
    assert resp.status_code == 422
```

## Exercise

Write a suite against your service:

- create and list, asserting status **and** body shape;
- the failing paths: missing fields (`422`), unauthenticated access to admin (`401`);
- one schema-level assertion so a dropped or renamed field is caught.

Make each test read as a sentence about the contract.

## Solution

See [`solution/`](solution).

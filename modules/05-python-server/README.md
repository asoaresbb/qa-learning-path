# Module 5 — A server in Python

> Where the client-server model stops being theory. This service is the system under test for everything that follows.

## Theory

A REST service built with **FastAPI**. It is a good first server because it gives you two things for free that you'd otherwise hand-roll:

- **Validation** from **Pydantic** models: declare the shape of a candidate (name, email, ...) as a Python class, and FastAPI rejects malformed requests with a `422` before your code runs.
- **OpenAPI docs**: an interactive `/docs` page generated from those same models, so the contract is always visible and never drifts from the code.

Concepts: a **path operation** (`@app.get("/candidates")`) maps a method + path to a function; the function's parameters and return type are the contract; **uvicorn** is the server that runs it.

This is the first app module — `/app` starts here and grows one layer per module after this.

## Exercise

Add the first two endpoints to the service:

- `POST /candidates` — accepts a candidate (name, email, and whatever the consultancy form needs), validates it, stores it, returns it with an id and `201`.
- `GET /candidates` — returns the list.

An in-memory store (a list or dict) is fine at this stage; module 6 swaps it for a database. Run it with uvicorn and exercise both endpoints from `/docs` and from `curl`.

## Solution

See [`solution/`](solution).

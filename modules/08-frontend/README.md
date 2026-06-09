# Module 8 — The front end, server-rendered first

> Start simple: the server renders the whole page. Then split out a JSON API.

## Theory

Two stages, deliberately in this order.

**Server-side rendering with Jinja2.** The server receives the request, talks to the database, renders the full HTML page and returns it. This keeps a beginner away from async, JSON synchronisation and CORS while they build the candidate form. Server-rendered pages also carry their content in the initial HTML, which means fewer waits and fewer flaky tests later (module 11).

**Then split the submission into a JSON endpoint** consumed by JavaScript with `fetch`. This introduces the model used in most modern stacks — and, importantly for us, opens a clean **API layer** to test directly (module 10). This is also where **CORS** first appears.

Plain **HTML, CSS and JavaScript** are the right starting point: the DOM, events and forms are exactly what the browser automation will interact with.

## Exercise

1. Build the public **candidate form** as a server-rendered Jinja2 page: GET renders it, POST handles the submission and persists it.
2. Then **split** the submission: a JSON endpoint (`POST /api/candidates`) that the form calls with `fetch`, handling the response in JavaScript.

Keep the form's fields stable and labelled — module 11 will select on them and module 13 will check their accessibility.

## Solution

See [`solution/`](solution).

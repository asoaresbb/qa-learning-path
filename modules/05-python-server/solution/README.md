# Solution — A server in Python

The solution to an app module is the state of `/app` after it. Once the path is tagged:

```bash
git checkout module-05
uvicorn app.main:app --reload
```

Then open http://127.0.0.1:8000/docs.

## What "done" looks like

- A Pydantic `Candidate` model with the fields the form needs.
- `POST /candidates` returns `201` with the stored record (including an `id`); a malformed body returns `422` without your code running.
- `GET /candidates` returns the list.
- `/docs` shows both endpoints with the request/response schema.

## Notes

- Keep the store behind a small function (e.g. `save_candidate`) even while it's in memory — module 9 turns that seam into a service layer and module 6 swaps the body for a database without touching the endpoints.
- Don't log the request body; it will contain personal data once the real form exists.

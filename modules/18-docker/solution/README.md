# Solution — Docker

```bash
git checkout module-18
docker compose up --build      # whole site: app + database
docker compose run --rm tests  # the suite against the running stack
```

## What "done" looks like

- A `Dockerfile` that builds the app image with pinned dependencies.
- A `compose` file wiring app + database (+ a test runner service) on one network.
- A clean clone runs with Docker alone — nothing else installed.

## Notes

- Database password and signing key come from the environment, never baked into the image or committed.
- This is the foundation module 19 builds on: CI runs the same containers, so "passes in CI" and "passes locally" mean the same thing.

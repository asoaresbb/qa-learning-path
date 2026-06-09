# Module 18 — Docker

> Running the application, the database and the tests reproducibly.

## Theory

"Works on my machine" is a real cost, and Docker is the standard answer.

- An **image** is a packaged filesystem + the command to run; a **container** is a running instance of one. The image pins the Python version, the dependencies, everything — so it runs the same on your laptop and in CI.
- A **Dockerfile** describes how to build the app's image.
- **Docker Compose** brings up several containers together — the app, the database, and the test runner — wired into one network with one command.
- For this project it means: one command starts the whole site (app + MySQL), and another runs the full suite against it, identically everywhere.

## Exercise

- Write a **Dockerfile** for the app.
- Write a **compose** file that brings up the app and the database together.
- Make `docker compose up` start the whole site, and add a way to run the test suite against the running stack.
- Confirm a fresh clone needs nothing installed but Docker.

Keep secrets (database password, signing key) in environment variables / compose `environment`, never baked into the image.

## Solution

See [`solution/`](solution).

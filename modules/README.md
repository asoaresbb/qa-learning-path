# Modules

The top-level [README](../README.md) is the map: the narrative path, one paragraph per module. This folder is the territory: each module has its own theory, an exercise to attempt, and a gated solution to check against afterwards.

## Layout

Every module folder follows the same shape:

```
NN-name/
  README.md     theory, then the exercise prompt
  exercise/     starter files to fill in (where a starter helps)
  solution/     reference answer — try the exercise first
```

## Two kinds of module

**Foundation drills (1–4)** are standalone. Each folder is self-contained: theory, exercise, and a complete reference solution.

**App modules (5–19)** all grow a single application. The app lives at [`/app`](../app) and accumulates one layer per module. Rather than copy a diverging app into nineteen folders, the repo is tagged per module:

```
git checkout module-08    # the app exactly as it stands after module 8
```

So a module's "solution" is two things: the notes and tests in its `solution/` folder, and the state of `/app` at that module's tag.

## The path

| # | Module | Builds |
|---|--------|--------|
| 1 | [Linux basics](01-linux-basics) | foundation |
| 2 | [Git and GitHub](02-git-github) | foundation |
| 3 | [Networking and HTTP](03-networking-http) | foundation |
| 4 | [QA fundamentals and test design](04-test-design) | foundation |
| 5 | [A server in Python](05-python-server) | the app begins |
| 6 | [SQL and the database](06-sql-database) | persistence |
| 7 | [Authentication and sessions](07-auth-sessions) | protected admin view |
| 8 | [The front end](08-frontend) | public form, then JSON API |
| 9 | [The MVC pattern](09-mvc) | service layer |
| 10 | [API testing](10-api-testing) | API suite |
| 11 | [Playwright and the UI](11-playwright-ui) | end-to-end coverage |
| 12 | [Test data and isolation](12-test-data) | per-test state |
| 13 | [Accessibility](13-accessibility) | axe scan of the form |
| 14 | [Security testing](14-security-testing) | abuse-case tests |
| 15 | [Performance testing](15-performance) | load test |
| 16 | [BDD and Gherkin](16-bdd-gherkin) | executable scenarios |
| 17 | [ATDD](17-atdd) | acceptance-first feature |
| 18 | [Docker](18-docker) | one-command bring-up |
| 19 | [CI with GitHub Actions](19-ci-github-actions) | the suite on every PR |

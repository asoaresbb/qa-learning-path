# Quality Engineering from the Ground Up

> Building and Testing a Web App, One Layer at a Time

A learning path for anyone working toward software quality — testers, QA and quality engineers, and developers who want to test what they build — to understand how systems talk to each other and how to automate testing across the stack. It moves from the ground up, starting with the environment everything runs on and ending with a full application that the learner has built and tested themselves.

The method matters as much as the topics. Rather than ten disconnected exercises, the work is organised around a single application that grows with each module. The foundations are short drills. From the server module onward, every topic adds a layer to the same project, so the learner sees how the pieces connect instead of meeting them in isolation. The end result is a consultancy website where a candidate submits their details through a form and those details persist in a database, with a complete test suite running automatically on every change.

> **A note on the name.** "Quality engineering" and "QA" are the terms people search for, so they're on the cover — but this path holds to Michael Bolton's distinction underneath. *Testing is not quality, and quality engineering is not testing.* Testing produces information that lets people make decisions about quality; it doesn't produce or assure quality — that's the work of everyone building the thing. Read the title as the familiar doorway, and the content as an argument for what testing actually is and does. See Bolton's *[Testing is Not Quality; Quality is Not Testing](https://developsense.com/blog/2024/10/testing-is-not-quality-quality-is-not-testing)* (2024) and *[Quality Engineering Is Not Testing](https://developsense.com/blog/2026/04/quality-engineering-is-not-testing)* (2026), and module 4.

## How to use this

Work through the modules in order; each one assumes the previous. Modules 1 to 4 are standalone exercises that build the foundation and the testing mindset. Modules 5 onward build the consultancy site one layer at a time, so by the end the final project is the finished accumulation, wired into continuous integration.

This page is the map. The territory is in [`modules/`](modules): each module has its own folder with the theory, an exercise to attempt, and a gated solution to check against. The foundation drills (1–4) carry a complete reference solution; the app modules (5–19) grow the single application in [`app/`](app), with the repo tagged per module (`git checkout module-08`) so you can see the app at any stage. Clone it, try the exercises, then read the solutions.

## Learning path

### 1. Linux basics
The environment everything runs on. The shell, the filesystem, pipes and redirection — and above all the two things a tester reaches for daily: navigating a machine and searching logs to triage a bug.
Exercise: find your way around the command line, then triage real web and application logs — tracking a brute-force attempt and a failing checkout across both files, ending in a written bug report.

### 2. Git and GitHub
Version control before there is any code worth keeping. Commits, branches, merges, conflicts, pull requests and review.
Exercise: contribute to a repository, open a pull request, and review someone else's.

### 3. Networking and the client-server model
How the web actually works: TCP/IP, DNS, ports, and the HTTP request-response cycle with its methods, status codes and headers. This is also where TLS and HTTPS belong, at a level that explains why port 443 matters, what the handshake does, and what a certificate is for.
Exercise: inspect real traffic with curl and the browser's Network tab, reading what comes back.

### 4. Testing fundamentals and test design
The mental frame before the tools: how to think about a test, so that the automation built later has something to stand on. The distinction between testing and checking — Michael Bolton and James Bach's, from Rapid Software Testing — the place of risk and oracles, and the test-design techniques that turn guessing into choosing, specification-based and experience-based alike — knowing what is worth checking before automating anything.

One idea runs through everything that follows and is worth planting here: a test should say *what* it verifies, not *how* it drives the system. "A candidate submits valid details and is accepted" is the intent; the clicking, posting and waiting are mechanics that belong underneath it, out of sight. Hold the two apart and a test reads as a specification of behaviour rather than a script that happens to pass — and the suite survives a change in the UI or the wiring beneath it. This is the same principle whether the test talks to a browser or to an API, and it is what the Page Object Model in module 11 and the API suite in module 10 are built to express. The point now is only to recognise the seam between intent and mechanics, before any framework hides it.

Exercise: take a real user intent — placing an order, say: add to cart, check out, pay, confirm. First test it: walk the flow as if you had never seen it, and each time it surprises you, update your notes on what could go wrong and what actually matters. Then design the checks: decide whether one automated test should drive the whole flow end to end or whether each step earns its own, where along the way the inputs — quantity, address, payment — are worth partitioning and bounding, and which of those choices buys the most confidence for the least upkeep. The first half is testing, the exploring that keeps changing your mental model; the second is checking, choosing what is worth pinning down in code. Naming which half you are in is the skill.

### 5. A server in Python
Where the client-server model stops being theory. A REST service built with FastAPI, which provides validation and OpenAPI documentation out of the box. This service becomes the system under test for everything that follows.
Adds to the project: endpoints to create and list candidates.

### 6. SQL and the database
The persistence layer behind the service. Schema design, CRUD, joins, and the service talking to the database. SQLite is enough to start; MySQL brings it closer to production.
Adds to the project: candidate records stored and queried in a real database.

### 7. Authentication and sessions
Tokens, cookies, JWT, and what they imply for testing, including how to authenticate in tests without driving the login screen hundreds of times. Given the security context this work sits in, mutual TLS can be introduced towards the end.
Adds to the project: a protected administration view for the consultant.

### 8. The front end, server-rendered first
Start with server-side rendering using Jinja2, the standard Python template engine. The server receives the request, talks to the database, renders the full page and returns it, which keeps a beginner away from async, JSON synchronisation and CORS while they build the candidate form. Once that flow is solid, split the submission into a JSON endpoint consumed by JavaScript, which introduces the model used in most modern stacks and opens a clean API layer to test. Plain HTML, CSS and JavaScript are the right starting point, since the DOM, events and forms are what the browser automation will interact with later.
Adds to the project: the public candidate form, then a JSON API behind it.

### 9. Structuring the app: the MVC pattern
With the model (the database layer), the view (the templates) and the controller (the routes) all present, the natural next step is to separate them properly. Business logic moves out of the templates and the route handlers into a service layer, leaving controllers thin and views dumb. This is not architecture for its own sake: a service that holds the logic in plain functions is what makes unit tests possible, and a thin controller is what keeps the API layer clean to test. Good structure and testability are the same goal seen from two sides. The same separation decouples the data layer: with database access isolated behind the service, swapping SQLite for MySQL touches only the model, not the controllers or the views, which is exactly what lets module 6 start on SQLite and move to MySQL later without rewriting the application.
Adds to the project: the service reorganised into model, view and controller, with the candidate logic in its own testable layer.

### 10. API testing
Now there is an API of one's own to test, which is far better than testing someone else's blind. Assertions on status, contract and schema, error paths, and authentication. pytest with httpx, or Postman to see it first.
Adds to the project: a suite against the service, including the paths that fail.

### 11. Playwright and the UI
Browser automation, with the Page Object Model from the start so no bad habits form. Selectors, waits and fixtures. Server-rendered pages carry their content in the initial HTML, which means fewer waits and fewer flaky tests than a client-rendered equivalent.
Adds to the project: end-to-end coverage of the main flows, candidate submission and admin login included.

### 12. Test data and isolation
Fixtures, factories, and creating then destroying state per test. This is what separates a stable suite from one full of flaky tests.
Adds to the project: each end-to-end test creating and cleaning up its own candidate.

### 13. Accessibility
Bring axe checks into Playwright. Forms are exactly where accessibility matters, which ties this to the candidate form and to the European Accessibility Act.
Adds to the project: an accessibility scan of the form, with fixes for what it finds.

### 14. Security testing
The non-functional dimension that matters most given the data the site collects. The OWASP Top 10 applied to a system the learner owns: injection, broken authentication, input validation, and the file-upload attack surface that the CV question raises. The point is to test for what the application must refuse to do, not only what it should do. Tools such as OWASP ZAP for a baseline scan, alongside hand-written negative tests against the API.
Adds to the project: negative and abuse-case tests against the form and the API, plus a baseline scan of the running site.

### 15. Performance testing
How the service behaves under load rather than whether it is correct. Latency, throughput and the difference between a single slow request and a system that degrades under concurrency. Load testing with k6 against the candidate submission endpoint, reading percentiles instead of averages and knowing what a meaningful threshold looks like.
Adds to the project: a load test against the submission flow, with a baseline the suite can hold to.

### 16. BDD and Gherkin
Given/when/then and feature files, wired to pytest-bdd or Playwright. The point to land is that Gherkin exists to align understanding, not to decorate tests.
Adds to the project: the candidate scenarios rewritten as executable Gherkin.

### 17. ATDD
More a practice and a mindset than a tool: the three amigos, and writing acceptance criteria before the code.
Adds to the project: a new feature built acceptance-first.

### 18. Docker
Running the application, the database and then the tests reproducibly. It settles the "works on my machine" problem and is expected in most places now.
Adds to the project: the whole site brought up with a single command.

### 19. Continuous integration with GitHub Actions
Everything running on every pull request: unit, API, end-to-end, the security baseline and a performance smoke check, with the request turning red when something breaks. The heavier security and load runs can sit on a nightly schedule rather than every push, which teaches the difference between fast feedback and thorough coverage.
Adds to the project: the suite wired into CI, with a deliberate failure to confirm the signal.

## The final project

The consultancy website is not new work; it is the accumulation of everything above. A candidate fills in their details on a public form, those details reach the database through the service, and a consultant signs into a protected view to read the submissions. Over that runs the full pyramid: API tests, end-to-end tests with Playwright and the Page Object Model, data isolation, an accessibility scan of the form, the scenarios in Gherkin, all inside Docker and running in CI on every change. Anyone who can explain the final README has understood the essentials.

Two questions the subject raises naturally, each a good lesson in its own right. The first is CV upload, if it is included: validating file type and size is a classic entry point for security problems and teaches the learner to think about attack surface. The second is data protection. Collecting candidates' personal details is the right moment to introduce the basics of consent and retention, in line with GDPR. It need not be deep, but it shows early that quality is also governance, not only features.

## Stack

Linux and Bash, Git and GitHub, HTTP and TLS, Python with FastAPI, Jinja2, SQLite or MySQL, plain JavaScript with fetch, pytest with httpx, Playwright, pytest-bdd, axe for accessibility, OWASP ZAP for security, k6 for performance, Docker, and GitHub Actions.

## Further reading

Books that span the whole path rather than a single module (each module has its own focused references):

- **Dan Olsen**, *The Lean Product Playbook* (2015) — building the right product: product-market fit and MVPs. The counterpart to this path, which is about building it well and knowing it works.
- **Steve Freeman & Nat Pryce**, *Growing Object-Oriented Software, Guided by Tests* — the canonical treatment of test-first development and the acceptance-test architecture module 4 introduces.
- **Kent Beck**, *Test-Driven Development by Example* — red-green-refactor from the source.
- **Lisa Crispin & Janet Gregory**, *Agile Testing* — testing as a whole-team activity, with the testing quadrants.
- **Gojko Adzic, David Evans & Tom Roden**, *Fifty Quick Ideas to Improve Your Tests* (2015) — short, practical ideas on what to test and how to keep a suite valuable. [fiftyquickideas.com](https://www.fiftyquickideas.com/)

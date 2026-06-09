# Module 17 — ATDD

> More a practice and a mindset than a tool.

## Theory

**Acceptance-Test-Driven Development** flips the order: you agree on the acceptance criteria, as tests, *before* the code is written.

- **The three amigos**: business, development and testing sit together and agree what "done" means for a feature before anyone builds it. Most defects are misunderstandings; this catches them while they're free to fix.
- **Acceptance criteria before code**: the criteria — often expressed as the Gherkin scenarios from module 16 — become the failing tests you then make pass. The test is the specification, written first.
- It's a mindset more than a tool: BDD/Gherkin (module 16) and the test architecture (module 4) are how you express it, but the discipline is *agree, then write the test, then build*.

This is module 4's "decide what's worth checking before automating" taken to its conclusion: decide what *correct* means before there's anything to check.

## Exercise

Build a **new, small feature** acceptance-first:

1. Run a three-amigos conversation (even solo, play the roles) and write the acceptance criteria.
2. Turn them into **failing** acceptance tests (reuse module 16's Gherkin and step definitions).
3. Write only enough code to make them pass.

Notice what the conversation surfaced that you'd otherwise have built wrong.

## Solution

See [`solution/`](solution).

## References

- **Luís Soares**, *Working backward* (begin with the end in mind) — agreeing the outcome and the acceptance test before writing the code. [medium.com](https://medium.com/codex/begin-with-the-end-in-mind-8d9ccc4ee4fe)

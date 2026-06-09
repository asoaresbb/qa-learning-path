# Module 16 — BDD and Gherkin

> Gherkin exists to align understanding, not to decorate tests.

## Theory

**Behaviour-Driven Development** writes scenarios in a structured natural language so that business, development and testing share one description of what the system should do.

- **Gherkin** is that language: `Feature`, `Scenario`, and the **Given/When/Then** steps — *given* a starting state, *when* an action, *then* an expected outcome.
- Each step binds to a step-definition function (in **pytest-bdd**, or wired to Playwright) that performs it. The feature file is the intent; the step definitions are the mechanics — module 4's seam again, now formalised.
- The point to land: Gherkin earns its keep when it **aligns understanding** between people. Writing it purely to wrap existing tests in `Given/When/Then` adds ceremony without value.

```gherkin
Feature: Candidate application
  Scenario: A candidate submits valid details
    Given the application form is open
    When the candidate submits valid details
    Then their application is confirmed
    And the submission is stored
```

## Exercise

- Rewrite the candidate scenarios as **executable Gherkin** (`.feature` files plus step definitions).
- Reuse the page objects (module 11) and API helpers (module 10) inside the steps — the steps are intent, the objects are mechanics.
- Sanity-check: would a non-programmer read the feature file and recognise the behaviour? If not, rewrite it.

## Solution

See [`solution/`](solution).

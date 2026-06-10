# Module 4 — Testing fundamentals and test design

> The mental frame before the tools: how to think about a test.

## Theory

This module has no framework and almost no code. It is the thinking the rest of the path stands on. Three ideas.

### Testing is not checking

The distinction is **Michael Bolton and James Bach's**, from *Rapid Software Testing* (their 2013 essay *Testing and Checking Refined*):

- A **check** is an observation with a decision rule that a machine can make: *given this input, is the output exactly this?* Checks are confirmatory and automatable. Most of what we call "automated tests" are checks.
- **Testing** is the human activity around the checks: exploring, questioning, modelling, learning. It decides *what is worth checking*, notices what no one thought to check, and updates your mental model of the system every time the app surprises you.

You cannot automate testing. You can automate checks — but only testing tells you which checks are worth having. Both matter; confusing them is how teams end up with a thousand green checks and no confidence.

### Risk and oracles

- **Risk** is where the cost of being wrong is highest. You can never check everything, so you spend your effort where failure would hurt most — the payment step, not the footer copyright year.
- An **oracle** is how you decide a result is right or wrong: a spec, a comparable system, a consistent rule ("the total should equal the sum of line items"), or a user's expectation. Every check needs an oracle, explicit or not. Naming yours is what stops "it ran without error" from masquerading as "it works".

### Choosing cases, not guessing

A test-design technique turns "I'll try some values" into a defensible set. ISTQB groups them, and the grouping maps neatly onto the testing/checking split above.

**Specification-based** (derived from what the system *should* do — these produce checks):

- **Equivalence partitioning**: split the inputs into classes that should behave the same, and test one value from each. An age field partitions into *too young*, *valid*, *too old*, *non-numeric* — four cases instead of forty.
- **Boundary value analysis**: bugs cluster at the edges. If valid age is 18–99, test 17/18 and 99/100, not just 50.
- **Decision tables**: when the outcome depends on a *combination* of conditions, tabulate the combinations and their expected result, so you cover the interactions rather than each input alone (e.g. member × in-stock × coupon → which price).
- **State transition**: when behaviour depends on what happened before, model the states and the moves between them — a cart goes *empty → has items → checked out → paid* — and test both the allowed transitions and the forbidden ones (can you pay an empty cart?).

**Experience-based** (lean on the tester, not a spec — this is the *testing* half of Bolton and Bach's distinction):

- **Exploratory testing**: learning, designing and running tests at the same time, letting what you find steer what you try next. This is the "walk the flow and update your mental model" half of the exercise below.
- **Error guessing**: deliberately aiming where defects hide — empty fields, zero, negatives, huge inputs, double submits, unexpected types.
- **Checklist-based testing**: work through a checklist of conditions to cover — the inputs, the error paths, the things easy to forget — designing a test for each. (Pure *ad-hoc* poking is the informal cousin; useful for a quick look, but not an ISTQB-named technique, and the least repeatable.)

There is also a **structure-based (white-box)** view — statement and branch coverage — which measures how much of the code the tests exercise rather than choosing inputs; treat it as a gap-finder, not a goal. The specification-based techniques get applied for real in modules 10–15, structure-based coverage shows up with the unit tests in module 9, and the experience-based ones are a habit you carry through all of them.

### Levels: where you test

Technique is one axis; **level** is the other, and they're independent — you can test black-box at any level. Levels say what *scope* you're checking:

- **Unit / component** — one function in isolation (the service layer, module 9).
- **Integration** — parts wired together: service ↔ database, API ↔ service (module 10).
- **System** — the whole app end to end, through its real interface (Playwright, module 11).
- **Acceptance** — does it meet the agreed criteria (BDD and ATDD, modules 16–17).

The **test pyramid** is the rule of thumb across these: many fast unit and API checks at the base, few slow system checks at the top — the cheap ones catch most problems, the expensive ones only prove the pieces connect. The non-functional dimensions — accessibility, security, performance (modules 13–15) — cut across every level.

### Intent over mechanics

One idea runs through every testing module: a test should say **what** it verifies, not **how** it drives the system. "A customer places an order and it is confirmed" is the intent; the clicking, posting and waiting are mechanics that belong underneath, out of sight. Hold the two apart and a test reads as a specification of behaviour rather than a script that happens to pass — and the suite survives a change to the UI or the wiring beneath it.

The same principle at every level:

- against the **UI**, it becomes the Page Object Model (module 11) — a page exposes `submitApplication()`, not raw selectors;
- against an **API**, it becomes a declarative call (module 10) — name the endpoint, send the payload, assert the outcome.

Dave Farley pushes it furthest with a four-layer separation — the test, a domain language (DSL) of actions, the components that perform them, and the system itself — so the same readable scenarios outlive a rewrite of everything below. You don't build a DSL here; you just learn to see the **seam between intent and mechanics** before a framework hides it.

```mermaid
graph TD
    A["Test — intent<br/>'place an order, expect confirmation'"] --> B["DSL — vocabulary of actions<br/>placeOrder(), expectConfirmation()"]
    B --> C["Components — mechanics<br/>click, fill, POST, wait"]
    C --> D["System under test"]
```

## Exercise

Take a real user intent — **placing an order**: add to cart, check out, pay, confirm.

1. **Test it first.** Walk the flow as if you'd never seen it. Each time it surprises you, write down what could go wrong and what actually matters. This is the exploring that keeps changing your mental model — and you can't script it in advance.
2. **Then design the checks.** Decide:
   - Should *one* automated test drive the whole flow end to end, or should each step earn its own check? What does each choice cost, and what does it buy in confidence?
   - Where along the way are the inputs — quantity, address, payment — worth **partitioning** and **bounding**? Write those cases out.
   - Which checks would you actually keep, given they have to run on every change and not turn flaky?
3. For one step, write the **intent** in plain words and, separately, the **mechanics** it would need. See where the line falls.

The skill this builds: naming which half you're in — testing or checking — at any moment.

A worked version in [`solution/`](solution) — do your own first; there's no single right answer, only defensible ones.

## References

- **Michael Bolton & James Bach**, *Testing and Checking Refined* (2013) — the testing/checking distinction. [developsense.com](https://www.developsense.com/blog/2013/09/testing-and-checking-refined/) · [Rapid Software Testing](https://rapid-software-testing.com/)
- **Michael Bolton**, *Testing is Not Quality; Quality is Not Testing* (2024) — testing produces information about quality; it does not produce or assure quality. Why "QA" overstates what testing does. [developsense.com](https://developsense.com/blog/2024/10/testing-is-not-quality-quality-is-not-testing)
- **Michael Bolton**, *Quality Engineering Is Not Testing* (2026) — why relabelling testing as "quality engineering" blurs a real skill and promises control over quality that testers don't hold. [developsense.com](https://developsense.com/blog/2026/04/quality-engineering-is-not-testing)
- **ISTQB**, *Certified Tester Foundation Level Syllabus v4.0* — the test-technique families (black-box, white-box, experience-based) and levels. [istqb.org](https://istqb.org/certifications/certified-tester-foundation-level-ctfl-v4-0/)
- **Jez Humble & David Farley**, *Continuous Delivery* (2010) — the four-layer acceptance-test architecture (test → DSL → driver → system under test).
- **Martin Fowler**, *PageObject* — the page object as a layer that hides UI mechanics behind intent. [martinfowler.com](https://martinfowler.com/bliki/PageObject.html)
- **Martin Fowler**, *TestPyramid* — many fast low-level checks, few slow end-to-end ones. [martinfowler.com](https://martinfowler.com/bliki/TestPyramid.html)
- **Luís Soares**, *Defining a Testing Strategy* — choosing levels and coverage deliberately rather than by habit. [levelup.gitconnected.com](https://levelup.gitconnected.com/defining-a-testing-strategy-24f733d822df)
- **Luís Soares**, *The Waterfall Assessment Test* — where testing sits in the process, and why late-only test phases fail. [levelup.gitconnected.com](https://levelup.gitconnected.com/the-waterfall-assessment-test-d22c6363d137)

# Module 11 — Playwright and the UI

> Browser automation, with the Page Object Model from the start so no bad habits form.

## Theory

End-to-end tests drive a real browser. The risk is that they become brittle scripts full of selectors and waits. The **Page Object Model (POM)** is module 4's "intent over mechanics" applied to the UI: a page object exposes **user intent** as methods — `submitApplication(candidate)`, `signIn(user)` — and hides the selectors, clicks and waits inside.

The test then reads as a specification:

```python
def test_candidate_can_apply(page):
    form = CandidateForm(page)
    form.open()
    form.submit_application(name="Ada", email="ada@example.com")
    assert form.confirmation_visible()
```

`CandidateForm` is the only place that knows the CSS selectors exist. Change the markup and you fix one object, not fifty tests — the same survives-a-rewrite property module 4 described.

Other essentials:

- **Selectors**: prefer role- and label-based locators (`get_by_role`, `get_by_label`) over brittle CSS/XPath — they're stable and they double as an accessibility signal (module 13).
- **Waits**: rely on Playwright's auto-waiting and web-first assertions; avoid fixed sleeps. Server-rendered pages (module 8) carry content in the initial HTML, so there's less to wait for and fewer flaky tests.
- **Fixtures**: set-up and tear-down hooks — expanded in module 12.

## Exercise

Cover the main flows end to end, POM from the first line:

- a `CandidateForm` page object and a test that submits an application and asserts confirmation;
- an admin sign-in flow that reaches the protected view.

No raw selectors in the test bodies — they live only in the page objects.

## Solution

See [`solution/`](solution).

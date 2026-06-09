# Module 13 — Accessibility

> Forms are exactly where accessibility matters.

## Theory

Accessibility is whether people using assistive technology — screen readers, keyboard-only navigation — can actually use the site. For a form that collects someone's application, that's not optional; the **European Accessibility Act** makes it a legal expectation.

- **axe** is an accessibility engine that checks rendered pages against WCAG rules: missing labels, poor contrast, controls with no accessible name, bad heading structure.
- Bringing axe **into Playwright** means the accessibility scan runs in the same suite as the end-to-end tests, against the real rendered page, on every change.
- This ties straight back to module 11: the role- and label-based locators that make tests stable are the *same* properties axe checks for. Accessible markup and testable markup are the same markup.

## Exercise

- Run an **axe scan** of the candidate form inside a Playwright test.
- Read the violations, **fix** them in the markup (labels, contrast, names), and get the scan to pass.
- Keep the scan in the suite so a regression is caught.

## Solution

See [`solution/`](solution).

# Solution — Accessibility

```bash
git checkout module-13
pytest tests/e2e/test_accessibility.py
```

## What "done" looks like

- An axe scan of the candidate form running inside a Playwright test.
- The form's violations fixed: every input has an associated label, controls have accessible names, contrast passes.
- The scan stays in the suite as a regression guard.

## Notes

- Fix the markup, don't suppress the rule. A suppressed axe violation is a real barrier for a real user.
- The fixes here often *improve* module 11's tests too, because `get_by_label` now has a label to find.

# Solution — BDD and Gherkin

```bash
git checkout module-16
pytest tests/features
```

## What "done" looks like

- `.feature` files for the candidate scenarios in plain Given/When/Then.
- Step definitions that delegate to existing page objects and API helpers — no new mechanics invented in the steps.
- Feature files readable by someone who can't read Python.

## Notes

- If the Gherkin only restates code in three keywords, it's decoration — the module's warning. Keep it at the level of behaviour a stakeholder cares about.
- Reusing module 10/11 helpers inside steps is the intent/mechanics separation paying off a third time.

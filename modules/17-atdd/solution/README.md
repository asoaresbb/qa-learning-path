# Solution — ATDD

```bash
git checkout module-17
```

## What "done" looks like

- A new small feature (for example: candidates receive a confirmation, or the consultant can mark one as reviewed) with acceptance criteria agreed and written **first**.
- Those criteria committed as failing acceptance tests before the implementation commit.
- Implementation that makes them pass and adds nothing the criteria didn't ask for.

## Notes

- The git history is the evidence: the failing-test commit should precede the implementation commit.
- The value isn't the tests, it's the conversation that wrote them — record at least one assumption it corrected.

# Solution — Performance testing

```bash
git checkout module-15
k6 run tests/perf/submission.js
```

## What "done" looks like

- A k6 script that ramps virtual users against the submission endpoint.
- `thresholds` defined (e.g. `http_req_duration: ['p(95)<300']`, `http_req_failed: ['rate<0.01']`) so the run passes or fails on its own.
- A recorded baseline (the p95/p99 and error rate) to compare future runs against.

## Notes

- Report p95/p99, never just the mean.
- This run is heavier than the rest of the suite — module 19 puts a light smoke version on every PR and the full run on a nightly schedule.

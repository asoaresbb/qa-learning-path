# Module 15 — Performance testing

> How the service behaves under load, rather than whether it is correct.

## Theory

Functional tests ask "is it right?". Performance tests ask "does it stay right under load?".

- **Latency** is how long one request takes; **throughput** is how many it serves per second. They trade off.
- The interesting failure is not one slow request but a system that **degrades under concurrency** — fine for one user, falling over for two hundred.
- Read **percentiles, not averages**. An average hides the tail; p95/p99 tell you what your slowest users actually experience. A mean of 100 ms with a p99 of 4 s is a bad system that looks fine on average.
- A **threshold** is the line a test holds to ("p95 < 300 ms, error rate < 1%"). It turns a vague "seems fast" into a pass/fail check.

Tool: **k6** — write the load profile as a script, run it against the candidate submission endpoint, read the percentiles.

## Exercise

- Write a **k6** load test against the submission endpoint.
- Define a meaningful **threshold** on p95 latency and error rate.
- Run it, read the percentiles (not the average), and record a **baseline** the suite can hold to.

## Solution

See [`solution/`](solution).

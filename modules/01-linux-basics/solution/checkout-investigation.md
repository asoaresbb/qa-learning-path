# Part 3 — worked solution: the checkout failure

> Try the investigation yourself before reading this. The point is the *process*, not the answer.

Bug report received: *"Checkout was failing this morning, around 08:17."*

## 1. What went wrong — find the error in `app.log`

Search the application log for the checkout component:

```bash
grep 'CheckoutService' app.log
```

```text
2026-06-10 08:17:21 ERROR [http-nio-8080] CheckoutService - payment gateway timeout after 30000ms
2026-06-10 08:17:21 ERROR [http-nio-8080] CheckoutService - order creation failed for user u-1055
2026-06-10 08:17:25 ERROR [http-nio-8080] CheckoutService - payment gateway timeout after 30000ms
2026-06-10 08:23:50 ERROR [http-nio-8080] CheckoutService - payment gateway timeout after 30000ms
2026-06-10 08:23:51 ERROR [http-nio-8080] CheckoutService - order creation failed for user u-1055
```

## 2. The matching requests — find them in `access.log`

```bash
grep '/checkout' access.log
```

```text
192.168.1.33 - - [10/Jun/2026:08:17:21 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
192.168.1.33 - - [10/Jun/2026:08:17:25 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
192.168.1.33 - - [10/Jun/2026:08:23:50 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
```

The web log shows the user got `500`s; the app log explains *why*. The timestamps line up (08:17:21, 08:17:25, 08:23:50) — that's the confirmation the two logs describe the same incident.

## 3. Root cause

Read the order of the app-log lines: the **payment gateway timed out after 30s**, and *because* of that, **order creation failed**. So it isn't a bug in the checkout code itself — checkout is a victim of a slow/unresponsive downstream payment gateway. That distinction matters: the fix is on the gateway/integration side, not in the checkout logic.

## 4. Blast radius

```bash
grep -c '/checkout' access.log          # 3 failed checkout requests (all 500)
grep 'order creation failed' app.log    # which users were affected
```

Three failed `500` responses, all from IP `192.168.1.33`, and the order-creation failures name a single user: **`u-1055`**.

## The deliverable — bug report

```text
Title:    Checkout fails with 500 during payment
When:     2026-06-10, 08:17-08:23 (two waves)
Evidence: app.log — "payment gateway timeout after 30000ms" (CheckoutService), x3
          access.log — GET /checkout -> 500, x3 (IP 192.168.1.33)
Cause:    Payment gateway timeout (30s); order creation then fails.
          Not a checkout defect — a downstream dependency.
Impact:   3 failed checkout attempts, user u-1055.
Severity: High — users cannot complete purchases.
```

Same six fields as the template in Part 3 — each line traceable to a command you ran above.

## Why this is the whole job

You started with a vague symptom ("checkout was failing") and ended with something a developer can act on: a time window, the exact error, the root cause, and the blast radius — each backed by a command and its output. Correlating the *app* error with the *web* 500s across two logs is what turns "it's broken" into evidence. That's QA triage.

# Module 1 — worked solutions

Try each exercise yourself first; these are here to check your reasoning, not to copy. The exercises are **Part 2**, **Part 3** and **Part 4** in the [module README](README.md), with sample logs in [`sample-logs/`](sample-logs). Run the commands from the `sample-logs/` folder.

There's usually more than one correct command — what matters is reading the output correctly.

---

## Part 2 — log triage answers

### 1. How many requests in `access.log` returned a `500`?

```bash
grep -c ' 500 ' access.log
```

**3.** (The spaces around `500` keep it to the status field — a bare `500` could also match a byte count.)

### 2. Show the last 5 failed logins from `app.log`

```bash
grep 'login failed' app.log | tail -n 5
```

Only **4** lines match, so you see all 4: three for `u-9999`, one for `u-2088`. `tail -n 5` shows *up to* 5 — fewer if fewer exist.

### 3. Which IP is hammering `POST /login` with `401`s, and how many times?

```bash
grep 'POST /login' access.log | grep '401' | awk '{print $1}' | sort | uniq -c | sort -rn
```

```text
   3 192.168.1.77
   1 192.168.1.88
```

**`192.168.1.77`, 3 times.** Note `192.168.1.88` also has one `401`, but it's immediately followed by a `200` — a human mistyping once, not an attack. The burst from one IP (and the `curl` user-agent) is the brute-force signature.

### 4. Find every `ERROR` line in `app.log` with its line number

```bash
grep -n 'ERROR' app.log
```

Seven `ERROR` lines (8, 11, 12, 13, 20, 21, 24): the account lockout, the checkout/payment failures, and a nightly report job failure.

### 5. The only `403` — what, and whose?

```bash
grep '403' access.log
```

```text
192.168.1.77 - - [10/Jun/2026:08:14:30 +0000] "GET /admin HTTP/1.1" 403 512 "-" "curl/8.4.0"
```

A `curl` client at **`192.168.1.77`** tried to reach **`/admin`** and was forbidden (`403`). The familiar part: that's the *same* IP and `curl` user-agent that starts brute-forcing `POST /login` three seconds later (08:14:30 → 08:14:33). Read in order, it's a little attack story — probe `/admin`, get refused, pivot to guessing the login. Connecting those two lines is the instinct the brute-force question (Q3) was building toward.

### 6. Show only the non-`200` responses in `access.log`

```bash
grep -v ' 200 ' access.log          # add -c to count: 13
```

**13** lines — the redirects (`302` x2), `401` x4, `403`, `404` x3, and `500` x3. `-v` inverts the match. Note the `/health` probes return `200`, so they're filtered *out* — exactly what you want when separating real traffic from noise.

### 7. Which user account got locked, and after how many attempts?

```bash
grep 'locked' app.log
```

**`u-9999`, after 3 failed attempts** — the line reads `account u-9999 locked after 3 failed attempts`, right after its three `login failed` warnings.

---

## Part 3 — the checkout failure (worked investigation)

Bug report received: *"Checkout was failing this morning, around 08:17."*

### 1. What went wrong — find the error in `app.log`

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

### 2. The matching requests — find them in `access.log`

```bash
grep '/checkout' access.log
```

```text
192.168.1.33 - - [10/Jun/2026:08:17:21 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
192.168.1.33 - - [10/Jun/2026:08:17:25 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
192.168.1.33 - - [10/Jun/2026:08:23:50 +0000] "GET /checkout HTTP/1.1" 500 740 "-" "Mozilla/5.0"
```

The web log shows the user got `500`s; the app log explains *why*. The timestamps line up (08:17:21, 08:17:25, 08:23:50) — that's the confirmation the two logs describe the same incident. Note the second wave at **08:23**: the user said "around 08:17," but widening the window shows it recurred — so this is three failures, not two.

### 3. Root cause

Read the order of the app-log lines: the **payment gateway timed out after 30s**, and *because* of that, **order creation failed**. So it isn't a bug in the checkout code itself — checkout is a victim of a slow/unresponsive downstream payment gateway. That distinction matters: the fix is on the gateway/integration side, not in the checkout logic.

### 4. Blast radius

```bash
grep -c '/checkout' access.log          # 3 failed checkout requests (all 500)
grep 'order creation failed' app.log    # which users were affected
```

Three failed `500` responses, all from IP `192.168.1.33`, and the order-creation failures name a single user: **`u-1055`**.

### The deliverable — bug report

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

### Why this is the whole job

You started with a vague symptom ("checkout was failing") and ended with something a developer can act on: a time window, the exact error, the root cause, and the blast radius — each backed by a command and its output. Correlating the *app* error with the *web* 500s across two logs is what turns "it's broken" into evidence. That's testing — investigation that produces information someone can act on.

---

## Part 4 — the triage script

The finished `triage.sh`, built up from the four steps. Yours doesn't need to match line for line — what matters is that it runs the Part 2–3 commands for you, takes the log as an argument, and refuses bad input cleanly.

```bash
#!/bin/bash
# triage.sh — quick summary of a web access log
# usage: ./triage.sh <access.log>

log="$1"

# guard: no argument given, or the file doesn't exist
if [ -z "$log" ]; then
  echo "usage: ./triage.sh <access.log>"
  exit 1
fi
if [ ! -f "$log" ]; then
  echo "file not found: $log"
  exit 1
fi

echo "== Triage report for $log =="
echo
echo "Total requests:    $(wc -l < "$log")"
echo "500 errors:        $(grep -c ' 500 ' "$log")"
echo "Non-200 responses: $(grep -vc ' 200 ' "$log")"
echo
echo "Top IPs on /login 401s:"
grep 'POST /login' "$log" | grep '401' | awk '{print $1}' | sort | uniq -c | sort -rn
```

Run it:

```bash
chmod +x triage.sh
./triage.sh access.log
```

```text
== Triage report for access.log ==

Total requests:    25
500 errors:        3
Non-200 responses: 13

Top IPs on /login 401s:
   3 192.168.1.77
   1 192.168.1.88
```

Every number matches what you found by hand in Part 2 — the script just gathers them in one pass.

### The pieces worth naming

- **`$1`** — the first argument you type after the script name. Storing it in `log="$1"` once, then using `"$log"`, means you change the source in a single place.
- **`$( ... )`** — *command substitution*. It runs the command inside and drops its output where it sits, so `$(grep -c ' 500 ' "$log")` becomes the number `3` before `echo` prints the line.
- **`"$log"` in quotes** — protects you if a filename ever contains spaces. A habit worth forming early; it costs nothing and saves a baffling bug later.
- **`wc -l < "$log"`** — feeding the file in with `<` makes `wc` print just the count, not the filename beside it.
- **the two guards** — `-z` tests for an empty string (you forgot the argument); `-f` tests that the path is a real file (you typo'd it). `exit 1` stops the script with a non-zero code, the universal shell signal for "this failed."

### Why this is the point

You turned a manual investigation into a tool. The next time a log lands on your desk you run one command instead of six, and you can hand the script to a teammate who's never memorised the pipelines. That's the whole arc of test automation in miniature — notice the repetition, capture it once, and free your attention for the parts that actually need a human. Everything from module 10's API suite to module 19's CI pipeline is this same instinct, scaled up.

**Extend it** (optional): point a second guard at `app.log` and add a line for `grep -c 'ERROR' "$log"`, or have the script take *two* arguments and summarise the web log and the app log together — the cross-log correlation from Part 3, automated.

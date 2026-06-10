# Part 2 — worked answers: log triage

> Run the commands yourself first. There's usually more than one correct command — what matters is reading the output correctly.

These answer the **Part 2** questions in the [module README](../README.md). Run them from the `exercise/` folder.

## 1. How many requests in `access.log` returned a `500`?

```bash
grep -c ' 500 ' access.log
```

**3.** (The spaces around `500` keep it to the status field — a bare `500` could also match a byte count.)

## 2. Show the last 5 failed logins from `app.log`

```bash
grep 'login failed' app.log | tail -n 5
```

Only **4** lines match, so you see all 4: three for `u-9999`, one for `u-2088`. `tail -n 5` shows *up to* 5 — fewer if fewer exist.

## 3. Which IP is hammering `POST /login` with `401`s, and how many times?

```bash
grep 'POST /login' access.log | grep '401' | awk '{print $1}' | sort | uniq -c | sort -rn
```

```text
   3 192.168.1.77
   1 192.168.1.88
```

**`192.168.1.77`, 3 times.** Note `192.168.1.88` also has one `401`, but it's immediately followed by a `200` — a human mistyping once, not an attack. The burst from one IP (and the `curl` user-agent) is the brute-force signature.

## 4. Find every `ERROR` line in `app.log` with its line number

```bash
grep -n 'ERROR' app.log
```

Seven `ERROR` lines (8, 11, 12, 13, 20, 21, 24): the account lockout, the checkout/payment failures, and a nightly report job failure.

## 5. The only `403` — what, and whose?

```bash
grep '403' access.log
```

```text
192.168.1.77 - - [10/Jun/2026:08:14:30 +0000] "GET /admin HTTP/1.1" 403 512 "-" "curl/8.4.0"
```

A `curl` client at **`192.168.1.77`** tried to reach **`/admin`** and was forbidden (`403`). The familiar part: that's the *same* IP and `curl` user-agent that starts brute-forcing `POST /login` three seconds later (08:14:30 → 08:14:33). Read in order, it's a little attack story — probe `/admin`, get refused, pivot to guessing the login. Connecting those two lines is the instinct the brute-force question (Q3) was building toward.

## 6. Show only the non-`200` responses in `access.log`

```bash
grep -v ' 200 ' access.log          # add -c to count: 13
```

**13** lines — the redirects (`302` x2), `401` x4, `403`, `404` x3, and `500` x3. `-v` inverts the match. Note the `/health` probes return `200`, so they're filtered *out* — exactly what you want when separating real traffic from noise.

## 7. Which user account got locked, and after how many attempts?

```bash
grep 'locked' app.log
```

**`u-9999`, after 3 failed attempts** — the line reads `account u-9999 locked after 3 failed attempts`, right after its three `login failed` warnings.

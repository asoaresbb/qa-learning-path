# Solution — Networking and HTTP

## 1. Read a full exchange

```bash
curl -v https://example.com 2>&1 | less
```

What to find in the output:

- `* Trying 93.184.216.34:443` — DNS already resolved the name to an IP.
- `* TLSv1.3 ... * Server certificate:` — the handshake and the cert that proves identity.
- Lines starting `>` are what **you sent** (request line, `Host`, `User-Agent`, `Accept`).
- Lines starting `<` are the **response** (`HTTP/1.1 200 OK`, then headers like `Content-Type`).

## 2. A JSON API

```bash
curl -i https://api.github.com/repos/asoaresbb/qa-learning-path
```

`-i` includes the response headers. Note `Content-Type: application/json` and read the status line.

## 3. Redirects and 404

```bash
curl -i http://github.com           # 301 -> https://github.com (Location header)
curl -iL http://github.com          # -L follows the redirect to the final 200
curl -i https://example.com/nope     # 404
```

The `Location` header is what a `3xx` uses to send you on; `-L` makes curl follow it.

## 4. Browser Network tab

Load any page with DevTools → Network open:

- The first request (type **document**) is the HTML. Its **status** and **method** (`GET`) are in the table.
- **script**/**stylesheet** rows are the assets the HTML pulls in.
- **fetch/XHR** rows are JavaScript calling APIs after load — this is the JSON layer module 8 introduces and module 10 tests.

The takeaway: a page is one HTML response plus many follow-up requests. Knowing which is which is what lets you test the API layer directly instead of only through the screen.

# Solution — Security testing

```bash
git checkout module-14
pytest tests/security
# baseline scan against the running site:
# docker run -t ghcr.io/zaproxy/zaproxy zap-baseline.py -t http://host:8000
```

## What "done" looks like

- Abuse tests that assert the app *refuses*: an injection string stored as literal text (not executed), admin access denied without valid auth, oversized/malformed input rejected.
- If upload exists: wrong-type and oversized files rejected.
- A ZAP baseline scan run and its findings triaged (fixed, or justified as false positives).

## Notes

- An abuse test asserts a refusal: the request returns `4xx` and nothing harmful persisted. "It didn't crash" is not a pass.
- Never put real credentials or tokens in these tests. Inputs that resemble secrets or personal data must be synthetic.
- This is defensive testing of a system you own — keep it that way.

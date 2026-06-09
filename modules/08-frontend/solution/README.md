# Solution — The front end

```bash
git checkout module-08
```

## What "done" looks like

- A server-rendered candidate form: `GET /` renders it, `POST` persists a submission and shows a result.
- A JSON endpoint (`POST /api/candidates`) the page calls with `fetch`, with the response handled in JS.
- Form fields have stable `name`s and associated `<label>`s.

## Notes

- Once the JSON split exists you'll meet CORS if the page and API differ in origin; understand the header rather than disabling the check blindly.
- Stable, labelled fields are not cosmetic: module 11 selects on them and module 13 scans them with axe. Accessible markup is testable markup.

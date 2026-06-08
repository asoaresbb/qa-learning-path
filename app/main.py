"""QA Learning Path, application entry point.

This is a minimal starter. The server boots and serves one page so you can
confirm your environment works. Everything else is left for you to build as
you move through the modules. Follow the TODOs.

Run it from the repository root:

    uvicorn app.main:app --reload

Then open http://127.0.0.1:8000
"""

from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

app = FastAPI(title="QA Learning Path")

templates = Jinja2Templates(directory="app/templates")


@app.get("/", response_class=HTMLResponse)
def index(request: Request):
    """The landing page. This one already works, so you can confirm the server boots."""
    return templates.TemplateResponse(request, "index.html")


# TODO (module 5): add POST /candidates that accepts the application form.
#   Start by reading the submitted fields and returning a confirmation page.
#   At this point you can throw the data away; persistence comes next.

# TODO (module 6): wire a database (SQLite to begin with) and store each
#   candidate inside POST /candidates instead of discarding it.

# TODO (module 7): add authentication and a protected GET /admin view that
#   lists the stored candidates. Keep it behind a login.

# TODO (module 8, phase 2): once the server-rendered flow is solid, split the
#   submission into a JSON endpoint so a JavaScript front end can consume it.

# Module 2 — Git and GitHub

> Version control before there is any code worth keeping.

## Theory

Git records the history of a project as a chain of **commits** — snapshots, each with a message and a parent. You learn it now, with nothing important at stake, so it is second nature by the time it matters.

- **Commits**: stage changes with `git add`, record them with `git commit -m "..."`. A good message says *why*, not *what the diff already shows*. This repo uses Conventional Commits (`type: message`).
- **Branches**: a branch is a movable pointer to a commit. Work happens on a branch off `main`; `git switch -c feature` creates one. Branching is cheap — use it freely.
- **Merges and conflicts**: bringing a branch back into `main` with `git merge`. When two branches change the same lines, Git stops and asks you to resolve the **conflict** by hand.
- **Pull requests**: on GitHub, a PR proposes merging a branch and opens it for review. This is where the social half of version control lives.
- **Review**: reading someone else's change, asking questions, requesting changes. Reviewing well is a QA skill in itself — you are checking intent against implementation.

The remote (`origin`) is the shared copy on GitHub. `git push` sends your commits up, `git pull` brings others' down, `git clone` makes the first local copy.

## Exercise

1. Create a repository and make a series of commits with clear, conventional messages.
2. Branch, make a change, and open a **pull request** against `main`.
3. Deliberately create a **merge conflict** on a shared file and resolve it.
4. **Review** someone else's pull request (or a second branch of your own): leave a comment, request a change, then approve.

Notes and a worked walkthrough in [`solution/`](solution).

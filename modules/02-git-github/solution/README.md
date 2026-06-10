# Solution — Git and GitHub

A walkthrough, not a single answer. Run these against a scratch repo.

## 1. Commits

```bash
git init demo && cd demo
echo "# Demo" > README.md
git add README.md
git commit -m "docs: add readme"
```

A conventional message is `type(scope): summary` — `feat`, `fix`, `docs`, `chore`, `test`, `refactor`. The summary is imperative and lowercase: "add readme", not "Added the readme file".

## 2. Branch and pull request

```bash
git switch -c feat/greeting
echo "hello" > greeting.txt
git add greeting.txt && git commit -m "feat: add greeting"
git push -u origin feat/greeting
gh pr create --fill          # opens the PR from the branch
```

## 3. Create and resolve a conflict

On `main` and on a branch, change the *same line* of the same file, commit both, then merge:

```bash
git switch main && git merge feat/greeting
```

Git marks the clash:

```
<<<<<<< HEAD
line as it is on main
=======
line as it is on the branch
>>>>>>> feat/greeting
```

Edit the file to the version you want, delete the markers, then:

```bash
git add greeting.txt
git commit            # completes the merge
```

## 4. Review

On a PR, use **Files changed → review changes**: leave a line comment, choose *Request changes*, push a fix on the branch (the PR updates itself), then *Approve* and merge.

The lesson: reviewing is checking intent against implementation — exactly the testing habit the rest of the path builds on.

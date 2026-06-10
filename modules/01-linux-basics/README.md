# Module 1 — Linux basics

> The environment everything runs on.

## Theory

Everything later in this path runs on a Unix-like machine: the server, the database, the test runner, the CI container. Before any of that, you need to be at home on the command line.

- **The shell** is a program that reads commands and runs them. `bash` and `zsh` are the common ones. A command is a program name followed by arguments and flags (`ls -la /tmp`).
- **The filesystem** is a single tree rooted at `/`. Paths are absolute (`/home/you/file`) or relative to where you are (`./file`, `../sibling`). `pwd`, `cd`, `ls`, `cat`, `mkdir`, `rm`, `cp`, `mv` are the daily verbs.
- **Pipes and redirection** connect programs: `|` feeds one program's output into the next, `>` writes output to a file, `>>` appends, `<` reads from a file. This is the idea that makes the shell composable — small tools chained into bigger ones (`cat log | grep ERROR | wc -l`).

You'll also meet **permissions** (who can read/run a file — `chmod`, and the `rwx` columns in `ls -l`) and **processes** (running programs — `ps`, `kill`) as you go, but this module focuses on the two things a QA reaches for daily: navigation and search.

The mindset to take away: the command line is not a worse GUI — it's where small, composable tools (`grep`, `tail`, pipes) let you ask a system precise questions and get exact answers.

## Exercise

> **New to the terminal?** On macOS, open **Terminal** (press `Cmd+Space`, type "Terminal", hit Enter). On Linux, open your terminal app. First move into the folder where you cloned this repo, then into this module's exercise folder:
>
> ```bash
> cd path/to/qa-learning-path          # wherever you cloned it
> cd modules/01-linux-basics/exercise
> ```
>
> Run `pwd` to confirm where you are and `ls` to see the two sample logs.
>
> **On Windows?** macOS and Linux share the same Unix commands, but Windows differs. Use **WSL** (`wsl --install` in PowerShell, then reboot — gives you a real Linux) or **Git Bash** (ships with [Git for Windows](https://git-scm.com)). Either one runs every command in this module exactly as written. Plain PowerShell works too, but the commands have different names (`grep` → `Select-String`, `tail -n 5 x.log` → `Get-Content x.log -Tail 5`), so it's not worth the extra dialect while you're learning.

### Part 1 — find your way around

The goal here isn't to memorise commands — it's to *see* what each one does. Two habits make that click:

- **Run `ls` (or `ls -la`) after every change** so you watch the folder before and after. The output is the feedback loop.
- **Open the same folder in your file manager** (Finder on macOS, File Explorer on Windows, Files on Linux) and keep it visible. As you type commands, watch folders and files appear, move, and disappear in the window. The terminal and the GUI are two views of the *same* filesystem.

Not sure what a command or flag means? Look it up in [`linux-cheatsheet.md`](linux-cheatsheet.md) as you go.

These steps create their own files, so nothing needs to exist beforehand. Work in a throwaway folder so you don't clutter the repo — create it and move in first:

```bash
mkdir -p ~/linux-practice && cd ~/linux-practice
pwd                       # where am I now?
ls -la                    # empty so far — this is your "before"
```

> Tip: open `~/linux-practice` in Finder/Explorer now, so you can watch it fill up as you run the commands below.

Now try each idea, and **run the `ls` line after each block to see what changed**:

```bash
# 1. create a nested folder structure
mkdir -p project/src/utils
ls -R                     # -R lists recursively — see the whole tree you just made

# 2. create a file, then move and rename it
echo "hello" > old.txt
ls                        # old.txt is here now
mv old.txt new.txt        # rename it...
ls                        # ...old.txt is gone, new.txt appeared
mv new.txt project/src/   # move it into a subfolder
ls                        # gone from here...
ls project/src            # ...it's in there now. inspect with ls -l for permissions

# 3. search inside files, count matches, save the result
echo "TODO: write tests" > project/src/notes.txt
grep -r "TODO" .          # find the word anywhere below here
grep -rc "TODO" .         # count matching lines per file
grep -r "TODO" . > found.txt   # redirect the result into a file (nothing prints!)
cat found.txt             # ...because it went into the file. read it back
```

That last step is the key idea: `>` sends output **into a file instead of the screen**. That's why nothing printed — `cat` shows you where it went.

When you're done, step out of the scratch folder and delete it, then head into the exercise folder for Part 2:

```bash
cd ~                                 # leave the folder before deleting it
rm -rf ~/linux-practice              # delete the whole scratch folder
cd path/to/qa-learning-path/modules/01-linux-basics/exercise   # where you cloned the repo
```

### Part 2 — log triage (the QA core skill)

You should be in the exercise folder now (Part 1 left you here). Run `ls` — you'll see a web `access.log` and an application `app.log`. They share the same timeline, so you can pivot between them like in a real investigation. This is the part to actually drill — it's the skill you'll use on the job.

Using `grep`, `tail`, `head` and pipes (`|`), work through these. Keep [`linux-cheatsheet.md`](linux-cheatsheet.md) open beside you as a command reference.

1. How many requests in `access.log` returned a `500`? (`grep -c`)
2. Show the last 5 failed logins from `app.log`. (`grep ... | tail`)
3. Which IP is hammering `POST /login` with `401`s, and how many times?
4. Find every `ERROR` line in `app.log` with its line number. (`grep -ni`)
5. There's exactly one `403` (forbidden) in `access.log` — what was the client trying to reach, and is there anything familiar about that IP? (`grep`)
6. Show only the non-`200` responses in `access.log`. (`grep -v`)
7. Which user account got locked, and after how many attempts?

Work through them first — running the commands and reading the output *is* the exercise. Then check your reasoning against the [worked solutions](solution) (Part 2 section).

### Part 3 — run a real triage

This is the whole job in miniature: a symptom comes in, you find the evidence, and you write it up. Still in the exercise folder, with both `access.log` and `app.log`.

> **Bug report:** *"A user says checkout was failing this morning, around 08:17. Can you look into it?"*

Investigate using only the command line. Work out, with a command and its output for each:

1. **What** went wrong — find the error in `app.log` around that time. (Hint: `grep` the time, or `grep` `CheckoutService`.)
2. **The matching requests** — find the failed `/checkout` requests in `access.log` and their status code.
3. **Root cause** — read the `app.log` error lines: *why* did checkout fail? (It's not the app's own bug.)
4. **Blast radius** — how many times did it happen, and did it hit more than one user? (`grep -c`, and look at the user IDs.)

Then write a short bug report — the deliverable a QA actually hands over. Fill in each field in your own words and numbers:

```text
Title:    <one-line summary of what's broken>
When:     <the time window you found>
Evidence: <the key log lines — the app error + the matching web 500s>
Cause:    <root cause — and why; name the dependency>
Impact:   <how many failures, which user(s)>
Severity: <how bad — can users still use the product?>
```

Practise your redirection while you write it: `>` for the **first** line (creates the file), `>>` for **every line after** (appends). Get them the wrong way round and `>` wipes what you've written — the Part 1 lesson, now with something real at stake. The shape is `echo "..." >> file`; the findings are yours to fill in. Read it back with `cat` when you're done. (Name the file whatever you like — `.txt` files here are git-ignored, so it's just scratch.)

Confirming the story across *two* logs (the app error and the web 500s line up in time) is exactly how you turn "it's broken" into something a developer can act on.

When you're done, compare your write-up with the [worked solutions](solution) (Part 3 section) — not to match it word for word, but to check you landed the same root cause and blast radius. Try the whole investigation yourself first.

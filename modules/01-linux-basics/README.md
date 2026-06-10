# Module 1 — Linux basics

> The environment everything runs on.

## Theory

Everything later in this path runs on a Unix-like machine: the server, the database, the test runner, the CI container. Before any of that, you need to be at home on the command line.

- **The shell** is a program that reads commands and runs them. `bash` and `zsh` are the common ones. A command is a program name followed by arguments and flags (`ls -la /tmp`).
- **The filesystem** is a single tree rooted at `/`. Paths are absolute (`/home/you/file`) or relative to where you are (`./file`, `../sibling`). `pwd`, `cd`, `ls`, `cat`, `mkdir`, `rm`, `cp`, `mv` are the daily verbs.
- **Pipes and redirection** connect programs: `|` feeds one program's output into the next, `>` writes output to a file, `>>` appends, `<` reads from a file. This is the idea that makes the shell composable — small tools chained into bigger ones (`cat log | grep ERROR | wc -l`).

You'll also meet **permissions** (who can read/run a file — `chmod`, and the `rwx` columns in `ls -l`) and **processes** (running programs — `ps`, `kill`) as you go, but this module focuses on the two things a tester reaches for daily: navigation and search.

The mindset to take away: the command line is not a worse GUI — it's where small, composable tools (`grep`, `tail`, pipes) let you ask a system precise questions and get exact answers.

## Exercise

> **New to the terminal?** On macOS, open **Terminal** (press `Cmd+Space`, type "Terminal", hit Enter). On Linux, open your terminal app. First move into the folder where you cloned this repo, then into this module's `sample-logs` folder:
>
> ```bash
> cd path/to/quality-engineering-path          # wherever you cloned it
> cd modules/01-linux-basics/sample-logs
> ```
>
> Run `pwd` to confirm where you are and `ls` to see the two sample logs.
>
> **On Windows?** macOS and Linux share the same Unix commands, but Windows differs. Use **WSL** (`wsl --install` in PowerShell, then reboot — gives you a real Linux) or **Git Bash** (ships with [Git for Windows](https://git-scm.com)). Either one runs every command in this module exactly as written. Plain PowerShell works too, but the commands have different names (`grep` → `Select-String`, `tail -n 5 x.log` → `Get-Content x.log -Tail 5`), so it's not worth the extra dialect while you're learning.

### Part 1 — find your way around

The goal here isn't to memorise commands — it's to *see* what each one does. Two habits make that click:

- **Run `ls` (or `ls -la`) after every change** so you watch the folder before and after. The output is the feedback loop.
- **Open the same folder in your file manager** (Finder on macOS, File Explorer on Windows, Files on Linux) and keep it visible. As you type commands, watch folders and files appear, move, and disappear in the window. The terminal and the GUI are two views of the *same* filesystem.

Not sure what a command or flag means? Look it up in [`cheatsheet.md`](cheatsheet.md) as you go.

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

When you're done, step out of the scratch folder and delete it, then head into the `sample-logs` folder for Part 2:

```bash
cd ~                                 # leave the folder before deleting it
rm -rf ~/linux-practice              # delete the whole scratch folder
cd path/to/quality-engineering-path/modules/01-linux-basics/sample-logs   # where you cloned the repo
```

### Part 2 — log triage (a core testing skill)

You should be in the `sample-logs` folder now (Part 1 left you here). Run `ls` — you'll see a web `access.log` and an application `app.log`. They share the same timeline, so you can pivot between them like in a real investigation. This is the part to actually drill — it's the skill you'll use on the job.

Using `grep`, `tail`, `head` and pipes (`|`), work through these. Keep [`cheatsheet.md`](cheatsheet.md) open beside you as a command reference.

1. How many requests in `access.log` returned a `500`? (`grep -c`)
2. Show the last 5 failed logins from `app.log`. (`grep ... | tail`)
3. Which IP is hammering `POST /login` with `401`s, and how many times?
4. Find every `ERROR` line in `app.log` with its line number. (`grep -ni`)
5. There's exactly one `403` (forbidden) in `access.log` — what was the client trying to reach, and is there anything familiar about that IP? (`grep`)
6. Show only the non-`200` responses in `access.log`. (`grep -v`)
7. Which user account got locked, and after how many attempts?

Work through them first — running the commands and reading the output *is* the exercise. Then check your reasoning against the [worked solutions](solution/README.md) (Part 2 section).

### Part 3 — run a real triage

This is the whole job in miniature: a symptom comes in, you find the evidence, and you write it up. Still in the `sample-logs` folder, with both `access.log` and `app.log`.

> **Bug report:** *"A user says checkout was failing this morning, around 08:17. Can you look into it?"*

Investigate using only the command line. Work out, with a command and its output for each:

1. **What** went wrong — find the error in `app.log` around that time. (Hint: `grep` the time, or `grep` `CheckoutService`.)
2. **The matching requests** — find the failed `/checkout` requests in `access.log` and their status code.
3. **Root cause** — read the `app.log` error lines: *why* did checkout fail? (It's not the app's own bug.)
4. **Blast radius** — how many times did it happen, and did it hit more than one user? (`grep -c`, and look at the user IDs.)

Then write a short bug report — the deliverable a tester actually hands over. Fill in each field in your own words and numbers:

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

When you're done, compare your write-up with the [worked solutions](solution/README.md) (Part 3 section) — not to match it word for word, but to check you landed the same root cause and blast radius. Try the whole investigation yourself first.

### Part 4 — script the boring parts

You just ran the same handful of commands by hand to triage that checkout failure. Do it twice and you'll feel it: the counts, the top-IPs pipeline, the `grep` for errors — the same keystrokes every time a log lands on your desk. That's the signal to **script it**. A script is nothing more than the commands you already know, saved in a file so the machine repeats them for you.

This is a real tester's instinct, not a detour: the moment you notice you're repeating yourself, you capture the repetition in a check so your attention is free for the judgement — the same reflex that later becomes "automate the checks, explore by hand."

> **On Windows?** A `.sh` script needs a real `bash` to run it — use **WSL** or **Git Bash** (both from the Windows note at the top of the exercise). Plain PowerShell can't run a `.sh` file at all, so don't attempt this part there. macOS and Linux run it as-is in their own terminal.

**The task.** Write a script, `triage.sh`, that takes a log file as its argument so that:

```bash
./triage.sh access.log
```

prints, in one go, the summary you assembled by hand in Parts 2–3: the **total number of requests**, the count of **`500`s**, the count of **non-`200`** responses, and the **table of IPs** failing `POST /login` with `401`s. Every command you need you already wrote in Part 2 — the new skill is wrapping them in a runnable file.

**New pieces you'll need** — the only things Part 4 adds; look them up here as you go, the way you used `cheatsheet.md` for Part 2:

- `#!/bin/bash` as the **first line** — the *shebang*; it tells the system to run the file with `bash`.
- `chmod +x triage.sh` makes the file executable (the `x` you saw in `ls -l`); then run it with `./triage.sh` — the `./` means "the script right here in this folder".
- `"$1"` — inside the script, the **first argument** you typed after its name. Store it once (`log="$1"`) and reuse `"$log"` — in quotes — everywhere after.
- `$(command)` — *command substitution*: runs the command and drops its output in place, so `echo "500s: $(grep -c ' 500 ' "$log")"` prints the count on a labelled line.
- `if [ ! -f "$log" ]; then ... fi` — a test; `-f` asks "is this a real file?". Use it to stop early on a missing or mistyped name.

**Build it up one step at a time**, running it after each — the same before/after habit as Part 1. Work in the `sample-logs` folder so the script has the logs beside it.

1. Make `triage.sh` run just *one* of your Part 2 commands — start with the `500` count. Add the shebang, `chmod +x` it, run it. (You've now proved a script is only commands in a file.)
2. Stop hardcoding `access.log`: take the log as `$1` instead, so you can point the script at any file.
3. Guard the input — if the argument is missing or the file doesn't exist, print a message and `exit 1` rather than charging ahead on bad input.
4. Fill in the rest of the report — total requests, non-`200`s, the `401` IP table — each line labelled so the output reads like something you'd paste into a ticket.

Write it yourself first — the thinking is in choosing which Part 2 commands to reuse and assembling them, not in new commands. Then compare with the [worked solution](solution/README.md) (Part 4 section) — the runnable script is there too, as [`triage.sh`](solution/triage.sh).

> The `exit 1` in step 3 is worth a pause. A script that exits non-zero on failure is exactly how an automated system knows a step passed or failed — you've just met, in one line, the mechanism that module 19 builds on to turn a pull request red.

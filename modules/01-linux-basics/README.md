# Module 1 — Linux basics

> The environment everything runs on.

## Theory

Everything later in this path runs on a Unix-like machine: the server, the database, the test runner, the CI container. Before any of that, you need to be at home on the command line.

- **The shell** is a program that reads commands and runs them. `bash` and `zsh` are the common ones. A command is a program name followed by arguments and flags (`ls -la /tmp`).
- **The filesystem** is a single tree rooted at `/`. Paths are absolute (`/home/you/file`) or relative to where you are (`./file`, `../sibling`). `pwd`, `cd`, `ls`, `cat`, `mkdir`, `rm`, `cp`, `mv` are the daily verbs.
- **Permissions** decide who can read, write or execute a file: three groups (owner, group, other) of three bits (`rwx`). `chmod`, `chown`, and reading the `ls -l` columns.
- **Processes** are running programs with a PID. `ps`, `top`, `kill`, and running something in the background with `&`.
- **Pipes and redirection** connect programs: `|` feeds one program's output into the next, `>` writes output to a file, `>>` appends, `<` reads from a file. This is the idea that makes the shell composable — small tools chained into bigger ones (`cat log | grep ERROR | wc -l`).

The mindset to take away: the command line is not a worse GUI, it is a place where work can be *automated*. Anything you can type, you can put in a script.

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

Not sure what a command or flag means? Look it up in [`log-triage-cheatsheet.md`](log-triage-cheatsheet.md) as you go.

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

You should be in the exercise folder now (Part 1 left you here). Run `ls` — you'll see a web `access.log` and an application `app.log`. This is the part to actually drill — it's the skill you'll use on the job. Using `grep`, `tail`, `head` and pipes (`|`), answer questions like:

- find every line mentioning `failed` in `app.log`;
- show the last 5 requests that returned a `404` in `access.log`;
- work out which IP is brute-forcing the login.

The full list of practice questions, plus a command reference, is in [`log-triage-cheatsheet.md`](log-triage-cheatsheet.md).

> _Optional stretch:_ once pipes and redirection click, try writing a small bash script that automates something repetitive (e.g. a timestamped backup of a folder). Useful to have seen once — but as a QA you'll **operate** the shell far more than you'll **script** it.

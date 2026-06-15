# Linux cheat sheet — navigation & log triage

The part of the command line you actually reach for when working with a real system: **finding your way around a machine** and **searching text/logs to triage a problem**. It's not testing-specific — a developer debugging an incident, an ops engineer, anyone who reads logs uses exactly these. But it's core fluency for a tester: mostly you *operate* through the shell and read what happened — and when you catch yourself retyping the same triage, you capture it in a small script (Part 4).

## Navigation & files

| Command | What it does |
| --- | --- |
| `pwd` | Print working directory — where am I? |
| `ls` | List files. `ls -la` shows hidden files and permissions |
| `cd dir` | Change directory. `cd ..` goes up, `cd ~` goes home, `cd -` jumps back |
| `cat file` | Print a whole file |
| `whoami` | Which user am I logged in as |
| `find . -name "*.txt"` | Find files by name from the current directory down |

## Reading a file

| Command | What it does |
| --- | --- |
| `cat access.log` | Dump the whole file |
| `head -n 10 access.log` | First 10 lines |
| `tail -n 3 access.log` | Last 3 lines |
| `tail -f access.log` | Follow the file live — watch new lines as they arrive |

## Writing & appending

| Command | What it does |
| --- | --- |
| `echo "Hello" > hello.txt` | Create (or overwrite) a file with "Hello" |
| `echo "more" >> hello.txt` | Append to the end of the file |

> `>` overwrites, `>>` appends. Mixing them up overwrites your file — worth burning in.

## Searching with grep

`grep` searches text for a pattern. This is the single most useful tool for bug triage.

| Command | What it does |
| --- | --- |
| `grep "failed" access.log` | Show every line containing "failed" |
| `grep -i "thm" access.log` | Case-insensitive — matches THM, thm, Thm |
| `grep -n "failed" access.log` | Prefix each match with its line number |
| `grep -c "THM" access.log` | Count matching lines (not print them) |
| `grep -r "TODO" .` | Search recursively through every file under here |
| `grep -v "200" access.log` | Invert — show lines that do **not** match |

### One file vs everywhere

The form is `grep PATTERN where` — the last argument decides the scope:

```bash
grep "failed" app.log         # search ONE named file
grep "failed" app.log access.log   # search several files
grep -r "failed" .            # search EVERY file in this folder and below
```

A common mix-up: `grep -r "failed" .` searches everything because `-r` (recursive) is pointed at `.` (the current folder). To look in just one file, drop the `-r` and name the file instead. With `-r` (or multiple files) grep prefixes each match with the filename (`app.log:...`) so you know where it came from; with a single named file it doesn't, since there's only one source.

## Piping — chain small tools into answers

`|` feeds one command's output into the next. This is where the shell gets powerful for triage.

```bash
# Last 5 failed logins (the word "failed" lives in the app log)
grep "failed" app.log | tail -n 5

# Last 5 requests from a specific IP
grep "192.168.1.10" access.log | tail -n 5

# Last 5 requests that returned a 404
grep "404" access.log | tail -n 5

# How many lines mention an error (grep -c does the same in one step)
grep "ERROR" app.log | wc -l
```

## Common triage recipes

```bash
# What just happened? — last 20 lines of the log
tail -n 20 app.log

# Watch the log live while you reproduce a bug
tail -f app.log

# Did this user/IP/order-id appear at all, and how often?
grep -c "u-1042" app.log

# All errors, case-insensitive, with line numbers
grep -ni "error" app.log

# Everything that is NOT a healthy 200 response
grep -v " 200 " access.log

# Find which config file holds a setting
grep -r "timeout" ./config
```

## Ranking offenders — "count per group"

When the log is too long to eyeball and you need *which X happens most* (which IP, which URL, which error), there's one fixed idiom:

```bash
# Which IPs fail the login most? (the brute-force signature)
grep '/login' access.log | grep '401' | awk '{print $1}' | sort | uniq -c | sort -rn
```

Read the pipeline one stage at a time:

| Stage | What it does |
| --- | --- |
| `grep ... \| grep ...` | your filter — narrow to the lines that matter |
| `awk '{print $1}'` | print **field 1** of each line (here, the IP — fields split on spaces) |
| `sort` | put identical values next to each other (**required** before `uniq`) |
| `uniq -c` | collapse adjacent duplicates, prefixing each with its **count** |
| `sort -rn` | sort by that count, **r**everse + **n**umeric → biggest on top |

> Gotcha: `uniq` only collapses *adjacent* duplicates, so `sort` must come first. Swap the field number (`$1`, `$7`, …) to rank by IP, URL, status code, etc.

Don't force this when a smaller tool fits — match the tool to the size of the haystack:

| Situation | Reach for |
| --- | --- |
| Small log, you can read it | `grep ... \| grep ...` and look |
| You already suspect a value | `grep 'X' file \| grep -c 'Y'` |
| Big log, unknown culprit, rank them | the `sort \| uniq -c \| sort -rn` pipeline |

## How to approach an investigation

Writing the query is the easy part; knowing *what to look for* is the skill. A repeatable loop:

1. **Look** — read the data before filtering. `head`/`cat` one file: what fields does a line have, what can you filter on? You can't query what you haven't seen.
2. **Hypothesise** — describe the signal in words first. Brute force isn't "a 401" — it's *many attempts on one target from one source in a short window*. Repetition, bursts, and outliers are signal; a single odd line is usually noise.
3. **Filter** — build the query one pipe at a time, checking the output after each stage. Start broad, narrow gradually. Don't write the whole pipeline blind.
4. **Verify** — pull the suspect's actual lines and confirm the story (the bunched timestamps, the `curl` user-agent, the matching error downstream). Let the *shape* of the data confirm it, not your assumption.

> An attacker won't always leave a tidy status code — but they'll almost always leave a *spike*. Read the shape, not just the code.

## Mental model

- The shell is **composable**: small tools (`grep`, `tail`, `wc`) chained with `|` answer questions no single tool can.
- `grep` finds *what*, `tail`/`head` pick *which slice*, `wc -l` counts. Most triage is some combination of those three.
- When a test fails or an app misbehaves, the evidence is in a log file. Knowing these commands is the difference between "I'll ask a dev" and "here's the exact line that broke."

## Scripting basics (Part 4)

A script is just the commands you already know, saved in a file so the machine repeats them. Capturing repeated triage this way is a core tester instinct — the moment you notice you're retyping the same commands, script it.

| Piece | What it does |
| --- | --- |
| `#!/bin/bash` | First line — the *shebang*; tells the system to run this file with bash |
| `chmod +x triage.sh` | Make the file executable (the `x` in `ls -l`); then run it with `./triage.sh` |
| `"$1"` | The first argument typed after the script name (`$2` the second, …) |
| `log="$1"` | Store it once; reuse as `"$log"` — in quotes — everywhere after |
| `$(command)` | *Command substitution* — run the command, drop its output in place |
| `if [ cond ]; then … fi` | Run the lines only when `cond` is true; `fi` closes the block |
| `exit 1` | Stop the script now, signalling failure (`0` = success, non-zero = a problem) |

The condition inside `[ ]` — note `[ ]` is itself a test *command*, so the **spaces are required** (`[ -z`, never `[-z`):

| Test | True when… |
| --- | --- |
| `[ -z "$log" ]` | the string is **empty** — you ran the script with no argument |
| `[ -f "$log" ]` | the path is a **real, existing file** |
| `[ ! -f "$log" ]` | `!` **negates** — "*not* a real file" |

> Together, `-z` and `! -f` are the two input guards a robust script opens with: bail out early (with a message and `exit 1`) on a missing argument or a missing file, rather than charging ahead on bad input.

---

This is a reference — keep it open while you work. The exercises that use it are **Parts 2, 3 and 4** in the [module README](README.md), with sample logs in [`exercise/`](exercise) and worked answers in [`solution/`](solution).

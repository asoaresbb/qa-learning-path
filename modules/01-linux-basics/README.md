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

1. Working **only** on the command line, in a scratch directory:
   - create a nested folder structure, move and rename files, and inspect permissions with `ls -l`.
   - find all files containing a given word (`grep -r`), count matching lines, and redirect the result to a file.
   - make a file executable and run it.
2. Then write a **bash script** that automates something repetitive — for example, organising files into folders by extension, or backing up a directory with a timestamped name.

A starter lives in [`exercise/`](exercise). Reference answer in [`solution/`](solution) — try first.

#!/usr/bin/env bash
# Exercise: organise files in a directory into subfolders by extension.
#
# Usage: ./organise.sh <target-directory>
#
# Fill in the TODOs. Run `bash organise.sh ./somedir` to test.
# When you think it works, compare with ../solution/organise.sh

set -euo pipefail

target="${1:-}"

# TODO 1: if no target was given, print a usage message and exit non-zero.

# TODO 2: if the target is not a directory, print an error and exit non-zero.

# TODO 3: for each *file* (not directory) directly inside target:
#   - read its extension (the part after the last dot)
#   - make a subfolder named after the extension if it does not exist
#   - move the file into that subfolder
#   - print what you moved

echo "Not implemented yet — fill in the TODOs."

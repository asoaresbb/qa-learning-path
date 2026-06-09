#!/usr/bin/env bash
# Reference solution: organise files in a directory into subfolders by extension.
#
# Usage: ./organise.sh <target-directory>

set -euo pipefail

target="${1:-}"

if [[ -z "$target" ]]; then
  echo "usage: $0 <target-directory>" >&2
  exit 1
fi

if [[ ! -d "$target" ]]; then
  echo "error: '$target' is not a directory" >&2
  exit 1
fi

shopt -s nullglob
for path in "$target"/*; do
  [[ -f "$path" ]] || continue          # skip directories
  file="$(basename "$path")"
  ext="${file##*.}"                      # part after the last dot
  [[ "$ext" == "$file" ]] && ext="noext" # no extension at all

  dest="$target/$ext"
  mkdir -p "$dest"
  mv "$path" "$dest/"
  echo "moved $file -> $ext/"
done

#!/bin/bash
# triage.sh — quick summary of a web access log
# usage: ./triage.sh <access.log>
#
# Reference solution for Part 4. Run it against the sample log:
#   ./triage.sh ../sample-logs/access.log

log="$1"

# guard: no argument given, or the file doesn't exist
if [ -z "$log" ]; then
  echo "usage: ./triage.sh <access.log>"
  exit 1
fi
if [ ! -f "$log" ]; then
  echo "file not found: $log"
  exit 1
fi

echo "== Triage report for $log =="
echo
echo "Total requests:    $(wc -l < "$log" | tr -d ' ')"
echo "500 errors:        $(grep -c ' 500 ' "$log")"
echo "Non-200 responses: $(grep -vc ' 200 ' "$log")"
echo
echo "Top IPs on /login 401s:"
grep 'POST /login' "$log" | grep '401' | awk '{print $1}' | sort | uniq -c | sort -rn

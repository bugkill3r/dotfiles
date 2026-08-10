#!/bin/bash
# Lightweight network speed for tmux status bar
# Reads byte counters from netstat, diffs against last reading stored in /tmp

IFACE="${1:-en1}"
DIR="${2:-rx}"  # rx or tx
CACHE="/tmp/tmux-net-${IFACE}-${DIR}"

# Get current bytes
if [[ "$DIR" == "rx" ]]; then
  NOW=$(netstat -ib -I "$IFACE" | awk 'NR==2{print $7}')
else
  NOW=$(netstat -ib -I "$IFACE" | awk 'NR==2{print $10}')
fi

if [[ -f "$CACHE" ]]; then
  read -r PREV PREV_TIME < "$CACHE"
  NOW_TIME=$(date +%s)
  ELAPSED=$((NOW_TIME - PREV_TIME))
  [[ $ELAPSED -lt 1 ]] && ELAPSED=1
  DIFF=$(( (NOW - PREV) / ELAPSED ))

  if [[ $DIFF -gt 1048576 ]]; then
    printf "%.1fM" "$(echo "$DIFF/1048576" | bc -l)"
  elif [[ $DIFF -gt 1024 ]]; then
    echo "$(( DIFF / 1024 ))K"
  else
    echo "${DIFF}B"
  fi
else
  echo "0B"
fi

echo "$NOW $(date +%s)" > "$CACHE"

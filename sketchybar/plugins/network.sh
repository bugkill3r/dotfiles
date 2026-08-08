#!/usr/bin/env sh
# Network throughput from netstat byte counters (no ifstat dependency).
IFACE="en0"

counters() { netstat -ibn -I "$IFACE" 2>/dev/null | awk 'NR==2 {print $7, $10; exit}'; }

set -- $(counters); RX1=${1:-0}; TX1=${2:-0}
sleep 1
set -- $(counters); RX2=${1:-0}; TX2=${2:-0}

DOWN=$((RX2 - RX1))   # bytes/sec
UP=$((TX2 - TX1))
[ "$DOWN" -lt 0 ] && DOWN=0
[ "$UP" -lt 0 ] && UP=0

fmt() {
  if [ "$1" -ge 1048576 ]; then
    awk "BEGIN{printf \"%.1f MB/s\", $1/1048576}"
  else
    awk "BEGIN{printf \"%d KB/s\", $1/1024}"
  fi
}
DOWN_FORMAT=$(fmt "$DOWN")
UP_FORMAT=$(fmt "$UP")

sketchybar -m --set network_down label="$DOWN_FORMAT" \
                    icon.highlight="$([ "$DOWN" -gt 0 ] && echo on || echo off)" \
              --set network_up   label="$UP_FORMAT" \
                    icon.highlight="$([ "$UP" -gt 0 ] && echo on || echo off)"

#!/bin/bash
source "$CONFIG_DIR/colors.sh"
TS="$(command -v tailscale || echo /usr/local/bin/tailscale)"

STATE="$("$TS" status --json 2>/dev/null | jq -r '.BackendState' 2>/dev/null)"

# Click toggles the connection.
if [ "$1" = "toggle" ]; then
  if [ "$STATE" = "Running" ]; then "$TS" down; else "$TS" up; fi
  exit 0
fi

if [ "$STATE" = "Running" ]; then
  IP="$("$TS" status --json 2>/dev/null | jq -r '.Self.TailscaleIPs[0]' 2>/dev/null)"
  sketchybar --set "$NAME" icon.color=$GREEN label="${IP}" label.drawing=off
else
  sketchybar --set "$NAME" icon.color=$GREY label.drawing=off
fi

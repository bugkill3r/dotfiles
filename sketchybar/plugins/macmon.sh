#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# one JSON sample from macmon (head -1 closes the stream → macmon exits)
DATA="$(macmon pipe -i 200 2>/dev/null | head -1)"
[ -z "$DATA" ] && exit 0

TEMP="$(echo "$DATA" | jq -r '.temp.cpu_temp_avg | round' 2>/dev/null)"
PWR="$(echo "$DATA"  | jq -r '.all_power | round' 2>/dev/null)"
[ -z "$TEMP" ] || [ "$TEMP" = "null" ] && exit 0

COLOR=$GREEN
[ "$TEMP" -ge 70 ] && COLOR=$YELLOW
[ "$TEMP" -ge 85 ] && COLOR=$RED

sketchybar --set "$NAME" icon.color=$COLOR label="${TEMP}° · ${PWR}W"

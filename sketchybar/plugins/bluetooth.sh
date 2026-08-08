#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Find a connected device's battery level (AirPods/headphones report this).
# system_profiler is slow, so this item updates infrequently.
BATT="$(system_profiler SPBluetoothDataType -json 2>/dev/null \
        | jq -r '.. | .device_batteryLevelMain? // empty' 2>/dev/null | head -1)"
BATT="${BATT%\%}"

if [ -n "$BATT" ]; then
  COLOR=$WHITE
  [ "$BATT" -le 20 ] 2>/dev/null && COLOR=$RED
  sketchybar --set "$NAME" drawing=on icon.color=$COLOR label="${BATT}%"
else
  sketchybar --set "$NAME" drawing=off
fi

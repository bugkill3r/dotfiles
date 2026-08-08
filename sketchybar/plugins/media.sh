#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# sketchybar's media_change sends a JSON blob in $INFO.
STATE="$(echo "$INFO" | jq -r '.state' 2>/dev/null)"
TITLE="$(echo "$INFO" | jq -r '.title' 2>/dev/null)"
ARTIST="$(echo "$INFO" | jq -r '.artist' 2>/dev/null)"

if [ "$STATE" = "playing" ] && [ -n "$TITLE" ] && [ "$TITLE" != "null" ]; then
  LABEL="$TITLE"
  [ -n "$ARTIST" ] && [ "$ARTIST" != "null" ] && LABEL="$TITLE — $ARTIST"
  sketchybar --set "$NAME" drawing=on label="$LABEL"
else
  sketchybar --set "$NAME" drawing=off
fi

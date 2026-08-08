#!/bin/bash
[ "$SENDER" = "mouse.exited.global" ] && { sketchybar --set "$NAME" popup.drawing=off; exit 0; }

sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"

# popup detail: full date + week number
sketchybar --set calendar.date label="$(date '+%A, %B %-d')  ·  W$(date '+%V')" 2>/dev/null

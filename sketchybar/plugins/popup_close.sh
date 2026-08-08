#!/bin/bash
# Close this item's popup when the mouse leaves it (click-outside dismiss).
[ "$SENDER" = "mouse.exited.global" ] && sketchybar --set "$NAME" popup.drawing=off

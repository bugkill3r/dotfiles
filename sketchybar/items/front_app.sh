#!/bin/bash

# This script sets up the front app label with an icon
# We'll use the icon_map.sh script that's already part of your setup

# Use the sketchybar-app-font (real brand logos, same as the workspace pills)
# for the focused app icon + name, plus the focused window title.
FRONT_APP_SCRIPT='
  if [ "$SENDER" = "front_app_switched" ]; then
    source "$CONFIG_DIR/plugins/icon_map.sh" "$INFO"
    [ -z "$icon_result" ] && icon_result=":default:"
    title=$(aerospace list-windows --focused --format "%{window-title}" 2>/dev/null | head -1)
    label="$INFO"
    [ -n "$title" ] && [ "$title" != "$INFO" ] && label="$INFO  ·  ${title:0:36}"
    sketchybar --set $NAME icon="$icon_result" label="$label"
  fi
'

# Define the front_app item
front_app=(
  icon.drawing=on
  icon.font="sketchybar-app-font:Regular:16.0"
  label.font="$FONT:Black:12.0"
  associated_display=active
  script="$FRONT_APP_SCRIPT"
  label.padding_left=6
  icon.padding_right=6
  background.padding_left=10
  background.padding_right=10
)

# Add the front_app item to sketchybar
sketchybar --add item front_app left         \
           --set front_app "${front_app[@]}" \
           --subscribe front_app front_app_switched

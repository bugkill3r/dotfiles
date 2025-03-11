#!/bin/bash

# This script sets up the front app label with an icon
# We'll use the icon_map.sh script that's already part of your setup

# The script to run when front_app is updated
# Format the label to just show the app name without the icon name prefix
FRONT_APP_SCRIPT='
  [ "$SENDER" = "front_app_switched" ] && 
  source "$CONFIG_DIR/plugins/icon_map.sh" "$INFO" && 
  icon=$(echo "$icon_result" | sed "s/:/-/g") && 
  sketchybar --set $NAME icon="$icon" label="$INFO"
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

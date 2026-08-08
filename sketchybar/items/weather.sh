#!/bin/bash

weather=(
  update_freq=1800          # refresh every 30 min
  icon.font="$FONT:Regular:14.0"
  icon.color=$YELLOW
  label.font="$FONT:Semibold:13.0"
  padding_left=6
  padding_right=6
  script="$PLUGIN_DIR/weather.sh"
)

sketchybar --add item weather right       \
           --set weather "${weather[@]}"  \
           --subscribe weather system_woke

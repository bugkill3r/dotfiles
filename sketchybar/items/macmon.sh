#!/bin/bash

macmon=(
  update_freq=5
  icon=􀇬                       # thermometer
  icon.color=$GREEN
  icon.font="$FONT:Regular:13.0"
  icon.padding_right=2
  label.font="$FONT:Semibold:12.0"
  padding_left=6
  padding_right=6
  script="$PLUGIN_DIR/macmon.sh"
)

sketchybar --add item macmon right      \
           --set macmon "${macmon[@]}"  \
           --subscribe macmon system_woke

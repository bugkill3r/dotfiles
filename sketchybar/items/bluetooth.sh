#!/bin/bash

bluetooth=(
  update_freq=120                # system_profiler is slow
  icon=􀑈                        # headphones
  icon.color=$BLUE
  icon.font="$FONT:Regular:13.0"
  icon.padding_right=2
  label.font="$FONT:Semibold:12.0"
  padding_left=6
  padding_right=6
  drawing=off
  script="$PLUGIN_DIR/bluetooth.sh"
)

sketchybar --add item bluetooth right         \
           --set bluetooth "${bluetooth[@]}"  \
           --subscribe bluetooth system_woke

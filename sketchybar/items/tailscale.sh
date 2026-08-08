#!/bin/bash

tailscale=(
  update_freq=20
  icon=􀆪
  icon.font="$FONT:Regular:14.0"
  label.drawing=off
  padding_left=6
  padding_right=6
  script="$PLUGIN_DIR/tailscale.sh"
  click_script="$PLUGIN_DIR/tailscale.sh toggle"
)

sketchybar --add item tailscale right         \
           --set tailscale "${tailscale[@]}"  \
           --subscribe tailscale system_woke

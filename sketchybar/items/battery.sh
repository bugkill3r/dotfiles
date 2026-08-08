#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:19.0"
  padding_right=5
  padding_left=0
  label.drawing=off
  update_freq=120
  updates=on
)

sketchybar --add item battery right      \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke mouse.exited.global

# click → popup with time remaining
sketchybar --set battery \
             click_script="sketchybar --set battery popup.drawing=toggle" \
             popup.align=center \
             popup.background.corner_radius=9 \
             popup.background.border_width=2 \
             popup.background.border_color=$POPUP_BORDER_COLOR \
             popup.background.color=$POPUP_BACKGROUND_COLOR

sketchybar --add item battery.info popup.battery \
           --set battery.info icon.drawing=off \
                              label.font="$FONT:Semibold:12.0" \
                              label.padding_left=12 label.padding_right=12 \
                              background.height=26

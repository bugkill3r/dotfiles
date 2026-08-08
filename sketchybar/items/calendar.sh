#!/bin/bash

calendar=(
  icon=cal
  icon.font="$FONT:Black:12.0"
  icon.padding_right=0
  label.width=45
  label.align=right
  padding_left=15
  update_freq=30
  script="$PLUGIN_DIR/calendar.sh"
  click_script="sketchybar --set calendar popup.drawing=toggle"
  popup.align=center
  popup.background.corner_radius=9
  popup.background.border_width=2
  popup.background.border_color=$POPUP_BORDER_COLOR
  popup.background.color=$POPUP_BACKGROUND_COLOR
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke mouse.exited.global

# popup: full date + a Zen-mode toggle (zen was the old click action)
sketchybar --add item calendar.date popup.calendar   \
           --set calendar.date icon.drawing=off       \
                              label.font="$FONT:Semibold:12.0" \
                              label.padding_left=12 label.padding_right=12 \
                              background.height=26

sketchybar --add item calendar.zen popup.calendar    \
           --set calendar.zen icon=􀆺 icon.padding_left=12 \
                             label="Zen Mode" label.padding_right=12 \
                             background.height=26      \
                             click_script="$PLUGIN_DIR/zen.sh; sketchybar --set calendar popup.drawing=off"

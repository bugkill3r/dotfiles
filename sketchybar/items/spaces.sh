#!/bin/bash
# AeroSpace workspaces (replaces the old yabai/native-Spaces integration).
# One item per AeroSpace workspace; the plugin fills app icons + highlights focus.

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
      updates=on \
      associated_display=active \
      icon="$sid" \
      icon.padding_left=10 \
      icon.padding_right=4 \
      icon.color=$WHITE \
      icon.highlight_color=$MAGENTA \
      icon.font="$FONT:Bold:14.0" \
      label.font="sketchybar-app-font:Regular:16.0" \
      label.padding_left=2 \
      label.padding_right=10 \
      label.y_offset=-1 \
      label.color=$GREY \
      label.drawing=off \
      background.color=$BACKGROUND_1 \
      background.border_color=$BACKGROUND_2 \
      background.corner_radius=9 \
      background.height=26 \
      background.drawing=off \
      click_script="aerospace workspace $sid" \
      script="$PLUGIN_DIR/aerospace.sh $sid"
done

sketchybar --add bracket workspaces '/space\..*/' \
           --set workspaces background.color=$BACKGROUND_1 \
                            background.border_color=$BACKGROUND_2

# initial paint
sketchybar --trigger aerospace_workspace_change \
           FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused)"

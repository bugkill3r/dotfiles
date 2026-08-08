#!/bin/bash

POPUP_OFF='sketchybar --set apple.logo popup.drawing=off'
POPUP_CLICK_SCRIPT='sketchybar --set $NAME popup.drawing=toggle'

apple_logo=(
  icon=$APPLE
  icon.font="$FONT:Black:16.0"
  icon.color=$GREEN
  padding_left=8
  padding_right=8
  label.drawing=off
  click_script="$POPUP_CLICK_SCRIPT"
  script="$PLUGIN_DIR/popup_close.sh"
  popup.height=35
)

apple_prefs=(
  icon=$PREFERENCES
  label="Preferences"
  click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
  icon=$ACTIVITY
  label="Activity"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon=$LOCK
  label="Lock Screen"
  click_script="pmset displaysleepnow; $POPUP_OFF"
)

apple_sleep=(
  icon=􀆼
  label="Sleep"
  click_script="pmset sleepnow; $POPUP_OFF"
)

apple_restart=(
  icon=􀅈
  label="Restart"
  click_script="osascript -e 'tell app \"System Events\" to restart'; $POPUP_OFF"
)

apple_shutdown=(
  icon=􀆨
  label="Shut Down"
  click_script="osascript -e 'tell app \"System Events\" to shut down'; $POPUP_OFF"
)

sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"         \
           --subscribe apple.logo mouse.exited.global  \
                                                       \
           --add item apple.prefs popup.apple.logo     \
           --set apple.prefs "${apple_prefs[@]}"       \
                                                       \
           --add item apple.activity popup.apple.logo  \
           --set apple.activity "${apple_activity[@]}" \
                                                       \
           --add item apple.lock popup.apple.logo      \
           --set apple.lock "${apple_lock[@]}"          \
                                                       \
           --add item apple.sleep popup.apple.logo     \
           --set apple.sleep "${apple_sleep[@]}"        \
                                                       \
           --add item apple.restart popup.apple.logo   \
           --set apple.restart "${apple_restart[@]}"    \
                                                       \
           --add item apple.shutdown popup.apple.logo  \
           --set apple.shutdown "${apple_shutdown[@]}"

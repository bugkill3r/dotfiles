#!/bin/bash

APP="$1"

case "$APP" in
"Google Chrome" | "Chrome" | "Chromium")
  icon="􀼺"
  ;;
"Code" | "Visual Studio Code")
  icon="􀤙"
  ;;
"Terminal" | "iTerm2" | "Alacritty" | "kitty")
  icon="􀆍"
  ;;
"Safari" | "Safari Browser")
  icon="􀤇"
  ;;
"Finder")
  icon="􀉟"
  ;;
"Mail" | "Spark")
  icon="􀍜"
  ;;
"Spotify")
  icon="􀊈"
  ;;
"Messages")
  icon="􀌥"
  ;;
"Slack")
  icon="􀑮"
  ;;
"Discord")
  icon="􀌆"
  ;;
"Notes")
  icon="􀓕"
  ;;
"Calendar")
  icon="􀉉"
  ;;
"Music")
  icon="􀑪"
  ;;
"Photos")
  icon="􀑦"
  ;;
"Xcode")
  icon="􀨋"
  ;;
"System Preferences" | "System Settings")
  icon="􀺽"
  ;;
*)
  icon="􀏜"
  ;;
esac

sketchybar --set "$NAME" icon="$icon"

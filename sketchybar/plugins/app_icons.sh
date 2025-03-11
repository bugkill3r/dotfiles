#!/bin/bash

# This script maps application names to SF Symbol icons
# For use with sketchybar
# Add apps as needed

APP_NAME="$1"

case "$APP_NAME" in
  "Google Chrome")
    icon="􀻱"
    ;;
  "Code" | "Visual Studio Code")
    icon="􀤙"
    ;;
  "Safari" | "Safari Browser")
    icon="􀤇"
    ;;
  "Terminal" | "iTerm2")
    icon="􀆍"
    ;;
  "Finder")
    icon="􀉟"
    ;;
  "Slack")
    icon="􀑮"
    ;;
  "Mail")
    icon="􀍜"
    ;;
  "Spotify")
    icon="􀑬"
    ;;
  "Messages")
    icon="􀌥"
    ;;
  *)
    icon="􀏜"
    ;;
esac

sketchybar --set front_app_icon icon="$icon"
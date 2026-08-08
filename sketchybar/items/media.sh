#!/bin/bash
# Generic now-playing via MediaRemote — works with any player
# (Apple Music, Spotify, browser video, etc.).

media=(
  icon=􀑪
  icon.color=$GREEN
  icon.font="$FONT:Regular:14.0"
  label.max_chars=32
  label.font="$FONT:Semibold:12.0"
  label.color=$WHITE
  scroll_texts=on
  drawing=off
  updates=on
  script="$PLUGIN_DIR/media.sh"
)

sketchybar --add item media center           \
           --set media "${media[@]}"         \
           --subscribe media media_change

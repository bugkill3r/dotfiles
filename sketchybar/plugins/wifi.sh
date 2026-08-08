#!/bin/bash

update() {
  source "$CONFIG_DIR/icons.sh"
  # `airport` was removed in recent macOS; detect via IP + networksetup instead.
  IP="$(ipconfig getifaddr en0 2>/dev/null)"
  SSID="$(networksetup -getairportnetwork en0 2>/dev/null | sed -n 's/^Current Wi-Fi Network: //p')"
  if [ -n "$IP" ]; then
    ICON="$WIFI_CONNECTED"
    LABEL="${SSID:-Wi-Fi} ($IP)"
  else
    ICON="$WIFI_DISCONNECTED"
    LABEL="off"
  fi
  sketchybar --set $NAME icon="$ICON" label="$LABEL"
}

click() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

  WIDTH=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi

  sketchybar --animate sin 20 --set $NAME label.width="$WIDTH"
}

case "$SENDER" in
  "wifi_change") update
  ;;
  "mouse.clicked") click
  ;;
esac

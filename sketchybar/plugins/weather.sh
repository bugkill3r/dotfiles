#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# wttr.in auto-detects location by IP. %C=condition text, %t=temp.
DATA="$(curl -s --max-time 6 'https://wttr.in/?format=%C|%t' 2>/dev/null)"
COND="${DATA%%|*}"
TEMP="${DATA##*|}"
TEMP="${TEMP// /}"   # strip spaces (e.g. "+25°C")

# map condition text → SF Symbol + color
ICON=􀇕; COLOR=$YELLOW   # default: cloud.sun
case "$COND" in
  *Sunny*|*Clear*)                 ICON=􀆮; COLOR=$YELLOW ;;   # sun.max
  *"Partly cloudy"*|*Overcast*|*Cloudy*) ICON=􀇕; COLOR=$GREY ;;   # cloud.sun / cloud
  *rain*|*Rain*|*drizzle*|*Drizzle*|*shower*) ICON=􀇈; COLOR=$BLUE ;;   # cloud.rain
  *snow*|*Snow*|*sleet*|*Sleet*)   ICON=􀇥; COLOR=$WHITE ;;   # cloud.snow
  *thunder*|*Thunder*)             ICON=􀇟; COLOR=$MAGENTA ;; # cloud.bolt
  *fog*|*Fog*|*mist*|*Mist*|*haze*) ICON=􀇋; COLOR=$GREY ;;   # cloud.fog
esac

if [ -z "$TEMP" ] || [ -z "$DATA" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color="$COLOR" label="$TEMP"
fi

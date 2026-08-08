#!/bin/bash
[ "$SENDER" = "mouse.exited.global" ] && { sketchybar --set "$NAME" popup.drawing=off; exit 0; }

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

COLOR=$WHITE
case ${PERCENTAGE} in
  9[0-9]|100) ICON=$BATTERY_100; COLOR=$GREEN
  ;;
  [6-8][0-9]) ICON=$BATTERY_75;  COLOR=$GREEN
  ;;
  [3-5][0-9]) ICON=$BATTERY_50;  COLOR=$YELLOW
  ;;
  [1-2][0-9]) ICON=$BATTERY_25;  COLOR=$ORANGE
  ;;
  *) ICON=$BATTERY_0; COLOR=$RED
esac

if [[ $CHARGING != "" ]]; then
  ICON=$BATTERY_CHARGING
  COLOR=$GREEN
fi

# always visible, with a percentage label
sketchybar --set $NAME drawing=on icon="$ICON" icon.color=$COLOR \
                       label="${PERCENTAGE}%" label.drawing=on

# popup detail: time remaining
TIME_LEFT="$(echo "$BATTERY_INFO" | grep -Eo '[0-9]+:[0-9]+' | head -1)"
if [[ $CHARGING != "" ]]; then
  DETAIL="Charging${TIME_LEFT:+ · $TIME_LEFT to full}"
else
  DETAIL="${TIME_LEFT:+$TIME_LEFT remaining}"; DETAIL="${DETAIL:-Calculating…}"
fi
sketchybar --set battery.info label="$DETAIL" 2>/dev/null

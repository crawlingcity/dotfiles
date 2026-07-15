#!/bin/sh

batt_info=$(pmset -g batt)

if [ "$SENDER" = "mouse.clicked" ]; then
  remaining=$(printf '%s\n' "$batt_info" | sed -n 's/.* \([0-9][0-9]*:[0-9][0-9]*\) remaining.*/\1/p')
  [ -n "$remaining" ] && remaining="${remaining}h" || remaining="No estimate"
  sketchybar --set battery_time label="$remaining"
  sketchybar --set "$NAME" popup.drawing=toggle
  exit 0
fi

percentage=$(printf '%s\n' "$batt_info" | grep -Eo '[0-9]+%' | head -1 | cut -d% -f1)
[ -n "$percentage" ] || exit 0

color=0xff7bd88f
if printf '%s\n' "$batt_info" | grep -q 'AC Power'; then
  icon=""
elif [ "$percentage" -gt 80 ]; then
  icon=""
elif [ "$percentage" -gt 60 ]; then
  icon=""
elif [ "$percentage" -gt 40 ]; then
  icon=""
elif [ "$percentage" -gt 20 ]; then
  icon=""
  color=0xfffd9353
else
  icon=""
  color=0xfffc618d
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${percentage}%" label.color="$color"

#!/bin/sh

if [ "${SENDER:-}" = "mouse.clicked" ]; then
  open -a "Activity Monitor"
  exit 0
fi

cpu_percent=$(
  LC_ALL=C top -l 1 -n 0 |
    awk '/CPU usage:/ {
      user = $3
      sys = $5
      gsub(/%/, "", user)
      gsub(/%/, "", sys)
      printf "%.1f", user + sys
      exit
    }'
)

[ -n "$cpu_percent" ] || exit 0

graph_value=$(
  awk -v cpu="$cpu_percent" 'BEGIN {
    value = cpu / 100
    if (value < 0) value = 0
    if (value > 1) value = 1
    printf "%.3f", value
  }'
)

label=$(awk -v cpu="$cpu_percent" 'BEGIN { printf "%.0f%%", cpu }')

sketchybar --push "$NAME" "$graph_value" \
           --set "$NAME" label="$label"

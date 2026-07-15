#!/bin/sh

volume="${INFO:-$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)}"
[ -n "$volume" ] || exit 0

if [ "$SENDER" = "mouse.clicked" ]; then
  state_file="${TMPDIR:-/tmp}/sketchybar-volume-slider-width"
  width=$(cat "$state_file" 2>/dev/null || true)
  case "$width" in
    100) target=0 ;;
    *) target=100 ;;
  esac
  printf '%s\n' "$target" > "$state_file"
  sketchybar --animate tanh 0.3 --set volume_slider slider.width="$target"
  exit 0
fi

case "$volume" in
  6[1-9]|[7-9][0-9]|100) icon="􀊩" ;;
  3[1-9]|[4-5][0-9]) icon="􀊧" ;;
  1[1-9]|2[0-9]|30) icon="􀊥" ;;
  *) icon="􀊣" ;;
esac

sketchybar --set volume icon="$icon" label="${volume}%"
sketchybar --set volume_slider slider.percentage="$volume" 2>/dev/null || true

#!/bin/sh

[ -n "$PERCENTAGE" ] || exit 0
osascript -e "set volume output volume ${PERCENTAGE}"

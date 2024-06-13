#!/bin/bash
sketchybar  --add item slack right \
            --set slack \
                  update_freq=30 \
                  script="$PLUGIN_DIR/slack.sh" \
                  background.padding_left=5  \
                  icon.font.size=20 \
                  click_script="open -a 'Slack'" \
           --subscribe slack system_woke

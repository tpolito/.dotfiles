#!/usr/bin/env bash

# - make sure to chmod +x ~/.config/hypr/focus_discord.sh

client_json=$(hyprctl clients -j | jq -r '
  map(select(.class | ascii_downcase | test("discord|vesktop"))) | .[0]
')

ws=$(printf '%s\n' "$client_json" | jq -r '.workspace.id')
addr=$(printf '%s\n' "$client_json" | jq -r '.address')

if [ -n "$addr" ] && [ "$addr" != "null" ]; then
    hyprctl dispatch workspace "$ws"
    hyprctl dispatch focuswindow "address:$addr"
else
    discord
fi

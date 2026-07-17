#!/bin/zsh

# Raycast Script Command metadata
# @raycast.schemaVersion 1
# @raycast.title Toggle btop overlay
# @raycast.mode silent
# @raycast.packageName System
# @raycast.icon 📊

# Toggles a centred, interactive btop overlay (kitty quick-access-terminal).
# The wallpaper btop panel is a separate instance and is not affected.
# Note: launching via "open -na kitty.app" fails silently while the wallpaper
# panel occupies the kitty-quick-access helper app, so invoke the kitten
# binary directly. First run starts the overlay, later runs toggle it.

nohup /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal btop >/dev/null 2>&1 &

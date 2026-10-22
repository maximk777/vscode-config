#!/usr/bin/env bash
# macOS VS Code setup bootstrap: editor configs, extensions, LaunchAgents,
# Caps Lock -> Option remap. Idempotent — safe to re-run.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
LA="$HOME/Library/LaunchAgents"

command -v code >/dev/null || { echo "error: 'code' CLI not on PATH"; exit 1; }

mkdir -p "$USER_DIR" "$LA" "$HOME/vscode/scratch"

# 1. Editor configs
cp "$DIR/config/settings.json"    "$USER_DIR/settings.json"
cp "$DIR/config/keybindings.json" "$USER_DIR/keybindings.json"

# 2. Extensions
while read -r ext; do
  [ -n "$ext" ] && code --install-extension "$ext" --force >/dev/null
done < "$DIR/extensions.txt"

# 3. LaunchAgents: VS Code pre-warmed at login + Caps Lock -> Option
cp "$DIR/launchagents/com.user.vscode-warm.plist"   "$LA/"
cp "$DIR/launchagents/com.user.caps-to-option.plist" "$LA/"
launchctl bootstrap "gui/$(id -u)" "$LA/com.user.vscode-warm.plist" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$LA/com.user.caps-to-option.plist" 2>/dev/null || true

# 4. Caps Lock -> Left Option (hidutil, applied immediately)
/usr/bin/hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E2}]}' >/dev/null

echo "Done. Restart VS Code if it was running."

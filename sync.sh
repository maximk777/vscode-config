#!/usr/bin/env bash
# Sync live VS Code configs into this repo, commit and push.
# Usage: ./sync.sh [--no-push]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"
PUSH=1
[ "${1:-}" = "--no-push" ] && PUSH=0

command -v code >/dev/null || { echo "error: 'code' CLI not on PATH"; exit 1; }
# Configs are JSONC (comments) — jq chokes on them, python handles both
validate() { python3 -c "import json,re,sys; json.loads(re.sub(r'^\s*//.*$','',open(sys.argv[1]).read(),flags=8))" "$1"; }

# 1. Pull live configs + refresh extension list
cp "$USER_DIR/settings.json"    "$DIR/config/settings.json"
cp "$USER_DIR/keybindings.json" "$DIR/config/keybindings.json"
code --list-extensions > "$DIR/extensions.txt"

# 2. Validate before committing anything
validate "$DIR/config/settings.json"
validate "$DIR/config/keybindings.json"

# 3. Commit only if something actually changed
cd "$DIR"
if [ -z "$(git status --porcelain -- config/ extensions.txt)" ]; then
  echo "configs unchanged, nothing to sync"
  exit 0
fi

git add config/ extensions.txt
git commit -m "chore(config): sync live settings and keybindings"

# 4. Push
if [ "$PUSH" = 1 ]; then
  git push
else
  echo "committed locally (--no-push)"
fi

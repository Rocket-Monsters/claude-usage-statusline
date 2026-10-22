#!/bin/sh
# Installs the usage status line into $CLAUDE_CONFIG_DIR (default ~/.claude).
set -e
command -v jq >/dev/null || { echo "jq is required (brew install jq / apt install jq)" >&2; exit 1; }
DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SRC="https://raw.githubusercontent.com/Rocket-Monsters/claude-usage-statusline/main/statusline-usage.sh"
mkdir -p "$DIR"
curl -fsSL "$SRC" -o "$DIR/statusline-usage.sh"
chmod +x "$DIR/statusline-usage.sh"
S="$DIR/settings.json"
[ -f "$S" ] || echo '{}' > "$S"
jq --arg c "$DIR/statusline-usage.sh" '.statusLine = {type: "command", command: $c, padding: 0}' "$S" > "$S.tmp" && mv "$S.tmp" "$S"
echo "Installed to $DIR/statusline-usage.sh. Restart Claude Code."

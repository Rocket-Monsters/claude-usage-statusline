# claude-usage-statusline

Claude Code status line showing 5-hour and weekly usage %, time until each resets, and context window usage. Colors shift at warning/critical thresholds.

```
5h 42% 2h13m · wk 18% 4d6h · ctx 120k/1M 12%
```

## Install

Requires `jq` and `curl`.

```sh
curl -fsSL https://raw.githubusercontent.com/Rocket-Monsters/claude-usage-statusline/main/install.sh | sh
```

Uses `$CLAUDE_CONFIG_DIR` if set, otherwise `~/.claude`. It copies the script there and sets `statusLine` in `settings.json`. Restart Claude Code afterwards.

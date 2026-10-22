# vscode-config

Personal VS Code setup for macOS (Apple Silicon): performance config, one-hand
hotkey layer, warm background launch, JetBrains-style scratch folder.

## What's inside

| Path | What |
|---|---|
| `config/settings.json` | 63 settings: telemetry/AI off, manual updates, watcher/search excludes (Go/Zig/Rust/Python), extension process isolation, relative line numbers, autosave 200ms, blue status bar, search without result cap |
| `config/keybindings.json` | One-hand `alt` layer + nvim jumplist (`ctrl+o`/`ctrl+i`), vim page jumps (`ctrl+u/d/b/f`), `Cmd+W` last-tab protection, `alt+n` scratch folder |
| `launchagents/` | VS Code pre-warmed at login (instant `code <path>`) + Caps Lock → Option remap |
| `extensions.txt` | 15 extensions (Go, TS, Zig, Rust, Python, k8s/containers) |
| `HOTKEYS.md` | Full hotkey registry, ordered by learning priority |
| `install.sh` | One-shot bootstrap |

## Install

```bash
git clone https://github.com/maximk777/vscode-config.git && cd vscode-config
./install.sh
```

Requires macOS and the `code` CLI on PATH (`Cmd+Shift+P` → *Shell Command: Install 'code' command in PATH*).

## How it works

- **Warm start**: a LaunchAgent opens VS Code hidden at login, so `code <path>`
  attaches to a running instance and a window appears instantly. `Cmd+W` closes
  tabs but never the last one in a group.
- **One-hand layer**: Caps Lock is remapped to Option via `hidutil` (no third-party
  apps), so the whole `alt+letter` layer sits under the left palm — `alt+s` symbol,
  `alt+d` definition, `alt+f` format, `alt+t` terminal, etc. See `HOTKEYS.md`.
- **Search**: ripgrep by default, PCRE2 engages automatically only for lookarounds;
  `vendor/`, `node_modules` and friends are excluded from watcher and search.
- **No built-in AI**: `chat.disableAIFeatures` plus per-extension AI/telemetry opt-outs.

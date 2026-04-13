# dotfiles-term

A script to automate the setup of a clean and efficient terminal environment.

## Quick Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/setup.sh)"
```

## What Gets Installed

- **Homebrew** — package manager
- **Fish** — user-friendly shell
- **Fisher** — Fish plugin manager + plugins
- **Aporetic Nerd Font** — terminal font (Echinoidea's Nerd Font patched variant)
- **Ghostty** — GPU-accelerated terminal emulator
- **Neovim** — text editor
- **uv / ruff / ty** — Python package manager, linter, and type checker
- **Pyright** — Python LSP server
- **pi coding agent** — terminal AI coding agent

## Getting Started

Run the one-liner above. The script is fully automated — no prompts.

> **Linux users:** Ghostty has no Homebrew cask on Linux. Install it manually from [ghostty.org/docs/install/binary](https://ghostty.org/docs/install/binary) before running the script.

After the script finishes, restart your terminal. To set Fish as your system default shell:

```bash
chsh -s $(which fish)
```

## Configuration

### Fish Shell

Config installed to `~/.config/fish/config.fish`. Includes:

- **Locale**: UTF-8 (en_US.UTF-8) set at the top to prevent encoding issues
- **Tide prompt**: Auto-configured on first run
- **Editor**: Neovim set as default
- **Secret env vars**: Loads `~/.config/fish/fish_env.fish` if present (for API keys etc., not tracked in git)
- **fzf**: Fuzzy finder integration
- **History**: 10,000 lines
- **Less**: Colorized man pages

#### Fish plugins

| Plugin | Purpose |
|---|---|
| IlanCosman/tide@v6 | Modern prompt theme |
| PatrickF1/fzf.fish | fzf key bindings |
| jethrokuan/z | Directory jumping |
| franciscolourenco/done | Notifications for long commands |
| joseluisq/gitnow | Git utilities |
| nickeb96/puffer-fish | Fish abbreviations |
| acomagu/fish-async-prompt | Async prompt loading (disabled by default) |
| gazorby/fish-abbreviation-tips | Abbreviation suggestions |

To enable async prompt:
```fish
set -g async_prompt_enable 1
```

To reconfigure Tide:
```fish
tide configure
```

### Ghostty Terminal

Config installed to `~/.config/ghostty/config`. Fish is set as the default shell, which enables [automatic shell integration](https://ghostty.org/docs/features/shell-integration) with no extra setup.

### Neovim

Config installed to `~/.config/nvim/init.lua`.

### Python tooling

`uv`, `ruff`, and `ty` are installed via Homebrew. `pyright` is installed separately as an LSP server for editor integration.

### pi coding agent

Installed globally via npm. User-level config and skills are installed to `~/.pi/agent/` from this repo's `.pi/agent/` directory.

## Secret Environment Variables

Create `~/.config/fish/fish_env.fish` for private values (not tracked in git):

```fish
set -gx MY_API_KEY "your-secret-key"
set -gx ANOTHER_TOKEN "another-secret"
```

This file is loaded automatically if it exists.

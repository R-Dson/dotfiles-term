# dotfiles-term

A script to automate the setup of a clean and efficient terminal environment.

The installer is interactive by default and asks before each major step. Each prompt uses a `Y/n` default, so pressing Enter accepts the step.

## Quick Install

Interactive install:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/setup.sh)"
````

Fully automated install:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/setup.sh)" -- -y
```

## Installer Options

| Option         | Description                      |
| -------------- | -------------------------------- |
| `-y`           | Accept all prompts automatically |
| `-Y`           | Accept all prompts automatically |
| `--yes`        | Accept all prompts automatically |
| `-h`, `--help` | Show usage help                  |

## What Gets Installed

The script can install and configure:

* **Homebrew** — package manager
* **Aporetic Nerd Font** — terminal font, Echinoidea's Nerd Font patched variant
* **Fish** — user-friendly shell
* **Fisher** — Fish plugin manager and plugins
* **Ghostty** — GPU-accelerated terminal emulator
* **VS Code settings** — editor configuration
* **Neovim** — text editor
* **Codicons** — VS Code icon font package for editor/UI integrations
* **Pyright** — Python LSP server
* **pi coding agent** — terminal AI coding agent

## Getting Started

Run the one-liner above.

By default, the installer asks before each major step:

```text
Set up Homebrew? [Y/n]
Install Aporetic Nerd Font? [Y/n]
Install Fish shell? [Y/n]
Install Fish config? [Y/n]
...
```

Press Enter to accept the default `yes`, or type `n` to skip a step.

For a fully automated setup, pass `-y`:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/setup.sh)" -- -y
```

> **Linux users:** Ghostty has no Homebrew cask on Linux. Install it manually from [ghostty.org/docs/install/binary](https://ghostty.org/docs/install/binary), or skip the Ghostty install step when prompted.

After the script finishes, restart your terminal.

To set Fish as your system default shell:

```bash
chsh -s $(which fish)
```

## Configuration

Existing configuration directories are backed up before being replaced. Backups are created next to the original directory with a `.bak` suffix.

For example:

```text
~/.config/fish.bak
~/.config/nvim.bak
~/.config/ghostty.bak
```

### Fish Shell

Config installed to:

```text
~/.config/fish/config.fish
```

Includes:

* **Locale**: UTF-8, `en_US.UTF-8`, set at the top to prevent encoding issues
* **Tide prompt**: Auto-configured on first run
* **Editor**: Neovim set as default
* **Secret env vars**: Loads `~/.config/fish/fish_env.fish` if present
* **fzf**: Fuzzy finder integration
* **History**: 10,000 lines
* **Less**: Colorized man pages

#### Fish plugins

| Plugin                           | Purpose                                   |
| -------------------------------- | ----------------------------------------- |
| `IlanCosman/tide@v6`             | Modern prompt theme                       |
| `PatrickF1/fzf.fish`             | fzf key bindings                          |
| `jethrokuan/z`                   | Directory jumping                         |
| `franciscolourenco/done`         | Notifications for long commands           |
| `joseluisq/gitnow`               | Git utilities                             |
| `nickeb96/puffer-fish`           | Fish abbreviations                        |
| `acomagu/fish-async-prompt`      | Async prompt loading, disabled by default |
| `gazorby/fish-abbreviation-tips` | Abbreviation suggestions                  |

To enable async prompt:

```fish
set -g async_prompt_enable 1
```

To reconfigure Tide:

```fish
tide configure
```

### Ghostty Terminal

Config installed to:

```text
~/.config/ghostty/config
```

If Fish is installed, the script appends Fish as Ghostty’s default command unless the Ghostty config already defines a `command`.

This enables [automatic shell integration](https://ghostty.org/docs/features/shell-integration) with no extra setup.

### VS Code

Settings installed to:

macOS:

```text
~/Library/Application Support/Code/User/settings.json
```

Linux:

```text
~/.config/Code/User/settings.json
```

### Neovim

Config installed to:

```text
~/.config/nvim/init.lua
```

### Python tooling

`pyright` is installed as the Python LSP server for editor integration.

### pi coding agent

Installed globally via npm:

```bash
npm install --yes -g @earendil-works/pi-coding-agent
```

User-level config and skills are installed to:

```text
~/.pi/agent/
```

from this repo’s `.pi/agent/` directory.

## Secret Environment Variables

Create this file for private values:

```text
~/.config/fish/fish_env.fish
```

Example:

```fish
set -gx MY_API_KEY "your-secret-key"
set -gx ANOTHER_TOKEN "another-secret"
```

This file is loaded automatically by the Fish config if it exists.

It should not be tracked in git.

## Running Locally

Clone the repo:

```bash
git clone --branch main-oma https://github.com/R-Dson/dotfiles-term.git
cd dotfiles-term
```

Run interactively:

```bash
./setup.sh
```

Run non-interactively:

```bash
./setup.sh -y
```

Show help:

```bash
./setup.sh --help
```

## Notes

* The installer is safe to run interactively because each major step can be accepted or skipped.
* The `-y`, `-Y`, and `--yes` flags are intended for fresh machines or environments where you want the full setup.
* Some steps depend on earlier tools. For example, package installs require Homebrew, and Fish plugins require Fish.
* Restart your terminal after installation so shell, font, and terminal settings fully apply.

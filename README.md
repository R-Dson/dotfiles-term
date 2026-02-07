# dotfiles-term

A script to automate the setup of a clean and efficient Fish shell environment.

## Overview

The setup script handles the installation and configuration of several tools to provide a modern terminal experience:

- Homebrew: The package manager.
- Fish: A user-friendly and feature-rich shell.
- Fisher: A plugin manager for Fish.
- Tide: A modern and customizable Fish prompt theme.
- Plugins: fzf (fuzzy finder), z (jump directories), done (smart command confirmation), gitnow (git utilities), puffer-fish (abbreviations), fish-async-prompt (async prompt loading), fish-abbreviation-tips (abbreviation suggestions).
- Kitty: A fast, feature-rich GPU-accelerated terminal emulator.
- Neovim: A modern, extensible text editor.

## Getting Started

To set up your environment, ensure the script is executable and then run it from your terminal:

```bash
chmod +x setup.sh
./setup.sh
```

The script will:
1. Check for Homebrew (prompt to install if missing)
2. Install Fish shell
3. Set Fish as your default shell
4. Install Fish configuration (config.fish, fish_variables)
5. Install Fisher plugin manager
6. Install Fish plugins (fzf, z, done, gitnow, puffer-fish, fish-async-prompt, fish-abbreviation-tips, tide)
7. Install Kitty terminal
8. Install Kitty configuration (kitty.conf)
9. Install Neovim
10. Install Neovim configuration (init.lua)

Once the process is complete, restart your terminal to use Fish.

## Configuration

The configuration files are managed as follows:

### Fish Shell (`fish/config.fish`)

- **Path settings**: Multiple binary directories added to PATH
- **Editor**: Neovim set as default editor
- **Secret environment variables**: Loads `~/.config/fish/fish_env.fish` if it exists (for API keys, tokens, etc. - not tracked in git)
- **Tide prompt**: Auto-configured with Lean style and true color
- **Aliases**: Common commands (ls, git, navigation, etc.)
- **fzf**: Fuzzy finder integration
- **History**: 10,000 lines of history
- **Less colors**: Colorized man pages

### Kitty Terminal (`kitty/kitty.conf`)

The Kitty configuration is automatically downloaded and installed to `~/.config/kitty/kitty.conf`. Customize font, colors, key bindings, and terminal behavior there.

### Neovim Editor (`nvim/init.lua`)

The Neovim configuration is automatically downloaded and installed to `~/.config/nvim/init.lua`. Customize your editor settings, key mappings, plugins, and Lua configuration there.

## Secret Environment Variables

To set private environment variables (API keys, tokens, etc.), create a file at `~/.config/fish/fish_env.fish`:

```fish
# Example: ~/.config/fish/fish_env.fish
set -gx MY_API_KEY "your-secret-key-here"
set -gx ANOTHER_SECRET "another-secret"
```

This file is automatically loaded if it exists, but won't be tracked in version control.

## File Structure

```
.
├── setup.sh          # Installation script
├── fish/
│   └── config.fish   # Fish shell configuration
└── README.md         # This file
```

## Plugins Included

- **PatrickF1/fzf.fish**: fzf key bindings and integrations
- **jethrokuan/z**: Directory jumping
- **franciscolourenco/done**: Smart command confirmation
- **joseluisq/gitnow**: Git utilities
- **nickeb96/puffer-fish**: Fish abbreviations
- **acomagu/fish-async-prompt**: Asynchronous prompt loading
- **gazorby/fish-abbreviation-tips**: Abbreviation suggestions
- **IlanCosman/tide@v6**: Modern prompt theme

## Customization

To customize Tide prompt, run:
```fish
tide configure
```

To add more Fisher plugins:
```fish
fisher install <plugin-name>
```

Edit `fish/config.fish` to add your own aliases, functions, and environment variables.

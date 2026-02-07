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
4. Install Fisher plugin manager
5. Install Fish plugins (fzf, z, done, gitnow, puffer-fish, fish-async-prompt, fish-abbreviation-tips, tide)
6. Install Kitty terminal
7. Install Neovim

Once the process is complete, restart your terminal to use Fish.

## Configuration

The Fish configuration is located in `fish/config.fish`. It includes:

- **Path settings**: Multiple binary directories added to PATH
- **Editor**: Neovim set as default editor
- **Tide prompt**: Auto-configured with Lean style and true color
- **Aliases**: Common commands (ls, git, navigation, etc.)
- **fzf**: Fuzzy finder integration
- **History**: 10,000 lines of history
- **Less colors**: Colorized man pages

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

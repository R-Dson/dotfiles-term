# dotfiles-term

A script to automate the setup of a clean and efficient Fish shell environment.

## Overview

The setup script handles the installation and configuration of several tools to provide a modern terminal experience:

- Homebrew: The package manager.
- Fish: A user-friendly and feature-rich shell.
- Fisher: A plugin manager for Fish.
- Fonts: Maple Mono NF Nerd Font (for Kitty terminal).
- Plugins: fzf (fuzzy finder), z (jump directories), done (smart command confirmation), gitnow (git utilities), puffer-fish (abbreviations), fish-async-prompt (async prompt loading, disabled by default), Tide (modern prompt theme).
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
3. Install Maple Mono NF font (for Kitty terminal)
4. Note: Run `chsh -s $(which fish)` to set Fish as default shell
5. Install Fish configuration (from local fish/config.fish)
6. Install Fisher plugin manager
7. Install Fish plugins (including Tide configured in config.fish)
8. Install Kitty terminal
9. Install Kitty configuration (from local kitty/kitty.conf)
10. Install Neovim
11. Install Neovim configuration (from local nvim/init.lua)

Once the process is complete, restart your terminal to use Fish.

## Configuration

### Fish Shell

The Fish configuration is installed from `fish/config.fish` to `~/.config/fish/config.fish`. It includes:

- **Locale**: UTF-8 locale (en_US.UTF-8) set at the top to prevent encoding issues
- **Tide prompt**: Auto-configured with Classic style, Dark color, True color, Angled separators (runs once on startup)
- **Paths**: Multiple binary directories added to PATH
- **Editor**: Neovim set as default editor
- **Secret environment variables**: Loads `~/.config/fish/fish_env.fish` if it exists (for API keys, tokens, etc. - not tracked in git)
- **Aliases**: Common commands (ls, git, navigation, etc.)
- **fish-async-prompt**: Disabled by default (`async_prompt_enable=0`) due to locale/async issues. Enable with `set -g async_prompt_enable 1`
- **fzf**: Fuzzy finder integration
- **History**: 10,000 lines of history
- **Less colors**: Colorized man pages

### Kitty Terminal (`kitty/kitty.conf`)

The Kitty configuration is automatically downloaded and installed to `~/.config/kitty/kitty.conf`. It uses the Maple Mono NF Nerd Font (installed via Homebrew). Customize font, colors, key bindings, and terminal behavior there.

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

## Plugins Included

- **IlanCosman/tide@v6**: Modern prompt theme with Classic style
- **PatrickF1/fzf.fish**: fzf key bindings and integrations
- **jethrokuan/z**: Directory jumping
- **franciscolourenco/done**: Smart command confirmation
- **joseluisq/gitnow**: Git utilities
- **nickeb96/puffer-fish**: Fish abbreviations
- **acomagu/fish-async-prompt**: Asynchronous prompt loading (disabled by default, enable with `set -g async_prompt_enable 1`)
- **gazorby/fish-abbreviation-tips**: Abbreviation suggestions

## Customization

To reconfigure Tide prompt with different settings, run:
```fish
tide configure
```

To enable fish-async-prompt (disabled by default), run:
```fish
set -g async_prompt_enable 1
```

To add more Fisher plugins:
```fish
fisher install <plugin-name>
```

Edit `fish/config.fish` to add your own aliases, functions, and environment variables.


# dotfiles-term

A script to automate the setup of a clean and efficient ZSH environment.

## Overview

The setup script handles the installation and configuration of several tools to provide a modern terminal experience:

- Homebrew: The package manager.
- Zsh: An extended shell with many improvements over bash.
- Oh My Zsh: A framework for managing your Zsh configuration.
- Spaceship Prompt: A minimal and powerful Zsh prompt.
- Plugins: Includes syntax highlighting and auto-suggestions for better productivity.

## Getting Started

To set up your environment, ensure the script is executable and then run it from your terminal:

```
chmod +x setup.sh
./setup.sh
```

Once the process is complete, restart your terminal or source your configuration:

```
source ~/.zshrc
```

## Details

The script generates a .zshrc file with optimized settings for performance and includes a global alias expansion feature. It also ensures a .zsh_aliases file exists for your custom shortcuts.

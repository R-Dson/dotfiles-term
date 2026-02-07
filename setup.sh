#!/bin/bash

# Stop on error
set -e

echo "🚀 Starting environment setup..."

# 1. Check for Homebrew and install if missing
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found."
    read -p "Do you want to install Homebrew? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to path for the current session
        eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
    else
        echo "❌ Homebrew is required for this setup. Exiting."
        exit 1
    fi
else
    echo "✅ Homebrew already installed."
fi

# 2. Install Fish via Brew
echo "🐟 Installing Fish..."
if ! command -v fish &> /dev/null; then
    brew install fish
else
    echo "✅ Fish already installed."
fi

# 3. Set Fish as default shell
if [[ "$SHELL" != *"/fish" ]]; then
    echo "🔧 Changing default shell to fish..."
    # Add fish to /etc/shells if it's not there
    if ! grep -q "$(which fish)" /etc/shells; then
        echo "Adding fish to /etc/shells..."
        echo "$(which fish)" | sudo tee -a /etc/shells
    fi
    if command -v chsh &> /dev/null; then
        chsh -s "$(which fish)"
    else
        echo "⚠️  chsh not available. To set Fish as default shell, run: chsh -s $(which fish)"
    fi
fi

# 4. Install Fisher (plugin manager)
echo "🎣 Installing Fisher..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# 5. Install Fish plugins
echo "🧩 Installing Fish plugins..."
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install franciscolourenco/done"
fish -c "fisher install joseluisq/gitnow"
fish -c "fisher install nickeb96/puffer-fish"
fish -c "fisher install acomagu/fish-async-prompt"
fish -c "fisher install gazorby/fish-abbreviation-tips"
fish -c "fisher install IlanCosman/tide@v6"

# 6. Install Kitty
echo "🐱 Installing Kitty..."
if ! command -v kitty &> /dev/null; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "✅ Kitty already installed."
fi

# 7. Install Neovim
echo "🌚 Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    brew install neovim
else
    echo "✅ Neovim already installed."
fi

echo "🎉 Setup complete! Restart your terminal to use Fish."

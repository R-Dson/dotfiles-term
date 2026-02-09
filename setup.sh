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
        # Add brew to path for current session
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

# 3. Install Fonts
echo "🔤 Installing Fonts..."
brew install --cask font-maple-mono-nf
echo "✅ Fonts installed"

# 4. Set Fish as default shell (optional)
echo "ℹ️  To set Fish as default shell, run: chsh -s $(which fish)"

# 5. Backup and install Fish config
echo "📝 Setting up Fish configuration..."
FISH_CONFIG="$HOME/.config/fish"
if [ -d "$FISH_CONFIG" ]; then
    echo "Backing up existing Fish config..."
    cp -r "$FISH_CONFIG" "$FISH_CONFIG.bak" 2>/dev/null || true
    # Remove old config files and plugins for clean install
    rm -rf "$FISH_CONFIG/functions" "$FISH_CONFIG/conf.d" "$FISH_CONFIG/completions" 2>/dev/null || true
    rm -f "$FISH_CONFIG/config.fish" "$FISH_CONFIG/fish_variables" "$FISH_CONFIG/fish_plugins" 2>/dev/null || true
fi
# Create directories
if ! mkdir -p "$FISH_CONFIG/functions" "$FISH_CONFIG/conf.d" "$FISH_CONFIG/completions" 2>/dev/null; then
    echo "❌ Cannot create Fish config directory at $FISH_CONFIG"
    echo "   This is likely due to permission issues."
    exit 1
fi
echo "Downloading Fish config file..."
if ! curl -s https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/fish/config.fish -o "$FISH_CONFIG/config.fish"; then
    echo "❌ Failed to download Fish config"
    exit 1
fi
echo "✅ Fish configuration installed"

# 6. Install Fisher (plugin manager)
echo "🎣 Installing Fisher..."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# 7. Install Fish plugins
echo "🧩 Installing Fish plugins..."
fish << 'EOF'
source ~/.config/fish/functions/fisher.fish
fisher install IlanCosman/tide@v6
fisher install PatrickF1/fzf.fish
fisher install jethrokuan/z
fisher install franciscolourenco/done
fisher install joseluisq/gitnow
fisher install nickeb96/puffer-fish
fisher install acomagu/fish-async-prompt
fisher install gazorby/fish-abbreviation-tips
EOF
echo "✅ All Fish plugins installed (Tide auto-configured in config.fish)"

# 8. Install Kitty
echo "🐱 Installing Kitty..."
if ! command -v kitty &> /dev/null; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "✅ Kitty already installed."
fi

# 9. Backup and install Kitty config
echo "📝 Setting up Kitty configuration..."
KITTY_CONFIG="$HOME/.config/kitty"
if [ -d "$KITTY_CONFIG" ]; then
    echo "Backing up existing Kitty config..."
    cp -r "$KITTY_CONFIG" "$KITTY_CONFIG.bak" 2>/dev/null || true
fi
if ! mkdir -p "$KITTY_CONFIG" 2>/dev/null; then
    echo "❌ Cannot create Kitty config directory at $KITTY_CONFIG"
    exit 1
fi
echo "Downloading Kitty config file..."
if ! curl -s https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/kitty/kitty.conf -o "$KITTY_CONFIG/kitty.conf"; then
    echo "❌ Failed to download Kitty config"
    exit 1
fi
if ! curl -s https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/kitty/theme.conf -o "$KITTY_CONFIG/theme.conf"; then
    echo "❌ Failed to download Kitty theme config"
    exit 1
fi
echo "✅ Kitty configuration installed"

# 14. Install opencode CLI
echo "🤖 Installing opencode CLI..."
if ! command -v opencode &> /dev/null; then
    curl -fsSL https://opencode.ai/install | bash
else
    echo "✅ opencode already installed."
fi

# 15. Install opencode config
echo "🤖 Setting up opencode configuration..."
OPCODE_CONFIG="$HOME/.config/opencode"
if [ -d "$OPCODE_CONFIG" ]; then
    echo "Backing up existing opencode config..."
    cp -r "$OPCODE_CONFIG" "$OPCODE_CONFIG.bak" 2>/dev/null || true
fi
if ! mkdir -p "$OPCODE_CONFIG" 2>/dev/null; then
    echo "❌ Cannot create opencode config directory at $OPCODE_CONFIG"
    exit 1
fi
echo "Copying opencode config file..."
cp opencode/opencode.jsonc "$OPCODE_CONFIG/opencode.jsonc"
echo "✅ opencode configuration installed"

# 17. Install Neovim
echo "🌚 Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    brew install neovim
else
    echo "✅ Neovim already installed."
fi

# 18. Check for npm (required for Neovim plugins)
echo "📦 Checking for npm..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm required for Neovim plugins (copilot.vim, nvim-web-devicons)"
    echo "   Please install npm first, then run this script again."
    exit 1
fi
echo "✅ npm already installed."
echo "📦 Installing VS Code Codicons..."
npm i @vscode/codicons
echo "✅ VS Code Codicons installed"

# 19. Install pyright (LSP server for Python)
echo "🐍 Installing pyright..."
if ! command -v pyright &> /dev/null; then
    brew install pyright
    echo "✅ pyright installed"
else
    echo "✅ pyright already installed."
fi

# 20. Install uv (Python package manager)
echo "🐍 Installing uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "✅ uv already installed."
fi

# 21. Install uv tools
echo "🛠️  Installing uv tools..."
if command -v uv &> /dev/null; then
    uv tool install ruff@latest
    uv tool install ty@latest
    echo "✅ uv tools installed"
else
    echo "⚠️  Skipping uv tools installation (uv not found)"
fi

# 22. Backup and install Neovim config
echo "📝 Setting up Neovim configuration..."
NVIM_CONFIG="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG" ]; then
    echo "Backing up existing Neovim config..."
    cp -r "$NVIM_CONFIG" "$NVIM_CONFIG.bak" 2>/dev/null || true
fi
if ! mkdir -p "$NVIM_CONFIG" 2>/dev/null; then
    echo "❌ Cannot create Neovim config directory at $NVIM_CONFIG"
    exit 1
fi
echo "Downloading Neovim config file..."
if ! curl -s https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma/nvim/init.lua -o "$NVIM_CONFIG/init.lua"; then
    echo "❌ Failed to download Neovim config"
    exit 1
fi
echo "✅ Neovim configuration installed"

echo "🎉 Setup complete! Restart your terminal to use Fish."
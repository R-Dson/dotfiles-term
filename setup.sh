#!/bin/bash

# Sources:
# https://scottspence.com/posts/my-updated-zsh-config-2025

# Stop on error
set -e

echo "🚀 Starting ZSH environment setup..."

# 1. Check for Homebrew and install if missing
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)" || eval "$(/usr/local/bin/brew shellenv)"
else
    echo "✅ Homebrew already installed."
fi

# 2. Install Zsh via Brew
echo "🐚 Installing Zsh..."
brew install zsh

# 3. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed."
fi

# Define custom plugin/theme directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 4. Install Plugins
echo "🧩 Installing plugins..."
# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 5. Install Spaceship Theme
echo "🎨 Installing Spaceship Theme..."
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

# 6. Create .zsh_aliases if it doesn't exist (to prevent errors)
if [ ! -f "$HOME/.zsh_aliases" ]; then
    echo "📝 Creating empty .zsh_aliases file..."
    touch "$HOME/.zsh_aliases"
fi

# 7. Set ZSH as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔧 Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

# 8. Install Kitty
echo "🐱 Installing Kitty..."
if ! command -v kitty &> /dev/null; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
else
    echo "✅ Kitty already installed."
fi

# 9. Install Neovim
echo "🌚 Installing Neovim..."
brew install neovim

echo "🎉 Setup complete! Restart your terminal or run 'source ~/.zshrc'"

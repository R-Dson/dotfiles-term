#!/bin/bash

set -e

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

info()    { echo "ℹ️  $*"; }
success() { echo "✅ $*"; }
error()   { echo "❌ $*" >&2; }
step()    { echo; echo "── $* ──────────────────────────────"; }

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }

download() {
    local url="$1" dest="$2"
    if ! curl -fsSL "$url" -o "$dest"; then
        error "Failed to download: $url"
        exit 1
    fi
}

backup_and_prepare() {
    local dir="$1"
    if [ -d "$dir" ]; then
        cp -r "$dir" "${dir}.bak" 2>/dev/null || true
    fi
    mkdir -p "$dir" || { error "Cannot create directory: $dir"; exit 1; }
}

DOTFILES="https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma"
DOTFILES_REPO="https://github.com/R-Dson/dotfiles-term"
DOTFILES_BRANCH="main-oma"

# ─────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────

step "Homebrew"
if ! command -v brew &>/dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Activate brew for the current session (Apple Silicon, Intel, Linux)
    if   [ -x "/opt/homebrew/bin/brew" ];              then eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ];                 then eval "$(/usr/local/bin/brew shellenv)"
    elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else error "Homebrew installed but brew binary not found in expected locations."; exit 1
    fi
fi
success "Homebrew ready"

# ─────────────────────────────────────────────
# Fonts
# ─────────────────────────────────────────────

step "Fonts"
FONT_DIR="$HOME/.local/share/fonts/AporeticNerdFont"
mkdir -p "$FONT_DIR"
FONT_TMP=$(mktemp -d)
git clone --depth 1 https://github.com/Echinoidea/Aporetic-Nerd-Font "$FONT_TMP"
cp "$FONT_TMP"/*.ttf "$FONT_DIR/"
rm -rf "$FONT_TMP"
if is_macos; then
    # Register fonts with macOS font system
    cp "$FONT_DIR"/*.ttf "$HOME/Library/Fonts/" 2>/dev/null || true
else
    fc-cache -f "$FONT_DIR"
fi
success "Aporetic Nerd Font installed"

# ─────────────────────────────────────────────
# Fish shell
# ─────────────────────────────────────────────

step "Fish"
command -v fish &>/dev/null || brew install fish
info "To set Fish as your system default shell: chsh -s \$(which fish)"
success "Fish ready"

step "Fish config"
FISH_CONFIG="$HOME/.config/fish"
backup_and_prepare "$FISH_CONFIG"
rm -rf "$FISH_CONFIG/functions" "$FISH_CONFIG/conf.d" "$FISH_CONFIG/completions"
rm -f  "$FISH_CONFIG/config.fish" "$FISH_CONFIG/fish_variables" "$FISH_CONFIG/fish_plugins"
mkdir -p "$FISH_CONFIG/functions" "$FISH_CONFIG/conf.d" "$FISH_CONFIG/completions"
download "$DOTFILES/fish/config.fish" "$FISH_CONFIG/config.fish"
success "Fish config installed"

step "Fisher & plugins"
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
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
success "Fisher and all plugins installed"

# ─────────────────────────────────────────────
# Ghostty
# ─────────────────────────────────────────────

step "Ghostty"
if ! command -v ghostty &>/dev/null; then
    if is_macos; then
        brew install --cask ghostty
    else
        echo
        error "Ghostty has no Homebrew cask on Linux."
        info  "Install it manually from: https://ghostty.org/docs/install/binary"
    fi
else
    success "Ghostty already installed"
fi

step "Ghostty config"
GHOSTTY_CONFIG="$HOME/.config/ghostty"
backup_and_prepare "$GHOSTTY_CONFIG"
download "$DOTFILES/ghostty/config.ghostty" "$GHOSTTY_CONFIG/config"

# Set fish as Ghostty's default shell so shell integration is auto-injected.
# Only appended if the config doesn't already define a command.
if ! grep -q "^command" "$GHOSTTY_CONFIG/config" 2>/dev/null; then
    printf "\ncommand = %s\n" "$(which fish)" >> "$GHOSTTY_CONFIG/config"
fi
success "Ghostty config installed (fish set as default shell)"

# ─────────────────────────────────────────────
# Neovim
# ─────────────────────────────────────────────

step "Neovim"
command -v nvim &>/dev/null || brew install neovim
success "Neovim ready"

step "npm & Codicons"
if ! command -v npm &>/dev/null; then
    error "npm is required for Neovim plugins. Install Node.js first, then re-run this script."
    exit 1
fi
npm i --yes @vscode/codicons
success "VS Code Codicons installed"

step "Neovim config"
NVIM_CONFIG="$HOME/.config/nvim"
backup_and_prepare "$NVIM_CONFIG"
download "$DOTFILES/nvim/init.lua" "$NVIM_CONFIG/init.lua"
success "Neovim config installed"

# ─────────────────────────────────────────────
# Python tooling
# ─────────────────────────────────────────────

step "Python tooling (uv, ruff, ty)"
brew install uv ruff ty
success "uv, ruff, and ty installed"

step "Pyright (LSP)"
command -v pyright &>/dev/null || brew install pyright
success "Pyright ready"

# ─────────────────────────────────────────────
# pi coding agent
# ─────────────────────────────────────────────

step "pi coding agent"
npm install --yes -g @mariozechner/pi-coding-agent
success "pi coding agent installed"

step "pi agent config"
PI_CONFIG="$HOME/.pi/agent"
backup_and_prepare "$PI_CONFIG"
PI_TMP=$(mktemp -d)
git clone --depth 1 --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$PI_TMP"
if [ -d "$PI_TMP/.pi/agent" ]; then
    cp -r "$PI_TMP/.pi/agent/." "$PI_CONFIG/"
    success "pi agent config installed"
else
    error "Could not find .pi/agent in dotfiles repo — skipping"
fi
rm -rf "$PI_TMP"

# ─────────────────────────────────────────────

echo
echo "🎉 Setup complete! Restart your terminal to start using Fish."

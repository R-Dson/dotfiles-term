#!/bin/bash

set -e

# ─────────────────────────────────────────────
# Globals
# ─────────────────────────────────────────────

ASSUME_YES=0

DOTFILES="https://raw.githubusercontent.com/R-Dson/dotfiles-term/refs/heads/main-oma"
DOTFILES_REPO="https://github.com/R-Dson/dotfiles-term"
DOTFILES_BRANCH="main-oma"

# ─────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────

usage() {
    cat << EOF
Usage: $0 [-y|-Y|--yes]

Options:
  -y, -Y, --yes    Accept all prompts automatically
  -h, --help       Show this help message
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|-Y|--yes)
                ASSUME_YES=1
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done
}

# ─────────────────────────────────────────────
# Logging
# ─────────────────────────────────────────────

info()    { echo "ℹ️  $*"; }
success() { echo "✅ $*"; }
error()   { echo "❌ $*" >&2; }

step() {
    echo
    echo "── $* ──────────────────────────────"
}

# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

confirm() {
    local prompt="$1"
    local reply

    if [[ "$ASSUME_YES" -eq 1 ]]; then
        info "$prompt: yes"
        return 0
    fi

    while true; do
        read -r -p "$prompt [Y/n] " reply

        case "$reply" in
            ""|y|Y|yes|YES|Yes)
                return 0
                ;;
            n|N|no|NO|No)
                return 1
                ;;
            *)
                info "Please answer yes or no."
                ;;
        esac
    done
}

run_step() {
    local prompt="$1"
    local title="$2"
    local fn="$3"

    if confirm "$prompt"; then
        step "$title"

        if "$fn"; then
            return 0
        else
            error "$title failed or was skipped because a requirement was missing."
            return 0
        fi
    else
        info "Skipped $title"
    fi
}

download() {
    local url="$1"
    local dest="$2"

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

    mkdir -p "$dir" || {
        error "Cannot create directory: $dir"
        exit 1
    }
}

ensure_brew() {
    if command -v brew &>/dev/null; then
        return 0
    fi

    error "Homebrew is required for this step but is not installed."
    info "Run this script again and choose yes for Homebrew, or install Homebrew manually."
    return 1
}

ensure_npm() {
    if command -v npm &>/dev/null; then
        return 0
    fi

    ensure_brew && brew install npm
}

ensure_fish() {
    if command -v fish &>/dev/null; then
        return 0
    fi

    ensure_brew && brew install fish
}

# ─────────────────────────────────────────────
# Setup steps
# ─────────────────────────────────────────────

setup_homebrew() {
    if ! command -v brew &>/dev/null; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        else
            error "Homebrew installed but brew binary not found in expected locations."
            exit 1
        fi
    fi

    success "Homebrew ready"
}

install_fonts() {
    local font_dir="$HOME/.local/share/fonts/AporeticNerdFont"
    local font_tmp

    mkdir -p "$font_dir"

    font_tmp=$(mktemp -d)
    git clone --depth 1 https://github.com/Echinoidea/Aporetic-Nerd-Font "$font_tmp"
    cp "$font_tmp"/*.ttf "$font_dir/"
    rm -rf "$font_tmp"

    if is_macos; then
        mkdir -p "$HOME/Library/Fonts"
        cp "$font_dir"/*.ttf "$HOME/Library/Fonts/" 2>/dev/null || true
    else
        if command -v fc-cache &>/dev/null; then
            fc-cache -f "$font_dir"
        else
            info "fc-cache not found; fonts were copied but cache was not refreshed."
        fi
    fi

    success "Aporetic Nerd Font installed"
}

install_fish() {
    ensure_fish || return 1

    local fish_path
    fish_path="$(command -v fish)"

    if [ -z "$fish_path" ]; then
        error "Fish was installed but could not be found in PATH."
        return 1
    fi

    if ! grep -qx "$fish_path" /etc/shells 2>/dev/null; then
        info "Adding Fish to /etc/shells"
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi

    if [ "$SHELL" != "$fish_path" ]; then
        info "Changing default shell to Fish"
        chsh -s "$fish_path" || {
            error "Could not change default shell automatically."
            info "Run manually: chsh -s $fish_path"
            return 0
        }
    fi

    success "Fish ready and set as default shell"
}

install_fish_config() {
    local fish_config="$HOME/.config/fish"

    backup_and_prepare "$fish_config"

    rm -rf "$fish_config/functions" "$fish_config/conf.d" "$fish_config/completions"
    rm -f  "$fish_config/config.fish" "$fish_config/fish_variables" "$fish_config/fish_plugins"

    mkdir -p "$fish_config/functions" "$fish_config/conf.d" "$fish_config/completions"

    download "$DOTFILES/fish/config.fish" "$fish_config/config.fish"

    success "Fish config installed"
}

install_fisher_plugins() {
    if ! command -v fish &>/dev/null; then
        error "Fish is not installed; skipping Fisher and plugins."
        return 0
    fi

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
}

install_tmux() {
    if ! command -v tmux &>/dev/null; then
        ensure_brew && brew install tmux
    fi

    success "tmux ready"
}

install_tmux_config() {
    local tmux_config="$HOME/.config/tmux"
    local tmux_conf="$tmux_config/tmux.conf"
    local legacy_tmux_conf="$HOME/.tmux.conf"

    backup_and_prepare "$tmux_config"

    download "$DOTFILES/tmux/tmux.conf" "$tmux_conf"

    if command -v fish &>/dev/null; then
        {
            echo
            echo "# Default shell"
            echo "set -g default-shell $(command -v fish)"
            echo "set -g default-command $(command -v fish)"
        } >> "$tmux_conf"

        success "tmux config installed; fish set as tmux default shell"
    else
        success "tmux config installed; fish not found, so tmux default shell was not changed"
    fi

    # Keep compatibility with tmux setups that still read ~/.tmux.conf
    if [ -e "$legacy_tmux_conf" ] || [ -L "$legacy_tmux_conf" ]; then
        cp "$legacy_tmux_conf" "${legacy_tmux_conf}.bak" 2>/dev/null || true
    fi

    ln -sf "$tmux_conf" "$legacy_tmux_conf" 2>/dev/null || cp "$tmux_conf" "$legacy_tmux_conf"
}

install_ghostty() {
    if command -v ghostty &>/dev/null; then
        success "Ghostty already installed"
        return 0
    fi

    if is_macos; then
        ensure_brew && brew install --cask ghostty
        success "Ghostty installed"
    else
        error "Ghostty has no Homebrew cask on Linux."
        info  "Install it manually from: https://ghostty.org/docs/install/binary"
    fi
}

install_ghostty_config() {
    local ghostty_config="$HOME/.config/ghostty"

    backup_and_prepare "$ghostty_config"
    download "$DOTFILES/ghostty/config.ghostty" "$ghostty_config/config"

    if command -v fish &>/dev/null; then
        if ! grep -q "^command" "$ghostty_config/config" 2>/dev/null; then
            printf "\ncommand = %s\n" "$(which fish)" >> "$ghostty_config/config"
        fi

        success "Ghostty config installed; fish set as default shell"
    else
        success "Ghostty config installed; fish not found, so default shell was not changed"
    fi
}

install_vscode_config() {
    local vscode_config

    if is_macos; then
        vscode_config="$HOME/Library/Application Support/Code/User"
    else
        vscode_config="$HOME/.config/Code/User"
    fi

    backup_and_prepare "$vscode_config"
    download "$DOTFILES/Code/User/settings.json" "$vscode_config/settings.json"

    success "VS Code settings installed"
}

install_neovim() {
    if ! command -v nvim &>/dev/null; then
        ensure_brew && brew install neovim
    fi

    success "Neovim ready"
}

install_codicons() {
    ensure_npm

    if command -v npm &>/dev/null; then
        npm i --yes @vscode/codicons
        success "VS Code Codicons installed"
    else
        error "npm is not available; skipping Codicons."
    fi
}

install_neovim_config() {
    local nvim_config="$HOME/.config/nvim"

    backup_and_prepare "$nvim_config"
    download "$DOTFILES/nvim/init.lua" "$nvim_config/init.lua"

    success "Neovim config installed"
}

install_pyright() {
    if ! command -v pyright &>/dev/null; then
        ensure_brew && brew install pyright
    fi

    success "Pyright ready"
}

install_pi_agent() {
    ensure_npm

    if command -v npm &>/dev/null; then
        npm install --yes -g @earendil-works/pi-coding-agent
        success "pi coding agent installed"
    else
        error "npm is not available; skipping pi coding agent."
    fi
}

install_pi_agent_config() {
    local pi_config="$HOME/.pi/agent"
    local pi_tmp

    backup_and_prepare "$pi_config"

    pi_tmp=$(mktemp -d)
    git clone --depth 1 --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" "$pi_tmp"

    if [ -d "$pi_tmp/.pi/agent" ]; then
        cp -r "$pi_tmp/.pi/agent/." "$pi_config/"
        success "pi agent config installed"
    else
        error "Could not find .pi/agent in dotfiles repo — skipping"
    fi

    rm -rf "$pi_tmp"
}

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

main() {
    parse_args "$@"

    run_step "Set up Homebrew?" "Homebrew" setup_homebrew
    run_step "Install Aporetic Nerd Font?" "Fonts" install_fonts

    run_step "Install Fish shell and set as default?" "Fish" install_fish
    run_step "Install Fish config?" "Fish config" install_fish_config
    run_step "Install Fisher and Fish plugins?" "Fisher & plugins" install_fisher_plugins

    run_step "Install tmux?" "tmux" install_tmux
    run_step "Install tmux config?" "tmux config" install_tmux_config

    run_step "Install Ghostty?" "Ghostty" install_ghostty
    run_step "Install Ghostty config?" "Ghostty config" install_ghostty_config

    run_step "Install VS Code config?" "VS Code config" install_vscode_config

    run_step "Install Neovim?" "Neovim" install_neovim
    run_step "Install npm and VS Code Codicons?" "npm & Codicons" install_codicons
    run_step "Install Neovim config?" "Neovim config" install_neovim_config

    run_step "Install Pyright LSP?" "Pyright" install_pyright

    run_step "Install pi coding agent?" "pi coding agent" install_pi_agent
    run_step "Install pi agent config?" "pi agent config" install_pi_agent_config

    echo
    echo "🎉 Setup complete! Restart your terminal to start using Fish."
}

main "$@"

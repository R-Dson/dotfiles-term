# Set locale (must be first to prevent UTF-8 issues)
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Configure Tide prompt (runs once)
if status --is-interactive && not set -q _tide_once
    tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Dark --show_time=No --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Sparse --icons='Few icons' --transient=No
    set -gx _tide_once
end

# Disable fish-async-prompt (causes issues with locale/async loading)
# Set to 1 to enable if your system handles async prompts correctly
set -g async_prompt_enable 0

# Paths
fish_add_path /opt/brew/bin
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH bin $PATH

# Terminal
set -gx TERM xterm-256color

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim
command -qv nvim && alias vim nvim

# Load secret environment variables if they exist
set -l fish_env_file "$HOME/.config/fish/fish_env.fish"
if test -f "$fish_env_file"
    source "$fish_env_file"
end

# Directory name length
set -gx fish_prompt_pwd_dir_length 1

# LS_COLORS for file type colors (Linux)
# Simple format: type=color (e.g., di=01;34 for bold blue directories)
# Attributes: 00=none, 01=bold, 04=underline, 05=blink, 07=reverse
set -gx LS_COLORS "di=01;34:ln=01;36:ex=01;31:su=01;32:pi=40;33:so=01;35:bd=40;33:01;34:cd=40;33:01;34:tw=01;35:ow=01;34:st=01;37:sg=01;30:*.txt=00;32:*.md=00;32"

# Aliases with --color=auto
alias ls "ls --color=auto -p"
alias la "ls -A --color=auto"
alias ll "ls -lah --color=auto"
alias lla "ll -A --color=auto"
alias l "ls --color=auto -CF"
alias grep "grep --color=auto"
alias fgrep "fgrep --color=auto"
alias egrep "egrep --color=auto"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias g git
alias gc "git commit"
alias gs "git status"
alias ga "git add"
alias gp "git push"
alias gl "git pull"
alias gd "git diff"
alias gb "git branch"
alias gco "git checkout"
alias nv "nvim"
alias v "nvim"
alias tmx "tmux -u new"

# fzf key bindings
if type -q fzf
    fzf --fish | source
end

# History
set -gx HISTSIZE 10000
set -gx SAVEHIST 10000

# Less colors
set -gx LESS_TERMCAP_mb (printf "\e[1;31m")
set -gx LESS_TERMCAP_md (printf "\e[1;34m")
set -gx LESS_TERMCAP_me (printf "\e[0m")
set -gx LESS_TERMCAP_so (printf "\e[1;44;33m")
set -gx LESS_TERMCAP_se (printf "\e[0m")
set -gx LESS_TERMCAP_us (printf "\e[1;32m")
set -gx LESS_TERMCAP_ue (printf "\e[0m")

# Prevent macOS from creating .DS_Store files on network volumes
set -gx COPYFILE_DISABLE true

# Auto jump (z) compatibility
set -gx _ZO_DATA_DIR $HOME/.z

# Abbreviation tips settings
set -gx FISH_ABBREVIATION_TIPS_DURATION 5000

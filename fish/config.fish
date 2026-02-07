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

# fzf key bindings
if type -q fzf
    fzf --fish | source
end

# Aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -lah"
alias lla "ll -A"
alias l "ls -CF"
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

# History
set -gx HISTSIZE 10000
set -gx SAVEHIST 10000

# Set locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

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

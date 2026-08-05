# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

# Spaceship theme configuration
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_CHAR_SYMBOL="→ "
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_USER_SHOW=needed
SPACESHIP_HOST_SHOW=false
SPACESHIP_DIR_TRUNC=0
SPACESHIP_GIT_SYMBOL=" "
SPACESHIP_GIT_PREFIX=""
SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_GIT_BRANCH_COLOR="cyan"
SPACESHIP_GIT_STATUS_PREFIX=" ["
SPACESHIP_GIT_STATUS_SUFFIX="]"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history
  dirhistory
  macos
)

source $ZSH/oh-my-zsh.sh

# History
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias twork="$HOME/Dev/dotfiles/tmux-work-setup.sh"
alias tsave="$HOME/Dev/dotfiles/tmux-save.sh"
alias cat='bat --paging=never'

# OpenClaw
alias oc-start="cd ~/openclaw-sandbox && docker compose up -d openclaw-gateway"
alias oc-stop="cd ~/openclaw-sandbox && docker compose down"
alias oc-restart="cd ~/openclaw-sandbox && docker compose restart openclaw-gateway"
alias oc-status="cd ~/openclaw-sandbox && docker compose ps"
alias oc-logs="docker logs -f openclaw-sandbox-openclaw-gateway-1"

# Colors for syntax highlighting (must be set after zsh-syntax-highlighting is loaded)
# Catppuccin Mocha syntax highlighting colors
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  ZSH_HIGHLIGHT_STYLES[default]=none
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=#f38ba8
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=#cba6f7
  ZSH_HIGHLIGHT_STYLES[alias]=fg=#89b4fa
  ZSH_HIGHLIGHT_STYLES[builtin]=fg=#89b4fa
  ZSH_HIGHLIGHT_STYLES[function]=fg=#89b4fa
  ZSH_HIGHLIGHT_STYLES[command]=fg=#89b4fa
  ZSH_HIGHLIGHT_STYLES[precommand]=fg=#a6e3a1,underline
  ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=#f5c2e7
  ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=#89b4fa
  ZSH_HIGHLIGHT_STYLES[path]=fg=#94e2d5,underline
  ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=#94e2d5
  ZSH_HIGHLIGHT_STYLES[globbing]=fg=#f5c2e7
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=#cba6f7
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=#a6e3a1
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=#a6e3a1
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=#f5e0dc
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=#f5e0dc
  ZSH_HIGHLIGHT_STYLES[assign]=fg=#f9e2af
fi

# Show hidden files in auto-complete
setopt globdots

# NOTE: previously a zshexit() hook saved tmux sessions on *every* shell exit,
# which fired constantly (once per command/pane close) and was slow. Removed —
# tmux-continuum's timer + the client-detached hook handle persistence now.
# Use `tsave` to save manually anytime.

eval "$(zoxide init --cmd cd zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%,60%"
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --border --height 60%"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :80 {}' --preview-window=right:50%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -40'"

# nvm
export NVM_DIR="$HOME/.nvm"
# Lazy-load nvm itself only in interactive shells (avoids breaking scripts/CI)
if [[ $- == *i* ]]; then
  _load_nvm() {
    unset -f nvm node npm npx yarn _load_nvm
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  }
  nvm()  { _load_nvm; nvm "$@"; }
  node() { _load_nvm; node "$@"; }
  npm()  { _load_nvm; npm "$@"; }
  npx()  { _load_nvm; npx "$@"; }
  yarn() { _load_nvm; yarn "$@"; }
fi

# Digital Billing Service Environment Variables
export GOPRIVATE="github.com/razorpay/*"
export GOPATH=$HOME/go
export GOOSE_MIGRATION_DIR=internal/database/migrations

# PATH
export PATH="$NVM_DIR/versions/node/v22.22.0/bin:$HOME/Dev/dotfiles/bin:/usr/local/bin:$GOPATH/bin:$HOME/.antigravity/antigravity/bin:$PATH"

# Google Cloud SDK completion
[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
[ -f /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc

# Fix brew completion issues
# Remove broken symlinks before compinit runs
_brew_svc="/opt/homebrew/share/zsh/site-functions/_brew_services"
if [ -L "$_brew_svc" ] && [ ! -f "$_brew_svc" ]; then
  rm -f "$_brew_svc" 2>/dev/null || true
fi
unset _brew_svc
export PATH="$HOME/.local/bin:$PATH"

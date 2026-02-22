# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load 
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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

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

# Terminal color settings
export TERM="xterm-256color"

# Colors for syntax highlighting (must be set after zsh-syntax-highlighting is loaded)
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  ZSH_HIGHLIGHT_STYLES[default]=none
  ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red
  ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[function]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[command]=fg=cyan
  ZSH_HIGHLIGHT_STYLES[precommand]=fg=green
  ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue
  ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=blue
  ZSH_HIGHLIGHT_STYLES[path]=fg=blue
  ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=blue
  ZSH_HIGHLIGHT_STYLES[globbing]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
  ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
  ZSH_HIGHLIGHT_STYLES[assign]=fg=blue
fi

# Show hidden files in auto-complete
setopt globdots

# Function to save tmux sessions when exiting the shell
function zshexit() {
  # Only run if tmux is active
  if [ -n "$TMUX" ]; then
    tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh >/dev/null 2>&1
    echo "Tmux sessions saved on exit!"
  fi
}

eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_TMUX=1
export FZF_TMUX_OPTS="-p 80%,60%"
export FZF_DEFAULT_OPTS="
  --color=bg+:#2e3440,bg:#000000,spinner:#81a1c1,hl:#616e88
  --color=fg:#d8dee9,header:#616e88,info:#81a1c1,pointer:#bf616a
  --color=marker:#a3be8c,fg+:#d8dee9,prompt:#81a1c1,hl+:#81a1c1
  --border --height 60%"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :80 {}' --preview-window=right:50%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -40'"

# nvm — lazy loaded for fast shell startup
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
  unset -f nvm node npm npx yarn
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }
yarn() { _load_nvm; yarn "$@"; }

# Digital Billing Service Environment Variables
export GOPRIVATE="github.com/razorpay/*"
export GOPATH=$HOME/go
export GOOSE_MIGRATION_DIR=internal/database/migrations
export PATH="$HOME/Dev/dotfiles/bin:$PATH"
export PATH=/usr/local/bin:$PATH
export PATH=$GOPATH/bin:$PATH

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Google Cloud SDK completion
[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
[ -f /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ] && source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc

# Fix brew completion issues
# Remove broken symlinks before compinit runs
if [ -L "$(brew --prefix)/share/zsh/site-functions/_brew_services" ]; then
  if [ ! -f "$(brew --prefix)/share/zsh/site-functions/_brew_services" ]; then
    # Symlink is broken, remove it
    rm -f "$(brew --prefix)/share/zsh/site-functions/_brew_services" 2>/dev/null || true
  fi
fi
# Configure compinit to ignore missing files (set before Oh My Zsh loads)
# This is handled by Oh My Zsh, but we can ensure it's set
autoload -Uz compinit
compinit -u 2>/dev/null || true
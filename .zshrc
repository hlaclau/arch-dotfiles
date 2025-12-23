# =============================================================================
#                               PATH CONFIGURATIONS
# =============================================================================

# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then 
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

# Access rust/cargo binaries
export PATH="$HOME/.cargo/bin:$PATH"

# Add Go binaries to PATH
export PATH=$PATH:$HOME/.local/opt/go/bin
export PATH=$PATH:$HOME/go/bin

# Configure pnpm (Linux location)
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Add dotnet tools to path
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Add spicetify to path (if installed)
[ -d "$HOME/.spicetify" ] && export PATH="$PATH:$HOME/.spicetify"

# =============================================================================
#                               SHELL BEHAVIOR
# =============================================================================

# Initialize zsh completion system
autoload -Uz compinit && compinit

# Add git completion to fpath (Arch Linux location)
if [[ -d "/usr/share/zsh/site-functions" ]]; then
  fpath=(/usr/share/zsh/site-functions $fpath)
fi

# Ignore duplicates in history
setopt HIST_IGNORE_ALL_DUPS

# Setup history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt notify

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize zoxide (smart cd)
eval "$(zoxide init zsh)"

# Initialize thefuck
eval $(thefuck --alias)

# Load envman if available
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# =============================================================================
#                               SHELL APPEARANCE
# =============================================================================

ZSH_SYNTAX_HIGHLIGHTING_DIR="$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
if [ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ] && [ -f "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh" ]; then
  source "$ZSH_SYNTAX_HIGHLIGHTING_DIR/zsh-syntax-highlighting.zsh"
  
  # Disable path underline
  (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none
else
  [ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Activate autosuggestions (Arch Linux location)
ZSH_AUTOSUGGESTIONS_DIR="$HOME/.config/zsh/plugins/zsh-autosuggestions"
if [ -d "$ZSH_AUTOSUGGESTIONS_DIR" ] && [ -f "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh" ]; then
  source "$ZSH_AUTOSUGGESTIONS_DIR/zsh-autosuggestions.zsh"
else
  # Fallback to system installation if available
  [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# =============================================================================
#                               FZF CONFIGURATION
# =============================================================================

if command -v fzf >/dev/null 2>&1; then
  # Configure fzf search commands
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  else
    export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*'"
  fi
  
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
  fi
  
  # Source completion
  if [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
  fi
fi

# Configure fzf with catppuccin colors
export FZF_DEFAULT_OPTS=" \
--height 50% \
--layout=default \
--border \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# Configure fzf previews
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
else
  export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"
fi

if command -v eza >/dev/null 2>&1; then
  export FZF_ALT_C_OPTS="--preview 'eza --long --color=always --icons=always --git {} | head -200'"
else
  export FZF_ALT_C_OPTS="--preview 'ls -lah {} | head -200'"
fi

# Configure fzf for tmux
export FZF_TMUX_OPTS=" -p90%,70% "

# Ensure fzf keybindings work properly
# Ctrl+T: file search (fzf-file-widget)
# Ctrl+R: history search reverse (fzf-history-widget)
# Alt+C: directory change (fzf-cd-widget)
if command -v fzf >/dev/null 2>&1 && [ -f /usr/share/fzf/key-bindings.zsh ]; then
fi

# =============================================================================
#                               ALIASES
# =============================================================================

# Modern replacements for standard commands
alias ls="eza --color=always --icons=always -a"
alias ll="eza --long --color=always --icons=always --git -a"
alias cat="bat"
alias cd="z"
alias n="nvim"
alias g="git"
alias vi="nvim"
alias vim="nvim"

# Git related aliases
alias ga="git add ."
alias gst="git status"
alias gs="git switch"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias lg="lazygit"
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

# Function for interactive directory selection with eza
fzf-cd() {
  local dir
  if command -v eza >/dev/null 2>&1; then
    dir=$(eza --tree --level=2 --color=always --icons=always | fzf --ansi --preview 'eza --long --color=always --icons=always {}' | sed 's/.* //')
  else
    dir=$(find . -type d -not -path '*/\.*' | fzf)
  fi
  if [ -n "$dir" ] && [ -d "$dir" ]; then
    cd "$dir"
  fi
}

# Utility aliases
alias cls="clear"
alias h="history 1 | fzf"
alias f="fuck"

# Waybar restart (Arch equivalent of sketchybar)
alias wb="pkill waybar && waybar &"

# source zshrc 
alias reload="source ~/.zshrc"

# Function to open GitHub repo in browser
repo() {
  gh repo view --web
}


# =============================================================================
#                               TMUX AUTO-START
# =============================================================================

# Open tmux by default if available and not already in tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [[ $- == *i* ]]; then
  # Try to attach to existing default session, or create new one
  tmux new-session -A -s default
fi

# =============================================================================
#                               FASTFETCH DISPLAY
# =============================================================================

# Show fastfetch only in interactive shells that are not inside tmux
if [[ $- == *i* ]] && [ -z "$TMUX" ]; then
  fastfetch
fi

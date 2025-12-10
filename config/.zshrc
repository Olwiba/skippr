# Skippr zsh configuration - minimal and fast

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Enable colors
autoload -U colors && colors

# Minimal, fast prompt showing current directory and git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' [%b]'
setopt PROMPT_SUBST
PROMPT='%F{green}%n@skippr%f:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f
%F{cyan}$%f '

# Basic completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Environment
export ENV="skippr"

# Path additions
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Claude Code alias  
alias claude='claude'

# ==========================================
# MOBILE SHORTCUTS (type these at prompt)
# ==========================================

# TMUX - Windows & Panes
alias th='tmux split-window -h'           # split horizontal
alias tv='tmux split-window -v'           # split vertical  
alias tw='tmux new-window'                # new window
alias tn='tmux next-window'               # next window
alias tp='tmux previous-window'           # prev window
alias tl='tmux list-sessions'             # list sessions
alias ta='tmux attach'                    # attach

# TMUX - Send keys to current pane (for running processes)
alias kc='tmux send-keys C-c'             # Ctrl+C (interrupt)
alias kd='tmux send-keys C-d'             # Ctrl+D (EOF)
alias kz='tmux send-keys C-z'             # Ctrl+Z (suspend)
alias ke='tmux send-keys Escape'          # Escape
alias kt='tmux send-keys Tab'             # Tab

# Clear screen
alias xx='clear'

# Show mobile help
alias hh='echo "
  ┌─────────────────────────────────────────┐
  │  SKIPPR MOBILE COMMANDS                 │
  ├─────────────────────────────────────────┤
  │  SEND KEYS (to running process):        │
  │    kc = Ctrl+C    kd = Ctrl+D           │
  │    kz = Ctrl+Z    ke = Escape           │
  │    kt = Tab                             │
  ├─────────────────────────────────────────┤
  │  TMUX:                                  │
  │    th = split horizontal                │
  │    tv = split vertical                  │
  │    tw = new window                      │
  │    tn = next window                     │
  │    tp = prev window                     │
  ├─────────────────────────────────────────┤
  │  VIM (in insert mode):                  │
  │    jj or kk or jk = Escape              │
  ├─────────────────────────────────────────┤
  │  OTHER:                                 │
  │    xx = clear    hh = this help         │
  │    mm = about                           │
  └─────────────────────────────────────────┘
"'

# Show about/tugboat
alias mm='echo "
            ~  ~
       ~~~~     ~~~~
          |\\
          | \\
          |S \\
     _____|   \\____
    |             |_____
    | ○  SKIPPR   |     |~~
    |_____________|_____|
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~

           v0.0.1

    Mobile Dev Environment
"'

# Environment message on login
if [[ -o interactive ]]; then
    echo ""
    echo "  ┌───────────────────────────────────────┐"
    echo "  │  SKIPPR - Mobile Dev Environment      │"
    echo "  │                                       │"
    echo "  │  Type: hh = help   mm = about         │"
    echo "  │                                       │"
    echo "  │  kc=^C  kd=^D  ke=Esc  th=split      │"
    echo "  │  vim: jj or kk = Escape               │"
    echo "  └───────────────────────────────────────┘"
    echo ""
fi

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
  │  ANYWHERE (qq + letter):                │
  │    qqe = Escape   qqc = Ctrl+C          │
  │    qqd = Ctrl+D   qqz = Ctrl+Z          │
  │    qqt = Tab      qql = Clear           │
  │    qqa = Line start  qqf = Line end     │
  │    qqr = Search history                 │
  │    qq? = Help popup                     │
  ├─────────────────────────────────────────┤
  │  TMUX (qq + letter):                    │
  │    qqh = split horizontal               │
  │    qqv = split vertical                 │
  │    qqw = new window                     │
  │    qqn = next window                    │
  │    qqp = prev window                    │
  ├─────────────────────────────────────────┤
  │  VIM (in insert mode):                  │
  │    jj or kk or jk = Escape              │
  ├─────────────────────────────────────────┤
  │  AT PROMPT:                             │
  │    hh = this help    mm = about         │
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
    echo "  │  Anywhere: qq + letter                │"
    echo "  │    qqe=Esc qqc=^C qqd=^D qq?=help    │"
    echo "  │                                       │"
    echo "  │  In vim: jj or kk = Escape            │"
    echo "  │  At prompt: hh=help  mm=about         │"
    echo "  └───────────────────────────────────────┘"
    echo ""
fi

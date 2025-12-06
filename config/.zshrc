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

# Path additions
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Quick tmux aliases
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias tn='tmux new-session -s'

# Claude Code alias
alias cc='claude-code'

# Environment message on login
if [[ -o interactive ]]; then
    echo "Welcome to Skippr - your mobile dev environment"
    echo "Tip: Use 'C-a |' for horizontal split, 'C-a -' for vertical split"
fi

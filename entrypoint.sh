#!/bin/bash
set -e

# Ensure directories exist (volumes may be empty on first run)
mkdir -p ~/projects ~/.claude

# Configure git from environment variables
if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi
if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

# Dracula theme for ttyd
THEME='{"background":"#282a36","foreground":"#f8f8f2","cursor":"#f8f8f2","selectionBackground":"#44475a","black":"#21222c","red":"#ff5555","green":"#50fa7b","yellow":"#f1fa8c","blue":"#bd93f9","magenta":"#ff79c6","cyan":"#8be9fd","white":"#f8f8f2"}'

# Start nginx for mobile keyboard overlay (runs in background)
echo "Starting nginx on port 8080"
nginx -c /etc/nginx/nginx.conf &

# Start ttyd web terminal (runs in foreground, proxied by nginx at /terminal/)
echo "Starting ttyd web terminal on port 7681"
exec ttyd -p 7681 -W \
  -t fontSize=16 \
  -t fontFamily="Menlo, Monaco, Consolas, monospace" \
  -t "theme=${THEME}" \
  /bin/zsh -c 'tmux attach || tmux new-session'

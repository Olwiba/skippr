#!/bin/bash
set -e

# Start ttyd web terminal
# Authentication is handled by Coolify/Traefik at the reverse proxy level
echo "Starting ttyd web terminal on port 7681"
exec ttyd -p 7681 -W /bin/zsh -c 'tmux attach || tmux new-session'

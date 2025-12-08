#!/bin/bash
set -e

# Build ttyd command
TTYD_CMD="ttyd -p 7681 -W"

# Add basic auth if credentials are provided
if [ -n "$TTYD_USERNAME" ] && [ -n "$TTYD_PASSWORD" ]; then
    echo "Starting ttyd with authentication enabled"
    TTYD_CMD="$TTYD_CMD -c $TTYD_USERNAME:$TTYD_PASSWORD"
else
    echo "WARNING: Starting ttyd without authentication (not recommended for production)"
fi

# Add the shell command
TTYD_CMD="$TTYD_CMD /bin/zsh -c 'tmux attach || tmux new-session'"

# Execute ttyd
eval $TTYD_CMD

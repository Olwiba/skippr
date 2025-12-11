#!/bin/bash
set -e

# =============================================================================
# EXTRA_PACKAGES: Install additional system packages at runtime
# Set via environment variable, comma or space separated
# Example: EXTRA_PACKAGES="chromium-browser,ffmpeg,imagemagick"
# =============================================================================
if [ -n "$EXTRA_PACKAGES" ]; then
    echo "Installing extra packages: $EXTRA_PACKAGES"
    # Convert commas to spaces
    PACKAGES=$(echo "$EXTRA_PACKAGES" | tr ',' ' ')
    apt-get update
    for pkg in $PACKAGES; do
        if apt-get install -y "$pkg" 2>&1; then
            echo "✓ Installed: $pkg"
        else
            echo "✗ Failed to install: $pkg (skipping)"
        fi
    done
    rm -rf /var/lib/apt/lists/*
    
    # Set Puppeteer to use system Chromium if installed
    if command -v chromium-browser &> /dev/null; then
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
        export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
    fi
fi

# =============================================================================
# Run remaining setup as dev user
# =============================================================================
setup_user() {
    # Ensure directories exist (volumes may be empty on first run)
    mkdir -p ~/projects ~/.claude

    # Deploy config files from /etc/skel (updates on each deploy)
    cp /etc/skel/.tmux.conf ~/.tmux.conf
    cp /etc/skel/.zshrc ~/.zshrc
    cp /etc/skel/.vimrc ~/.vimrc

    # Configure git from environment variables
    if [ -n "$GIT_USER_NAME" ]; then
        git config --global user.name "$GIT_USER_NAME"
    fi
    if [ -n "$GIT_USER_EMAIL" ]; then
        git config --global user.email "$GIT_USER_EMAIL"
    fi
}

# Export function and run as dev user
export -f setup_user
export GIT_USER_NAME GIT_USER_EMAIL
gosu dev bash -c "setup_user"

# Dracula theme for ttyd
THEME='{"background":"#282a36","foreground":"#f8f8f2","cursor":"#f8f8f2","selectionBackground":"#44475a","black":"#21222c","red":"#ff5555","green":"#50fa7b","yellow":"#f1fa8c","blue":"#bd93f9","magenta":"#ff79c6","cyan":"#8be9fd","white":"#f8f8f2"}'

# Start ttyd web terminal as dev user
echo "Starting ttyd web terminal on port 7681"
exec gosu dev ttyd -p 7681 -W \
  -t fontSize=16 \
  -t fontFamily="Menlo, Monaco, Consolas, monospace" \
  -t "theme=${THEME}" \
  /bin/zsh -c 'tmux attach || tmux new-session'

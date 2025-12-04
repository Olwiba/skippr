FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    tmux \
    zsh \
    build-essential \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash \
    && ln -s /root/.bun/bin/bun /usr/local/bin/bun

# Install ttyd for web terminal
RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

# Create non-root user
RUN useradd -m -s /bin/zsh dev \
    && mkdir -p /home/dev/projects \
    && mkdir -p /home/dev/.claude \
    && chown -R dev:dev /home/dev

# Switch to dev user
USER dev
WORKDIR /home/dev

# Install Bun for dev user
RUN curl -fsSL https://bun.sh/install | bash

# Add Bun to PATH for dev user
ENV BUN_INSTALL="/home/dev/.bun"
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Copy configuration files
COPY --chown=dev:dev config/.tmux.conf /home/dev/.tmux.conf
COPY --chown=dev:dev config/.zshrc /home/dev/.zshrc

# Set working directory to projects
WORKDIR /home/dev/projects

# Expose ttyd port
EXPOSE 7681

# Start ttyd with tmux
# If tmux session exists, attach to it; otherwise create new session
CMD ["ttyd", "-p", "7681", "-W", "/bin/zsh", "-c", "tmux attach || tmux new-session"]

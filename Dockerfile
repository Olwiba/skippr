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
    vim \
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

# Install ttyd for web terminal (ARM64 version)
RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.aarch64 \
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

# Configure npm to use user-local directory for global packages
RUN mkdir -p /home/dev/.npm-global \
    && npm config set prefix '/home/dev/.npm-global'

# Add npm global bin to PATH
ENV PATH="/home/dev/.npm-global/bin:${PATH}"

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Copy configuration files to /etc/skel (entrypoint will deploy to home)
COPY config/.tmux.conf /etc/skel/.tmux.conf
COPY config/.zshrc /etc/skel/.zshrc
COPY config/.vimrc /etc/skel/.vimrc

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Set working directory to projects
WORKDIR /home/dev/projects

# Expose ttyd port
EXPOSE 7681

# Use entrypoint script to start ttyd with optional authentication
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

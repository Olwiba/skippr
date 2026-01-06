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
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Bun globally (with retry for flaky GitHub)
RUN for i in 1 2 3 4 5; do \
        curl -fsSL https://bun.sh/install | bash && break || sleep 10; \
    done && \
    ln -sf /root/.bun/bin/bun /usr/local/bin/bun

# Install ttyd for web terminal (auto-detect architecture)
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
        x86_64)  TTYD_ARCH="x86_64" ;; \
        aarch64) TTYD_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    wget -qO /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.${TTYD_ARCH}" && \
    chmod +x /usr/local/bin/ttyd

# Create non-root user with npm-global setup
RUN useradd -m -s /bin/zsh dev \
    && mkdir -p /home/dev/projects \
    && mkdir -p /home/dev/.claude \
    && mkdir -p /home/dev/.npm-global \
    && chown -R dev:dev /home/dev

# Configure npm prefix for dev user (allows global installs without root)
RUN su - dev -c "npm config set prefix '/home/dev/.npm-global'"

# Add npm global bin to PATH
ENV PATH="/home/dev/.npm-global/bin:${PATH}"

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Copy configuration files to /etc/skel (entrypoint will deploy to home)
COPY config/.tmux.conf /etc/skel/.tmux.conf
COPY config/.zshrc /etc/skel/.zshrc
COPY config/.vimrc /etc/skel/.vimrc

# Copy ralph scripts (agentic coding)
COPY --chmod=755 ralph/ralph /usr/local/bin/ralph
COPY --chmod=755 ralph/ralph-once /usr/local/bin/ralph-once
COPY --chmod=755 ralph/ralph-init /usr/local/bin/ralph-init

# Copy entrypoint script
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Set working directory to projects
WORKDIR /home/dev/projects

# Expose ttyd port
EXPOSE 7681

# Use entrypoint script to start ttyd with optional authentication
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

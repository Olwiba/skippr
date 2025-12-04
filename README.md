# Skippr

A self-hosted Docker-based development environment for remote mobile coding from anywhere.

## What is Skippr?

Skippr is a containerized development environment that runs on your server and provides a web-based terminal accessible from anywhere. It's designed for coding on mobile devices, with all the tools you need to build, test, and deploy applications using Claude Code.

The workflow is simple:
1. Access your Skippr instance via a web browser on your phone
2. Use tmux to create split panes - one for Claude Code, one for your dev server
3. Code with Claude, see changes in real-time via Tailscale-exposed dev servers
4. Commit and push to trigger Coolify deployments

## Architecture

Skippr runs as a single Docker container within a Coolify project. It doesn't manage databases - those are handled by Coolify separately. Your Skippr container connects to databases via environment variables.

The container includes:
- **ttyd** - Web terminal accessible on port 7681
- **tmux** - Session persistence and split panes (mobile-optimized)
- **Claude Code CLI** - AI-powered development assistant
- **Node.js 22** - Latest LTS
- **Bun** - Fast JavaScript runtime and package manager
- **Git, zsh** - Standard development tools

Projects live in `~/projects/` on a persistent volume, and your Claude Code config is stored in `~/.claude/` (also persistent).

## Coolify Deployment

### 1. Create a New Service in Coolify

1. In your Coolify dashboard, create a new **Docker Compose** service
2. Point it to this repository
3. Coolify will use the `docker-compose.yml` file automatically

### 2. Configure Environment Variables

Set these in Coolify's environment variable section:

```bash
# Required: Your Anthropic API key
ANTHROPIC_API_KEY=sk-ant-your-key-here

# Example: Connection string to a Coolify-managed Postgres database
# Replace with your actual database service name and credentials
DATABASE_URL=postgresql://user:password@postgres-service:5432/dbname

# Optional: Set your timezone
TZ=America/New_York
```

### 3. Deploy

Deploy the service. Coolify will:
- Build the Docker image
- Create persistent volumes for `~/projects` and `~/.claude`
- Start the container
- Expose port 7681

### 4. Access Your Environment

Coolify will provide a URL to access ttyd. Open it in your mobile browser and you'll land in a zsh shell inside a tmux session.

## Setting Up Tailscale for Dev Server Access

To access hot-reloading dev servers (like `bun dev` running on port 3000) from your phone:

1. **Install Tailscale in your Skippr container** (run inside the container):
   ```bash
   curl -fsSL https://tailscale.com/install.sh | sh
   sudo tailscale up
   ```

2. **Enable Tailscale Serve** to expose a dev server:
   ```bash
   # If your dev server runs on port 3000
   tailscale serve https / http://127.0.0.1:3000
   ```

3. **Access from your phone**:
   - Install Tailscale on your phone and join the same network
   - Visit `https://skippr.yourtailnet.ts.net` (or whatever hostname Tailscale assigns)

This gives you instant access to your hot-reloading dev server without exposing it to the public internet.

## Basic Usage

### Starting a New Project

1. Connect to your Skippr instance
2. Create a new project directory:
   ```bash
   cd ~/projects
   mkdir my-app
   cd my-app
   ```

3. Initialize your project:
   ```bash
   bun init
   # or
   npm init -y
   ```

### Typical Coding Session

1. **Create a horizontal split in tmux**:
   - Press `C-a` then `|` (that's Ctrl+A, release, then Shift+Backslash)

2. **In the left pane, start your dev server**:
   ```bash
   bun dev
   # or
   npm run dev
   ```

3. **In the right pane, start Claude Code**:
   ```bash
   claude-code
   # or use the alias
   cc
   ```

4. **Code with Claude**, see changes in real-time via Tailscale

5. **Commit and push** when ready:
   ```bash
   git add .
   git commit -m "feature: add new component"
   git push
   ```

This triggers Coolify to deploy your changes.

### Navigating Tmux (Mobile-Friendly)

Prefix is `C-a` (Ctrl+A):

| Command | Action |
|---------|--------|
| `C-a \|` | Split horizontally (side by side) |
| `C-a -` | Split vertically (stacked) |
| `C-a h/j/k/l` | Navigate panes (left/down/up/right) |
| `C-a c` | Create new window |
| `C-a n` | Next window |
| `C-a p` | Previous window |
| `C-a d` | Detach (session keeps running) |
| `C-a [` | Enter scroll mode (q to exit) |
| `C-a r` | Reload tmux config |

**Mouse support is enabled** - you can tap to switch panes and scroll with your finger.

## Connecting to Coolify-Managed Databases

Your Coolify-managed Postgres (or other databases) can be accessed via the `DATABASE_URL` environment variable:

```javascript
// Example with Drizzle ORM
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

const connectionString = process.env.DATABASE_URL;
const client = postgres(connectionString);
const db = drizzle(client);
```

The format is:
```
postgresql://username:password@service-name:5432/database-name
```

Where `service-name` is the name of your Postgres service in Coolify (usually something like `postgres-xyz123`).

## Project Structure

```
skippr/
├── Dockerfile              # Ubuntu 24.04 with Node, Bun, Claude Code, ttyd
├── docker-compose.yml      # Coolify-compatible compose file
├── config/
│   ├── .tmux.conf          # Mobile-friendly tmux config
│   └── .zshrc              # Minimal zsh config with aliases
└── README.md               # This file
```

## Tips

- **Authentication**: The first time you run `claude-code`, you'll be prompted to authenticate with Anthropic
- **Session persistence**: tmux sessions persist even if you close your browser. Run `tmux attach` to reconnect
- **Quick git**: Use aliases `gs` (status), `ga` (add), `gc` (commit), `gp` (push), `gl` (log)
- **Multiple projects**: All projects share the same container - just `cd` between them
- **Port conflicts**: If running multiple dev servers, they'll use different ports - expose each via Tailscale Serve

## Why "Skippr"?

Because you're skipping the overhead of local development and jumping straight into coding from anywhere.

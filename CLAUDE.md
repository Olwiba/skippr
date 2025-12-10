# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is Skippr?

Skippr is a self-hosted Docker-based development environment designed for remote mobile coding from anywhere. It provides a complete dev environment accessible via web terminal (ttyd), running on a server managed by Coolify.

## Project Architecture

### Container Design

Skippr runs as a single Docker container with:
- **Base**: Ubuntu 24.04
- **Runtime**: Node.js 22 LTS + Bun (latest)
- **CLI Tools**: Claude Code CLI, Git, tmux, zsh
- **Web Terminal**: ttyd (port 7681)
- **User**: Non-root user "dev" with home at `/home/dev`

### Data Persistence

Separate volumes for each persistent path (allows config updates on redeploy):
- `~/projects/` - All user projects
- `~/.claude/` - Claude Code auth and configuration
- `~/.zsh_history` - Command history

Git config is set via environment variables. SSH keys are managed via Coolify.

### External Dependencies

Databases (Postgres, etc.) are **not** managed by Skippr - they're separate Coolify services. Each project inside `~/projects/` configures its own database connection via project-level `.env` files.

## Development Commands

### Building and Running

```bash
# Build the Docker image
docker build -t skippr .

# Run with docker-compose (for local testing)
docker-compose up

# Access the web terminal
# Navigate to http://localhost:7681
```

### Testing Configuration Changes

When modifying config files:

```bash
# Test tmux config
tmux source-file config/.tmux.conf

# Test zsh config
source config/.zshrc

# Rebuild image after changes
docker-compose up --build
```

## Configuration Philosophy

### Tmux (.tmux.conf)
- **Mouse support**: Enabled for touch interaction
- **Large history**: 100k lines for deep scrollback
- **Minimal status bar**: Shows session, time, date
- **Mobile**: Use shell aliases (`th`, `tv`, `kc`, etc.) instead of keybindings

### Zsh (.zshrc)
- **Minimal and fast**: No heavy frameworks (Oh My Zsh, etc.)
- **Git-aware prompt**: Shows current branch when in a repo
- **Aliases**: Common git commands and tmux shortcuts
- **Path**: Includes Bun and npm global bins

## Typical Workflow

Users typically:
1. Access Skippr via browser on mobile device
2. Create tmux split panes (one for dev server, one for Claude Code)
3. Run dev server (e.g., `bun dev`) in one pane
4. Run `claude-code` in another pane for AI-assisted development
5. Access hot-reloading dev servers via Tailscale
6. Commit/push changes to trigger Coolify deployments

## Code Style

- **Functional patterns** where applicable
- **Explicit over implicit**: Clear configuration with comments
- **Minimal configs**: Only include what's needed, no bloat

## Mobile Commands (Gboard optimized)

Uses shell aliases - just type the command at the prompt. Reliable and simple!

**Send keys to running process:**
| Alias | Sends |
|-------|-------|
| `kc` | Ctrl+C (interrupt) |
| `kd` | Ctrl+D (EOF/exit) |
| `kz` | Ctrl+Z (suspend) |
| `ke` | Escape |
| `kt` | Tab |

**Tmux:**
| Alias | Action |
|-------|--------|
| `th` | Split horizontal |
| `tv` | Split vertical |
| `tw` | New window |
| `tn` | Next window |
| `tp` | Prev window |

**Vim (in insert mode):**
| Keys | Action |
|------|--------|
| `jj` | Escape |
| `kk` | Escape |
| `jk` | Escape |

**Other:**
| Alias | Action |
|-------|--------|
| `xx` | Clear screen |
| `hh` | Show help |
| `mm` | Show tugboat/version |

## Important Notes

- Never install databases in the container - they're external Coolify services
- ttyd starts automatically via entrypoint.sh
- tmux auto-attaches if session exists, otherwise creates new
- All configs optimized for mobile keyboards (C-a prefix, special bindings)
- Keep the image lean - only install necessary tools

## File Structure

```
skippr/
├── Dockerfile              # Container definition
├── docker-compose.yml      # Coolify deployment config
├── entrypoint.sh           # Container startup script
├── config/
│   ├── .tmux.conf          # Tmux configuration (includes mobile bindings)
│   └── .zshrc              # Zsh configuration
├── CLAUDE.md               # This file
└── README.md               # User-facing documentation
```

## Environment Variables

### Skippr Container Level (set in Coolify)
- `ANTHROPIC_API_KEY` - Optional: For Claude Code API auth (can use browser auth instead)
- `TZ` - Optional: Timezone setting (defaults to UTC)
- `GIT_USER_NAME` - Git commit author name
- `GIT_USER_EMAIL` - Git commit author email

### Project Level (set in each project's .env file)
Database connections are configured per-project, not at the container level:
```bash
# Example: ~/projects/my-app/.env
DATABASE_URL=postgresql://user:password@postgres-xyz123:5432/myapp
```

Where `postgres-xyz123` is the name of a separate Postgres service in Coolify.

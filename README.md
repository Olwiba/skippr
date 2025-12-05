![Skippr Banner](images/skippr.0.0.1.png)

# Skippr

**A self-hosted Docker-based development environment for coding from anywhere, on any device.**

Skippr gives you a full-featured terminal accessible from your browser, optimized for mobile development with Claude Code. Deploy once, code from your phone, tablet, or any browser.

---

## What's Included

- **ttyd** - Web-based terminal (port 7681)
- **tmux** - Session persistence with mobile-friendly shortcuts
- **Claude Code CLI** - AI-powered development assistant
- **Node.js 22 LTS** + **Bun** - Modern JavaScript runtimes
- **Git** + **zsh** - Essential development tools
- **Persistent storage** - Projects and config survive restarts

---

## Quick Start

### 1. Fork & Deploy

1. **Fork this repository** to your GitHub account

2. **Create a new service in Coolify**:
   - Type: Docker Compose
   - Source: Your forked repository
   - Coolify will automatically use `docker-compose.yml`

3. **Set environment variables** in Coolify:
   ```bash
   ANTHROPIC_API_KEY=sk-ant-your-key-here
   TZ=America/New_York  # Optional
   ```

4. **Deploy** 🚀

Coolify will build the container and provide you with a URL like `https://skippr.yourdomain.com`.

### 2. First Login

Open the URL in your browser. You'll land in a zsh shell inside a tmux session.

**Authenticate Claude Code**:
```bash
claude-code
```

Follow the prompts to authenticate with your Anthropic account. This only needs to be done once.

### 3. Start Coding

**Create a new project**:
```bash
cd ~/projects
git clone https://github.com/you/your-project
cd your-project
```

**Create a tmux split** (Ctrl+A, then |):
```bash
# Left pane: Start your dev server
bun dev

# Right pane: Start Claude Code
claude-code
```

---

## Accessing Dev Servers with Tailscale

By default, your dev servers (like `bun dev` on port 3000) are only accessible inside the container. Use Tailscale to securely access them from your phone.

### Setup Steps

**1. Install Tailscale in the Skippr container**:
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

**2. Expose your dev server**:
```bash
# If running on port 3000
tailscale serve https / http://127.0.0.1:3000
```

**3. Access from your device**:
- Install Tailscale on your phone
- Join the same Tailnet
- Visit `https://skippr.yourtailnet.ts.net`

Now you can see your hot-reloading changes in real-time while coding on your phone.

---

## Database Connections

Databases are managed separately in Coolify. Each project configures its own connection:

**Example Coolify project structure**:
```
your-coolify-project/
├── postgres-app1
├── postgres-app2
├── postgres-app3
└── skippr
```

**Configure per-project** by creating `.env` files:
```bash
# ~/projects/my-app/.env
DATABASE_URL=postgresql://user:password@postgres-app1:5432/myapp
```

Then use it in your code:
```javascript
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';

const client = postgres(process.env.DATABASE_URL);
const db = drizzle(client);
```

---

## Tmux Quick Reference

Prefix: `Ctrl+A` (easier than `Ctrl+B` on mobile)

| Command | Action |
|---------|--------|
| `Ctrl+A` then `\|` | Split horizontally |
| `Ctrl+A` then `-` | Split vertically |
| `Ctrl+A` then `h/j/k/l` | Navigate panes |
| `Ctrl+A` then `c` | New window |
| `Ctrl+A` then `d` | Detach (keeps running) |
| `Ctrl+A` then `[` | Scroll mode (q to exit) |

**Mouse support enabled** - tap to switch panes, scroll with your finger.

---

## Project Structure

```
skippr/
├── Dockerfile              # Ubuntu 24.04 + Node 22 + Bun + tools
├── docker-compose.yml      # Coolify deployment config
├── .env.example            # Environment variable template
├── config/
│   ├── .tmux.conf          # Mobile-optimized tmux config
│   └── .zshrc              # Minimal zsh with git-aware prompt
├── images/
│   └── skippr.0.0.1.png    # Banner image
├── CLAUDE.md               # Instructions for Claude Code
└── README.md               # This file
```

---

## Tips

- **Session persistence**: Close your browser anytime. Run `tmux attach` to reconnect to your session.
- **Git aliases**: Use `gs` (status), `ga` (add), `gc` (commit), `gp` (push), `gl` (log)
- **Multiple projects**: All projects share the same container - just `cd` between them
- **Claude Code alias**: Type `cc` instead of `claude-code`

---

## Why "Skippr"?

Skip the overhead of local development. Jump straight into coding from anywhere.

---

## License

MIT

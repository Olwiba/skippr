![Skippr Banner](images/skippr.0.0.1.png)

# Skippr

**A self-hosted development environment for coding from anywhere, on any device.**

Skippr gives you a full-featured terminal accessible from your browser. Deploy once, code from your phone, tablet, or any browser.

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

3. **Set environment variables** in Coolify (all optional):
   ```bash
   # Claude Code API key (or authenticate via browser)
   ANTHROPIC_API_KEY=sk-ant-your-key-here

   # Timezone
   TZ=America/New_York
   ```

4. **Deploy** 🚀

Coolify will build the container and provide you with a URL like `https://skippr.yourdomain.com`.

### 2. First Login

Open the URL in your browser. You'll land in a zsh shell inside a tmux session.

**Authenticate Claude Code**:
```bash
claude
```

Follow the browser authentication prompts (uses your Claude.ai Pro plan). This only needs to be done once - credentials persist in the `~/.claude` volume.

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
claude
```

---

## Security Setup (Recommended)

For production use, secure Skippr with Tailscale - no public exposure needed.

### 1. Install Tailscale on Your Coolify Server

SSH into your server (or use Coolify's web terminal) and run:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
tailscale ip -4   # Note this IP (e.g., 100.x.x.x)
```

### 2. Install Tailscale on Your Mobile Device

1. Download Tailscale from App Store / Play Store
2. Sign in with the same account
3. Both devices are now on the same private network

### 3. Configure Skippr in Coolify

- **Disable or remove the public domain** for Skippr (Configuration → Domains)
- Keep the container running - it's now only accessible via Tailscale

### 4. Access Skippr

Open in your mobile browser: `http://100.x.x.x:7681` (your server's Tailscale IP)

That's it! Tailscale handles encryption and authentication. No public exposure, no passwords to remember.

---

## Accessing Dev Servers

When running dev servers in Skippr (e.g., `bun dev` on port 3000), access them via:

1. **Tailscale VPN** - Your mobile device and Coolify server on same network
2. **Direct IP access** - `http://[server-tailscale-ip]:3000`

Your hot-reload changes appear instantly while coding from your phone!

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

## License

MIT

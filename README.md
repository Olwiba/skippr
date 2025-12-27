![Skippr Banner](images/skippr.0.0.2.png)

# Skippr

**A self-hosted development environment for coding from anywhere, on any device.**

Skippr gives you a full-featured terminal accessible from your browser.  
Deploy once, code from your phone, tablet, or any browser.

## What's Included

| Tool | Purpose |
|------|---------|
| **Ubuntu 24.04** | Base image |
| **ttyd** | Web-based terminal (port 7681) |
| **tmux** | Session persistence + mobile shortcuts |
| **zsh** | Shell with git-aware prompt |
| **Node.js 22 LTS** | JavaScript runtime |
| **Bun** | Fast JS runtime & package manager |
| **Claude Code CLI** | AI-powered development |
| **Git** | Version control |
| **GitHub CLI** | `gh` for repo management |
| **vim** | Text editor with mobile bindings |

## How It Works

1. **Deploy** via Docker or Coolify (uses `docker-compose.yml`)
2. **Access** the web terminal at `http://your-server:7681`
3. **Land** in a zsh shell inside a tmux session
4. **Code** using Claude Code, your dev server, or any CLI tools

The entire `/home/dev` directory persists across restarts - projects, config, and Claude auth all survive redeployments.

> [!TIP]
> For secure remote access, expose Skippr via [Tailscale](https://tailscale.com) rather than a public domain. No auth config needed—just access it from your tailnet.

### Environment Variables (optional)

```bash
TZ=America/New_York        # Timezone
GIT_USER_NAME=Your Name    # Git commit author
GIT_USER_EMAIL=you@ex.com  # Git commit email
EXTRA_PACKAGES=htop,curl   # Additional apt packages to install
```

## Mobile Commands

Type `hh` at the prompt for a quick reference, or `qqx` anywhere for a popup.

<details>
<summary><strong>Anywhere: <code>qq</code> + letter</strong></summary>

Works inside ANY program (vim, claude, node, etc.) - these are tmux bindings.

| Keys | Action |
|------|--------|
| `qqe` | Escape |
| `qqc` | Ctrl+C |
| `qqd` | Ctrl+D |
| `qqz` | Ctrl+Z |
| `qqt` | Tab |
| `qqa` | Start of line (Ctrl+A) |
| `qqf` | End of line (Ctrl+E) |
| `qqr` | Reverse search history (Ctrl+R) |
| `qql` | Clear screen |
| `qqs` | Fix glitched screen |
| `qqq` | Literal 'q' |

</details>

<details>
<summary><strong>Tmux: <code>qq</code> + letter</strong></summary>

| Keys | Action |
|------|--------|
| `qqh` | Split pane horizontal |
| `qqv` | Split pane vertical |
| `qqw` | New window |
| `qqn` | Next window |
| `qqp` | Previous window |
| `qqx` | Help popup |
| `qqm` | About/tugboat |

</details>

<details>
<summary><strong>Vim (insert mode)</strong></summary>

| Keys | Action |
|------|--------|
| `jj` | Escape |
| `kk` | Escape |
| `jk` | Escape |

</details>

<details>
<summary><strong>Shell Aliases</strong></summary>

| Alias | Action |
|-------|--------|
| `hh` | Show help |
| `mm` | Show about |
| `th` / `tv` | Split horizontal / vertical |
| `tw` | New tmux window |
| `tn` / `tp` | Next / previous window |

</details>

## License

MIT - for the love of OSS 💖.

---

[Changelog](CHANGELOG.md)
[Buy me a coffee](https://buymeacoffee.com/olwiba)

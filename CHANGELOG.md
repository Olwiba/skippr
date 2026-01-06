# Changelog

## v0.0.3

### New Features
- **Ralph** - Agentic coding system built-in
  - Iteratively works through PRD tasks using Claude Code
  - Auto-detects CI commands (pnpm/npm/bun/yarn/pytest/cargo/go)
  - `ralph init` scaffolds project with PRD template
  - `ralph <n>` runs n iterations, `ralph-once` for single pass
  - `ralph status` shows PRD completion progress
  - Short aliases: `r`, `ro`, `ri`, `rs`

---

## v0.0.2

### Security
- Added `no-new-privileges` and capability restrictions to container
- Lock down `/var/tmp` permissions on startup
- Fix `.cache` directory permissions (prevent world-writable)

### Improvements
- ttyd now auto-detects architecture (x86_64/aarch64)
- Resilient tmux session handling (attach-or-create with fallback)
- Added git aliases (st, co, br, cm, ca, aa, df, dfs, lg, etc.)

---

## v0.0.1

Initial release.

- Ubuntu 24.04 base image
- ttyd web terminal with Dracula theme
- tmux with mobile-friendly `qq` bindings
- zsh with git-aware prompt
- Node.js 22 LTS + Bun
- Claude Code CLI pre-installed
- GitHub CLI
- Non-root `dev` user with persistent home volume


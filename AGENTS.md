# Bootstrap-Me — Agent Instructions

macOS personal bootstrap for Egor Zekov. Stack: Node.js · Rust · AWS.

## Architecture

| File | Purpose |
|------|---------|
| `bootstrap.sh` | Main entry point — run once on a fresh Mac |
| `utils.sh` | Shared logging/UI helpers — sourced by all scripts |
| `config.sh` | Shell env config (nvm, zoxide) — source into `~/.zshrc` |
| `aliases.sh` | Shell aliases — source into `~/.zshrc` |
| `ssh.sh` | Interactive GitHub SSH key setup — run standalone |

`bootstrap.sh` must be executed from the repo root (`bash bootstrap.sh`) because it sources `utils.sh` via `source ./utils.sh`. `ssh.sh` uses `$(dirname "$0")/utils.sh` so it works from any directory.

## Conventions

**Logging** — always use helpers from `utils.sh` (never raw `echo` for status):
- `log "message"` — info (blue `==>`)
- `ok "message"` — success (green `✔`)
- `warn "message"` — warning (yellow `⚠`)
- `item "label"` + `link "url"` — manual install entries

**Section headers** — use `print_box "[N] SECTION NAME"` to open each major step.

**Idempotency** — every install step checks whether the tool already exists before installing. Pattern:
```bash
if brew list "$pkg" &>/dev/null; then
  ok "$pkg already installed"
else
  brew install "$pkg" && ok "$pkg installed"
fi
```

**Apple Silicon awareness** — check `uname -m == "arm64"` when paths differ between Intel and M-series Macs (e.g., Homebrew prefix `/opt/homebrew` vs `/usr/local`).

**Fail-fast** — `bootstrap.sh` and `ssh.sh` both use `set -e`.

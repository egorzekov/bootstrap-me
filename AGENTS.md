# Bootstrap-Me — Agent Instructions

macOS personal bootstrap for Egor Zekov. Stack: Node.js · Rust · AWS.

## Architecture

```
run.sh                          # entry point — run this on a fresh Mac
src/
  utils.sh                      # shared logging/UI helpers — sourced by all scripts
  config.sh                     # shell env config (nvm, zoxide) — source into ~/.zshrc
  aliases.sh                    # shell aliases — source into ~/.zshrc
  bootstrap/
    00_ssh.sh                   # GitHub SSH key setup + write ~/.bootstrap_profile
    01_xcode.sh                 # Xcode CLI tools
    02_homebrew.sh              # Homebrew install/update
    03_ohmyzsh.sh               # Oh My Zsh + plugins
    04_brew_tools.sh            # brew formula installs
    05_brew_casks.sh            # brew cask installs
    06_git_config.sh            # render templates/.gitconfig.template → ~/.gitconfig
    07_ghostty_config.sh        # copy templates/.ghostty.template → Ghostty config
    08_manual_installs.sh       # print manual download links (always last)
templates/
  .gitconfig.template           # git config with {{NAME}}/{{EMAIL}} placeholders
  .ghostty.template             # Ghostty terminal config
```

`run.sh` must be executed from the repo root (`bash run.sh`). It sources `src/utils.sh`, prints the banner, then runs each `src/bootstrap/*.sh` in numeric order via `bash`; stops on first failure.

Each script in `src/bootstrap/` sources utils with `source "$(dirname "$0")/../utils.sh"`. Template paths are relative: `$(dirname "$0")/../../templates/...`.

**Run order is automatic** — `run.sh` globs `src/bootstrap/*.sh` in filename order. `00_ssh.sh` runs first and writes `~/.bootstrap_profile` (GIT_NAME + GIT_EMAIL), which `06_git_config.sh` consumes and then deletes.

## Conventions

**Logging** — always use helpers from `src/utils.sh` (never raw `echo` for status):
- `log "message"` — info (blue `==>`)
- `ok "message"` — success (green `✔`)
- `warn "message"` — warning (yellow `⚠`)
- `item "label"` + `link "url"` — manual install entries

**Section headers** — use `print_box "[NN] SECTION NAME"` to open each script.

**Idempotency** — every install step checks whether the tool already exists before installing. Pattern:
```bash
if brew list "$pkg" &>/dev/null; then
  ok "$pkg already installed"
else
  brew install "$pkg" && ok "$pkg installed"
fi
```

**Apple Silicon awareness** — check `uname -m == "arm64"` when paths differ between Intel and M-series Macs (e.g., Homebrew prefix `/opt/homebrew` vs `/usr/local`).

**Fail-fast** — all scripts use `set -e`. Xcode step exits `1` (not `0`) when it opens the install dialog, so `run.sh` stops and the user knows to re-run after installation.

**Section ordering** — `08_manual_installs.sh` must always be the last script. All automated steps go before it. New scripts must be assigned a number before `08`.


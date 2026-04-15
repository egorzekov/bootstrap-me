# Bootstrap-Me — Agent Instructions

macOS personal bootstrap for Egor Zekov. Stack: Node.js · Rust · AWS.

## Architecture

```
run.sh                          # entry point — run this on a fresh Mac
scripts/
  utils.sh                      # shared logging/UI helpers — sourced by all scripts
  config.sh                     # shell env config (nvm, zoxide) — source into ~/.zshrc
  aliases.sh                    # shell aliases — source into ~/.zshrc
  stow_unlink.sh                # remove all stow-managed symlinks from $HOME
  bootstrap/
    00_ssh.sh                   # GitHub SSH key setup + write ~/.bootstrap_profile
    01_xcode.sh                 # Xcode CLI tools
    02_homebrew.sh              # Homebrew install/update
    03_ohmyzsh.sh               # Oh My Zsh + plugins
    04_brew_tools.sh            # brew formula installs
    05_brew_casks.sh            # brew cask installs
    06_git_config.sh            # render templates/.gitconfig.template → dotfiles/git/.gitconfig, stow link
    07_ghostty_config.sh        # stow link dotfiles/ghostty → ~/Library/Application Support/com.mitchellh.ghostty
    08_lazygit_config.sh        # stow link dotfiles/lazygit → ~/Library/Application Support/lazygit
    09_manual_installs.sh       # print manual download links (always last)
dotfiles/                       # GNU stow packages — mirrored into $HOME on bootstrap
  git/                          # → ~/.gitconfig (rendered from template at bootstrap time)
  ghostty/
    Library/Application Support/com.mitchellh.ghostty/
      config.ghostty
  lazygit/
    Library/Application Support/lazygit/
      config.yml
templates/
  .gitconfig.template           # git config with {{NAME}}/{{EMAIL}} placeholders
```

`run.sh` must be executed from the repo root (`bash run.sh`). It sources `scripts/utils.sh`, prints the banner, then runs each `scripts/bootstrap/*.sh` in numeric order via `bash`; stops on first failure.

Each script in `scripts/bootstrap/` sources utils with `source "$(dirname "$0")/../utils.sh"`. Template paths are relative: `$(dirname "$0")/../../templates/...`. Stow dir is resolved as: `$(cd "$(dirname "$0")/../.." && pwd)/dotfiles`.

**Run order is automatic** — `run.sh` globs `scripts/bootstrap/*.sh` in filename order. `00_ssh.sh` runs first and writes `~/.bootstrap_profile` (GIT_NAME + GIT_EMAIL), which `06_git_config.sh` consumes and then deletes.

## Conventions

**Logging** — always use helpers from `scripts/utils.sh` (never raw `echo` for status):
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

**Section ordering** — `09_manual_installs.sh` must always be the last script. All automated steps go before it. New scripts must be assigned a number before `09`.

**Stow-managed dotfiles** — configs in `dotfiles/<pkg>/` are symlinked into `$HOME` using GNU stow. Bootstrap scripts use `-R` (restow) for idempotent linking. To remove all links, run `bash scripts/stow_unlink.sh`.


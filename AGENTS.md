# Bootstrap-Me — Agent Instructions

macOS personal bootstrap for Egor Zekov. Stack: Node.js · Rust · AWS.

## Architecture

```
run.sh                          # entry point — run this on a fresh Mac
scripts/
  utils.sh                      # shared logging/UI helpers — sourced by all scripts
  stow_unlink.sh                # remove all stow-managed symlinks from $HOME
  backfills/                    # one-time migrations, run by hand; never run by run.sh
    unlink_skills_dir.sh        # old whole-dir skills symlink → real dirs (then run 10_agent_skills.sh)
  bootstrap/
    00_ssh.sh                   # GitHub SSH key setup + write ~/.bootstrap_profile
    01_xcode.sh                 # Xcode CLI tools
    02_homebrew.sh              # Homebrew install/update
    03_ohmyzsh.sh               # Oh My Zsh + plugins
    04_brew_tools.sh            # brew formula installs (incl. neovim)
    05_brew_casks.sh            # brew cask installs
    06_node.sh                  # Node via fnm
    07_rustup.sh                # Rust toolchain
    08_bun.sh                   # Bun runtime
    09_dotfiles.sh              # stow-link all dotfile packages
    10_agent_skills.sh          # agent skills install
    12_gitconfig_local.sh       # write ~/.gitconfig.local from ~/.bootstrap_profile
    13_profile_cleanup.sh       # remove ~/.bootstrap_profile
    14_manual_installs.sh       # print manual download links (always last)
dotfiles/                       # GNU stow packages — mirrored into $HOME on bootstrap
  git/
    .gitconfig                  # static git config; [include] pulls in ~/.gitconfig.local
  ghostty/
    Library/Application Support/com.mitchellh.ghostty/
      config.ghostty
  lazygit/
    Library/Application Support/lazygit/
      config.yml
  nvim/
    .config/nvim/               # LazyVim starter → ~/.config/nvim
```

`run.sh` must be executed from the repo root (`bash run.sh`). It sources `scripts/utils.sh`, prints the banner, then runs each `scripts/bootstrap/*.sh` in numeric order via `bash`; stops on first failure.

Each script in `scripts/bootstrap/` sources utils with `source "$(dirname "$0")/../utils.sh"`. Stow dir is resolved as: `$(cd "$(dirname "$0")/../.." && pwd)/dotfiles`.

**Run order is automatic** — `run.sh` globs `scripts/bootstrap/*.sh` in filename order. `00_ssh.sh` runs first and writes `~/.bootstrap_profile` (GIT_NAME + GIT_EMAIL), which `12_gitconfig_local.sh` consumes; `13_profile_cleanup.sh` deletes it.

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

**Section ordering** — `14_manual_installs.sh` must always be the last script. All automated steps go before it. New scripts must be assigned a number before `14`.

**Stow-managed dotfiles** — configs in `dotfiles/<pkg>/` are symlinked into `$HOME` using GNU stow with `--no-folding`: stow creates real directories and only symlinks the actual config files (prevents directory symlinks that would pollute the repo with app-written runtime files). Bootstrap scripts use `-R` (restow) for idempotent linking. To remove all links, run `bash scripts/stow_unlink.sh`.

**LazyVim** — `dotfiles/nvim/.config/nvim` is the [LazyVim starter](https://www.lazyvim.org/installation) (`.git` removed). `09_dotfiles.sh` backs up a non-stow `~/.config/nvim` before linking. Neovim itself is installed via brew in `04_brew_tools.sh`. Customize via comments in `lua/config/` and `lua/plugins/`.

**gitconfig.local** — `dotfiles/git/.gitconfig` is a static committed file. It uses `[include] path = ~/.gitconfig.local` to pull in user-specific settings (name, email). `~/.gitconfig.local` is written by `12_gitconfig_local.sh` at bootstrap time from `~/.bootstrap_profile` and is never committed.

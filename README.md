# bootstrap-me

Personal macOS bootstrap for a Node.js · Rust · AWS setup.

Run once on a fresh Mac (or re-run anytime — steps are idempotent). It installs the toolchain, apps, shell, and links dotfiles into `$HOME`.

## Quick start

```bash
git clone <this-repo> ~/dev/personal/bootstrap-me
cd ~/dev/personal/bootstrap-me
zsh run.sh
```

Scripts run in numeric order under `scripts/bootstrap/`. The first step asks for your Git name/email and sets up a GitHub SSH key. If Xcode Command Line Tools need installing, the run stops — finish that install, then re-run `bash run.sh`.

At the end you’ll get a short list of things that still need a manual download (e.g. Logi Options+).

## What it sets up

| Area | Highlights |
|------|------------|
| Shell | Oh My Zsh, Ghostty, herdr |
| Editors | Neovim ([LazyVim](https://www.lazyvim.org/)), Cursor, Zed |
| CLI | gh, lazygit, fzf, zoxide, eza, fd, ripgrep, bat, jq, htop, … |
| Languages | Node (fnm), Bun, Rust (rustup), uv |
| Cloud / data | AWS CLI, Docker, libpq, mongosh |
| Apps | Rectangle, Telegram, Spotify, fonts (Lilex, JetBrains Mono Nerd) |

Default `$EDITOR` / `$VISUAL` is `nvim`.

## Dotfiles

Configs live under `dotfiles/` and are linked with [GNU Stow](https://www.gnu.org/software/stow/) (`--no-folding`):

| Package | Lands in |
|---------|----------|
| `zsh` | `~/.zshrc` |
| `git` | `~/.gitconfig` (identity via `~/.gitconfig.local`) |
| `nvim` | `~/.config/nvim` (LazyVim starter) |
| `ghostty` | Ghostty config |
| `lazygit` | Lazygit config |
| `herdr` | herdr config |
| `cursor` / `zed` | editor settings |

Edit files in the repo; the symlinks in `$HOME` pick up changes immediately.

```bash
# re-link all packages after adding/changing packages
zsh scripts/bootstrap/09_dotfiles.sh

# remove all stow links from $HOME
zsh scripts/stow_unlink.sh
```

## Layout

```
run.sh                    # entry point
scripts/bootstrap/        # numbered install steps
scripts/utils.sh          # shared logging helpers
scripts/stow_unlink.sh    # unlink stow packages
dotfiles/                 # stow packages → $HOME
skills/                   # agent skills installed by bootstrap
```

Agent-oriented conventions live in [`AGENTS.md`](./AGENTS.md).

## Resources

- [LazyVim installation](https://www.lazyvim.org/installation)
- [Oh My Zsh](https://ohmyz.sh/)
- [Useful video](https://www.youtube.com/watch?v=mmqDYw9C30I)

# =============================================================================
# macOS Egor Zekov Bootstrap 
# Stack: Node.js · Rust · AWS
# =============================================================================
 
set -e
 
source ./utils.sh

print_banner

# =============================================================================
# 1. XCODE COMMAND LINE TOOLS
# =============================================================================
print_box "[1] XCODE CLI"
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "  → Install dialog opened. Re-run this script once complete."
  exit 0
else
  ok "Xcode CLI tools already installed"
fi

# =============================================================================
# 2. HOMEBREW
# ==============================================================================
print_box  "[2] HOMEBREW"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon path
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
else
  ok "Homebrew already installed — updating..."
  brew update --quiet 2>/dev/null || warn "brew update skipped — already running"
fi

# =============================================================================
# 3. SHELL — OH MY ZSH (skip if already installed)
# =============================================================================
print_box "[3] OH MY ZSH" 
if [ -d "$HOME/.oh-my-zsh" ]; then
  ok "Oh My Zsh already installed"
else
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh installed"
fi
 
# Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
 
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --quiet https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  ok "zsh-autosuggestions installed"
fi
 
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  ok "zsh-syntax-highlighting installed"
fi

# =============================================================================
# 4. BREW CLI TOOLS 
# =============================================================================
print_box "[4] BREW CLI TOOLS"
 
BREWS=(
  # git
  gh
  git-delta
  lazygit

  # terminal
  fzf
  zoxide
  tmux

  # file & search
  bat
  eza
  ripgrep
  fd

  # dev
  jq
  nvim
  nvm
  rustup
  docker
)
 
for pkg in "${BREWS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    ok "$pkg already installed"
  else
    brew install "$pkg" && ok "$pkg installed"
  fi
done

# =============================================================================
# 5. BREW CASKS 
# =============================================================================
print_box "[5] BREW CASKS"
 
CASKS=(
  rectangle
  ghostty
  copilot-cli
  google-chrome
  spotify
  telegram
)
 
for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask already installed"
  else
    brew install --cask "$cask" --quiet && ok "$cask installed"
  fi
done

# =============================================================================
# 6. GIT CONFIG
# =============================================================================
print_box "[6] GIT CONFIG"

GITCONFIG="$HOME/.gitconfig"
PROFILE="$HOME/.bootstrap_profile"
TEMPLATE="$(dirname "$0")/templates/.gitconfig.template"

if [[ -f "$GITCONFIG" ]]; then
  ok "~/.gitconfig already exists — skipping"
else
  if [[ ! -f "$PROFILE" ]]; then
    warn "~/.bootstrap_profile not found — run ssh.sh first, then re-run bootstrap"
  else
    source "$PROFILE"
    sed -e "s/{{NAME}}/$GIT_NAME/" -e "s/{{EMAIL}}/$GIT_EMAIL/" "$TEMPLATE" > "$GITCONFIG"
    ok "~/.gitconfig written"
  fi
fi

# Clean up shared profile — no longer needed after this point
if [[ -f "$PROFILE" ]]; then
  rm -f "$PROFILE"
  ok "~/.bootstrap_profile cleaned up"
fi

# =============================================================================
# 7. GHOSTTY CONFIG
# =============================================================================
print_box "[7] GHOSTTY CONFIG"

GHOSTTY_CONFIG="$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
GHOSTTY_TEMPLATE="$(dirname "$0")/templates/.ghostty.template"

if [[ -f "$GHOSTTY_CONFIG" ]]; then
  ok "Ghostty config already exists — skipping"
else
  mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
  cp "$GHOSTTY_TEMPLATE" "$GHOSTTY_CONFIG"
  ok "Ghostty config written"
fi

# =============================================================================
# 8. MANUAL INSTALLS
# =============================================================================
print_box "[8] MANUAL INSTALLS"

log "Open the following links in your browser and install manually:"
echo ""

item "Logi Options+"
link "https://prosupport.logi.com/hc/en-gb/articles/10991109278871-Logitech-Options-Offline-Installer"
echo ""

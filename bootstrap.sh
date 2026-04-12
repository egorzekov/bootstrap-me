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
  jq
  fzf
  bat
  eza
  ripgrep
  fd
  tmux
  zoxide
  nvim
  gh
  docker
  nvm
  rustup
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
# 6. MANUAL INSTALLS 
# =============================================================================
print_box "[6] MANUAL INSTALLS"

log "Open the following links in your browser and install manually:"
echo ""

item "Logi Options+"
link "https://prosupport.logi.com/hc/en-gb/articles/10991109278871-Logitech-Options-Offline-Installer"
echo ""

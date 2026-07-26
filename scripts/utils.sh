#!/bin/bash

# =============================================================================
# UTILS — source this file at the top of any bootstrap script
# Usage: source ./utils.sh
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()    { printf "${BLUE}==> ${NC}%s\n" "$1"; }
ok()     { printf "${GREEN}✔${NC}   %s\n" "$1"; }
warn()   { printf "${YELLOW}⚠${NC}   %s\n" "$1"; }
item()   { printf "  ${CYAN}↓${NC}  ${BOLD}%s${NC}\n" "$1"; }
link()   { printf "     ${YELLOW}%s${NC}\n" "$1"; }

print_banner() {
  echo ""
  echo "  ███████╗███████╗████████╗██╗   ██╗██████╗ "
  echo "  ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
  echo "  ███████╗█████╗     ██║   ██║   ██║██████╔╝"
  echo "  ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
  echo "  ███████║███████╗   ██║   ╚██████╔╝██║     "
  echo "  ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
  echo ""
  echo "  macOS Egor Zekov Bootstrap"
  echo "  Stack: Node.js · Rust · AWS" 
  echo "  ----------------------------------------"
  echo ""
}

print_box() {
  local title="$1"
  local subtitle="${2:-}"
  local width=55
  local border
  border=$(printf '─%.0s' $(seq 1 $width))

  echo ""
  echo "  ┌${border}┐"
  # Centre the title
  local title_len=${#title}
  local padding=$(( (width - title_len) / 2 ))
  printf "  │%*s%s%*s│\n" $padding "" "$title" $(( width - padding - title_len )) ""
  # Optional subtitle
  if [ -n "$subtitle" ]; then
    local sub_len=${#subtitle}
    local sub_padding=$(( (width - sub_len) / 2 ))
    printf "  │%*s%s%*s│\n" $sub_padding "" "$subtitle" $(( width - sub_padding - sub_len )) ""
  fi
  echo "  └${border}┘"
}

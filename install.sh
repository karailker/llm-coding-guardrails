#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Constants
REPO_RAW_URL="https://raw.githubusercontent.com/karailker/llm-coding-guardrails/main"

# Target configuration definitions
# Name | Raw file subpath | Local destination | Global destination
TARGETS=(
  "core" "AGENTS.md" "AGENTS.md" "AGENTS.md"
  "claude" "CLAUDE.md" "CLAUDE.md" ".claude/CLAUDE.md"
  "cursor" ".cursorrules" ".cursorrules" ".cursorrules"
  "antigravity" ".antigravity/rules.md" ".antigravity/rules.md" ".antigravity/rules.md"
  "copilot" ".github/copilot-instructions.md" ".github/copilot-instructions.md" ".github/copilot-instructions.md"
)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Selected target toggles (0 = disabled, 1 = enabled)
SEL_CORE=1
SEL_CLAUDE=1
SEL_CURSOR=1
SEL_ANTIGRAVITY=1
SEL_COPILOT=1

# Installation Scope (local or global)
INSTALL_SCOPE="local"

# Print banner
show_banner() {
  echo -e "${BLUE}🛡️ LLM Coding Guardrails Interactive Installer${NC}"
  echo -e "Enforcing disciplines of caution, security, and simplicity on AI models.\n"
}

# Check download utilities
detect_downloader() {
  if command -v curl &> /dev/null; then
    echo "curl -sSL"
  elif command -v wget &> /dev/null; then
    echo "wget -qO-"
  else
    echo -e "${RED}Error: Neither curl nor wget is installed. Please install one of them to proceed.${NC}" >&2
    exit 1
  fi
}

DOWNLOAD_CMD=$(detect_downloader)

# Safe parsing of flags (for non-interactive execution or automation scenarios)
# Supports --local, --global, --yes (completes with defaults without interactive prompt),
# or individual features: --only-core, --only-claude, --only-cursor, --only-antigravity, --only-copilot
yes_mode=0
interactive_mode=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)
      INSTALL_SCOPE="local"
      shift
      ;;
    --global)
      INSTALL_SCOPE="global"
      shift
      ;;
    -y|--yes)
      yes_mode=1
      interactive_mode=0
      shift
      ;;
    --only-core)
      SEL_CORE=1; SEL_CLAUDE=0; SEL_CURSOR=0; SEL_ANTIGRAVITY=0; SEL_COPILOT=0; yes_mode=1; interactive_mode=0; shift ;;
    --only-claude)
      SEL_CORE=0; SEL_CLAUDE=1; SEL_CURSOR=0; SEL_ANTIGRAVITY=0; SEL_COPILOT=0; yes_mode=1; interactive_mode=0; shift ;;
    --only-cursor)
      SEL_CORE=0; SEL_CLAUDE=0; SEL_CURSOR=1; SEL_ANTIGRAVITY=0; SEL_COPILOT=0; yes_mode=1; interactive_mode=0; shift ;;
    --only-antigravity)
      SEL_CORE=0; SEL_CLAUDE=0; SEL_CURSOR=0; SEL_ANTIGRAVITY=1; SEL_COPILOT=0; yes_mode=1; interactive_mode=0; shift ;;
    --only-copilot)
      SEL_CORE=0; SEL_CLAUDE=0; SEL_CURSOR=0; SEL_ANTIGRAVITY=0; SEL_COPILOT=1; yes_mode=1; interactive_mode=0; shift ;;
    -h|--help)
      show_banner
      echo "Options:"
      echo "  --local           Set scope to target current workspace directory (default)"
      echo "  --global          Set scope to target home directory (~/)"
      echo "  -y, --yes         Configure blindly using defaults without prompting"
      echo "  --only-core       Installs only Core Guidelines (AGENTS.md) in silent mode"
      echo "  --only-claude     Installs only Claude Code (CLAUDE.md) in silent mode"
      echo "  --only-cursor     Installs only Cursor rules (.cursorrules) in silent mode"
      echo "  --only-antigravity Installs only Antigravity rules (.antigravity/rules.md) in silent mode"
      echo "  --only-copilot    Installs only Github Copilot instructions (.github/copilot-instructions.md) in silent mode"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# If stdin is not a terminal (e.g. running via curl ... | bash), fallback to non-interactive default installation locally.
if [ ! -t 0 ]; then
  yes_mode=1
  interactive_mode=0
fi

# Multi-select selection interactive routine
interactive_selection() {
  clear
  show_banner
  while true; do
    echo -e "${YELLOW}=== Selection Step 1: Manage Integration Targets ===${NC}"
    
    # Render selectors
    [ $SEL_CORE -eq 1 ] && echo -e "  [${GREEN}X${NC}] 1) Core guidelines (AGENTS.md)" || echo -e "  [ ] 1) Core guidelines (AGENTS.md)"
    [ $SEL_CLAUDE -eq 1 ] && echo -e "  [${GREEN}X${NC}] 2) Claude Code (CLAUDE.md / ~/.claude/CLAUDE.md)" || echo -e "  [ ] 2) Claude Code (CLAUDE.md)"
    [ $SEL_CURSOR -eq 1 ] && echo -e "  [${GREEN}X${NC}] 3) Cursor (.cursorrules)" || echo -e "  [ ] 3) Cursor (.cursorrules)"
    [ $SEL_ANTIGRAVITY -eq 1 ] && echo -e "  [${GREEN}X${NC}] 4) Antigravity (.antigravity/rules.md)" || echo -e "  [ ] 4) Antigravity (.antigravity/rules.md)"
    [ $SEL_COPILOT -eq 1 ] && echo -e "  [${GREEN}X${NC}] 5) GitHub Copilot (.github/copilot-instructions.md)" || echo -e "  [ ] 5) GitHub Copilot (.github/copilot-instructions.md)"
    
    echo ""
    echo -e "  Type the item number [1-5] to toggle selection."
    echo -e "  Press ${GREEN}[C]${NC} to confirm and move to scope configuration."
    echo -e "  Press ${RED}[Q]${NC} to cancel and exit."
    echo ""
    read -r -p "Your choice: " opt
    
    case "$opt" in
      1) SEL_CORE=$((1 - SEL_CORE)) ;;
      2) SEL_CLAUDE=$((1 - SEL_CLAUDE)) ;;
      3) SEL_CURSOR=$((1 - SEL_CURSOR)) ;;
      4) SEL_ANTIGRAVITY=$((1 - SEL_ANTIGRAVITY)) ;;
      5) SEL_COPILOT=$((1 - SEL_COPILOT)) ;;
      [cC]) break ;;
      [qQ]) echo -e "${RED}Installation cancelled.${NC}"; exit 0 ;;
      *) echo -e "${RED}Invalid input.${NC}"; sleep 1 ;;
    esac
    clear
    show_banner
  done

  clear
  show_banner
  echo -e "${YELLOW}=== Selection Step 2: Choose Installation Scope ===${NC}"
  echo "Where should the guidelines be placed?"
  echo ""
  echo "  1) Local (Project-wide - in current folder)"
  echo "  2) Global (User-wide - placed under home '$HOME')"
  echo ""
  while true; do
    read -r -p "Select scope option [1 or 2]: " scope_choice
    case "$scope_choice" in
      1) INSTALL_SCOPE="local"; break ;;
      2) INSTALL_SCOPE="global"; break ;;
      *) echo -e "${RED}Invalid choice. Enter 1 or 2.${NC}" ;;
    esac
  done
}

if [ "$interactive_mode" -eq 1 ]; then
  interactive_selection
fi

# Compile final chosen list of keys to install
echo -e "\n${BLUE}⏳ Preparing installation with target scope [${INSTALL_SCOPE^^}]...${NC}"

# Define working absolute paths based on chosen scope
# Helper function to get correct location path
get_full_path() {
  local short_name="$1"
  for ((i=0; i<${#TARGETS[@]}; i+=4)); do
    if [ "${TARGETS[i]}" = "$short_name" ]; then
      local local_dest="${TARGETS[i+2]}"
      local global_dest="${TARGETS[i+3]}"
      if [ "$INSTALL_SCOPE" = "global" ]; then
        echo "$HOME/$global_dest"
      else
        echo "./$local_dest"
      fi
      return
    fi
  done
}

# Perform installation downloads
is_installed_something=0

download_and_extract() {
  local tool_code="$1"
  local file_subpath="$2"
  local out_path
  out_path=$(get_full_path "$tool_code")
  
  # Ensure directory path exists
  local par_dir
  par_dir=$(dirname "$out_path")
  mkdir -p "$par_dir"

  # Perform file download
  echo -e "  📥 Downloading to $out_path..."
  if [ "$DOWNLOAD_CMD" = "curl -sSL" ]; then
    curl -sSL "$REPO_RAW_URL/$file_subpath" -o "$out_path"
  else
    wget -qO "$out_path" "$REPO_RAW_URL/$file_subpath"
  fi
  is_installed_something=1
}

# Core Guidelines (AGENTS.md)
if [ $SEL_CORE -eq 1 ]; then
  download_and_extract "core" "AGENTS.md"
fi

# Claude Code
if [ $SEL_CLAUDE -eq 1 ]; then
  download_and_extract "claude" "CLAUDE.md"
fi

# Cursor
if [ $SEL_CURSOR -eq 1 ]; then
  download_and_extract "cursor" ".cursorrules"
fi

# Antigravity
if [ $SEL_ANTIGRAVITY -eq 1 ]; then
  download_and_extract "antigravity" ".antigravity/rules.md"
fi

# Copilot
if [ $SEL_COPILOT -eq 1 ]; then
  download_and_extract "copilot" ".github/copilot-instructions.md"
fi

# Output results and manual setups if necessary
if [ $is_installed_something -eq 1 ]; then
  echo -e "\n${GREEN}✨ LLM Coding Guardrails successfully installed!${NC}"
  echo -e "Scope: ${YELLOW}${INSTALL_SCOPE^^}${NC}\n"
  
  echo -e "${BLUE}💡 Active configurations:${NC}"
  [ $SEL_CORE -eq 1 ] && echo -e "  - Core Rules: $(get_full_path "core")"
  [ $SEL_CLAUDE -eq 1 ] && echo -e "  - Claude Code: $(get_full_path "claude")"
  [ $SEL_CURSOR -eq 1 ] && echo -e "  - Cursor Rules: $(get_full_path "cursor")"
  [ $SEL_ANTIGRAVITY -eq 1 ] && echo -e "  - Antigravity: $(get_full_path "antigravity")"
  [ $SEL_COPILOT -eq 1 ] && echo -e "  - Github Copilot: $(get_full_path "copilot")"

  if [ "$INSTALL_SCOPE" = "global" ]; then
    echo -e "\n${YELLOW}ℹ️  Global Scope Setup Directions:${NC}"
    if [ $SEL_COPILOT -eq 1 ]; then
      echo -e "  - ${GREEN}GitHub Copilot (Global VS Code Settings)${NC}:"
      echo -e "    Open VS Code Settings (JSON) and append or merge the following directive:"
      echo -e "    ${BLUE}\"github.copilot.chat.codeGeneration.instructions\": [${NC}"
      echo -e "      ${BLUE}  { \"path\": \"$HOME/.github/copilot-instructions.md\" }${NC}"
      echo -e "      ${BLUE}]${NC}"
    fi
    if [ $SEL_CLAUDE -eq 1 ]; then
      echo -e "  - ${GREEN}Claude Code (Global)${NC}:"
      echo -e "    Claude Code finds global rules on startup inside: ${BLUE}$HOME/.claude/CLAUDE.md${NC}"
    fi
    if [ $SEL_CURSOR -eq 1 ]; then
      echo -e "  - ${GREEN}Cursor (Global)${NC}:"
      echo -e "    Depending on your Cursor variant, if Global features are active, point Cursor's general Rules path to: ${BLUE}$HOME/.cursorrules${NC}"
    fi
  else
    echo -e "\n${YELLOW}💡 Local Scope Information:${NC}"
    echo -e "  Since you selected LOCAL scope, files were dropped right into your current workspace folder."
    echo -e "  Most IDEs and AI tools in this directory will find these configurations natively on startup."
  fi
else
  echo -e "\n${YELLOW}⚠️ No guardrails were selected for installation.${NC}"
fi

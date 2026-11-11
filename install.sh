#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

required_tools=(nvim starship git delta fzf rg bat)
if [ -z "${DOTFILES_SANDBOX:-}" ]; then
  required_tools+=(docker sbx jq)
fi

missing=()
for tool in "${required_tools[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    missing+=("$tool")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing required tools: ${missing[*]}"
  echo "Install them with: brew bundle install --file=\"$DOTFILES_DIR/Brewfile\""
  exit 1
fi

files=(
  .gitconfig
  .alias
  .zshrc
  .config/nvim
  .config/starship.toml
  .config/zellij
  .copilot/copilot-instructions.md
  .copilot/lsp-config.json
)

if [ -z "${DOTFILES_SANDBOX:-}" ]; then
  files+=(.sbx-helpers.sh)
fi

mkdir -p "$HOME/.config"

for file in "${files[@]}"; do
  target="$HOME/$file"
  source="$DOTFILES_DIR/$file"

  if [ ! -e "$source" ]; then
    echo "Skipping $file (not found in dotfiles)"
    continue
  fi

  if [ -L "$target" ]; then
    unlink "$target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.bak"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  echo "Linked $file"
done

echo "Installing nvim plugins (headless)..."
nvim --headless "+Lazy! restore" +qa 2>/dev/null || true

echo "Dotfiles installed."

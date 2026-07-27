#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

required_tools=(nvim tmux starship git delta fzf rg bat)

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
  .tmux.conf
  .config/nvim
  .config/starship.toml
  .copilot/copilot-instructions.md
  .copilot/lsp-config.json
)

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

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "Installing tmux plugins..."
tmux new-session -d -s _install 2>/dev/null
~/.tmux/plugins/tpm/bin/install_plugins || true
tmux kill-session -t _install 2>/dev/null || true

# nordtheme/tmux's nord.tmux script uses BASH_SOURCE but ships without a
# shebang. On Linux, tmux's run-shell uses /bin/sh (dash) which doesn't
# support BASH_SOURCE, causing the theme to silently fail to load.
# macOS is unaffected so we only patch on Linux.
nord_tmux="$HOME/.tmux/plugins/tmux/nord.tmux"
if [ "$(uname)" = "Linux" ] && [ -f "$nord_tmux" ] && ! head -1 "$nord_tmux" | grep -q '^#!'; then
  sed -i '1i#!/usr/bin/env bash' "$nord_tmux"
fi

echo "Installing nvim plugins (headless)..."
nvim --headless "+Lazy! restore" +qa 2>/dev/null || true

echo "Dotfiles installed."

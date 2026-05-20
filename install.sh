#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

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

if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing tmux plugins..."
  ~/.tmux/plugins/tpm/bin/install_plugins || true
fi

echo "Installing nvim plugins (headless)..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo "Dotfiles installed."

#!/bin/bash
trap 'echo "Warning: error on line $LINENO: $BASH_COMMAND" >&2' ERR

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || /opt/homebrew/bin/brew shellenv 2>/dev/null)" 2>/dev/null
export PATH="$(brew --prefix rustup 2>/dev/null)/bin:$HOME/.cargo/bin:$PATH"

if command -v sudo &>/dev/null; then
  sudo chown -R "$(id -u):$(id -g)" "$HOME/.cargo" "$HOME/.cache" "$HOME/.npm" "$HOME/.local" "$HOME/.ssh" 2>/dev/null || true
fi

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

files=(
  .gitconfig
  .alias
  .lima-helpers
  .devcontainer-helpers
  .devcontainer
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

THUMBS_DIR="$HOME/.tmux/plugins/tmux-thumbs"
if [ ! -d "$THUMBS_DIR" ]; then
  git clone https://github.com/fcsonline/tmux-thumbs "$THUMBS_DIR"
fi

if [ ! -f "$THUMBS_DIR/target/release/tmux-thumbs" ]; then
  echo "Compiling tmux-thumbs..."
  CARGO=$(rustup which cargo 2>/dev/null || command -v cargo 2>/dev/null)
  if [ -z "$CARGO" ]; then
    echo "Warning: cargo not found, skipping tmux-thumbs compile"
  else
    (cd "$THUMBS_DIR" && "$CARGO" build --release)
  fi
fi

echo "Installing tmux plugins..."
tmux start-server && tmux new-session -d -s _install 2>/dev/null
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

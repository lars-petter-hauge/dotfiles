#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Fix ownership of volume-mounted directories (Docker creates them as root)
if command -v sudo &>/dev/null; then
  sudo chown -R "$(id -u):$(id -g)" \
    /nix \
    "$HOME/.local" \
    "$HOME/.cargo" \
    "$HOME/.cache" \
    "$HOME/.npm" \
    "$HOME/.tmux" \
    2>/dev/null || true
fi

# Install Nix if not present
if ! command -v nix &>/dev/null; then
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi
. "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null || true

mkdir -p "$HOME/.config/nix"
echo "experimental-features = nix-command flakes" > "$HOME/.config/nix/nix.conf"

nix profile install \
  nixpkgs#azure-cli \
  nixpkgs#bzip2 \
  nixpkgs#cmake \
  nixpkgs#fzf \
  nixpkgs#gcc \
  nixpkgs#gdb \
  nixpkgs#gh \
  nixpkgs#git \
  nixpkgs#glib \
  nixpkgs#gnused \
  nixpkgs#guile \
  nixpkgs#htop \
  nixpkgs#jq \
  nixpkgs#libssh \
  nixpkgs#meson \
  nixpkgs#neovim \
  nixpkgs#nginx \
  nixpkgs#nodejs \
  nixpkgs#openmpi \
  nixpkgs#pkg-config \
  nixpkgs#pre-commit \
  nixpkgs#prettier \
  nixpkgs#python312 \
  nixpkgs#delta \
  nixpkgs#ripgrep \
  nixpkgs#ruff \
  nixpkgs#rustup \
  nixpkgs#starship \
  nixpkgs#tmux \
  nixpkgs#tree \
  nixpkgs#uv \
  nixpkgs#watch \
  nixpkgs#wget \
  nixpkgs#zsh \
  nixpkgs#zstd

gh extension install github/copilot-cli 2>/dev/null || true

if command -v rustup &>/dev/null && ! rustup show active-toolchain &>/dev/null; then
  rustup default stable
fi

files=(
  .gitconfig
  .alias
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
SHELL="$(command -v bash)" tmux start-server \; set -g default-shell "$(command -v bash)" && tmux new-session -d -s _install 2>/dev/null
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

#!/bin/bash
set -e
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOME=/home/vscode
mkdir -p "$HOME/.config"
git clone https://github.com/lars-petter-hauge/dotfiles.git /tmp/dotfiles-nvim
ln -s /tmp/dotfiles-nvim/.config/nvim "$HOME/.config/nvim"
nvim --headless "+Lazy! restore" +qa 2>/dev/null || true
rm -rf /tmp/dotfiles-nvim "$HOME/.config/nvim"

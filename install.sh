#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=("
  .alias
  .zshrc
  .p10k.zsh
  .tmux.conf
  .vimrc
  .config/nvim/lua/config/keymaps.lua
  .config/nvim/lua/plugins/disabled.lua
  .config/nvim/lua/plugins/flash.lua
  .config/nvim/lua/plugins/general_plugins.lua
")

for file in $files; do
  target=${HOME}/$file
  if [ -f $target ]; then
    if [ -L $target ]; then
      echo "Found existing symlink for $file, unlinking"
      unlink $target
    else
      echo "Moving existing $file -> $olddir/$file"
      mv $target $olddir/
    fi
  fi
  echo "Creating symlink for $target $(pwd)/$file "
  ln -s $(pwd)/$file $target
done

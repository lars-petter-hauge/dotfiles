#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=("
  .alias
  .zshrc
  .p10k.zsh
  .tmux.conf
  .vimrc
  .config/nvim
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

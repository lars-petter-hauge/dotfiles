#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=("
  .gitconfig
  .alias
  .zshrc
  .p10k.zsh
  .tmux.conf
  .vimrc
  .config/nvim
")

# The idea is that install.sh should not remove any existing files.
# It should also be possible to redo install over and over.
# Does not remove symlinks for files that are removed (i.e. file has
# been added previously, symlinked using this script, and then removed
# in a later commit)
for file in $files; do
  target=${HOME}/$file
  if [ -f $target ] || [ -d $target ]; then
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

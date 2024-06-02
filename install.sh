#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=".alias .zshrc .p10k.zsh .tmux.conf .vimrc"

for file in $files; do
	if [ -f ${HOME}/$file ]; then
    if [ -L ${HOME}/$file ]; then
		  echo "Found existing symlink for $file, unlinking"
		  unlink ${HOME}/$file
    else
      echo "Moving existing $file -> $olddir/$file"
      mv ${HOME}/$file $olddir/
	fi
  echo "Creating symlink for ${HOME}/$file $(pwd)/$file " 
	ln -s $(pwd)/$file ${HOME}/$file
done

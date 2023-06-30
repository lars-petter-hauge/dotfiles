#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=".tmux.conf .vimrc .vimrc.plugins .config/nvim/init.vim"

if [[ "$OSTYPE" == "darwin"* ]]; then
    files="${files} .zshrc"
else
    files="${files} .bashrc"
fi

for file in $files; do
    if [ -f ${HOME}/$file ]; then
        echo "Moving existing $file -> $olddir/$file"
        mv ${HOME}/$file $olddir/
    fi

    ln -s  $(pwd)/$file ${HOME}/$file
done

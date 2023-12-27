#!/bin/bash

olddir=${HOME}/dotfiles_old
mkdir -p $olddir

files=".zshrc .tmux.conf .vimrc .vimrc.plugins .config/nvim/init.lua"


for file in $files; do
    if [ -f ${HOME}/$file ]; then
        echo "Moving existing $file -> $olddir/$file"
        mv ${HOME}/$file $olddir/
    fi

    ln -s  $(pwd)/$file ${HOME}/$file
done

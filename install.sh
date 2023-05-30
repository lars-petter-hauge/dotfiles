#!/bin/bash

olddir=${HOME}/dotfiles_old

if [ ! -d "vimconf" ]; then
    git clone https://github.com/timss/vimconf.git
fi

ln -s -f -r vimconf/.vimrc .vimrc

mkdir -p $olddir

files=".bashrc .vimrc.plugins .vimrc .tmux.conf .config/nvim/init.lua"

if [[ "$OSTYPE" == "darwin"* ]]; then
    files="${files} .zshrc"
fi

for file in $files; do
    if [ -f ${HOME}/$file ]; then
        echo "Moving existing $file -> $olddir/$file"
        mv ${HOME}/$file $olddir/
    fi

    ln -s  $(pwd)/$file ${HOME}/$file
done


source $HOME/.bashrc

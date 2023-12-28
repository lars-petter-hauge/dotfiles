set nocompatible            " disable compatibility to old-time vi
filetype plugin indent on    " require
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right
set encoding=utf-8
set cursorline              " highlight current cursorline
set clipboard=unnamedplus   " access clipboard outside of vim
set mouse=n
set laststatus=2
set cc=80                   " set an 80 column border for good coding style
set number                  " add line numbers

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

syntax on

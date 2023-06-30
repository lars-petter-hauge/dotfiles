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

map <C-n> :NERDTreeToggle<CR>

" Make Y hank til end of line
nnoremap Y yg_

"execute "set <A-k>=\ek"
"execute "set <A-j>=\ej"
" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+0<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

call plug#begin()

Plug 'preservim/nerdtree'

Plug 'ntpeters/vim-better-whitespace'

" Plugin for vim tmux navigator. This plugin sets up the vim side
" The tmux side must also be configured (either in .conf of using plugin)
Plug 'christoomey/vim-tmux-navigator'

Plug 'airblade/vim-gitgutter'

" Color schemes, among others zenburn
Plug 'flazz/vim-colorschemes'

Plug 'ryanoasis/vim-devicons'

" Debugger
Plug 'puremourning/vimspector'

" lsp-server
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

"All of your Plugins must be added before the following line
call plug#end()

" Close the autocomplete window when you're done
"let g:ycm_autoclose_preview_window_after_completion=1

"let python_highlight_all=1
syntax on
colorscheme zenburn

" hide .pyc files
let NERDTreeIgnore=['\.pyc$', '\~$']

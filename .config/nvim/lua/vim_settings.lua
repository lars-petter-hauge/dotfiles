
local vim = vim                 -- Simply to silent warning of undefined global
vim.opt.expandtab=true          -- converts tabs to white space
vim.opt.shiftwidth=4            -- width for autoindents
vim.opt.autoindent=true         -- indent a new line the same amount as the line just typed
vim.opt.hlsearch=true           -- highlight search
vim.opt.incsearch=true          -- incremental search
vim.opt.tabstop=4               -- number of columns occupied by a tab
vim.opt.softtabstop=4           -- see multiple spaces as tabstops so <BS> does the right
vim.opt.encoding="utf-8"
vim.opt.cursorline=true         -- highlight current cursorline
vim.opt.clipboard="unnamedplus" -- access clipboard outside of vim
vim.opt.mouse=a
vim.opt.laststatus=2
vim.opt.number=true             -- add line number
vim.opt.relativenumber=true     -- and make them relative
vim.opt.syntax="on"
vim.opt.scrolloff=20            -- keep n lines above/below cursor (pad lines around cursor)
vim.opt.termguicolors = true
vim.opt.hidden=true             -- Allow to have multiple buffers open without saving

vim.g.python3_host_prog = HOME .. "/.pyenv/versions/nvim_env/bin/python"

vim.g.mapleader = " "

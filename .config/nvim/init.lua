
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
vim.opt.mouse=n
vim.opt.laststatus=2
vim.opt.number=true             -- add line number
vim.opt.syntax="on"
vim.opt.scrolloff=20            -- keep n lines above/below cursor (pad lines around cursor)

vim.g.mapleader = " "
vim.g.python3_host_prog = "/home/lars/.pyenv/versions/nvim_env/bin/python"
-- Navigate splits
vim.keymap.set('n','<C-J>','<C-W><C-J>')
vim.keymap.set('n','<C-K>','<C-W><C-K>')
vim.keymap.set('n','<C-L>','<C-W><C-L>')
vim.keymap.set('n','<C-H>','<C-W><C-H>')

-- Reselect last block selection
vim.keymap.set('v','<', '<gv')
vim.keymap.set('v','>', '>gv')

-- Move lines up/down
vim.keymap.set('n','<A-j>', ':m .+1<CR>==')
vim.keymap.set('n','<A-k>', ':m .-2<CR>==')
vim.keymap.set('i','<A-j>', '<Esc>:m .+0<CR>==gi')
vim.keymap.set('i','<A-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v','<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v','<A-k>', ":m '<-2<CR>gv=gv")


----------- Plugin bindings -----------
vim.keymap.set({'n','i','v'},'<C-n>', ':NERDTreeToggle<CR>')


vim.keymap.set({'n','i','v'},'<leader>ff','<cmd>Telescope find_files<cr>')
vim.keymap.set({'n','i','v'},'<leader>fg','<cmd>Telescope live_grep<cr>')
vim.keymap.set({'n','i','v'},'<leader>fb','<cmd>Telescope buffers<cr>')
vim.keymap.set({'n','i','v'},'<leader>fh','<cmd>Telescope help_tags<cr>')
vim.keymap.set({'n','i','v'},'<leader>fd','<cmd>Telescope diagnostics<cr>')

------------ Plugins --------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {"folke/which-key.nvim"},
  {'preservim/nerdtree'} ,
  {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
  dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {'flazz/vim-colorschemes'},
  {'neovim/nvim-lspconfig'},
  })

vim.cmd([[colorscheme zenburn]])

--local lspconfig = require('lspconfig')
--lspconfig.pyright.setup {}

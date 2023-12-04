
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
vim.opt.relativenumber=true     -- and make them relative
vim.opt.syntax="on"
vim.opt.scrolloff=20            -- keep n lines above/below cursor (pad lines around cursor)
vim.opt.termguicolors = true
HOME = os.getenv("HOME")

vim.g.mapleader = " "
vim.g.python3_host_prog = HOME .. "/.pyenv/versions/nvim_env/bin/python"
vim.keymap.set("n","<c-_>",":nohlsearch<CR>")
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

vim.api.nvim_create_augroup("AutoFormat", {})

vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !black --quiet %")
            vim.cmd("edit")
        end,
    }
)
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.rs",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !rustfmt %")
            vim.cmd("edit")
        end,
    }
)
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
    {"nvim-treesitter/nvim-treesitter", ensure_installed={"python"}, build = ":TSUpdate"},
    {'preservim/nerdtree'},
    {'nvim-telescope/telescope.nvim', tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap","mfussenegger/nvim-dap-python"}
    },
    {"tpope/vim-surround"},
    {"tpope/vim-repeat"},
    {"tpope/vim-fugitive"},
    {"airblade/vim-gitgutter"},
    {"vim-airline/vim-airline"},
    {'folke/which-key.nvim'},
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {'neovim/nvim-lspconfig'},
    {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
}})

require("tokyonight").setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
  style = "night", --`storm`, `moon`, a darker variant `night` and `day`
  light_style = "moon", -- The theme is used when the background is set to light
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
})
vim.cmd[[colorscheme tokyonight]]


require("ibl").setup()

require('dap-python').setup(HOME .."/.pyenv/versions/nvim_env/bin/python")

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Debug file',
  program = '${file}',
})
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup({})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
  end,
})

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

HOME = os.getenv("HOME")
vim.g.python3_host_prog = HOME .. "/.pyenv/versions/nvim_env/bin/python"

vim.g.mapleader = " "

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

-- vim.diagnostic result may come from several different sources
-- such as linters, lsp etc.
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

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
vim.keymap.set("n",'<C-n>', ':NERDTreeToggle<CR>')


vim.keymap.set('n','<leader>ff','<cmd>Telescope find_files<cr>')
vim.keymap.set('n','<leader>fg','<cmd>Telescope live_grep<cr>')
vim.keymap.set('n','<leader>fb','<cmd>Telescope buffers<cr>')
vim.keymap.set('n','<leader>fh','<cmd>Telescope help_tags<cr>')
vim.keymap.set('n','<leader>fd','<cmd>Telescope diagnostics<cr>')
vim.keymap.set("n","<leader>ft", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", { noremap = true })

------------ Plugins --------------

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
    {"folke/which-key.nvim"},
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {'preservim/nerdtree'},
    {'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {"nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim"}
    },
    {"tpope/vim-surround"},
    {"tpope/vim-repeat"},
    {"tpope/vim-fugitive"},
    {"tpope/vim-commentary"},
    {'mhinz/vim-signify'},
    {"lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    {"folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {"petertriho/nvim-scrollbar"},
    {"rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python"
        },
    },
    {'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        }
    },
    {'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
    },
})
------------ Colors and style --------------
require("tokyonight").setup({
  style = "storm", --`storm`, `moon`, a darker variant `night` and `day`
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "storm",
    floats = "storm",
  },
  on_highlights = function(hl, colors)
    hl.LineNr = {
      fg = colors.yellow
    }
    hl.CursorLine = {
      bg = colors.bg_dark
    }
  end
})

local colors = require("tokyonight.colors").setup()
require("scrollbar").setup({
    handle = {
        color = colors.bg_highlight,
    },
    marks = {
        Search = { color = colors.orange },
        Error = { color = colors.error },
        Warn = { color = colors.warning },
        Info = { color = colors.info },
        Hint = { color = colors.hint },
        Misc = { color = colors.purple },
    }
})

vim.cmd[[colorscheme tokyonight]]

require("ibl").setup()

------------ Syntax highlighting --------------
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query","python","rust" },
    auto_install = true,
    highlight = {
        enable = true
    }
})

require("telescope").setup {
  defaults = {
    theme = "center",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.3,
      },
    },
  },
}

require("telescope").load_extension "file_browser"


------------ Language Server Protocol --------------

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

    -- lsp_workspace_symbols gives an error with pyright (empty query) and urges
    -- the user to provide a text input. It is possible to use lsp_dynamic_workspace_symbols
    -- instead, but that includes a fairly large result. Also a search is performed
    -- per character, hence it is quite slow for larger projects. Here we prompt with something
    -- for the user to start with
    -- keymapping to fit with other telescope search
    vim.keymap.set("n", "<leader>fs", function()
            vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
                    require("telescope.builtin").lsp_workspace_symbols({ query = query })
            end, opts)
    end, { desc = "LSP workspace symbols" })
  end,
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Now we can setup servers with lspconfig
local lspconfig = require('lspconfig')
lspconfig.pyright.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.lua_ls.setup({})

-- Enable the following language servers
-- Any servers added here will be automatically installed - see docs for which ones are available
local servers = {
    pyright = {},
    rust_analyzer = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

------------ completion (nvim-cmp) --------------
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

------------ Debug adapters --------------
require('dap-python').setup(HOME .."/.pyenv/versions/nvim_env/bin/python")

vim.keymap.set('n', '<F1>', function() require('dap').continue() end)
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F3>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F4>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)

table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Debug file',
  program = '${file}',
  console="integratedTerminal",
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

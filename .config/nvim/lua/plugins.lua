
local vim = vim
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
    {"folke/which-key.nvim",
    event="VeryLazy",
    init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,},
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
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
    {'kevinhwang91/nvim-ufo', dependencies= 'kevinhwang91/promise-async'},
    {"tpope/vim-surround"},
    {"tpope/vim-repeat"},
    {"tpope/vim-fugitive"},
    {"tpope/vim-commentary"},
    {'mhinz/vim-signify'},
    {"windwp/nvim-ts-autotag" },
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
            'hrsh7th/cmp-nvim-lsp-signature-help',
        },
    },
})

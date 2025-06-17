-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Adding these explicitly, even when default values are used, as it was not obvious
-- that this is where one changes lsp. Would have thought that configuring
-- "neovim/nvim-lspconfig", would be the place to do this, but it is also required
-- for these two.
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"


local vim = vim

-- Some settings are added in this section as they are directly
-- related to lsp servers
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`.
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

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
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc="Declaration"} )
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc="Definition"} )
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc="Implementation"})
    vim.keymap.set('n', 'gR', vim.lsp.buf.references, { buffer = ev.buf, desc="References"})
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = ev.buf, desc="Type definition"})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc="Hover Definition"})
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc="Signature help"})
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = ev.buf, desc="Rename"})
    vim.keymap.set('n', '<leader>fr', function() require('telescope.builtin').lsp_references() end, { buffer = ev.buf, desc="References word under cursor"})
    -- lsp_workspace_symbols gives an error with pyright (empty query) and urges
    -- the user to provide a text input. It is possible to use lsp_dynamic_workspace_symbols
    -- instead, but that includes a fairly large result. Also a search is performed
    -- per character, hence it is quite slow for larger projects. Here we prompt with something
    -- for the user to start with
    -- keymapping to fit with other telescope search
    vim.keymap.set("n", "<leader>fw", function()
            vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
                    require("telescope.builtin").lsp_workspace_symbols({ query = query })
            end, { buffer = ev.buf})
    end, { desc = "LSP workspace symbols" })
  end,
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
-- Any servers added here should be automatically installed
-- Any additional server settings can be included and will be forwarded
-- to the server setup
local servers = {
    cpptools = {},
    clangd = {},
    codelldb = {},
    pyright = {},
    debugpy = {},
    tsserver = {}, -- MasonInstall typescript-language-server
    lua_ls = {},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason_lspconfig = require('mason-lspconfig')

-- Automatically install any servers setup with lspconfig
mason_lspconfig.setup({automatic_installation=true})

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
    }
  end,
}

-- The ufo plugin contains improved folding capabilities. The setting of capabilities
-- also sets up
require('ufo').setup()


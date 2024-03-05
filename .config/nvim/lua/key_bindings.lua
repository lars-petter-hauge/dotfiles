local vim = vim

-- "unset" search highlight
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

----------- Plugin bindings -----------
local wk = require("which-key")

local ts_builtin = require('telescope.builtin')
local ts_fb = require "telescope".extensions.file_browser

wk.register({
  ["<leader>f"] = {
    name = "Telescope operations",
    f = { function() ts_builtin.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}) end, "Find File" },
    r = { function() ts_builtin.oldfiles() end, "Open Recent File" },
    b = { function() ts_builtin.buffers() end, "Open Buffers" },
    h = { function() ts_builtin.help_tags() end, "Help Tags" },
    g = { function() ts_builtin.live_grep() end, "Live Grep" },
    d = { function() ts_builtin.diagnostics() end, "Diagnostics" },
    t = { function() ts_fb.file_browser() end, "File Browser" },
  },
  -- Default mapping of moving telescope result to quickfix is C-q. We map opening
  -- quickfix in telescope as C-q as well, so that one can toggle back and forth
  ["<C-q>"] = { function() ts_builtin.quickfix() vim.cmd(":cclose") end, "Quickfix" },
  ["<leader>i"] = {
    name = "Info Diagnostics",
    o = { function() vim.diagnostic.open_float() end, "Open diagnostic window"},
    k = { function() vim.diagnostic.goto_prev() end, "Next diagnostic"},
    j = { function() vim.diagnostic.goto_next() end, "Previous diagnostic"}
  },
  ["<leader>p"] = {
    name = "Pane operations",
    v = { function() vim.cmd('vsplit') end, "Create vertical pane"},
    h = { function() vim.cmd('split') end, "Create horizontal pane"},
  }
})


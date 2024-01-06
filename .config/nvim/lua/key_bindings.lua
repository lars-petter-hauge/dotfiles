local vim = vim
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

----------- Plugin bindings -----------
vim.keymap.set("n",'<C-n>', ':NERDTreeToggle<CR>')
local wk = require("which-key")

wk.register({
  ["<leader>f"] = {
    name = "Telescope operations",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    b = { '<cmd>Telescope buffers<cr>', "Open Buffers" },
    h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    d = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    t = { "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", "File Browser" },
  },
})


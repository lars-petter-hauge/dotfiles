local map = vim.keymap.set

-- s is vim built-in, mapped to change single char under cursor
-- Identical behaviour is achieved with e.g. cl. We want to use
-- surround with the least amount of overhead and therefore remap
map("n", "s", "ys", { desc = "Surround", remap = true })
map("v", "s", "S", { desc = "Surround", remap = true })

-- Use same split as in tmux
map("n", "<leader>wh", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })

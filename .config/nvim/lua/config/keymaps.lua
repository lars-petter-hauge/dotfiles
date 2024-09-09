local map = vim.keymap.set

-- s is vim built-in, mapped to change single char under cursor
-- Identical behaviour is achieved with e.g. cl. We want to use
-- surround with the least amount of overhead and therefore remap
map("n", "s", "ys", { desc = "Surround", remap = true })
map("v", "s", "S", { desc = "Surround", remap = true })

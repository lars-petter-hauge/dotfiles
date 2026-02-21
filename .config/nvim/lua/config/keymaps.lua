local map = vim.keymap.set

-- s is vim built-in, mapped to change single char under cursor
-- Identical behaviour is achieved with e.g. cl. We want to use
-- surround with the least amount of overhead and therefore remap
map("n", "s", "ys", { desc = "Surround", remap = true })
map("v", "s", "S", { desc = "Surround", remap = true })

-- Use same split as in tmux
map("n", "<leader>wh", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })

-- adding this little function
-- https://github.com/Allaman/nvim/blob/1e5395f395ed44cf5555cc03a2cfa87372c69979/lua/vnext/config/mappings.lua#L108
map("n", "<CR>", function()
	if vim.bo.buftype == "quickfix" then
		-- Execute the default Enter behavior in quickfix list
		return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
	end
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz") -- center the cursor line on screen
	end
end, { desc = "Toggle fold" })

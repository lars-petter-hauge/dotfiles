local octet = [[%(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])]]
local token_char = [=[[^[:space:]<>"'`(){}\[\]]]=]
local hint_patterns = {
	{
		description = "HTTP/HTTPS URL tokens, bounded by whitespace, quotes or brackets",
		pattern = [[https?://]] .. token_char .. "+",
	},
	{
		description = "UUIDs: hexadecimal groups of 8-4-4-4-12 characters",
		pattern = [[<\x{8}-\x{4}-\x{4}-\x{4}-\x{12}>]],
	},
	{
		description = "IPv4 addresses: four decimal octets, each between 0 and 255",
		pattern = [[<]] .. octet .. [[%(\.]] .. octet .. [[){3}>]],
	},
	{
		description = "Git SHA candidates: 7 to 40 hexadecimal characters",
		pattern = [[<\x{7,40}>]],
	},
	{
		description = "Slash-containing path tokens: /etc/hosts, ~/src, ./src, ../src, src/main.lua",
		pattern = token_char .. "*/" .. token_char .. "+",
	},
}
local patterns = vim.tbl_map(function(entry)
	return entry.pattern
end, hint_patterns)
local pattern = [[\v\C%(]] .. table.concat(patterns, "|") .. [[)]]

local function yank_hint()
	require("flash").jump({
		pattern = pattern,
		search = { mode = "search", multi_window = true, incremental = false, max_length = #pattern },
		jump = { pos = "start", autojump = false },
		label = { before = true, after = false },
		prompt = { enabled = false },
		action = function(match, state)
			local text = vim.api.nvim_buf_get_text(
				vim.api.nvim_win_get_buf(match.win),
				match.pos[1] - 1,
				match.pos[2],
				match.end_pos[1] - 1,
				match.end_pos[2] + 1,
				{}
			)
			vim.fn.setreg(vim.v.register, table.concat(text, "\n"), "v")
			require("flash.jump").jump(match, state)
			require("flash.jump").on_jump(state)
		end,
	})
end

return {
	"folke/flash.nvim",
	keys = {
		-- disable the default flash keymap
		{ "s", mode = { "n", "x", "o" }, false },
		{ "S", mode = { "n", "x", "o" }, false },
		{ "<leader>sf", yank_hint, desc = "Flash yank hints" },
	},
}

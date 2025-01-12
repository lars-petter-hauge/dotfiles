local function setupCustomHighlightGroup()
	vim.api.nvim_command("hi clear FlashMatch")
	vim.api.nvim_command("hi clear FlashCurrent")
	vim.api.nvim_command("hi clear FlashLabel")

	vim.api.nvim_command("hi FlashMatch guibg=#4A47A3 guifg=#B8B5FF") -- Emerald background
	vim.api.nvim_command("hi FlashCurrent guibg=#456268 guifg=#D0E8F2")
	vim.api.nvim_command("hi FlashLabel guibg=#A25772 guifg=#EEF5FF")
end

return {
	"hrsh7th/nvim-cmp",
	opts = {
		experimental = {
			ghost_text = false,
		},
	},
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gB", "<cmd>Git blame<cr>", desc = "Git blame in gutter" },
			{ "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Diff split vertical buffers" },
		},
		cmd = { "Gedit", "Git", "Gsplit" },
	},
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
	{ "tpope/vim-surround" },
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ruff = {
					autostart = false,
				},
				jedi_language_server = {
					autostart = false,
				},
			},
		},
	},
	{
		"folke/flash.nvim",
		opts = {
			rainbow = {
				enabled = true,
				shade = 5,
			},
			highlight = {
				backdrop = true,
				groups = {
					match = "FlashMatch",
					current = "FlashCurrent",
					backdrop = "FlashBackdrop",
					label = "FlashLabel",
				},
			},
		},
		config = function()
			setupCustomHighlightGroup()
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}

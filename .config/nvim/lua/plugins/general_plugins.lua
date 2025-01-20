local function setupCustomHighlightGroup()
	vim.api.nvim_command("hi clear FlashMatch")
	vim.api.nvim_command("hi clear FlashCurrent")
	vim.api.nvim_command("hi clear FlashLabel")

	vim.api.nvim_command("hi FlashMatch guibg=#4A47A3 guifg=#B8B5FF") -- Emerald background
	vim.api.nvim_command("hi FlashCurrent guibg=#456268 guifg=#D0E8F2")
	vim.api.nvim_command("hi FlashLabel guibg=#A25772 guifg=#EEF5FF")
end

return {
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = { enabled = false },
			indent = { enabled = false },
			input = { enabled = false },
			notifier = { enabled = false },
			scope = { enabled = false },
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			toggle = { map = LazyVim.safe_keymap_set },
			words = { enabled = false },
		},
	},
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
		},
		cmd = { "Gedit", "Git", "Gsplit" },
	},
	{ "tpope/vim-surround" },
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewFileHistory %" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view for index" },
			{ "<leader>gl", "<cmd>DiffviewFileHistory<cr>", desc = "Open git log" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {
					autostart = true,
				},
				ruff = {
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

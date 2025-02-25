local function setupCustomHighlightGroup()
	vim.api.nvim_command("hi clear FlashMatch")
	vim.api.nvim_command("hi clear FlashCurrent")
	vim.api.nvim_command("hi clear FlashLabel")

	vim.api.nvim_command("hi FlashMatch guibg=#4A47A3 guifg=#B8B5FF") -- Emerald background
	vim.api.nvim_command("hi FlashCurrent guibg=#456268 guifg=#D0E8F2")
	vim.api.nvim_command("hi FlashLabel guibg=#A25772 guifg=#EEF5FF")
end
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")

local function set_git_cwd_args(opts)
	-- verify cwd is a git repo, override user supplied
	-- cwd if cwd isn't a git repo, error was already
	-- printed to `:messages` by 'path.git_root'
	local git_root = path.git_root(opts)
	if not opts.cwd or not git_root then
		opts.cwd = git_root
	end
	if opts.git_dir or opts.git_worktree then
		opts.cmd = path.git_cwd(opts.cmd, opts)
	end
	return opts
end

local function git_cmd(opts)
	opts = set_git_cwd_args(opts)
	if not opts.cwd then
		return
	end
	opts = core.set_header(opts, opts.headers or { "cwd" })
	core.fzf_exec(opts.cmd, opts)
end

local function line_search(opts)
	opts = config.normalize_opts(opts, "git.commits")
	if not opts then
		return
	end
	if opts.preview then
		opts.preview = path.git_cwd(opts.preview, opts)
		if type(opts.preview_pager) == "function" then
			opts.preview_pager = opts.preview_pager()
		end
		if opts.preview_pager then
			opts.preview = string.format("%s | %s", opts.preview, utils._if_win_normalize_vars(opts.preview_pager))
		end
	end
	opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
	local line_start = vim.fn.getpos("v")[2]
	local line_end = vim.fn.getpos(".")[2]

	-- If a visual selection starts at the bottom and moves up, cursor pos is prior to beginning of selection
	-- Likewise if user press ctrl+o to toggle which end of visual selection to set cursor
	if line_start > line_end then
		line_start, line_end = line_end, line_start
	end

	opts.cmd = "git log -L"
		.. line_start
		.. ","
		.. line_end
		.. ":"
		.. vim.api.nvim_buf_get_name(0)
		.. " -s --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'"
	return git_cmd(opts)
end

local function pickaxe_search(opts)
	opts = config.normalize_opts(opts, "git.commits")
	if not opts then
		return
	end
	if opts.preview then
		opts.preview = path.git_cwd(opts.preview, opts)
		if type(opts.preview_pager) == "function" then
			opts.preview_pager = opts.preview_pager()
		end
		if opts.preview_pager then
			opts.preview = string.format("%s | %s", opts.preview, utils._if_win_normalize_vars(opts.preview_pager))
		end
	end
	opts = core.set_header(opts, opts.headers or { "actions", "cwd" })
	local user_input = vim.fn.input("Enter string to search for:")
	opts.cmd = "git log -S'"
		.. user_input
		.. "' --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'"
	return git_cmd(opts)
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
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
		},
		cmd = { "Gedit", "Git", "Gsplit" },
	},
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader>gc", false },
			{ "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "Git log" },
			{ "<leader>gL", "<cmd>FzfLua git_bcommits<CR>", desc = "Git log buffer" },
			{ "<leader>gs", false },
			{ "<leader>gS", pickaxe_search, desc = "Git Search all commit body (pickaxe)" },
			{ "<leader>gS", mode = { "v" }, line_search, desc = "Git search visual selection" },
		},
	},
	{ "tpope/vim-surround" },
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewFileHistory %" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open diff view for index" },
			{ "<leader>gD", "<cmd>DiffviewFileHistory<cr>", desc = "Open Git Log with diffs" },
			{ "<leader>gl", mode = { "v" }, ":DiffviewFileHistory<cr>", desc = "Open log for selected range" },
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

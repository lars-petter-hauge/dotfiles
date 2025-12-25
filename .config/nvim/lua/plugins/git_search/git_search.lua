-- Author of git repo tried to create some git functionality not found in plugins
-- Doing line search and pickaxe search with fzf lua.

local M = {}

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

function M.line_search(opts)
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

	local line_start = math.min(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])
	local line_end = math.max(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])

	opts.cmd = "git log -L"
		.. line_start
		.. ","
		.. line_end
		.. ":"
		.. vim.api.nvim_buf_get_name(0)
		.. " -s --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'"
	return git_cmd(opts)
end

function M.history_search(opts)
	opts = config.normalize_opts(opts, "git.commits")
	if not opts then
		return
	end

	local mode = vim.api.nvim_get_mode().mode
	if mode == "v" or mode == "V" then
		local reg_opts = {}
		reg_opts.type = mode
		local user_input = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), reg_opts)
		user_input = table.concat(user_input, "\n")
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
		opts.cmd = "git log -S'"
			.. user_input
			.. "' --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'"
		return git_cmd(opts)
	end

	opts = set_git_cwd_args(opts)
	if not opts.cwd then
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
	opts.prompt = "GitSearch> "
	opts.exec_empty_query = false

	return core.fzf_live(function(args)
		local query = args or ""
		if type(query) == "table" then
			query = args[1] or ""
		end
		return "git log -S" .. vim.fn.shellescape(query) .. " --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'"
	end, opts)
end

return M

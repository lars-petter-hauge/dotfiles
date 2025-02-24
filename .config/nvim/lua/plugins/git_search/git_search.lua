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

function M.history_search(opts)
	-- The search function is not ideal. First off, the preview shows the entire commit, makes more sense to
	-- show only the locations where a match has been found. Furthermore it would be better to open the fzf search
	-- immediately instead of giving a prompt, and then to live matching on searching the commit history
	-- There could be performance issues on this though, unsure how to handle those.
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

return M

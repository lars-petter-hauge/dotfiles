local M = {}

-- Get the visual selection text
local function get_visual_selection()
	local reg_opts = { type = vim.fn.mode() }
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), reg_opts)
	local line_start = math.min(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])
	local line_end = math.max(vim.fn.getpos("v")[2], vim.fn.getpos(".")[2])

	return {
		text = table.concat(lines, "\n"),
		line_start = line_start,
		line_end = line_end,
	}
end

-- Create and execute a script that launches copilot in tmux
local function launch_copilot(prompt)
	local script = os.tmpname()
	local s, err = io.open(script, "w")
	if not s then
		vim.notify("Failed to create script: " .. (err or "unknown error"), vim.log.levels.ERROR)
		return
	end

	s:write("#!/bin/bash\n")
	s:write("copilot -i \"$(cat <<'COPILOT_EOF'\n")
	s:write(prompt)
	s:write("\nCOPILOT_EOF\n")
	s:write(')"\n')
	s:write(string.format("rm '%s'\n", script))
	s:close()
	os.execute("chmod +x " .. script)

	vim.fn.system(string.format("tmux split-window -v '%s'", script))
end

-- Build the full prompt with context
local function build_prompt(context, selection)
	local filepath = vim.fn.expand("%:p")
	local line_range = string.format("lines %d-%d", selection.line_start, selection.line_end)

	return context .. "\n\nFrom file: " .. filepath .. " (" .. line_range .. ")\n\n```\n" .. selection.text .. "\n```"
end

-- Show floating input window for user context
local function show_context_input(selection, on_submit)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.3)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		style = "minimal",
		border = "rounded",
		title = " Add context for Copilot ",
		title_pos = "center",
	})

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "markdown"

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "# Add your context/question here, then press <C-s> to send", "" })

	-- Submit with Ctrl-s
	vim.keymap.set({ "n", "i" }, "<C-s>", function()
		if vim.api.nvim_get_mode().mode == "i" then
			vim.cmd("stopinsert")
		end

		local user_input = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		table.remove(user_input, 1) -- Remove instruction line
		local context = table.concat(user_input, "\n")

		vim.api.nvim_win_close(win, true)

		local prompt = build_prompt(context, selection)
		on_submit(prompt)
	end, { buffer = buf, desc = "Send to Copilot" })

	-- Cancel with Esc
	vim.keymap.set({ "n", "i" }, "<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, desc = "Cancel" })

	-- Start in insert mode on second line
	vim.cmd("startinsert")
	vim.api.nvim_win_set_cursor(win, { 2, 0 })
end

-- Main function
function M.ask_copilot()
	local selection = get_visual_selection()
	show_context_input(selection, launch_copilot)
end

return {
	{
		"LazyVim",
		keys = {
			{
				"<leader>ac",
				M.ask_copilot,
				mode = "v",
				desc = "Ask Copilot about selection",
			},
		},
	},
}

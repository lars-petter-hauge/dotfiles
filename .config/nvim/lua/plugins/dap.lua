
-- Wrap the continue function to enable loading launch.json.
-- An added benefit of doing this on every call to continue
-- is that changes to launch.json will be included immediately.
-- Credits go to https://github.com/mfussenegger/nvim-dap/issues/20
local continue = function()
	if vim.fn.filereadable(".vscode/launch.json") then
		require("dap.ext.vscode").load_launchjs()
	end
	require("dap").continue()
end

local function open_floating()
	-- Prompts user to select one of the elements in dapui to open as a floating
	-- element. Size will be the same as the current window in focus
	local height = vim.api.nvim_win_get_height(0)
	local width = vim.api.nvim_win_get_width(0)
	-- float_element should prompt user if window id, first argument is not passed.
	-- however nothing appears if one doesn't give _anything_ at all. Hence a dummy
	-- _ value is provided
	require("dapui").float_element(_, { height = height, width = width, position = "center", enter = true })
end


return {
  "mfussenegger/nvim-dap",
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", continue, desc = "Run/Continue (F5)" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>ds", function() require("dap").step_over() end, desc = "Step Over (F1)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (F2)" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out (F3)" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate (F4)" },
    { "<leader>dj", function() require("dap").down() end, desc = "Step Down (Stack) (F6)" },
    { "<leader>dk", function() require("dap").up() end, desc = "Step Up (Stack) (F7)" },
    { "<leader>dr", function() require("dap").restart() end, desc = "Restart Session (F8)" },
    { "<F1>", function() require("dap").step_over() end, desc = "Step Over (F1)" },
    { "<F2>", function() require("dap").step_into() end, desc = "Step Into (F2)" },
    { "<F3>", function() require("dap").step_out() end, desc = "Step Out (F3)" },
    { "<F4>", function() require("dap").terminate() end, desc = "Terminate (F4)" },
    { "<F5>", continue, desc = "Run/Continue (F5)" },
    { "<F6>", function() require("dap").down() end, desc = "Step Down (Stack) (F6)" },
    { "<F7>", function() require("dap").up() end, desc = "Step Up (Stack) (F7)" },
    { "<F8>", function() require("dap").restart() end, desc = "Restart Session (F8)" },
		p = { open_floating, "Pop out window" },
  }
}

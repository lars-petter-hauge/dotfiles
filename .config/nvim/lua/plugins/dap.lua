
-- The order of the layouts matters. If the layouts that cover bottom is defined first
-- they will cover the entire bottom. Therefore we define sidebar first, as we want the entire
-- vertical sidebar to be filled with elements, and the bottom layout should only be below
-- main window
local layouts = {
	{
		elements = {
			{
				id = "stacks",
				size = 0.25,
			},
			{
				id = "scopes",
				size = 0.75,
			},
		},
		position = "left",
		size = 40,
	},
	{
		elements = {
			{
				id = "stacks",
				size = 0.25,
			},
			{
				id = "breakpoints",
				size = 0.25,
			},
			{
				id = "watches",
				size = 0.25,
			},
			{
				id = "scopes",
				size = 0.25,
			},
		},
		position = "left",
		size = 40,
	},
	{
		elements = { "repl", "console" },
		size = 15,
		position = "bottom",
	},
}

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

local function toggle_sidelayout()
	-- Toggles between two sidebar layouts, one with some elements, other with all
	-- Layouts are defined further down
	require("dapui").toggle({ layout = 1 })
	require("dapui").toggle({ layout = 2 })
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = function()
      return {
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
        { "<leader>dp", open_floating, desc = "Pop out window" },
        { "<leader>dh", toggle_sidelayout, desc = "Toggle sidebar" },
      }
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({ layouts = layouts })
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = 1 })
        dapui.open({ layout = 3 })
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
      end,
  },
}

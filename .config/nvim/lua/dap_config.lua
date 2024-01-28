local vim = vim
------------ Debug adapters --------------
local dap, dapui, dap_python = require("dap"), require("dapui"), require("dap-python")

-- Expect that debugpy was installed (Is set to autoinstall through Mason)
dap_python.setup(HOME .."/.pyenv/versions/nvim_env/bin/python")
dap_python.test_runner = "pytest"

local wk = require("which-key")

local function open_floating()
    -- Prompts user to select one of the elements in dapui to open as a floating
    -- element. Size will be the same as the current window in focus
    local height = vim.api.nvim_win_get_height(0)
    local width = vim.api.nvim_win_get_width(0)
    -- float_element should prompt user if window id, first argument is not passed.
    -- however nothing appears if one doesn't give _anything_ at all. Hence a dummy
    -- _ value is provided
    dapui.float_element(_ ,{height = height, width = width, position='center', enter=true})
end

wk.register({
  ["<leader>d"] = {
    name = "Debug Operations",
    c = {function() dap.continue() end, "Continue"},
    s = {function() dap.step_over() end, "Step Over"},
    i = {function() dap.step_into() end, "Step Into"},
    u = {function() dap.up() end, "Step Up (Stack)"},
    d = {function() dap.down() end, "Step Down (Stack)"},
    o = {function() dap.step_out() end, "Step Out"},
    e = {function() dap.terminate() end, "End"},
    b = {function() dap.toggle_breakpoint() end, "Set Breakpoint"},
    r = {function() dap.repl.open() end, "Open Repl"},
    t = {function() dap_python.test_method() end, "Debug Test Method (at cursor)"},
    p = {open_floating, "Pop out window"},
  },
})

table.insert(dap.configurations.python, 1, {
  name = 'Debug file',
  type = 'python',
  request = 'launch',
  program = '${file}',
  console="integratedTerminal",
  justMyCode = false,
})

-- Expect that the cpptools server was installed with Mason
local debug_loc = vim.fn.stdpath('data') .. "/mason/bin/OpenDebugAD7"

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = debug_loc,
}

dap.configurations.cpp = {{
  name = 'Debug file',
  type = 'cppdbg',
  request = 'launch',
  program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  console="integratedTerminal",
  justMyCode = false,
  cwd = '${workspaceFolder}',
}}

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

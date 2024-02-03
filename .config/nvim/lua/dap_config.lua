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

local function toggle_sidelayout()
    -- Toggles between two sidebar layouts, one with some elements, other with all
    -- Layouts are defined further down
    dapui.toggle({layout=1})
    dapui.toggle({layout=2})
end

wk.register({
  ["<leader>d"] = {
    name = "Debug Operations",
    c = {function() dap.continue() end, "Continue (F5)"},
    s = {function() dap.step_over() end, "Step Over (F1)"},
    i = {function() dap.step_into() end, "Step Into (F2)"},
    o = {function() dap.step_out() end, "Step Out (F3)"},
    e = {function() dap.terminate() end, "End (F4)"},
    d = {function() dap.down() end, "Step Down (Stack) (F6)"},
    u = {function() dap.up() end, "Step Up (Stack) (F7)"},
    b = {function() dap.toggle_breakpoint() end, "Set Breakpoint"},
    t = {function() dap_python.test_method() end, "Debug Test Method (at cursor)"},
    p = {open_floating, "Pop out window"},
    h = {toggle_sidelayout, "Toggle sidebar"},
  },
})
-- Also map to function keys
vim.keymap.set('n', '<F5>', function() dap.continue() end, {desc="Continue"})
vim.keymap.set('n', '<F1>', function() dap.step_over() end, {desc="Step Over"})
vim.keymap.set('n', '<F2>', function() dap.step_into() end, {desc="Step Into"})
vim.keymap.set('n', '<F3>', function() dap.step_out() end, {desc="Step Out"})
vim.keymap.set('n', '<F4>', function() dap.terminate() end, {desc="End"})
vim.keymap.set('n', '<F6>', function() dap.down() end, {desc="Step Down (Stack)"})
vim.keymap.set('n', '<F7>', function() dap.up() end, {desc="Step Up (Stack)"})

wk.register({
  ["<leader>da"] = {
    name = "Exception Handling",
    n = {function() dap.set_exception_breakpoints({}) end, "Set no exception catching"},
    d = {function() dap.set_exception_breakpoints({'default'}) end, "Set Default exception catching"},
    r = {function() dap.set_exception_breakpoints({'raised'}) end, "Set Raised exception catching"},
    u = {function() dap.set_exception_breakpoints({'uncaught'}) end, "Set Uncaught exception catching"},
    U = {function() dap.set_exception_breakpoints({'unhandled'}) end, "Set Unhandled exception catching"},
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
local debug_loc = vim.fn.stdpath('data') .. "/mason/bin/"

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = debug_loc .. "OpenDebugAD7",
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

dap.adapters.lldb = {
  type = "server",
  port = "${port}",
  host = "127.0.0.1",
  executable = {
    command = debug_loc.."codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.rust = {
    {
        name = "Debug File",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        showDisassembly = "never",
        stopOnEntry = false,
        cwd = "${workspaceFolder}",
    }
}

-- The order of the layouts matters. If the layouts that cover bottom is defined first
-- they will cover the entire bottom. Therefore we define sidebar first, as we want the entire
-- vertical sidebar to be filled with elements, and the bottom layout should only be below
-- main window
local layouts = {
    {
        elements = { {
            id = "stacks",
            size = 0.25
          },{
            id = "scopes",
            size = 0.75
          } },
        position = "left",
        size = 40
    },
    {
        elements = { {
            id = "stacks",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          }, {
            id = "scopes",
            size = 0.25
          } },
        position = "left",
        size = 40
    },
    {
        elements = { "repl", "console"},
        size = 15,
        position = "bottom",
    },
}


dapui.setup({layouts=layouts})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({layout=1})
  dapui.open({layout=3})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


------------ Debug adapters --------------
local dap, dapui, dap_python = require("dap"), require("dapui"), require("dap-python")

dap_python.setup(HOME .."/.pyenv/versions/nvim_env/bin/python")
dap_python.test_runner = "pytest"
local wk = require("which-key")

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
  },
})


table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Debug file',
  program = '${file}',
  console="integratedTerminal",
})

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

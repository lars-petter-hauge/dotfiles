

local vim = vim
------------ Debug adapters --------------
local dap, dapui, dap_python = require("dap"), require("dapui"), require("dap-python")

dap_python.setup(HOME .."/.pyenv/versions/nvim_env/bin/python")
dap_python.test_runner = "pytest"

vim.keymap.set('n', '<F1>', function() dap.continue() end)
vim.keymap.set('n', '<F2>', function() dap.step_over() end)
vim.keymap.set('n', '<F3>', function() dap.step_into() end)
vim.keymap.set('n', '<F4>', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dt', function() dap_python.test_method() end)

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

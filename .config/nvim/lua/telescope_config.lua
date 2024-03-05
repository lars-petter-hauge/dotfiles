
local actions = require('telescope.actions')
require("telescope").setup {
  defaults = {
    theme = "center",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.3,
      },
    },
    mappings = {
      i = {
        ["<C-q>"]   = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },
  },
}

require("telescope").load_extension "file_browser"

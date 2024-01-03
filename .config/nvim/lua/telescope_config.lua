
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
  },
}

require("telescope").load_extension "file_browser"

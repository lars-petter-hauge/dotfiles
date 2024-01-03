
local vim = vim
------------ Colors and style --------------
require("tokyonight").setup({
  style = "storm", --`storm`, `moon`, a darker variant `night` and `day`
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = "storm",
    floats = "storm",
  },
  on_highlights = function(hl, colors)
    hl.LineNr = {
      fg = colors.yellow
    }
    hl.CursorLine = {
      bg = colors.bg_dark
    }
  end
})

local colors = require("tokyonight.colors").setup()
require("scrollbar").setup({
    handle = {
        color = colors.bg_highlight,
    },
    marks = {
        Search = { color = colors.orange },
        Error = { color = colors.error },
        Warn = { color = colors.warning },
        Info = { color = colors.info },
        Hint = { color = colors.hint },
        Misc = { color = colors.purple },
    }
})

vim.cmd[[colorscheme tokyonight]]

require("ibl").setup()

------------ Syntax highlighting --------------
require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query","python","rust" },
    auto_install = true,
    highlight = {
        enable = true
    }
})

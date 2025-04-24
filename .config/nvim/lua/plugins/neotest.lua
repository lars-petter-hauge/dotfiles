return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Run Nearest (neotest debug)",
      },
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
        },
      },
    },
  },
}

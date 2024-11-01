return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require "nvim-treesitter.configs"

    -- configure treesitter
    treesitter.setup {
      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = true },

      auto_install = true,

      ensure_installed = {
        "json",
        "lua",
        "c",
        "zig",
        "rust",
        "ruby",
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-w>",
          node_incremental = "<C-w>",
          scope_incremental = false,
          node_decremental = "<C-r>",
        },
      },
    }
  end,
}

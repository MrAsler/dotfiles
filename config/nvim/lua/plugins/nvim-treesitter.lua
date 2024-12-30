-- https://github.com/nvim-treesitter/nvim-treesitter
-- Tree-sitter is a parser generator tool and an incremental parsing library. 
-- It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited. 

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

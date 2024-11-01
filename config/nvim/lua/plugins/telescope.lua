return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local telescope = require "telescope"
    telescope.setup {
      defaults = {
        path_display = { "smart" },
      },
    }

    telescope.load_extension "fzf"

    local map = vim.keymap.set
    local builtin = require "telescope.builtin"
    map("n", "<leader>pf", builtin.find_files, { desc = "Telescope find project files" })
    map("n", "<C-p>", builtin.git_files, { desc = "Telescope find git tracked files" })
    map("n", "<leader>pg", builtin.live_grep, { desc = "Telescope live grep" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    map("n", "<leader>fc", builtin.grep_string, { desc = "Telescope find string under cursor" })
    map("n", "<leader>fc", builtin.grep_string, { desc = "Telescope find string under cursor" })
    map("n", "<leader><leader>", builtin.oldfiles, { desc = "See old files" })
  end,
}

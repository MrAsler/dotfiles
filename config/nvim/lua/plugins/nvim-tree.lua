-- https://github.com/nvim-tree/nvim-tree.lua
-- A File Explorer For Neovim Written In Lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.termguicolors = true

    require("nvim-tree").setup {
      renderer = {
        group_empty = true,
        --hidden_display = "all",
      },
      filters = {
        dotfiles = false,
      },
    }
  end,
}

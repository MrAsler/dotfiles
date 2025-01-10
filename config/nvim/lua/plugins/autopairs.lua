-- https://github.com/windwp/nvim-autopairs
-- A super powerful autopair plugin for Neovim that supports multiple characters.

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  opts = function(_, opts)
    opts.check_ts = true -- enable treesitter
    opts.ts_config = {
      lua = { "string" }, -- it will not add a pair on that treesitter node
      javascript = { "template_string" },
    }

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp = require "cmp"

    -- make autopairs and completion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

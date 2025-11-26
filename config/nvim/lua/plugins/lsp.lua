-- https://github.com/neovim/nvim-lspconfig
-- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP client configurations for various LSP servers.
function formatter()
  return {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        ruby = { "rubocop" },
        rust = { "rustfmt" },
        go = { "goimports" },
        python = { "ruff_format" },
        bash = { "shfmt" },

        -- Frontend
        typescript = { 'prettierd', "prettier", stop_after_first = true },
        typescriptreact = { 'prettierd', "prettier", stop_after_first = true },
        javascript = { 'prettierd', "prettier", stop_after_first = true },
        javascriptreact = { 'prettierd', "prettier", stop_after_first = true },
        json = { 'prettierd', "prettier", stop_after_first = true },
        html = { 'prettierd', "prettier", stop_after_first = true },
        css = { 'prettierd', "prettier", stop_after_first = true },

      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  }
end

function linter()
  return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"

      lint.linters_by_ft = {
        go = { "golangcilint" },
        lua = { "luac" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = lint_augroup,
        callback = function() lint.try_lint() end,
      })

      vim.keymap.set("n", "<leader>li", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })

      local ns = require("lint").get_namespace("my_linter_name")
      --vim.diagnostic.config({ virtual_text = true }, ns)
    end,
  }
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",

      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      "j-hui/fidget.nvim",
    },
    lazy = false,

    config = function()
      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      require("fidget").setup {}
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          -- Lua
          "lua_ls", -- language server
          -- "stylua", -- formatter
          -- "luac", -- linter

          -- Golang
          "gopls",            -- language server
          -- "goimports", -- formatter
          "golangci_lint_ls", -- linter

          -- Rust (managed by `rustup`)
          -- "rustfmt", -- formatter"
          "rust_analyzer", -- language server

          -- Javascript
          -- Typescript
          "ts_ls",
          "eslint",
          "cssls",
          "tailwindcss",



          -- Python
          "pyright", -- language server
          "ruff",    -- formatter

          -- Zig
          "zls", -- Installed locally

          -- Shell
          "bashls", -- language server
          -- "shfmt", -- formatting

          -- Templating languages
          "cssls",
          "svelte",
          "jsonls",   -- JSON LS
          "html",     -- HTML language server
          "taplo",    -- TOML language server
          "yamlls",   -- YAML language server
          "lemminx",  -- XML language server
          "marksman", -- Markdown language server
        },
      }

      local cmp_nvim_lsp = require "cmp_nvim_lsp"

      local capabilities = cmp_nvim_lsp.default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local cmp = require "cmp"
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<Enter>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },
          ["<C-Space>"] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
        }),
      }

      -- From https://github.com/nvim-lua/kickstart.nvim/blob/a8f539562a8c5d822dd5c0ca1803d963c60ad544/init.lua#L545
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          --map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        end,
      })

      vim.diagnostic.config {
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }
    end,
  },
  formatter(),
  linter(),
}

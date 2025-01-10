-- https://github.com/neovim/nvim-lspconfig
-- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP client configurations for various LSP servers.

function configure_lsp_config()
  local cmp_lsp = require "cmp_nvim_lsp"
  local lsp_config = require "lspconfig"

  local capabilities =
    vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

  -- Lua
  lsp_config.lua_ls.setup {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = "Lua 5.4" },
        diagnostics = {
          globals = { "vim", "Snacks" },
        },
      },
    },
  }

  -- Go
  lsp_config.gopls.setup { capabilities = capabilities }

  -- Rust
  lsp_config.rust_analyzer.setup {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        procMacro = { enable = true },
        checkOnSave = { command = "clippy" },
      },
    },
  }

  -- Python
  lsp_config.pyright.setup {
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          diagnosticSeverityOverrides = {
            -- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-rule-defaults
            reportMissingImports = "error",
            reportUndefinedVariable = "none",
          },
          typeCheckingMode = "off",
        },
      },
    },
  }

  --  Bash
  lsp_config.bashls.setup { capabilities = capabilities }
  --  JSON
  lsp_config.jsonls.setup { capabilities = capabilities }
  -- HTML
  lsp_config.html.setup { capabilities = capabilities }
  -- TOML
  lsp_config.taplo.setup { capabilities = capabilities }
  -- YAML
  lsp_config.yamlls.setup { capabilities = capabilities }
  -- XML
  lsp_config.marksman.setup { capabilities = capabilities }
  -- Markdown
end

return {
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
        "lua-language-server", -- language server
        "stylua", -- formatter
        "luacheck", -- linter

        -- Golang
        "gopls", -- language server
        "goimports", -- formatter
        "golangci-lint", -- linter

        -- Rust (managed by `rustup`)
        -- "rustfmt", -- formatter"
        -- "rust-analyzer", -- language server

        -- Python
        "pyright", -- language server
        "ruff", -- formatter

        -- Shell
        "bash-language-server", -- language server
        "shfmt", -- formatting

        -- Templating languages
        "json-lsp", -- JSON LS
        "html-lsp", -- HTML language server
        "taplo", -- TOML language server
        "yaml-language-server", -- YAML language server
        "lemminx", -- XML language server
        "marksman", -- Markdown language server
      },
    }

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

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        -- Find references for the word under your cursor.
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map("gtd", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype [D]efinition")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
}

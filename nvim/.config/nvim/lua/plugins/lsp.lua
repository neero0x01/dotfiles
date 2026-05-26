-- Extra Mason tools not covered by LazyVim lang extras
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Formatters
        "prettierd",
        "php-cs-fixer",
        "isort",
        "ruff",
        "stylua",
        -- Linters
        "eslint_d",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- HTML / CSS / JSON handled by LazyVim core but ensure they're listed
        html = {},
        cssls = {},
        jsonls = {},
        -- Lua LSP config for editing Neovim configs
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      },
    },
  },
}

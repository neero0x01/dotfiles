return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = false,
        ["*"] = true,
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    -- nvim-cmp as dep ensures it loads first, then copilot-cmp registers its source
    dependencies = { "zbirenbaum/copilot.lua", "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    -- no copilot-cmp dependency here — avoids the circular dep that broke cmp loading
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
      return opts
    end,
  },
}

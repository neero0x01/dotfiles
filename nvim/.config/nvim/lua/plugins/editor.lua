return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then return 15
        elseif term.direction == "vertical" then return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 3,
      },
      highlights = {
        FloatBorder = { link = "FloatBorder" },
      },
      shade_terminals = false,
    },
  },
}

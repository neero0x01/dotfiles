-- LazyVim's coding.copilot extra already sets up copilot.lua + copilot-cmp.
-- This file only overrides defaults.
return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false }, -- use cmp source instead of inline ghost text
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = false,
        ["*"] = true,
      },
    },
  },
}

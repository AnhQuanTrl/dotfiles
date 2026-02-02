return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
        snacks = {
          enabled = true,
        }
      },
      custom_highlights = function(colors)
        return {
          SnacksInputBorder = { link = "FloatBorder" },
          SnacksInputTitle = { link = "FloatTitle" },
          SnacksInputNormal = { link = "NormalFloat" },
          SnacksInputIcon = { fg = colors.flamingo },
        }
      end
    },
    config = function(_, opts)
      local theme = require 'catppuccin'
      theme.setup(opts)
    end,
  }
}

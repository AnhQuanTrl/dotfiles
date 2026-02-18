return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
      integrations = {
        snacks = {
          enabled = true,
        },
        blink_cmp = {
          style = 'bordered',
        },
      },
      custom_highlights = function(colors)
        return {
          SnacksInputBorder = { link = 'FloatBorder' },
          SnacksInputTitle = { link = 'FloatTitle' },
          SnacksInputNormal = { link = 'NormalFloat' },
          SnacksInputIcon = { fg = colors.flamingo },
          FodedLineCount = { fg = colors.crust },
          -- remove flamingo color from the select because it is really hard to read.
          TelescopeSelection = { fg = 'NONE', bg = colors.surface0 },
          TelescopeSelectionCaret = { fg = colors.flamingo, bg = colors.surface0 },
          TelescopeMatching = { fg = colors.blue },
          -- make win separator much more easier to see
          WinSeparator = { fg = colors.pink },
        }
      end,
    },
    config = function(_, opts)
      local theme = require 'catppuccin'
      theme.setup(opts)
    end,
  },
}

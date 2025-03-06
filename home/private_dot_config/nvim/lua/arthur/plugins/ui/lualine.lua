local Util = require 'arthur.util'

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    -- Remove lualine if starting nvim without argument
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = 'catppuccin',
        globalstatus = vim.o.laststatus == 3,
        -- Disable for 'dashboard' type of files
        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
      },
      sections = {
        lualine_x = {
          {
            function()
              return require('noice').api.status.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.mode.has()
            end,
            color = Util.ui.fg 'Constant',
          },
          'filetype',
        },
      },
      extensions = { 'quickfix', 'nvim-tree', 'lazy' },
    }

    return opts
  end,
}

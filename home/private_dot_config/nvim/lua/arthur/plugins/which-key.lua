return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts_extend = { 'spec' },
  opts = function()
    local options = {
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>f', group = '[F]iles/[F]ind' },
          { '<leader>u', group = '[U]I' },
          { '<leader>c', group = '+[C]ode' },
        },
      },
    }

    if require('arthur.util').has 'noice.nvim' then
      table.insert(options.spec[1], { '<leader>sn', group = '[N]oice' })
    end

    return options
  end,
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)
  end,
}

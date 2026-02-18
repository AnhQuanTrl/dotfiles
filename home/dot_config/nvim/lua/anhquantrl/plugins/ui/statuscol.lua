return {
  {
    'luukvbaal/statuscol.nvim',
    event = { 'LazyFile' },
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        setopt = true,
        relculright = true,
        ft_ignore = {
          'help',
          'NvimTree',
          'TelescopePrompt',
        },
        bt_ignore = {
          'help',
          'prompt',
        },
        segments = {
          {
            sign = { namespace = { 'diagnostic' }, maxwidth = 1, auto = false },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
          {
            text = { builtin.foldfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScFa',
          },
          {
            sign = { name = { '.*' }, maxwidth = 2, auto = true, wrap = true },
            click = 'v:lua.ScSa',
          },
        },
      }
    end,
  },
}

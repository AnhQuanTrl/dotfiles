return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      -- Document existing key chains
      spec = {
        { '<leader>f', group = '[F]iles', mode = { 'n', 'v' } },
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>c', group = '[C]ode', mode = { 'n', 'v' } },
        -- { '<leader>t', group = '[T]oggle' },
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
}

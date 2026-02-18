return {
  {
    'mikavilpas/yazi.nvim',
    version = '*', -- use the latest stable version
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    keys = {
      {
        '<leader>fY',
        '<cmd>Yazi cwd<cr>',
        desc = '[F]ile: [Y]azi (cwd)',
      },
      {
        '<leader>fy',
        '<cmd>Yazi<cr>',
        desc = '[F]ile: [Y]azi (current file)',
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = false,
    },
  },
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { 'python' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pylsp = {
          mason = false,
          settings = {
            pylsp = {
              plugins = {
                ruff = {
                  enabled = true, -- Enable the plugin
                  formatEnabled = true, --
                },
                -- rope_autoimport = {
                --   enabled = true,
                -- },
              },
            },
          },
        },
      },
    },
  },
}

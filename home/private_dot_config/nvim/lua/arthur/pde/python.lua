local Util = require 'arthur.util'

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
        basedpyright = {
          mason = false,
          settings = {
            basedpyright = {},
          },
        },
        ruff_lsp = {
          mason = false,
          keys = {
            {
              '<leader>co',
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { 'source.organizeImports' },
                    diagnostics = {},
                  },
                }
              end,
              desc = 'Organize Imports',
            },
          },
          settings = {},
        },
      },
      setup = {
        ruff_lsp = function()
          Util.lsp.on_attach(function(client, _)
            if client.name == 'ruff_lsp' then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
}

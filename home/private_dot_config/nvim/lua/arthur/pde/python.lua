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
            basedpyright = {
              disableOrganizeImports = true,
              -- Settings should be set in pyproject.toml instead.
              --
              -- analysis = {
              --   diagnosticSeverityOverrides = {
              --     reportAny = false,
              --   },
              -- },
            },
          },
        },
        ruff = {
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
          trace = 'messages',
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
        },
      },
      setup = {
        ruff = function()
          Util.lsp.on_attach(function(client, _)
            if client.name == 'ruff' then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      'mfussenegger/nvim-dap-python',
      config = function()
        require('dap-python').setup(Util.get_pkg_path('debugpy', '/venv/bin/python'))
      end,
    },
  },
  -- Don't mess up DAP adapters provided by nvim-dap-python
  {
    'jay-babu/mason-nvim-dap.nvim',
    optional = true,
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}

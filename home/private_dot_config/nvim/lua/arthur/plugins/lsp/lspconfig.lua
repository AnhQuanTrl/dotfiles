local Util = require 'arthur.util'

return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
      -- 'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      diagnostics = {
        underline = true,
        virtual_text = {
          source = 'if_many',
        },
        severity_sort = true,
      },
      servers = {},
      setup = {},
      actions = {},
    },
    config = function(_, opts)
      Util.format.register(Util.lsp.formatter())

      -- Attach keymap when lsp attach
      Util.lsp.on_attach(function(client, buffer)
        require('arthur.plugins.lsp.util.keymaps').on_attach(buffer)
      end)

      -- For dynamic capabilities
      local register_capability = vim.lsp.handlers['client/registerCapability']
      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local buffer = vim.api.nvim_get_current_buf()
        require('arthur.plugins.lsp.util.keymaps').on_attach(buffer)
        return ret
      end

      -- Diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Inlay hint
      local inlay_hint = vim.lsp.inlay_hint
      Util.lsp.on_attach(function(client, buf)
        if client.supports_method 'textDocument/inlayHint' then
          inlay_hint.enable(true, { bufnr = buf })
        end
      end)

      -- Codelens
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        callback = function(event)
          local buf = event.buf
          local clients = vim.lsp.get_clients {
            bufnr = buf,
          }
          local supported_clients = vim.tbl_filter(function(client)
            return client.supports_method 'textDocument/codeLens'
          end, clients)
          if #supported_clients > 0 then
            vim.lsp.codelens.refresh {
              bufnr = buf,
            }
          end
        end,
      })

      local servers = opts.servers
      -- local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local blink = require 'blink-cmp'
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        -- has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        blink.get_lsp_capabilities(),
        opts.capabilities or {}
      ) --[[@as table]]

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup['*'] then
          if opts.setup['*'](server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
      end
    end,
  },
  -- {
  --   'jmederosalvarado/roslyn.nvim',
  --   dependencies = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
  --   event = 'LazyFile',
  --   config = function()
  --     ---@type table|nil
  --     local capabilities = require('cmp_nvim_lsp').default_capabilities()
  --     capabilities = vim.tbl_deep_extend('force', capabilities, {
  --       workspace = {
  --         didChangeWatchedFiles = {
  --           dynamicRegistration = false,
  --         },
  --       },
  --       textDocument = {
  --         codeLens = {
  --           dynamicRegistration = false,
  --         },
  --       },
  --     })
  --     capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), capabilities)
  --     require('roslyn').setup {
  --       capabilities = capabilities,
  --       on_attach = function() end,
  --     }
  --   end,
  -- },
}

return {
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    config = function()
      -- Setup autocmds and handlers
      Util.lsp.setup()

      -- lua_ls config
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config')
              and (vim.uv.fs_stat(path .. '/.luarc.json')
              or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = { Lua = {} },
      })

      vim.lsp.enable('lua_ls')
    end,
  },
}

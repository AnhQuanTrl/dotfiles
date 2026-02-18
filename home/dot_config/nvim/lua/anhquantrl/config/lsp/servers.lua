vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    -- lua language server is super confused when editing lua files in the config
    -- and raises a lot of [duplicate-doc-field] warnings
    local runtime_files = vim.tbl_filter(function(d)
      return not d:match(vim.fn.stdpath 'config' .. '/?a?f?t?e?r?')
    end, vim.api.nvim_get_runtime_file('', true))

    -- Add nvim runtime libraries and luv addon to LSP-aware libraries
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.tbl_extend('force', runtime_files, { '${3rd}/luv/library' }),
      },
    })
  end,
  settings = { Lua = {} },
})

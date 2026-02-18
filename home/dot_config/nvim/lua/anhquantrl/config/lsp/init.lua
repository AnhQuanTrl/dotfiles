local _done = {} ---@type table<string, boolean>

---@param buf number
---@param method string
---@return boolean
local function should_handle(buf, method)
  local key = ('%d:%s'):format(buf, method)
  if _done[key] then
    return false
  end
  _done[key] = true
  return true
end

---@param buf number
local function on_detach(buf)
  -- Only cleanup when no LSP clients remain
  if #vim.lsp.get_clients { bufnr = buf } > 0 then
    return
  end

  local prefix = ('%d:'):format(buf)
  for key in pairs(_done) do
    if key:sub(1, #prefix) == prefix then
      _done[key] = nil
    end
  end
  vim.lsp.buf.clear_references()
  vim.api.nvim_clear_autocmds { group = 'anhquantrl-lsp-highlight', buffer = buf }
end

---@param client vim.lsp.Client
---@param buf number
local function on_attach(client, buf)
  require('anhquantrl.config.lsp.keymaps').on_attach(client, buf)

  -- Folding
  if client:supports_method 'textDocument/foldingRange' and should_handle(buf, 'textDocument/foldingRange') then
    require('anhquantrl.config.fold').setup(buf)
  end

  -- Document highlight
  if client:supports_method 'textDocument/documentHighlight' and should_handle(buf, 'textDocument/documentHighlight') then
    local group = vim.api.nvim_create_augroup('anhquantrl-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = buf,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = buf,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Inlay hints
  if client:supports_method 'textDocument/inlayHint' and should_handle(buf, 'textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end
end

require 'anhquantrl.config.lsp.servers'

local group = vim.api.nvim_create_augroup('anhquantrl-lsp', { clear = true })

-- LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      on_attach(client, ev.buf)
    end
  end,
})

-- Dynamic registration
vim.lsp.handlers['client/registerCapability'] = (function(orig)
  return function(err, res, ctx)
    local result = orig(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for buf in pairs(client.attached_buffers) do
        on_attach(client, buf)
      end
    end
    return result
  end
end)(vim.lsp.handlers['client/registerCapability'])

-- LspDetach
vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function(ev)
    on_detach(ev.buf)
  end,
})

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'vtsls'

local _done = {} ---@type table<string, boolean>
local Util = require 'anhquantrl.util'

---@param client_id number
---@param buf number
---@param method string
---@return boolean
local function should_handle(client_id, buf, method)
  local key = ("%d:%d:%s"):format(client_id, buf, method)
  if _done[key] then return false end
  _done[key] = true
  return true
end

---@param client_id number
---@param buf number
local function on_detach(client_id, buf)
  local prefix = ("%d:%d:"):format(client_id, buf)
  for key in pairs(_done) do
    if key:sub(1, #prefix) == prefix then
      _done[key] = nil
    end
  end
  vim.lsp.buf.clear_references()
  vim.api.nvim_clear_autocmds { group = 'anhquantrl-lsp-highlight', buffer = buf }
end

---@param buf number
local function set_keymaps(buf)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
  end

  map('grD', vim.lsp.buf.declaration, 'Goto Declaration')
  map('grd', vim.lsp.buf.definition, 'Goto Definition')
end

---@param client vim.lsp.Client
---@param buf number
local function on_attach(client, buf)
  set_keymaps(buf)

  -- Folding
  if client:supports_method('textDocument/foldingRange')
    and should_handle(client.id, buf, 'textDocument/foldingRange') then
    Util.fold.setup(buf)
  end

  -- Document highlight
  if client:supports_method('textDocument/documentHighlight')
    and should_handle(client.id, buf, 'textDocument/documentHighlight') then
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
  if client:supports_method('textDocument/inlayHint')
    and should_handle(client.id, buf, 'textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end
end

require('anhquantrl.lsp.servers')

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
    on_detach(ev.data.client_id, ev.buf)
  end,
})

vim.lsp.enable("lua_ls")

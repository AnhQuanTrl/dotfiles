local M = {}

local default_lsp_keys_to_remove = {
  { 'n', 'grn' }, -- Rename
  { 'n', 'gra' }, -- Code Action
  { 'n', 'grr' }, -- References
  { 'n', 'gri' }, -- Implementation
  { 'n', 'grt' }, -- Type Definition
}

---@param client vim.lsp.Client
---@param buf number
local function set_keymaps(client, buf)
  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
  end

  local function map_if(method, keys, func, desc, mode)
    -- accept "definition" or "textDocument/definition"
    local m = method:find '/' and method or ('textDocument/' .. method)
    if client:supports_method(m) then
      map(keys, func, desc)
    end
  end

  local tb = require 'telescope.builtin'

  map_if('definition', 'gd', function()
    tb.lsp_definitions { reuse_win = true }
  end, 'Goto Definition')
  map_if('references', 'gr', tb.lsp_references, 'Goto References')
  map_if('declaration', 'gD', vim.lsp.buf.declaration, 'Goto Declaration')
  map_if('typeDefinition', 'gy', function()
    tb.lsp_type_definitions { reuse_win = true }
  end, 'Goto Type Definition')
  map_if('implementation', 'gI', function()
    tb.lsp_implementations { reuse_win = true }
  end, 'Goto Implementation')

  map_if('codeAction', '<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'v' })
  map_if('rename', '<leader>cr', vim.lsp.buf.rename, 'Rename')
end

---@param client vim.lsp.Client
---@param buf number
function M.on_attach(client, buf)
  for _, map in ipairs(default_lsp_keys_to_remove) do
    pcall(vim.keymap.del, map[1], map[2])
  end
  set_keymaps(client, buf)
end

return M

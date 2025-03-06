local LazyUtil = require 'lazy.core.util'

---@class arthur.util: LazyUtilCore
---@field telescope arthur.util.telescope
---@field lsp arthur.util.lsp
---@field format arthur.util.format
---@field sourceaction arthur.util.sourceaction
---@field cmp arthur.util.cmp
---@field root arthur.util.root
local M = {}

setmetatable(M, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    t[k] = require('arthur.util.' .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.uv.os_uname().sysname:find 'Windows' ~= nil
end

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local Config = require 'lazy.core.config'
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes('<c-G>u', true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == 'i' then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, 'n', false)
  end
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, 'mason') -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ''
  local ret = root .. '/packages/' .. pkg .. '/' .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require('lazy.core.config').headless() then
    M.warn(('Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package.'):format(pkg, path))
  end
  return ret
end

return M

-- Lazy nvim package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }

local function lazy_file()
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd('BufReadPost', {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match { buf = event.buf }
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd [[redraw]]
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require 'lazy.core.handler.event'

  Event.mappings.LazyFile = { id = 'LazyFile', event = lazy_file_events }
  Event.mappings['User LazyFile'] = Event.mappings.LazyFile
end

lazy_file()

require('lazy').setup {
  spec = {
    { import = 'arthur.plugins' },
    { import = 'arthur.plugins.lsp' },
    { import = 'arthur.plugins.ui' },
    { import = 'arthur.plugins.coding' },
    { import = 'arthur.pde' },
  },
  defaults = { lazy = true, version = nil },
}

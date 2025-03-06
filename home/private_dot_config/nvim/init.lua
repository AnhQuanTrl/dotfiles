require 'arthur.core.options'
require 'arthur.core.lazy'

local Util = require 'arthur.util'

if vim.fn.argc(-1) == 0 then
else
  Util.format.setup()
  require 'arthur.core.keymaps'
end

local nvim_start_without_args = vim.fn.argc(-1) == 0
if not nvim_start_without_args then
  require 'arthur.core.autocmds'
end

local group = vim.api.nvim_create_augroup('ArthurNvim', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'VeryLazy',
  callback = function()
    if nvim_start_without_args then
      require 'arthur.core.autocmds'
    end
    require 'arthur.core.keymaps'

    Util.format.setup()
    Util.root.setup()
  end,
})

-- For LSP Debugging
-- vim.lsp.set_log_level 'debug'

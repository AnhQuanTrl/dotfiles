_G.Util = require('anhquantrl.util')

require("anhquantrl.core.options")
require("anhquantrl.core.lazy")

vim.cmd.colorscheme("catppuccin-mocha")

local nvim_start_without_args = vim.fn.argc(-1) == 0
if not nvim_start_without_args then
  require('anhquantrl.core.autocmds')
  require('anhquantrl.core.commands')
end

local group = vim.api.nvim_create_augroup('anhquantrl-lazy-init', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'VeryLazy',
  callback = function()
    if nvim_start_without_args then
      require('anhquantrl.core.autocmds')
      require('anhquantrl.core.commands')
    end
  end,
})

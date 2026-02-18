require 'anhquantrl.config.options'
require 'anhquantrl.config.keymaps'
require 'anhquantrl.config.fold'
require 'anhquantrl.config.lsp'
require 'anhquantrl.config.lazy'

vim.cmd.colorscheme 'catppuccin-mocha'

local nvim_start_without_args = vim.fn.argc(-1) == 0
if not nvim_start_without_args then
  require 'anhquantrl.config.autocmds'
  require 'anhquantrl.config.commands'
end

local group = vim.api.nvim_create_augroup('anhquantrl-lazy-init', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'VeryLazy',
  callback = function()
    if nvim_start_without_args then
      require 'anhquantrl.config.autocmds'
      require 'anhquantrl.config.commands'
    end
  end,
})

vim.api.nvim_create_user_command('FoldSource', function()
  local source = vim.b[0].fold_source or 'not set'
  vim.notify('Fold source: ' .. source)
end, { desc = 'Show current fold source' })


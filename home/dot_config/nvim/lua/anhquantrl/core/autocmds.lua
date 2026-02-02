-- Try to apply fold again if switching to different buffer
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('anhquantrl-fold', { clear = true }),
  callback = function(ev)
    Util.fold.apply(ev.buf)
  end,
})

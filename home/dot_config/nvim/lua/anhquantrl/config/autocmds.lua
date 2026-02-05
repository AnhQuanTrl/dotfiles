vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = "Re-apply buffer fold source with highest priority when switching window.",
  group = vim.api.nvim_create_augroup('anhquantrl-fold', { clear = true }),
  callback = function(ev)
    require("anhquantrl.config.fold").apply(ev.buf)
  end,
})

local js = { 'prettierd', 'prettier', stop_after_first = true }

return {
  {
    'stevearc/conform.nvim',
    event = 'LazyFile',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = js,
        typescriptreact = js,
        javascript = js,
        javascriptreact = js,
      },
      format_on_save = function(bufnr)
        if vim.g.format_on_save == false then
          return
        end

        if vim.b[bufnr].format_on_save == false then
          return
        end

        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
    },
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('ConformFormatOnSaveToggle', function()
        vim.b.format_on_save = not vim.b.format_on_save
        print('Buffer Format on Save:', vim.b.format_on_save ~= false and 'ON' or 'OFF')
      end, {})

      vim.keymap.set('n', '<leader>uf', '<cmd>ConformFormatOnSaveToggle<cr>', { desc = 'Toggle Format on Save' })
      vim.keymap.set('n', '<leader>cf', function()
        require('conform').format()
      end, { desc = 'Code Format' })
    end,
  },
}

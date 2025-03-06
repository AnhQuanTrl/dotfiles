local Util = require 'arthur.util'

return {
  {
    'mfussenegger/nvim-dap',
    -- dependencies = {
    --   'rcarriga/nvim-dap-ui',
    -- },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Run/Continue',
      },
    },
    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      if Util.has 'mason-nvim-dap.nvim' then
        local opts = Util.opts 'mason-nvim-dap.nvim'
        require('mason-nvim-dap').setup(opts)
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require 'dap.ext.vscode'
      local json = require 'plenary.json'

      ---@diagnostic disable-next-line: duplicate-set-field
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = 'mason.nvim',
    cmd = { 'DapInstall', 'DapUninstall' },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    },
    config = function() end,
  },
}

local Util = require 'arthur.util'

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    {
      '<leader>fe',
      function()
        local api = require 'nvim-tree.api'
        api.tree.toggle {
          find_file = true,
          focus = true,
          path = Util.root(),
        }
      end,
      desc = '[F]ile [E]xplorer',
    },
  },
  opts = {
    git = {
      ignore = false,
    },
    view = {
      width = 30,
    },
  },
  config = function(_, opts)
    local nvimtree = require 'nvim-tree'
    nvimtree.setup(opts)
  end,
}

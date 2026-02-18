return {
  {
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
          }
        end,
        desc = '[F]ile [E]xplorer',
      },
    },
    opts = {
      filters = {
        git_ignored = false,
      },
      view = {
        width = {
          min = 30,
          max = -1,
        },
      },
      renderer = {
        -- remove the ~/xx/xx label on top
        root_folder_label = false,
        -- collapse single-child folder chains
        group_empty = true,
        -- nice looking indent line
        indent_markers = { enable = true },
      },
    },
    config = function(_, opts)
      local nvimtree = require 'nvim-tree'
      nvimtree.setup(opts)
    end,
  },
}

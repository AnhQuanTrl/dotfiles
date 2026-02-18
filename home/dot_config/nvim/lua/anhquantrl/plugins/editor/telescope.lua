return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    keys = {
      -- Files operations
      {
        '<leader>ff',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = '[F]ind [F]iles',
      },
      {
        '<leader>fr',
        function()
          require('telescope.builtin').oldfiles { only_cwd = true }
        end,
        desc = '[F]ind [R]ecent',
      },
      {
        '<leader>fb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[F]ind [B]uffers',
      },
      -- Search operations
      {
        '<leader>ss',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = '[S]earch [S]tring (Live Grep)',
      },
      {
        '<leader>sw',
        function()
          require('telescope.builtin').grep_string()
        end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sw',
        function()
          require('telescope.builtin').grep_string()
        end,
        mode = 'v',
        desc = '[S]earch selected [W]ord',
      },
      {
        '<leader>sb',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = '[S]earch current [B]uffer',
      },
      {
        '<leader>sr',
        function()
          require('telescope.builtin').resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>sd',
        function()
          require('telescope.builtin').resume()
        end,
        desc = '[S]earch [R]esume',
      },
    },
    opts = function()
      local actions = require 'telescope.actions'
      local themes = require 'telescope.themes'
      return {
        defaults = {
          mappings = {
            i = {
              ['<M-u>'] = actions.results_scrolling_up,
              ['<M-d>'] = actions.results_scrolling_down,
            },
            n = {
              ['<M-u>'] = actions.results_scrolling_up,
              ['<M-d>'] = actions.results_scrolling_down,
            },
          },
        },
        extensions = {
          ['ui-select'] = themes.get_dropdown {
            previewer = false,
            initial_mode = 'normal',
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
    end,
  },
}

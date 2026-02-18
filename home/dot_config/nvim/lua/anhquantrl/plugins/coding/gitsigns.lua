return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'LazyFile',
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation (h = hunk)
        map('n', ']h', gitsigns.next_hunk, 'Next hunk')
        map('n', '[h', gitsigns.prev_hunk, 'Prev hunk')

        -- stage / reset
        map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
        map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
        map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>gR', gitsigns.reset_buffer, 'Reset buffer')

        -- preview / blame
        map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
        map('n', '<leader>gb', function()
          gitsigns.blame_line { full = true }
        end, 'Blame line (full)')
        map('n', '<leader>gB', gitsigns.blame, 'Blame whole file')

        -- diff
        map('n', '<leader>gd', gitsigns.diffthis, 'Diff this')
        map('n', '<leader>gD', function()
          gitsigns.diffthis '~'
        end, 'Diff this (~)')

        -- Toggles
        map('n', '<leader>ugs', gitsigns.toggle_signs, 'Toggle git signs')
        -- map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, 'Toggle line blame')
        -- map('n', '<leader>gtw', gitsigns.toggle_word_diff, 'Toggle word diff')

        -- text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select hunk')
      end,
    },
  },
}

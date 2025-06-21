local Util = require 'arthur.util'

local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- -- Make Ctrl-C same as ESC and also stop vim.snippet session
-- map({ 'i', 's', 'v' }, '<C-c>', function()
--   if vim.snippet.active() then
--     vim.snippet.stop()
--   end
--   return '<Esc>'
-- end, { desc = 'Make C-c same as Esc', expr = true })

-- Make spac a <Nop> key as it is used for <leader>
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })

-- Better vertical navigation
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

--- formatting
map('n', '<leader>cf', function()
  Util.format { force = true }
end, { desc = 'Format' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- toggle options
map('n', '<leader>uf', function()
  Util.format.toggle()
end, { desc = 'Toggle auto format (global)' })
map('n', '<leader>uF', function()
  Util.format.toggle(true)
end, { desc = 'Toggle auto format (buffer)' })
map('n', '<leader>uh', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = nil }, { bufnr = nil })
end, { desc = 'Toggle Inlay Hint' })

-- =========================================
--  Yank “@file_path”  /  “@file_path#L..”  |
-- =========================================
local notify = require 'notify'

local function yank_file_path()
  local path = vim.fn.expand '%' -- path, relative to CWD
  local ref = '@' .. path
  vim.fn.setreg('+', ref) -- write to system clipboard

  notify('󱉣 ' .. ref .. '  copied', 'info', { title = 'Clipboard' })
end

local function yank_file_path_with_lines()
  local path = vim.fn.expand '%'
  local from = vim.fn.line "'<" -- start of visual selection
  local to = vim.fn.line "'>" -- end of visual selection
  local range = (from == to) and ('#L' .. from) or ('#L' .. from .. '-' .. to)
  local ref = '@' .. path .. range
  vim.fn.setreg('+', ref)
  -- exit Visual to leave the marks untouched
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  notify('󱉣  ' .. ref .. '  copied', 'info', { title = 'Clipboard' })
end

-- Key-maps -------------------------------------------------
-- <leader>yf  ➜  @relative/path/to/file.ext
vim.keymap.set('n', '<leader>yf', yank_file_path, { desc = 'Yank @file_path to + register' })

-- <leader>yl (visual) ➜  @file_path#Lstart-end
vim.keymap.set('v', '<leader>yl', yank_file_path_with_lines, { desc = 'Yank @file_path#line_range to + register' })

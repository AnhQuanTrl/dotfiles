-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function no_paste(reg)
  return function(lines)
    -- Do nothing! We can't paste with OSC52
  end
end

-- Configure clipboard for WSL environment
if vim.fn.has 'wsl' ~= 0 then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = no_paste '+', -- Pasting disabled
      ['*'] = no_paste '*', -- Pasting disabled
    },
  }
else
  -- force osc52
  vim.g.clipboard = 'osc52'
end

-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- line numbers and statuscolumn
vim.opt.number = true -- shows absolute line number on cursor line
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.numberwidth = 3
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number' -- set highlight CursorLineNr for current cursor line number.

-- folding
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent' -- fallback method for all files
vim.opt.foldlevelstart = 99 -- start with folds open for new buffers
vim.opt.foldlevel = 99 -- current fold depth
vim.opt.foldcolumn = '1'
vim.opt.foldtext = ''

-- theme: color, fillchars,listchars
vim.opt.termguicolors = true
vim.opt.fillchars = {
  eob = ' ', -- remove the ~ character t the end of the buffer
  fold = ' ', --  removes the dots/characters in the fold column
  foldopen = '',
  foldclose = '',
  foldsep = ' ', -- default is │
}
vim.opt.list = true
vim.opt.listchars = {
  -- space = '⋅',
  eol = '↴',
  tab = '→ ',
}

-- merge status line for different buffer (global)
vim.opt.laststatus = 3

-- floating window default border
vim.o.winborder = 'rounded'

-- Diagnostics config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = true,

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },

  -- set signcolumn icons
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
}

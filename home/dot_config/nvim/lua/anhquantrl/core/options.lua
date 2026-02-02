-- Configure clipboard for WSL environment
if vim.fn.has 'wsl' then
  vim.g.clipboard = { name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = false,
  }
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

-- theme: color, fillchars
vim.opt.termguicolors = true
vim.opt.fillchars = {
  eob = " ", -- remove the ~ character t the end of the buffer
  fold = " ", --  removes the dots/characters in the fold column
  foldopen = '',
  foldclose = '',
  foldsep = ' ', -- default is │
}

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
  }
}

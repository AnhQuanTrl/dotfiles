-- Highlight, edit, and navigate code
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    version = false, -- nvim-treesitter does not follow a frequent release schedule.
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    build = ':TSUpdate',
    opts_extend = { 'ensure_installed' },
    opts = {
      -- install common cross-language file type
      ensure_installed = {
        'bash',
        'diff',
        'html',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'printf',
        'query',
        'regex',
        'toml',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
        'json',
        'javascript',
        'typescript',
        'jsdoc',
        'tsx',
        'go',
        'gomod',
        'python',
        -- "c",
      },
    },
    config = function(_, opts)
      local TS = require 'nvim-treesitter'
      local installed = TS.get_installed 'parsers'
      local to_install = {}

      for _, lang in ipairs(opts.ensure_installed) do
        if not vim.tbl_contains(installed, lang) then
          table.insert(to_install, lang)
        end
      end

      if #to_install > 0 then
        TS.install(opts.ensure_installed, { summary = true })
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('anhquantrl-treesitter', { clear = true }),
        pattern = '*',
        callback = function(ev)
          local ft = ev.match
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end
          local has_parser, _ = pcall(vim.treesitter.get_parser, ev.buf, lang)
          if not has_parser then
            return
          end

          vim.treesitter.start()
          -- enable fold for supported file types
          if vim.treesitter.query.get(lang, 'folds') ~= nil then
            require('anhquantrl.config.fold').setup(ev.buf)
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'LazyFile', 'VeryLazy' },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        move = { set_jumps = true },
        select = { lookahead = true },
      }

      local select = require('nvim-treesitter-textobjects.select').select_textobject

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc })
      end

      -- keymaps
      -- select
      map({ 'x', 'o' }, 'am', function()
        select('@function.outer', 'textobjects')
      end, 'Around function')
      map({ 'x', 'o' }, 'im', function()
        select('@function.inner', 'textobjects')
      end, 'Inner function')
      map({ 'x', 'o' }, 'ac', function()
        select('@class.outer', 'textobjects')
      end, 'Around class')
      map({ 'x', 'o' }, 'ic', function()
        select('@class.inner', 'textobjects')
      end, 'Inner class')
      map({ 'x', 'o' }, 'aa', function()
        select('@parameter.outer', 'textobjects')
      end, 'Around parameter')

      map({ 'x', 'o' }, 'ia', function()
        select('@parameter.inner', 'textobjects')
      end, 'Inner parameter')

      -- move
      map('n', ']m', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
      end, 'Next function start')

      map('n', '[m', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
      end, 'Prev function start')

      map('n', ']M', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end, 'Next function end')

      map('n', '[M', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
      end, 'Prev function end')

      map('n', ']]', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end, 'Next class start')

      map('n', '[[', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
      end, 'Prev class start')

      map('n', '][', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end, 'Next class end')

      map('n', '[]', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end, 'Prev class end')
    end,
  },
}

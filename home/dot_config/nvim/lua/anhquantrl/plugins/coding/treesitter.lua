-- Highlight, edit, and navigate code
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    version = false, -- nvim-treesitter does not follow a frequent release schedule.
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    build = ":TSUpdate",
    opts_extend = { 'ensure_installed' },
    opts = {
      -- install common cross-language file type
      ensure_installed = {
        "bash",
        "diff",
        "html",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "query",
        "regex",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "json",
        -- "javascript",
        -- "jsdoc",
        -- "c",
        -- "python",
        -- "tsx",
        -- "typescript",
      },
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')
      local installed = TS.get_installed("parsers")
      local to_install = {}

      for _, lang in ipairs(opts.ensure_installed) do
        if not vim.tbl_contains(installed, lang) then
          table.insert(to_install, lang)
        end
      end

      if #to_install > 0 then
        TS.install(opts.ensure_installed, { summary = true })
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup('anhquantrl-treesitter', { clear = true }),
        pattern = opts.ensure_installed,
        callback = function(ev)
          -- most treesitter parser support highlight already.
          vim.treesitter.start()

          local ft = ev.match
          local lang = vim.treesitter.language.get_lang(ft)
          -- enable fold for supported file types
          if not lang or vim.treesitter.query.get(lang, "folds") ~= nil then
            require("anhquantrl.config.fold").setup(ev.buf)
          end
        end,
      })
    end,
  },
}

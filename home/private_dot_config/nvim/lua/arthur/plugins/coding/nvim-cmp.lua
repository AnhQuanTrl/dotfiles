local Util = require 'arthur.util'

return {
  'hrsh7th/nvim-cmp',
  version = false,
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
  },
  opts = function()
    -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require 'cmp'
    local defaults = require 'cmp.config.default'()
    local auto_select = true

    return {
      auto_brackets = {},
      completion = {
        completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
      },
      preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = Util.cmp.confirm { select = auto_select },
        ['<C-y>'] = Util.cmp.confirm { select = true },
        -- ['<S-CR>'] = Util.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace },
        -- ['<C-CR>'] = function(fallback)
        --   cmp.abort()
        --   fallback()
        -- end,
        ['<C-e>'] = function(fallback)
          cmp.abort()
          fallback()
        end,
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
      }),
      sorting = defaults.sorting,
    }
  end,
  main = 'arthur.util.cmp',
}

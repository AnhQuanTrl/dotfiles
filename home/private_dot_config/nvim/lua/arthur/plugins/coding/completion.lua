local Util = require 'arthur.util'

return {
  -- {
  --   'hrsh7th/nvim-cmp',
  --   version = false,
  --   event = 'InsertEnter',
  --   dependencies = {
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-buffer',
  --     'hrsh7th/cmp-path',
  --   },
  --   opts = function()
  --     -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --     local cmp = require 'cmp'
  --     local defaults = require 'cmp.config.default'()
  --     local auto_select = true
  --
  --     return {
  --       auto_brackets = {},
  --       completion = {
  --         completeopt = 'menu,menuone,noinsert' .. (auto_select and '' or ',noselect'),
  --       },
  --       preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
  --       mapping = cmp.mapping.preset.insert {
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --         -- ['<C-n>'] = cmp.mapping.select_next_item(),
  --         -- ['<C-p>'] = cmp.mapping.select_prev_item(),
  --         ['<C-Space>'] = cmp.mapping.complete(),
  --         ['<CR>'] = Util.cmp.confirm { select = auto_select },
  --         ['<C-y>'] = Util.cmp.confirm { select = true },
  --         -- ['<S-CR>'] = Util.cmp.confirm { behavior = cmp.ConfirmBehavior.Replace },
  --         -- ['<C-CR>'] = function(fallback)
  --         --   cmp.abort()
  --         --   fallback()
  --         -- end,
  --         ['<C-e>'] = function(fallback)
  --           cmp.abort()
  --           fallback()
  --         end,
  --       },
  --       sources = cmp.config.sources({
  --         { name = 'nvim_lsp' },
  --         { name = 'path' },
  --       }, {
  --         { name = 'buffer' },
  --       }),
  --       sorting = defaults.sorting,
  --     }
  --   end,
  --   main = 'arthur.util.cmp',
  -- },
  -- -- snippets
  -- {
  --   'nvim-cmp',
  --   optional = true,
  --   dependencies = {
  --     {
  --       'garymjr/nvim-snippets',
  --       opts = {
  --         friendly_snippets = true,
  --       },
  --       dependencies = { 'rafamadriz/friendly-snippets' },
  --     },
  --   },
  --   opts = function(_, opts)
  --     opts.snippet = {
  --       expand = function(item)
  --         return Util.cmp.expand(item.body)
  --       end,
  --     }
  --     if Util.has 'nvim-snippets' then
  --       table.insert(opts.sources, { name = 'snippets' })
  --     end
  --   end,
  -- },
  {
    'saghen/blink.cmp',
    lazy = false,
    version = 'v0.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },

    opts = {
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        -- ghost_text = {
        --   enabled = vim.g.ai_cmp,
        -- },
      },

      -- experimental signature help support
      -- signature = { enabled = true },

      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        -- compat = {},
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      keymap = { preset = 'default' },
    },
  },
  -- catppuccin support
  {
    'catppuccin',
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}

return {
  {
    'saghen/blink.cmp',
    event = 'VeryLazy',
    -- provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      completion = {
        trigger = {
          -- important for super-tab: in snipper preserve old tab functionality.
          show_in_snippet = false,
        },
      },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = {
        enabled = true,
        window = {
          show_documentation = true,
        },
      },
    },
  },
}

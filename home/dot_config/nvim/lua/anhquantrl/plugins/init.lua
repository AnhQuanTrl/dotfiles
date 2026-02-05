return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
    },
  },
  { "nvim-tree/nvim-web-devicons", opts = {}, lazy = false },
}

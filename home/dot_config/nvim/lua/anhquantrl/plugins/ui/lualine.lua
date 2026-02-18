-- local function has_telescope()
--   return pcall(require, "telescope")
-- end
--
-- local function telescope_title()
--   if not has_telescope() then return "" end
--   local ok, state = pcall(require, "telescope.actions.state")
--   if not ok then return "" end
--
--   local ok2, picker = pcall(state.get_current_picker, vim.api.nvim_get_current_buf())
--   if not ok2 or not picker then return "Telescope" end
--
--   return picker.prompt_title or ""
-- end
--
-- local function telescope_selection()
--   if not has_telescope() then return "" end
--   local ok, state = pcall(require, "telescope.actions.state")
--   if not ok then return "" end
--
--   local ok2, entry = pcall(state.get_selected_entry, 0)
--   if not ok2 or not entry then return "" end
--
--   -- try common fields in order
--   return entry.filename
--       or entry.path
--       or entry.value
--       or entry.ordinal
--       or ""
-- end
--
--
-- local function telescope_statusline()
--   return 'Telescope'
-- end

-- local telescope_ext = {
--   sections = {
--     lualine_a = { telescope_statusline },
--     lualine_y = { telescope_selection },
--     lualine_z = { telescope_title },
--   },
--   filetypes = { "TelescopePrompt", "TelescopeResults", "TelescopePreview" },
-- }
--
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      -- Remove lualine if starting nvim without argument
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = ' '
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
          theme = 'auto',
          component_separators = '',
          section_separators = { left = '', right = '' },
          globalstatus = vim.o.laststatus == 3,
          ignore_focus = {
            'TelescopePrompt',
            'TelescopeResults',
            'TelescopePreview',
            'yazi',
          },
        },
        extensions = { 'nvim-tree' },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = {
            { 'filename', path = 1, shorting_target = 40 },
          },
          lualine_x = { 'diagnostics', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}

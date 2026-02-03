-- Recommended way to install lazy.nvim from official documentation.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- LazyFile Event
--
-- Problem: When opening a file directly (nvim foo.lua), Neovim fires BufReadPost
-- BEFORE VimEnter. Plugins using event = "BufReadPost" would block rendering,
-- causing a blank screen while plugins load.
--
-- Solution: lazy.nvim's event handler (lazy.core.handler.event) intercepts ALL
-- events used for lazy loading. When any event fires:
--   1. Intercept the event with a one-shot autocmd
--   2. Expand to underlying events and build state (LazyEventOpts) containing:
--      event, buffer, data, and augroups to exclude (already registered, shouldn't re-run)
--   3. Load the plugins (they register their autocmds)
--   4. Execute the LazyEventOpts: get all autocmds for the event, exclude those
--      in excluded groups, trigger the rest (newly registered by plugins)
--
-- LazyFile is just a convenience alias for common file-editing events.
-- Instead of writing event = { "BufReadPost", "BufNewFile", "BufWritePre" }
-- in every plugin spec, you can just write event = "LazyFile".
--
-- Events covered:
--   BufReadPost  - file loaded into buffer (opening existing files)
--   BufNewFile   - creating a new file that doesn't exist yet
--   BufWritePre  - before saving (catches edge cases)
local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

local function lazy_file()
  local Event = require("lazy.core.handler.event")
  Event.mappings.LazyFile = { id = "LazyFile", event = lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

lazy_file()

require("lazy").setup({
  spec = {
    { import = 'anhquantrl.plugins' },
    { import = 'anhquantrl.plugins.editor' },
    { import = 'anhquantrl.plugins.ui' },
  },
})


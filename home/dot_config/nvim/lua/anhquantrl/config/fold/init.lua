require("anhquantrl.config.fold.foldtext")

local M = {}
local _priority = { lsp = 3, treesitter = 2, indent = 1 }

---@param buf number
function M.apply(buf)
  if buf ~= vim.api.nvim_get_current_buf() then return end
  local source = vim.b[buf].fold_source
  if not source then return end

  local win = vim.api.nvim_get_current_win()
  if source == 'lsp' then
    vim.wo[win][0].foldmethod = 'expr'
    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  elseif source == 'treesitter' then
    vim.wo[win][0].foldmethod = 'expr'
    vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  else
    vim.wo[win][0].foldmethod = 'indent'
  end
end

---@param buf number
function M.setup(buf)
  local current = vim.b[buf].fold_source

   -- Determine best available method
  local best = 'indent'

  for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    if c:supports_method('textDocument/foldingRange') then
      best = 'lsp'
      break
    end
  end

  if best ~= 'lsp' then
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if lang and vim.treesitter.query.get(lang, 'folds') then
      best = 'treesitter'
    end
  end

   -- Only update if better than current
  if not current or _priority[best] > _priority[current] then
    vim.b[buf].fold_source = best
    M.apply(buf)
  end
end

return M

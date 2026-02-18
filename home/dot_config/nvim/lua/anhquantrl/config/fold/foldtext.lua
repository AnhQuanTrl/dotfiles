local ns = vim.api.nvim_create_namespace 'anhquantrl.foldText'
local line_count_hl_group = 'FoldedLineCount'
vim.api.nvim_set_hl(0, line_count_hl_group, { default = true, link = 'Comment' })

---@param buf number
---@param foldstart number
---@return number foldend
local function render_fold_text(win, buf, foldstart)
  local foldend = vim.fn.foldclosedend(foldstart)
  if foldend <= -1 then
    return foldend
  end

  local virt_text = {
    { (' '):rep(3) },
    { (' %d'):format(foldend - foldstart), line_count_hl_group },
  }

  local line = vim.api.nvim_buf_get_lines(buf, foldstart - 1, foldstart, false)[1]
  local wininfo = vim.fn.getwininfo(win)[1]
  ---@diagnostic disable: undefined-field
  local leftcol = wininfo and wininfo.leftcol or 0
  local wincol = math.max(0, vim.fn.virtcol { foldstart, #line } - leftcol)

  -- must use virt_text_win_col instead of virt_text_pos because the folded line is a 'special' line
  vim.api.nvim_buf_set_extmark(buf, ns, foldstart - 1, 0, {
    virt_text = virt_text,
    virt_text_win_col = wincol, -- absolute window column
    hl_mode = 'combine',
    ephemeral = true,
  })

  return foldend
end

local function set_decoration_provider()
  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, win, buf, topline, botline)
      -- Skip non-code buffers
      local bt = vim.bo[buf].buftype
      if bt ~= '' then
        return false
      end -- skip special buffers
      -- TODO: add more filetype to skip if needed

      -- apply virtual fold text for each foldstart line

      vim.api.nvim_win_call(win, function()
        local line = topline
        while line <= botline do
          local foldstart = vim.fn.foldclosed(line)
          if foldstart > -1 then
            line = render_fold_text(win, buf, foldstart)
          end
          line = line + 1
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd('User', {
  desc = 'Set up fold text decoration provider',
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    set_decoration_provider()
  end,
})

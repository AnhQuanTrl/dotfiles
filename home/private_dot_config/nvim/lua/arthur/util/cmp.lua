local Util = require("arthur.util")

---@class arthur.util.cmp
local M = {}

---@alias Placeholder {n: number, text: string}

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
function M.snippet_replace(snippet, fn)
	return snippet:gsub("%$%b{}", function(m)
		local n, name = m:match("^%${(%d+):(.+)}$")
		return n and fn({ n = n, text = name }) or m
	end) or snippet
end

-- This function resolves nested placeholders in a snippet
---@param snippet string
---@return string
function M.snippet_preview(snippet)
	local ok, parsed = pcall(function()
		return vim.lsp._snippet_grammar.parse(snippet)
	end)
	return ok and tostring(parsed)
		or M.snippet_replace(snippet, function(placeholder)
			return M.snippet_preview(placeholder.text)
		end):gsub("%$0", "")
end

---@param entry cmp.Entry
function M.auto_brackets(entry)
	local cmp = require("cmp")
	local Kind = cmp.lsp.CompletionItemKind
	local item = entry:get_completion_item()
	if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
		local cursor = vim.api.nvim_win_get_cursor(0)
		local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
		if prev_char ~= "(" and prev_char ~= ")" then
			local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
			vim.api.nvim_feedkeys(keys, "i", true)
		end
	end
end

-- This function adds missing documentation to snippets.
-- The documentation is a preview of the snippet.
---@param window cmp.CustomEntriesView|cmp.NativeEntriesView
function M.add_missing_snippet_docs(window)
	local cmp = require("cmp")
	local Kind = cmp.lsp.CompletionItemKind
	local entries = window:get_entries()
	for _, entry in ipairs(entries) do
		if entry:get_kind() == Kind.Snippet then
			local item = entry:get_completion_item()
			if not item.documentation and item.insertText then
				item.documentation = {
					kind = cmp.lsp.MarkupKind.Markdown,
					value = string.format("```%s\n%\n```", vim.bo.filetype, M.snippet_preview(item.insertText)),
				}
			end
		end
	end
end

-- This is a better implementation of `cmp.confirm`:
--  * check if the completion menu is visible without waiting for running sources
--  * create an undo point before confirming
-- This function is both faster and more reliable.
---@param opts? {select: boolean, behavior: cmp.ConfirmBehavior}
function M.confirm(opts)
	local cmp = require("cmp")
	opts = vim.tbl_extend("force", {
		select = true,
		behavior = cmp.ConfirmBehavior.Insert,
	}, opts or {})
	return function(fallback)
		if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
			Util.create_undo()
			if cmp.confirm(opts) then
				return
			end
		end
		return fallback()
	end
end

---@param opts cmp.ConfigSchema | {auto_brackets?: string[]}
function M.setup(opts)
	for _, source in ipairs(opts.sources) do
		source.group_index = source.group_index or 1
	end

	local parse = require("cmp.utils.snippet").parse
	require("cmp.utils.snippet").parse = function(input)
		local ok, ret = pcall(parse, input)
		if ok then
			return ret
		end
		return M.snippet_preview(input)
	end

	local cmp = require("cmp")
	cmp.setup(opts)
	cmp.event:on("confirm_done", function(event)
		if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
			M.auto_brackets(event.entry)
		end
	end)
	cmp.event:on("menu_opened", function(event)
		M.add_missing_snippet_docs(event.window)
	end)
end

return M


local lsp = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>w", function()
		require("conform").format({ bufnr = bufnr, lsp_format = "fallback" })
	end, bufopts)
end

local treesitter = {
	enable = true,
	set_jumps = true,
	goto_next_start = {
		["]f"] = "@function.outer",
		["]a"] = "@parameter.inner",
	},
	goto_previous_start = {
		["[f"] = "@function.outer",
		["[a"] = "@parameter.outer",
	},
}

return {
	lsp = lsp,
	treesitter = treesitter,
}

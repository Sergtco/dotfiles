local telescope = function()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>b", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	vim.keymap.set("n", "<leader>d", builtin.diagnostics, {})
	vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols, {})
end

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

local grapple = function()
	local grapple = require("grapple")
	vim.keymap.set("n", "<leader>m", grapple.toggle)
	vim.keymap.set("n", "<leader>M", grapple.toggle_tags)
	vim.keymap.set("n", "<leader>j", "<cmd>Grapple select index=1<cr>")
	vim.keymap.set("n", "<leader>k", "<cmd>Grapple select index=2<cr>")
	vim.keymap.set("n", "<leader>l", "<cmd>Grapple select index=3<cr>")
	vim.keymap.set("n", "<leader>;", "<cmd>Grapple select index=4<cr>")
	vim.keymap.set("n", "<leader>[", "<cmd>Grapple cycle_tags prev<cr>")
	vim.keymap.set("n", "<leader>]", "<cmd>Grapple cycle_tags next<cr>")
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
	telescope = telescope,
	lsp = lsp,
	treesitter = treesitter,
	grapple = grapple,
}

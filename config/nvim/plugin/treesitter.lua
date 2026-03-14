vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
})
require("nvim-treesitter").install("markdown", "vim", "vimdoc", "markdown-inline", "comment")

vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable Treesitter",
	group = vim.api.nvim_create_augroup("enable_treesitter", {}),
	callback = function()
		if pcall(vim.treesitter.start) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldenable = false
		end
	end,
})

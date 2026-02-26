return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		init = function()
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
		end,
	},
}

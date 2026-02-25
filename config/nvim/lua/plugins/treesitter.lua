return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		opts = {
			ensure_installed = { "vim", "vimdoc", "query", "comment", "markdown", "markdown_inline" },
			sync_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby", "markdown" },
			},
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.opt.foldenable = false
		end,
	},
}

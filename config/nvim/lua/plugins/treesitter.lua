return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
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
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}

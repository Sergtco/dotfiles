return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		version = "1.*",
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = { dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" } },
			},
			cmdline = { completion = { menu = { auto_show = true } } },
			signature = { enabled = true },
			keymap = {
				["<Tab>"] = {},
				["<S-Tab>"] = {},
				["<C-l>"] = { "snippet_forward" },
				["<C-j>"] = { "snippet_backward" },
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
			},
		},
	},
}

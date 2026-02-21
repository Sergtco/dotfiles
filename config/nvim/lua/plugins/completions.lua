return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "1.*",
		opts = {
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			cmdline = { completion = { menu = { auto_show = true } } },
			signature = { enabled = true },
			keymap = {
				["<Tab>"] = {},
				["<S-Tab>"] = {},
				["<C-l>"] = { "accept", "snippet_forward" },
				["<C-j>"] = { "snippet_backward" },
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
			},
		},
	},
}

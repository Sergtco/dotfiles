return {
	{ "echasnovski/mini.surround", opts = { n_lines = 100 } },
	{ "echasnovski/mini.pairs", opts = {} },
	{ "backdround/improved-ft.nvim", opts = { use_default_mappings = true } },
	{
		"smoka7/hop.nvim",
		keys = { { "gh", "<cmd>HopWordMW<cr>", desc = "Hop to word", mode = { "n", "v" } } },
		opts = { keys = "etovxqpdygfblzhckisuran" },
	},
	{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
}

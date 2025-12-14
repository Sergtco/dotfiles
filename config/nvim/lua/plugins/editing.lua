return {
	{ "echasnovski/mini.surround", opts = { n_lines = 100 } },
	{ "echasnovski/mini.pairs", opts = {} },
	{
		"smoka7/hop.nvim",
		keys = { { "gh", "<cmd>HopWordMW<cr>", desc = "Hop to word", mode = { "n", "v" } } },
		opts = { keys = "etovxqpdygfblzhckisuran" },
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = { "nvimtools/hydra.nvim" },
		opts = {},
		cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
		keys = { { mode = { "v", "n" }, "<A-c>", "<cmd>MCstart<cr>", desc = "Create a mutlicursor" } },
	},
}

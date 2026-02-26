return {
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		opts = {},
	},
	{ "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
	{
		"smoka7/hop.nvim",
		keys = { { "gh", "<cmd>HopWordMW<cr>", desc = "Hop to word", mode = { "n", "v" } } },
		opts = { keys = "etovxqpdygfblzhckisuran" },
	},
}

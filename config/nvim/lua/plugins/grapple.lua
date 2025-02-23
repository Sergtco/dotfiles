return {
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple select index=1" },
			{ "<leader>j", "<cmd>Grapple select index=1<cr>", desc = "Grapple select index=1" },
			{ "<leader>k", "<cmd>Grapple select index=2<cr>", desc = "Grapple select index=2" },
			{ "<leader>l", "<cmd>Grapple select index=3<cr>", desc = "Grapple select index=3" },
			{ "<leader>;", "<cmd>Grapple select index=4<cr>", desc = "Grapple select index=4" },
			{ "<leader>[", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle_tags prev" },
			{ "<leader>]", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle_tags next" },
		},
		opts = {},
	},
}

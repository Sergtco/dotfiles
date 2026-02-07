return {
	{ "tpope/vim-fugitive" },
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Rs", desc = "Send request" },
			{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>Rb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = "<leader>R",
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>gd", "<cmd>Dbee toggle<cr>", desc = "toggle database" },
		},
		build = function()
			require("dbee").install()
		end,
		opts = {
			result = { focus_result = false },
		},
	},
}

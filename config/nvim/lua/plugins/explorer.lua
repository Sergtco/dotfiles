return {
	"stevearc/oil.nvim",
	dependencies = { "echasnovski/mini.icons", opts = {} },
	lazy = false,
	keys = {
		{ "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil" },
	},
	opts = {
		columns = { "permissions", "icon" },
		win_options = { list = false },
		view_options = { show_hidden = true },
		float = { border = "none" },
	},
}

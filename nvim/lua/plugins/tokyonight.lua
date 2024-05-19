return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "night",
			light_style = "day",
			on_highlights = function(hl, c) end,
		})
		vim.cmd.colorscheme("tokyonight")
	end,
}

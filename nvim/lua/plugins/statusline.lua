return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = { "BufEnter" },
	config = function()
		require("lualine").setup({
			options = {
				section_separators = "",
				component_separators = "",
				theme = "kanagawa",
			},
			extensions = {
				"oil",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "filename" },
				lualine_c = { "diagnostics" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

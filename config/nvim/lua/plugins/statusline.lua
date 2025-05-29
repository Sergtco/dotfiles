return {
	{
		"nvim-lualine/lualine.nvim",
		wants = { "echasnovski/mini.icons" },
		opts = {
			options = {
				theme = "lackluster",
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = { "filename", "diagnostics" },
				lualine_x = { "location" },
				lualine_y = { "branch" },
				lualine_z = {},
			},
			extensions = {
				"quickfix",
				"oil",
				"fugitive",
			},
		},
	},
}

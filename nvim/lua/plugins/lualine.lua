local buffers = {
	"buffers",
	show_filename_only = false,
	use_mode_color = true,
	symbols = {

		modified = " ●",
		alternate_file = "",
		directory = "",
	},
}
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		filetype_names = {
			TelescopePrompt = "Telescope",
		},
		disabled_filetypes = {
			statusline = { "Telescope" },
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "diagnostics" } },
		lualine_c = {},
		lualine_x = { "searchcount", "selectioncount", "encoding" },
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {
		lualine_a = { buffers },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})

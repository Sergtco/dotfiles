return {
	{
		"slugbyte/lackluster.nvim",
		opts = {
			tweak_ui = {
				enable_end_of_buffer = true,
			},
			tweak_highlight = {
				["Visual"] = {
					overwrite = true,
					fg = "white",
					bg = "#708090",
				},
			},
		},
		priority = 500,
		init = function()
			vim.cmd.colorscheme("lackluster")
		end,
	},
}

return {
	{
		"slugbyte/lackluster.nvim",
		opts = {
			tweak_ui = {
				enable_end_of_buffer = true,
			},
		},
		priority = 500,
		init = function()
			vim.cmd.colorscheme("lackluster")
			vim.api.nvim_set_hl(0, "Visual", { fg = "#000000", bg = "#708090" })
		end,
	},
}

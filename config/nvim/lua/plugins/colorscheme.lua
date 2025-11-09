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
			vim.api.nvim_set_hl(0, "Visual", { bg = "#242424", fg = "#aaaaaa" })
		end,
	},
}

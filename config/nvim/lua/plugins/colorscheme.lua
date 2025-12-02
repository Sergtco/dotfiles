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
		end,
	},
}

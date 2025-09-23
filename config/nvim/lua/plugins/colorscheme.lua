return {
	{
		"slugbyte/lackluster.nvim",
		opts = {},
        priority = 500,
		init = function()
			vim.cmd.colorscheme("lackluster")
		end,
	},
}

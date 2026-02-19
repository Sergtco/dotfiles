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
			vim.api.nvim_set_hl(0, "Visual", { fg = "#000000", bg = "#708090" })
		end,
	},
	{
		"ficcdaf/ashen.nvim",
		-- optional but recommended,
		-- pin to the latest stable release:
		version = "*",
		lazy = false,
		priority = 1000,
		opts = {
			-- your settings here
		},
		init = function()
			vim.cmd.colorscheme("ashen")
		end,
	},
}

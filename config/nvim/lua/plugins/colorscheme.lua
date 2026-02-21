return {
	{
		"slugbyte/lackluster.nvim",
		enabled = false,
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
		version = "*",
		lazy = false,
		priority = 1000,
	},
	{
		"kyza0d/xeno.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Create your custom theme here
			require("xeno").new_theme("xeno-lilypad", {
				base = "#1E1E1E",
				accent = "#8CBE8C",
				contrast = 0.1,
			})
		end,
		init = function()
			vim.cmd.colorscheme("xeno-lilypad")
		end,
	},
}

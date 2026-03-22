vim.pack.add({
	"https://github.com/slugbyte/lackluster.nvim",
})

require("lackluster").setup({
	tweak_ui = {
		enable_end_of_buffer = true,
	},
	tweak_highlight = {
		["Visual"] = {
			overwrite = true,
			fg = "white",
			bg = "#708090",
		},
		["MiniPickMatchCurrent"] = {
			bg = "black",
		},
	},
})

vim.cmd.colorscheme("lackluster")

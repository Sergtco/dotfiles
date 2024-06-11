return {
	"sontungexpt/sttusline",
	branch = "table_version",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = { "BufEnter" },
	config = function(_, opts)
		require("sttusline").setup({
			disabled = {
				buftypes = {},
			},
			components = {
				"mode",
				"filename",
				"diagnostics",
				"%=",
				"%=",
			},
		})
	end,
}

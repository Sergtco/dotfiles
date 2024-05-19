return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	config = function()
		require("grapple").setup({
			scope = "git_branch",
			icons = true,
		})
	end,
}

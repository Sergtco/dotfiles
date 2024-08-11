return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "CFLAGS=-march=native make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
                layout_strategy = 'bottom_pane',
                layout_config = {
                    vertical = {
                    },
                },
            },
			pickers = {
            },
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("grapple")
	end,
}

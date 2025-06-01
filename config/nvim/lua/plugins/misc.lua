return {
	{
		"echasnovski/mini.ai",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ts_spec = require("mini.ai").gen_spec.treesitter
			return {
				custom_textobjects = {
					F = ts_spec({ a = "@function.outer", i = "@function.inner" }),
					C = ts_spec({ a = "@class.outer", i = "@class.inner" }),
					a = ts_spec({ a = "@parameter.outer", i = "@parameter.inner" }),
					o = ts_spec({
						a = { "@conditional.outer", "@loop.outer" },
						i = { "@conditional.inner", "@loop.inner" },
					}),
				},
				n_lines = 200,
			}
		end,
	},
	{
		"echasnovski/mini.icons",
		opts = function()
			require("mini.icons").mock_nvim_web_devicons()
			return {}
		end,
	},
	{ "echasnovski/mini.surround", opts = { n_lines = 100 } },
	{ "echasnovski/mini.pairs", opts = {} },
	{ "echasnovski/mini.align", opts = {} },
	{ "backdround/improved-ft.nvim", opts = { use_default_mappings = true } },
	{
		"smoka7/hop.nvim",
		keys = { { "gh", "<cmd>HopWord<cr>", desc = "Hop to word" } },
		opts = { keys = "etovxqpdygfblzhckisuran" },
	},
	{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
}

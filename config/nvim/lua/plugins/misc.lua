return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			latex = { enabled = false },
			anti_conceal = { enabled = false },
			overrides = { buftype = { nofile = { code = { enabled = false } } } },
		},
	},
	{
		"echasnovski/mini.ai",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		vrsion = "*",
		config = function(_, _)
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				custom_textobjects = {
					F = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
					C = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
					p = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					o = spec_treesitter({
						a = { "@conditional.outer", "@loop.outer" },
						i = { "@conditional.inner", "@loop.inner" },
					}),
				},
				n_lines = 200,
			})
		end,
	},
	{ "echasnovski/mini.surround", version = "*", opts = { n_lines = 100 } },
	{ "echasnovski/mini.pairs", version = "*", opts = {} },
	{ "echasnovski/mini.align", version = "*", opts = {} },
	{ "backdround/improved-ft.nvim", version = "*", opts = { use_default_mappings = true } },
}

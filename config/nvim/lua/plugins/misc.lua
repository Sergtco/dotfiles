return {
	{ "echasnovski/mini-git", version = "*", main = "mini.git", opts = {} },
	{ "echasnovski/mini.surround", version = "*", opts = { n_lines = 100 } },
	{ "echasnovski/mini.pairs", version = "*", opts = {} },
	{ "echasnovski/mini.align", version = "*", opts = {} },
	{ "echasnovski/mini.jump", version = "*", opts = {} },
	{
		"smoka7/hop.nvim",
		version = "*",
		keys = { "gh", "<cmd>HopWord<cr>", desc = "Hop any word" },
		opts = {},
	},
	{
		"echasnovski/mini.ai",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		version = "*",
		config = function(_, _)
			local gen_spec = require("mini.ai").gen_spec
			require("mini.ai").setup({
				custom_textobjects = {
					F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					C = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
					L = gen_spec.treesitter({ a = "@loop.outer", i = "@loop.inner" }),
					c = gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
				},

				n_lines = 200,
			})
		end,
	},
}

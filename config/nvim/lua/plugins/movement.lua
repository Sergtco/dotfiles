return {
	{
		"smoka7/hop.nvim",
		version = "*",
		keys = { { "gh", "<cmd>HopWord<cr>", desc = "Hop any word" } },
		opts = { keys = "etovxqpdygfblzhckisuran" },
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

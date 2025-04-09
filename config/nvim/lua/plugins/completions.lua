return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				version = "v2.*",
				build = "make install_jsregexp",
			},
			"rafamadriz/friendly-snippets",
		},

		event = { "InsertEnter" },
		version = "1.*",
		opts = {
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			snippets = { preset = "luasnip" },
			completion = {
				keyword = { range = "prefix" },
				menu = { draw = { treesitter = { "lsp" } } },
			},
			cmdline = { completion = { menu = { auto_show = true } } },
			signature = { enabled = true },
			keymap = {
				["<Tab>"] = {},
				["<S-Tab>"] = {},
				["<C-k>"] = {},
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
			},
		},

		opts_extend = { "sources.default" },

		config = function(_, opts)
			require("blink.cmp").setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			ls.config.setup({ enable_autosnippets = true })

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { desc = "Expand or jump to next snippet placeholder" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(-1)
			end, { desc = "Jump to previous snippet placeholder" })
		end,
	},
}

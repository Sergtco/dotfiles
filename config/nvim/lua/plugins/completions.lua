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
		version = "v0.*",
		opts = {
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			snippets = { preset = "luasnip" },
			completion = { keyword = { range = "prefix" } },
			signature = { enabled = true },
			keymap = { ["<Tab>"] = {}, ["<S-Tab>"] = {}, ["<C-K>"] = {} },
		},

		opts_extend = { "sources.default" },

		config = function(_, opts)
			require("blink.cmp").setup(opts)
			require("luasnip.loaders.from_vscode").lazy_load()

			local ls = require("luasnip")
			ls.config.setup({ enable_autosnippets = true })

			vim.keymap.set("i", "<C-k>", ls.expand, { desc = "Expand(accept) snippet" })
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				ls.jump(1)
			end, { desc = "Jump to next snipeet placeholder" })
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(-1)
			end, { desc = "Jump to previous snippet placeholder" })
		end,
	},
}

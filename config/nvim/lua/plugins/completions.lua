return {
	{
		"saghen/blink.cmp",
		enabled = false,
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		version = "1.*",
		opts = {
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
				},
				providers = { dadbod = { module = "vim_dadbod_completion.blink" }, lsp = { fallbacks = {} } },
			},
			cmdline = { completion = { menu = { auto_show = true } } },
			signature = { enabled = true },
			keymap = {
				["<Tab>"] = {},
				["<S-Tab>"] = {},
				["<C-l>"] = { "snippet_forward" },
				["<C-j>"] = { "snippet_backward" },
				["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
			},
		},
	},
	{
		"nvim-mini/mini.completion",
		enabled = true,
		opts = { lsp_completion = { source_func = "omnifunc", auto_setup = false } },
		init = function()
			vim.o.completeopt = "menuone,noinsert,fuzzy"
			vim.o.wildoptions = "pum,fuzzy"
			vim.o.pumheight = 10
			vim.cmd([[autocmd CmdlineChanged [:\/\?] call wildtrigger()]])
			vim.o.wildmode = "noselect:lastused,full"
			vim.o.wildoptions = "pum,fuzzy"
		end,
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"nvim-mini/mini.snippets",
				opts = function()
					local gen_loader = require("mini.snippets").gen_loader
					return {
						snippets = {
							gen_loader.from_runtime("global.json"),
							gen_loader.from_lang(),
						},
						-- mappings = { expand = "<C-l>", jump_prev = "<C-j>" },
					}
				end,
			},
		},
	},
}

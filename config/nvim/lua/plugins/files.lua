return {
	{
		"stevearc/oil.nvim",
		wants = { "echasnovski/mini.icons" },
		lazy = false,
		keys = { { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil" } },
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		wants = { "echasnovski/mini.icons" },
		keys = {
			{ "<leader>z", "<cmd>FzfLua<cr>", desc = "FzfLua" },
			{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "find_files" },
			{ "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "live_grep" },
			{ "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "buffers" },
			{ "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", desc = "document diagnostics" },
			{ "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "workspace diagnostics" },
			{ "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "lsp_document_symbols" },
			{ "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "lsp_workspace_symbols_symbols" },
		},
		opts = { { "ivy", "borderless" }, fzf_colors = true },
		init = function()
			require("fzf-lua").register_ui_select()
		end,
	},
	{ "tpope/vim-fugitive" },
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Rs", desc = "Send request" },
			{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>Rb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = "<leader>R",
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>gd", "<cmd>Dbee toggle<cr>", desc = "toggle database" },
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup()
		end,
	},
}

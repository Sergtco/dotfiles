return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = { { "-", "<cmd>Oil<cr>", desc = "Open Oil" } },
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		event = "VeryLazy",
		keys = {
			{ "<F1>", "<cmd>FzfLua helptags<cr>", desc = "Pick Help" },
			{ "<C-g>", "<cmd>FzfLua live_grep<cr>", desc = "Pick grep" },
			{ "<C-/>", "<cmd>FzfLua buffers<cr>", desc = "Pick buffers" },
			{ "<leader>z", "<cmd>FzfLua<cr>", desc = "Pick" },
			{ "<A-z>", "<cmd>FzfLua resume<cr>", desc = "Pick resume last picker" },
			{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "Pick find_files" },
			{ "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", desc = "Pick document diagnostics" },
			{ "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Pick workspace diagnostics" },
			{ "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Pick lsp_document_symbols" },
			{ "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Pick lsp_workspace_symbols_symbols" },
		},
		opts = { { "ivy", "borderless", "hide" }, fzf_colors = true },
		init = function()
			require("fzf-lua").register_ui_select()
		end,
	},
}

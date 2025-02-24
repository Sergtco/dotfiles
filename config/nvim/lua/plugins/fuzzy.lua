return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
	keys = {
		{ "<leader>z", "<cmd>FzfLua<cr>", desc = "FzfLua" },
		{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "find_files" },
		{ "<leader>g", "<cmd>FzfLua live_grep<cr>", desc = "live_grep" },
		{ "<leader>c", "<cmd>FzfLua git_status<cr>", desc = "git_status" },
		{ "<leader>b", "<cmd>FzfLua buffers<cr>", desc = "buffers" },
		{ "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", desc = "document diagnostics" },
		{ "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "workspace diagnostics" },
		{ "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "lsp_document_symbols" },
		{ "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "lsp_workspace_symbols_symbols" },
	},
	opts = { { "ivy", "borderless" }, fzf_colors = true },
}

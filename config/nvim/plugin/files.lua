vim.pack.add({ "https://github.com/stevearc/oil.nvim", "https://github.com/ibhagwan/fzf-lua" })

local set = vim.keymap.set

require("oil").setup()
set("n", "-", "<cmd>Oil<cr>", { desc = "Open Oil" })


require("fzf-lua").setup({
	{ "skim", "ivy", "borderless", "hide" },
	fzf_colors = true,
	keymap = { builtin = { ["<A-p>"] = "toggle-preview" } },
})
require("fzf-lua").register_ui_select()

set("n", "<F1>", "<cmd>FzfLua helptags<cr>", { desc = "Pick Help" })
set("n", "<C-g>", "<cmd>FzfLua live_grep<cr>", { desc = "Pick grep" })
set("n", "<C-\\>", "<cmd>FzfLua buffers<cr>", { desc = "Pick buffers" })
set("n", "<leader>z", "<cmd>FzfLua<cr>", { desc = "Pick" })
set("n", "<A-z>", "<cmd>FzfLua resume<cr>", { desc = "Pick resume last picker" })
set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Pick find_files" })
set("n", "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Pick document diagnostics" })
set("n", "<leader>D", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Pick workspace diagnostics" })
set("n", "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Pick lsp_document_symbols" })
set("n", "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Pick lsp_workspace_symbols_symbols" })
set("n", "<leader>r", "<cmd>FzfLua lsp_references<cr>", { desc = "Pick lsp_references" })

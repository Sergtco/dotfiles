vim.pack.add({ 
    "https://github.com/stevearc/oil.nvim", 
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.extra",
})

local set = vim.keymap.set

require("oil").setup()
set("n", "-", "<cmd>Oil<cr>", { desc = "Open Oil" })

require("mini.extra").setup()
require("mini.pick").setup()

set("n", "<F1>", "<cmd>Pick help<cr>", { desc = "Pick Help" })
set("n", "<C-g>", "<cmd>Pick grep_live<cr>", { desc = "Pick grep" })
set("n", "<C-\\>", "<cmd>Pick buffers<cr>", { desc = "Pick buffers" })
set("n", "<A-z>", "<cmd>Pick resume<cr>", { desc = "Pick resume last picker" })
set("n", "<leader>f", "<cmd>Pick files<cr>", { desc = "Pick find_files" })
set("n", "<leader>d", "<cmd>Pick diagnostic<cr>", { desc = "Pick document diagnostics" })
set("n", "<leader>s", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Pick lsp_document_symbols" })
set("n", "<leader>S", "<cmd>Pick lsp scope='workspace_symbol_live'<cr>", { desc = "Pick lsp_workspace_symbols_symbols" })
set("n", "<leader>r", "<cmd>Pick lsp scope='references'<cr>", { desc = "Pick lsp_references" })

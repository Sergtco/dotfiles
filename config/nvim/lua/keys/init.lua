-- Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

-- global yank and paste
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+y$')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')

vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", { desc = "Tab next" })
vim.keymap.set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Tab prev" })
vim.keymap.set("n", "<A-t>", "<cmd>tabclose<cr>", { desc = "Tab close" })

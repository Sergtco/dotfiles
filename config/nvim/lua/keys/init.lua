--Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

--global yank and paste
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- quickfix
vim.keymap.set("n", "<M-n>", "<cmd>cnext<cr>", { desc = "Quickfix next" })
vim.keymap.set("n", "<M-p>", "<cmd>cprevious<cr>", { desc = "Quickfix prev" })

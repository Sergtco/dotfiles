require("base.term")

-- Buffer motions
vim.keymap.set("n", "<A-[>", "<cmd>tabprevious<cr>", {})
vim.keymap.set("n", "<A-]>", "<cmd>tabnext<cr>", {})
vim.keymap.set("n", "<A-c>", "<cmd>tabclose<cr>", {})

--Files
vim.keymap.set("n", "<leader>fe", require("oil").open_float, {})
--Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>", { silent = true })
vim.keymap.set("n", "<c-/>", ToggleTerminal, { silent = true })
vim.keymap.set("t", "<c-/>", ToggleTerminal, { silent = true })
--global yank and paste
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>p", '"+p')

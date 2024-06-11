require("base.term")

-- Buffer motions
vim.keymap.set("n", "<A-[>", "<cmd>bprevious<cr>", {})
vim.keymap.set("n", "<A-]>", "<cmd>bnext<cr>", {})
vim.keymap.set("n", "<A-c>", "<cmd>bdelete<cr>", {})

--Files
vim.keymap.set("n", "<leader>fe", "<cmd>Oil<cr>", {})
--Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>", { silent = true })
vim.keymap.set("n", "<c-space>", ToggleTerminal, { silent = true })
vim.keymap.set("t", "<c-space>", ToggleTerminal, { silent = true })
--global yank and paste
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>p", '"+p')

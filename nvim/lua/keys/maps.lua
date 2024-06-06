local g = vim.g

-- Buffer motions
vim.keymap.set("n", "<A-[>", "<cmd>bprevious<cr>", {})
vim.keymap.set("n", "<A-]>", "<cmd>bnext<cr>", {})
vim.keymap.set("n", "<A-c>", "<cmd>bdelete<cr>", {})

--Files
vim.keymap.set("n", "<leader>fe", "<cmd>20Lexplore<cr>", {})

--Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>", { silent = true })
vim.keymap.set("n", "<leader>t", "<cmd>split|terminal<cr>", { silent = true })
--global yank and paste
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>p", '"+p')

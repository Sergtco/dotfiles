-- Tab motions
vim.keymap.set("n", "<A-[>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<A-]>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<A-c>", "<cmd>tabclose<cr>")

--Term
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

--global yank and paste
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>p", '"+p')

-- quickfix
vim.keymap.set("n", "<M-n>", "<cmd>cnext<cr>", { desc = "Quickfix next" })
vim.keymap.set("n", "<M-p>", "<cmd>cprevious<cr>", { desc = "Quickfix prev" })

-- light-dark mode
local function swap_mode()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end
vim.keymap.set("n", "<leader>\\", swap_mode, { desc = "Light/dark mode" })

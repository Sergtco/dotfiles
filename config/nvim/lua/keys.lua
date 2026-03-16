local set = vim.keymap.set

-- global yank and paste
set({ "n", "v" }, "<leader>y", '"+y', { desc = "Global yank" })
set({ "n", "v" }, "<leader>Y", '"+y$', { desc = "Global yank end" })
set({ "n", "v" }, "<leader>p", '"+p', { desc = "Global paste" })
set({ "n", "v" }, "<leader>P", '"+P', { desc = "Global paste end" })

set("n", "]t", "<cmd>tabnext<cr>", { desc = "Tab next" })
set("n", "[t", "<cmd>tabprevious<cr>", { desc = "Tab prev" })
set("n", "<A-t>", "<cmd>tabclose<cr>", { desc = "Tab close" })
set("n", "<A-b>", "<cmd>bdelete<cr>", { desc = "Buffer close" })
set("n", "<A-B>", "<cmd>bdelete!<cr>", { desc = "Buffer close" })

set("n", "<A-q>", function()
	if vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].quickfix == 1 then
		vim.cmd("cclose")
	else
		vim.cmd("botright copen")
	end
end, { desc = "Toggle Quickfix" })

set("o", "ir", "i[")
set("o", "ar", "a[")
set("o", "ia", "i<")
set("o", "aa", "a<")

vim.keymap.set("i", "<C-y>", function()
	if vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected == -1 then
		return vim.fn["repeat"]("<C-n>", 1) .. "<C-y>"
	end

	return "<C-y>"
end, { expr = true, remap = false, desc = "Smart <C-y>: accept first if nothing selected" })

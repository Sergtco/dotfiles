vim.schedule(function()
	vim.pack.add({
		"https://github.com/kylechui/nvim-surround",
	})
	require("nvim-surround").setup()
end)

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			"https://github.com/echasnovski/mini.pairs",
		})
		require("mini.pairs").setup()
	end,
})

vim.pack.add({
	"https://github.com/smoka7/hop.nvim",
})
require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
vim.keymap.set({ "n", "v" }, "gh", "<cmd>HopWordMW<cr>", { desc = "Hop to word" })

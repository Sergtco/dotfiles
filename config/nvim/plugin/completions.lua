vim.pack.add({"https://github.com/nvim-mini/mini.completion"})
require('mini.completion').setup()

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({
			"https://github.com/rafamadriz/friendly-snippets",
			"https://github.com/nvim-mini/mini.snippets",
		})

		local gen_loader = require("mini.snippets").gen_loader
		require("mini.snippets").setup({
			snippets = {
				gen_loader.from_runtime("global.json"),
				gen_loader.from_lang(),
			},
		})
	end,
})
